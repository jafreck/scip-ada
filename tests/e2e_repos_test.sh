#!/bin/bash
# =============================================================================
# E2E Tests: Real-World Ada Repository Indexing
# =============================================================================
# Clones public Ada git repos at pinned commits, builds them, indexes with
# scip_ada, and verifies the generated SCIP index for correctness/completeness.
#
# This complements the snapshot-based e2e_test.sh by exercising scip_ada on
# real codebases of varying size and complexity.
#
# Prerequisites:
#   - scip_ada built (make build)
#   - scip CLI on PATH (https://github.com/sourcegraph/scip/releases)
#   - GNAT / gprbuild available (via Alire)
#   - jq available (for JSON parsing)
#   - git available
#
# Environment variables:
#   REPOS_CACHE_DIR   Override clone cache (default: /tmp/scip-ada-test-repos)
#   SKIP_CLONE        Set to 1 to skip cloning (use cached repos only)
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SCIP_ADA="$PROJECT_ROOT/bin/scip_ada"
REPOS_DIR="${REPOS_CACHE_DIR:-/tmp/scip-ada-test-repos}"

# ---------------------------------------------------------------------------
# Set up PATH — need Alire toolchain + scip + HOME/bin
# ---------------------------------------------------------------------------
export PATH="$HOME/bin:$PATH"
cd "$PROJECT_ROOT"
eval "$(alr printenv 2>/dev/null)" || true

# ---------------------------------------------------------------------------
# Prerequisite checks
# ---------------------------------------------------------------------------
fail_prereq() { echo "error: $1" >&2; exit 1; }

command -v git      >/dev/null 2>&1 || fail_prereq "'git' not found on PATH"
command -v gprbuild >/dev/null 2>&1 || fail_prereq "'gprbuild' not found on PATH (run from Alire env)"
command -v scip     >/dev/null 2>&1 || fail_prereq "'scip' CLI not found on PATH"
command -v jq       >/dev/null 2>&1 || fail_prereq "'jq' not found on PATH"
[ -x "$SCIP_ADA" ]                  || fail_prereq "scip_ada not found at $SCIP_ADA (run 'make build')"

mkdir -p "$REPOS_DIR"

# ---------------------------------------------------------------------------
# Counters & reporting
# ---------------------------------------------------------------------------
PASS=0; FAIL=0; TOTAL=0; ERRORS=""

log()         { echo "  $*"; }
log_section() { echo ""; echo "=== $* ==="; }
log_check()   { echo "    CHECK: $*"; }

record_pass() {
  PASS=$((PASS + 1)); TOTAL=$((TOTAL + 1))
  echo "    PASS: $1"
}

record_fail() {
  local name="$1"; shift
  FAIL=$((FAIL + 1)); TOTAL=$((TOTAL + 1))
  echo "    FAIL: $name — $*"
  ERRORS="${ERRORS}  - ${name}: $*\n"
}

# ---------------------------------------------------------------------------
# Repository helpers
# ---------------------------------------------------------------------------

# Clone (or reuse cache) at a specific commit.
clone_repo() {
  local name="$1" url="$2" commit="$3"
  local repo_dir="$REPOS_DIR/$name"

  if [ "${SKIP_CLONE:-0}" = "1" ] && [ -d "$repo_dir/.git" ]; then
    log "Using cached clone of $name"
    git -C "$repo_dir" checkout --quiet "$commit" 2>/dev/null || true
    return 0
  fi

  if [ -d "$repo_dir/.git" ]; then
    local current
    current="$(git -C "$repo_dir" rev-parse HEAD 2>/dev/null || echo "")"
    if [ "$current" = "$commit" ]; then
      log "Cache hit: $name @ ${commit:0:10}"
      return 0
    fi
  fi

  log "Cloning $name @ ${commit:0:10} ..."
  rm -rf "$repo_dir"
  git clone --quiet "$url" "$repo_dir"
  git -C "$repo_dir" checkout --quiet "$commit"
}

# Create a simple wrapper .gpr inside a repo so scip_ada's lightweight GPR
# parser can discover Object_Dir reliably.
write_wrapper_gpr() {
  local repo_dir="$1" gpr_name="$2" src_dirs="$3"
  local excludes="${4:-}"
  local gpr_path="$repo_dir/${gpr_name}.gpr"

  local src_list=""
  IFS=',' read -ra dirs <<< "$src_dirs"
  for d in "${dirs[@]}"; do
    [ -n "$src_list" ] && src_list="$src_list, "
    src_list="${src_list}\"${d}\""
  done

  local exclude_attr=""
  if [ -n "$excludes" ]; then
    local ex_list=""
    IFS=',' read -ra exfiles <<< "$excludes"
    for f in "${exfiles[@]}"; do
      [ -n "$ex_list" ] && ex_list="$ex_list, "
      ex_list="${ex_list}\"${f}\""
    done
    exclude_attr="   for Excluded_Source_Files use ($ex_list);"
  fi

  cat > "$gpr_path" <<EOF
project ${gpr_name} is
   for Source_Dirs use ($src_list);
   for Object_Dir use "obj_scip_test";
   for Create_Missing_Dirs use "True";
${exclude_attr}
end ${gpr_name};
EOF
  echo "$gpr_path"
}

# ---------------------------------------------------------------------------
# SCIP index verification primitives
# ---------------------------------------------------------------------------

# Extract a top-level numeric field from scip stats JSON.
scip_stats_field() {
  local index="$1" field="$2"
  scip stats --from "$index" 2>/dev/null | jq -r ".$field // 0"
}

# List all relative_path entries from documents.
scip_doc_paths() {
  local index="$1"
  scip print --json "$index" 2>/dev/null \
    | jq -r '.documents[]?.relative_path // empty'
}

# List all definition symbols (from documents + external_symbols).
scip_all_symbols() {
  local index="$1"
  scip print --json "$index" 2>/dev/null \
    | jq -r '([.documents[]?.symbols[]?.symbol] + [.external_symbols[]?.symbol]) | map(select(. != null and . != "")) | unique[]'
}

# Check that every document has at least one occurrence.
docs_without_occurrences() {
  local index="$1"
  scip print --json "$index" 2>/dev/null \
    | jq -r '.documents[] | select((.occurrences // []) | length == 0) | .relative_path // "<unknown>"'
}

# Extract metadata tool name.
scip_tool_name() {
  local index="$1"
  scip print --json "$index" 2>/dev/null \
    | jq -r '.metadata.tool_info.name // ""'
}

# ---------------------------------------------------------------------------
# Composite verification functions
# ---------------------------------------------------------------------------

# verify_metadata <prefix> <index>
verify_metadata() {
  local pfx="$1" idx="$2"
  log_check "metadata.tool_info.name = scip-ada"
  local name
  name="$(scip_tool_name "$idx")"
  if [ "$name" = "scip-ada" ]; then
    record_pass "$pfx/metadata"
  else
    record_fail "$pfx/metadata" "expected 'scip-ada', got '$name'"
  fi
}

# verify_stats <prefix> <index> <min_docs> <min_defs> <min_occs>
verify_stats() {
  local pfx="$1" idx="$2" min_docs="$3" min_defs="$4" min_occs="$5"
  local docs defs occs
  docs="$(scip_stats_field "$idx" documents)"
  defs="$(scip_stats_field "$idx" definitions)"
  occs="$(scip_stats_field "$idx" occurrences)"

  log_check "documents >= $min_docs (got $docs)"
  if [ "$docs" -ge "$min_docs" ]; then
    record_pass "$pfx/documents"
  else
    record_fail "$pfx/documents" "expected >= $min_docs, got $docs"
  fi

  log_check "definitions >= $min_defs (got $defs)"
  if [ "$defs" -ge "$min_defs" ]; then
    record_pass "$pfx/definitions"
  else
    record_fail "$pfx/definitions" "expected >= $min_defs, got $defs"
  fi

  log_check "occurrences >= $min_occs (got $occs)"
  if [ "$occs" -ge "$min_occs" ]; then
    record_pass "$pfx/occurrences"
  else
    record_fail "$pfx/occurrences" "expected >= $min_occs, got $occs"
  fi
}

# verify_no_empty_docs <prefix> <index>
verify_no_empty_docs() {
  local pfx="$1" idx="$2"
  log_check "every document has >= 1 occurrence"
  local empty
  empty="$(docs_without_occurrences "$idx")"
  if [ -z "$empty" ]; then
    record_pass "$pfx/no_empty_docs"
  else
    record_fail "$pfx/no_empty_docs" "empty docs: $(echo "$empty" | tr '\n' ' ')"
  fi
}

# verify_symbols <prefix> <index> <pattern> [<pattern> ...]
verify_symbols() {
  local pfx="$1" idx="$2"; shift 2
  local all_syms
  all_syms="$(scip_all_symbols "$idx")"
  for pat in "$@"; do
    log_check "symbol matches: $pat"
    if echo "$all_syms" | grep -qi "$pat"; then
      record_pass "$pfx/sym:$pat"
    else
      record_fail "$pfx/sym:$pat" "no symbol matching '$pat'"
    fi
  done
}

# verify_doc_paths <prefix> <index> <pattern> [<pattern> ...]
verify_doc_paths() {
  local pfx="$1" idx="$2"; shift 2
  local all_docs
  all_docs="$(scip_doc_paths "$idx")"
  for pat in "$@"; do
    log_check "document matches: $pat"
    if echo "$all_docs" | grep -qi "$pat"; then
      record_pass "$pfx/doc:$pat"
    else
      record_fail "$pfx/doc:$pat" "no document matching '$pat'"
    fi
  done
}

# verify_symbols_have_info <prefix> <index>
# Checks that at least some symbols have documentation or signature information.
# Ada body files may legitimately have definition-role occurrences (body
# completions) without standalone symbol entries, so we don't require every
# document to have them.
verify_symbols_have_info() {
  local pfx="$1" idx="$2"
  log_check "some symbols have documentation or signatures"
  local count
  count="$(scip print --json "$idx" 2>/dev/null \
    | jq '[.documents[]?.symbols[]? | select(.documentation != null or .signature_documentation != null)] | length')"
  if [ "$count" -gt 0 ]; then
    record_pass "$pfx/symbols_have_info ($count symbols)"
  else
    record_fail "$pfx/symbols_have_info" "no symbols with documentation or signatures"
  fi
}

# verify_occurrence_ranges <prefix> <index>
# Checks that occurrence ranges are non-negative and reasonable.
verify_occurrence_ranges() {
  local pfx="$1" idx="$2"
  log_check "occurrence ranges are valid (non-negative, col < 10000)"
  local bad
  bad="$(scip print --json "$idx" 2>/dev/null \
    | jq -r '
      [.documents[]? as $doc |
        ($doc.occurrences // [])[] as $occ |
        ($occ.range // []) as $r |
        if ($r | length) < 3 then
          "\($doc.relative_path // "?"): range too short \($r)"
        else
          ($r[0]) as $line |
          ($r[1]) as $col_start |
          (if ($r | length) == 3 then $r[2] else $r[3] end) as $col_end |
          if $line < 0 or $col_start < 0 or $col_end < 0 or $col_start > 10000 or $col_end > 10000 then
            "\($doc.relative_path // "?"): bad range \($r)"
          else
            empty
          end
        end
      ] | .[:5][] // empty')"
  if [ -z "$bad" ]; then
    record_pass "$pfx/valid_ranges"
  else
    record_fail "$pfx/valid_ranges" "$bad"
  fi
}

# ---------------------------------------------------------------------------
# Tier 2: Content verification — symbol-level assertions
# ---------------------------------------------------------------------------

# verify_exact_stats <prefix> <index> <exp_docs> <exp_defs> <exp_occs>
# Checks exact counts with a 5% tolerance to allow minor toolchain variations.
verify_exact_stats() {
  local pfx="$1" idx="$2" exp_docs="$3" exp_defs="$4" exp_occs="$5"
  local docs defs occs
  docs="$(scip_stats_field "$idx" documents)"
  defs="$(scip_stats_field "$idx" definitions)"
  occs="$(scip_stats_field "$idx" occurrences)"

  log_check "exact documents = $exp_docs (got $docs)"
  if [ "$docs" -eq "$exp_docs" ]; then
    record_pass "$pfx/exact_docs"
  else
    record_fail "$pfx/exact_docs" "expected $exp_docs, got $docs"
  fi

  # Definitions: allow ±5%
  local def_lo def_hi
  def_lo=$(( exp_defs * 95 / 100 ))
  def_hi=$(( exp_defs * 105 / 100 ))
  log_check "definitions ~ $exp_defs ±5% (got $defs, range $def_lo..$def_hi)"
  if [ "$defs" -ge "$def_lo" ] && [ "$defs" -le "$def_hi" ]; then
    record_pass "$pfx/exact_defs"
  else
    record_fail "$pfx/exact_defs" "expected ~$exp_defs ±5%, got $defs"
  fi

  # Occurrences: allow ±5%
  local occ_lo occ_hi
  occ_lo=$(( exp_occs * 95 / 100 ))
  occ_hi=$(( exp_occs * 105 / 100 ))
  log_check "occurrences ~ $exp_occs ±5% (got $occs, range $occ_lo..$occ_hi)"
  if [ "$occs" -ge "$occ_lo" ] && [ "$occs" -le "$occ_hi" ]; then
    record_pass "$pfx/exact_occs"
  else
    record_fail "$pfx/exact_occs" "expected ~$exp_occs ±5%, got $occs"
  fi
}

# verify_symbol_kind <prefix> <index> <display_name> <expected_kind>
# Checks that a symbol with the given display_name has the expected SCIP kind.
# SCIP SymbolInformation.Kind values: 7=Type, 11=Enum, 17=Function, 30=Package,
# 49=EnumMember, 54=TypeParameter, 58=Macro, 61=Variable
verify_symbol_kind() {
  local pfx="$1" idx="$2" dn="$3" exp_kind="$4"
  log_check "symbol '$dn' has kind=$exp_kind"
  local actual
  actual="$(scip print --json "$idx" 2>/dev/null \
    | jq --arg dn "$dn" '[.documents[]?.symbols[]? | select(.display_name == $dn) | .kind] | first // -1')"
  if [ "$actual" -eq "$exp_kind" ]; then
    record_pass "$pfx/kind:$dn"
  else
    record_fail "$pfx/kind:$dn" "expected kind=$exp_kind, got $actual"
  fi
}

# verify_symbol_signature <prefix> <index> <display_name> <expected_substring>
# Checks that a symbol's signature_documentation.text contains the expected text.
verify_symbol_signature() {
  local pfx="$1" idx="$2" dn="$3" expected="$4"
  log_check "symbol '$dn' signature contains '$expected'"
  local sig
  sig="$(scip print --json "$idx" 2>/dev/null \
    | jq -r --arg dn "$dn" \
      '[.documents[]?.symbols[]? | select(.display_name == $dn) | .signature_documentation.text // ""] | map(select(. != "")) | first // ""')"
  if echo "$sig" | grep -q "$expected"; then
    record_pass "$pfx/sig:$dn"
  else
    record_fail "$pfx/sig:$dn" "signature '$(echo "$sig" | head -c 80)' missing '$expected'"
  fi
}

# verify_doc_definition_count <prefix> <index> <path_pattern> <min_defs>
# Checks that a specific source file has at least min_defs definition occurrences.
verify_doc_definition_count() {
  local pfx="$1" idx="$2" path_pat="$3" min_defs="$4"
  log_check "document matching '$path_pat' has >= $min_defs definitions"
  local count
  count="$(scip print --json "$idx" 2>/dev/null \
    | jq --arg pat "$path_pat" '
      [.documents[]? | select(.relative_path | test($pat; "i"))
       | (.occurrences // [])[] | select((.symbol_roles // 0) == 1)] | length')"
  if [ "$count" -ge "$min_defs" ]; then
    record_pass "$pfx/defs_in:$path_pat ($count)"
  else
    record_fail "$pfx/defs_in:$path_pat" "expected >= $min_defs definitions, got $count"
  fi
}

# ---------------------------------------------------------------------------
# Tier 3: Integrity verification — cross-references and role balance
# ---------------------------------------------------------------------------

# verify_xref_integrity <prefix> <index>
# Every symbol referenced in occurrences must have a declaration in
# symbols[] or external_symbols[].
verify_xref_integrity() {
  local pfx="$1" idx="$2"
  log_check "all occurrence symbols have declarations (xref integrity)"
  local orphans
  orphans="$(scip print --json "$idx" 2>/dev/null \
    | jq '. as $root
      | ([.documents[]?.symbols[]?.symbol] + [.external_symbols[]?.symbol])
      | map(select(. != null)) | unique as $declared
      | [$root.documents[]?.occurrences[]?.symbol]
      | map(select(. != null and . != "")) | unique as $referenced
      | ($referenced - $declared) | length')"
  if [ "$orphans" -eq 0 ]; then
    record_pass "$pfx/xref_integrity"
  else
    # Show sample orphans for debugging
    local samples
    samples="$(scip print --json "$idx" 2>/dev/null \
      | jq -r '. as $root
        | ([.documents[]?.symbols[]?.symbol] + [.external_symbols[]?.symbol])
        | map(select(. != null)) | unique as $declared
        | [$root.documents[]?.occurrences[]?.symbol]
        | map(select(. != null and . != "")) | unique as $referenced
        | ($referenced - $declared) | .[:3][]')"
    record_fail "$pfx/xref_integrity" "$orphans orphaned refs: $(echo "$samples" | tr '\n' ' ')"
  fi
}

# verify_def_ref_balance <prefix> <index>
# In any real codebase, references should outnumber definitions.
# A healthy ratio is typically 2:1 to 10:1 (refs:defs).
verify_def_ref_balance() {
  local pfx="$1" idx="$2"
  log_check "references outnumber definitions (healthy ref:def ratio)"
  local counts
  counts="$(scip print --json "$idx" 2>/dev/null \
    | jq '{defs: [.documents[].occurrences[]? | select((.symbol_roles // 0) == 1)] | length,
           refs: [.documents[].occurrences[]? | select((.symbol_roles // 0) != 1 and .symbol != null and .symbol != "")] | length}')"
  local defs refs
  defs="$(echo "$counts" | jq '.defs')"
  refs="$(echo "$counts" | jq '.refs')"
  log_check "  definitions=$defs, references=$refs"

  if [ "$defs" -eq 0 ]; then
    record_fail "$pfx/def_ref_balance" "zero definitions"
    return
  fi

  local ratio
  ratio=$(( refs / defs ))
  if [ "$refs" -gt "$defs" ] && [ "$ratio" -ge 1 ]; then
    record_pass "$pfx/def_ref_balance (ratio ${ratio}:1)"
  else
    record_fail "$pfx/def_ref_balance" "unexpected ratio: $refs refs / $defs defs = ${ratio}:1"
  fi
}

# ===========================================================================
# TEST DEFINITIONS
# ===========================================================================
# Each test function: clone → build → index → verify.
# Repos are pinned to exact commit hashes for reproducibility.
#
# Verification tiers:
#   1. Structural — metadata, counts, no empty docs, valid ranges
#   2. Content    — specific symbols have correct kind/display_name/signature
#   3. Integrity  — cross-references resolve, def/ref balance is sane
# ===========================================================================

# ---------------------------------------------------------------------------
# 1. pmderodat/ada-toml — TOML parser (medium, 8 source files, generics)
# ---------------------------------------------------------------------------
test_ada_toml() {
  local name="ada-toml"
  local url="https://github.com/pmderodat/ada-toml.git"
  local commit="f51ff9730aa916f33981db4589666577e9dd05c7"
  local repo_dir="$REPOS_DIR/$name"

  log_section "$name — TOML parser (8 source files, generics)"

  if ! clone_repo "$name" "$url" "$commit"; then
    record_fail "$name/clone" "git clone failed"
    return
  fi

  # Create wrapper .gpr (original uses external-valued Object_Dir)
  local gpr_path
  gpr_path="$(write_wrapper_gpr "$repo_dir" "ada_toml_scip" "src")"
  local gpr_rel
  gpr_rel="$(basename "$gpr_path")"

  log "Building with wrapper .gpr ..."
  if ! (cd "$repo_dir" && gprbuild -P "$gpr_rel" -q -p -j0 2>&1); then
    record_fail "$name/build" "gprbuild failed"
    return
  fi
  record_pass "$name/build"

  local index="$repo_dir/index.scip"
  log "Indexing ..."
  if ! (cd "$repo_dir" && "$SCIP_ADA" index \
        --project "$gpr_rel" \
        --output "$index" \
        --exclude b__ \
        --quiet 2>&1); then
    record_fail "$name/index" "scip_ada index failed"
    return
  fi
  record_pass "$name/index"

  # --- Tier 1: Structural verifications ---
  verify_metadata      "$name" "$index"
  verify_no_empty_docs "$name" "$index"
  verify_occurrence_ranges "$name" "$index"
  verify_exact_stats   "$name" "$index" 8 787 4397

  # --- Tier 2: Content verifications ---
  verify_symbols       "$name" "$index" "TOML" "Generic_Parse" "File_IO"
  verify_doc_paths     "$name" "$index" "toml.ads" "toml.adb" "toml-generic_parse.ads"
  verify_symbols_have_info "$name" "$index"
  # Load_File is a function (kind=17) with a known signature
  verify_symbol_kind      "$name" "$index" "Load_File" 17
  verify_symbol_signature "$name" "$index" "Load_File" "function Load_File"
  verify_symbol_signature "$name" "$index" "Load_File" "return Read_Result"
  # Create_Table is a function (kind=17)
  verify_symbol_kind      "$name" "$index" "Create_Table" 17
  verify_symbol_signature "$name" "$index" "Create_Table" "return TOML_Value"
  # TOML_Value is a type (kind=7)
  verify_symbol_kind      "$name" "$index" "TOML_Value" 7
  # toml.ads should have substantial definitions
  verify_doc_definition_count "$name" "$index" "toml\\.ads" 50

  # --- Tier 3: Integrity verifications ---
  verify_xref_integrity   "$name" "$index"
  verify_def_ref_balance  "$name" "$index"

  rm -f "$index"
}

# ---------------------------------------------------------------------------
# 2. AdaCore/ada-traits-containers — Trait-based containers (82 source files)
# ---------------------------------------------------------------------------
test_ada_traits_containers() {
  local name="ada-traits-containers"
  local url="https://github.com/AdaCore/ada-traits-containers.git"
  local commit="2adadb542a92981bc1c988add1184013a203add3"
  local repo_dir="$REPOS_DIR/$name"

  log_section "$name — Trait-based containers (82 source files, generics, tagged types)"

  if ! clone_repo "$name" "$url" "$commit"; then
    record_fail "$name/clone" "git clone failed"
    return
  fi

  local gpr_path
  gpr_path="$(write_wrapper_gpr "$repo_dir" "atc_scip" "src")"
  local gpr_rel
  gpr_rel="$(basename "$gpr_path")"

  log "Building with wrapper .gpr ..."
  if ! (cd "$repo_dir" && gprbuild -P "$gpr_rel" -q -p -j0 2>&1); then
    record_fail "$name/build" "gprbuild failed"
    return
  fi
  record_pass "$name/build"

  local index="$repo_dir/index.scip"
  log "Indexing ..."
  if ! (cd "$repo_dir" && "$SCIP_ADA" index \
        --project "$gpr_rel" \
        --output "$index" \
        --exclude b__ \
        --quiet 2>&1); then
    record_fail "$name/index" "scip_ada index failed"
    return
  fi
  record_pass "$name/index"

  # --- Tier 1: Structural verifications ---
  verify_metadata      "$name" "$index"
  verify_no_empty_docs "$name" "$index"
  verify_occurrence_ranges "$name" "$index"
  verify_exact_stats   "$name" "$index" 82 2610 16022

  # --- Tier 2: Content verifications ---
  verify_symbols       "$name" "$index" \
    "Conts" "Cursors" "Elements" "Storage"
  verify_doc_paths     "$name" "$index" ".ads" ".adb"
  verify_symbols_have_info "$name" "$index"
  # Vector and List are types (kind=7)
  verify_symbol_kind      "$name" "$index" "Vector" 7
  verify_symbol_kind      "$name" "$index" "List" 7
  verify_symbol_kind      "$name" "$index" "Map" 7
  # Element_Access is a subtype/type param (kind=54)
  verify_symbol_kind      "$name" "$index" "Element_Access" 54

  # --- Tier 3: Integrity verifications ---
  verify_xref_integrity   "$name" "$index"
  verify_def_ref_balance  "$name" "$index"

  rm -f "$index"
}

# ---------------------------------------------------------------------------
# 3. jrcarter/PragmARC — Pragmatic Ada Reusable Components (~197 files, large)
# ---------------------------------------------------------------------------
test_pragmarc() {
  local name="PragmARC"
  local url="https://github.com/jrcarter/PragmARC.git"
  local commit="0f279b9c99ace7d4c1b3fe4d5a3ff4b0ca233545"
  local repo_dir="$REPOS_DIR/$name"

  log_section "$name — Pragmatic Ada Components (~197 files, generics, tasks, protected types)"

  if ! clone_repo "$name" "$url" "$commit"; then
    record_fail "$name/clone" "git clone failed"
    return
  fi

  # PragmARC has no .gpr file; all sources are flat in the repo root.
  local gpr_path
  gpr_path="$(write_wrapper_gpr "$repo_dir" "pragmarc_scip" "." "compile_all.adb")"
  local gpr_rel
  gpr_rel="$(basename "$gpr_path")"

  log "Building with wrapper .gpr ..."
  if ! (cd "$repo_dir" && gprbuild -P "$gpr_rel" -q -p -j0 2>&1); then
    record_fail "$name/build" "gprbuild failed"
    return
  fi
  record_pass "$name/build"

  local index="$repo_dir/index.scip"
  log "Indexing ..."
  if ! (cd "$repo_dir" && "$SCIP_ADA" index \
        --project "$gpr_rel" \
        --output "$index" \
        --exclude b__ \
        --quiet 2>&1); then
    record_fail "$name/index" "scip_ada index failed"
    return
  fi
  record_pass "$name/index"

  # --- Tier 1: Structural verifications ---
  verify_metadata      "$name" "$index"
  verify_no_empty_docs "$name" "$index"
  verify_occurrence_ranges "$name" "$index"
  verify_exact_stats   "$name" "$index" 196 3906 20310

  # --- Tier 2: Content verifications ---
  verify_symbols       "$name" "$index" \
    "PragmARC" "Data_Structures" "Sorting" "Encryption"
  verify_doc_paths     "$name" "$index" \
    "pragmarc.ads" "pragmarc-data_structures.ads" "pragmarc-sorting-quick.ads"
  verify_symbols_have_info "$name" "$index"
  # Sort is a procedure (kind=17) with known signature fragment
  verify_symbol_kind      "$name" "$index" "Sort" 17
  verify_symbol_signature "$name" "$index" "Sort" "procedure Sort"
  # Encrypt and Decrypt are functions/procedures (kind=17)
  verify_symbol_kind      "$name" "$index" "Encrypt" 17
  verify_symbol_kind      "$name" "$index" "Decrypt" 17
  verify_symbol_signature "$name" "$index" "Encrypt" "Encrypt"
  verify_symbol_signature "$name" "$index" "Decrypt" "Decrypt"
  # pragmarc-encryption-threefish.ads should have definitions
  verify_doc_definition_count "$name" "$index" "pragmarc-sorting-quick" 5
  verify_doc_definition_count "$name" "$index" "pragmarc-encryption" 5

  # --- Tier 3: Integrity verifications ---
  verify_xref_integrity   "$name" "$index"
  verify_def_ref_balance  "$name" "$index"

  rm -f "$index"
}

# ===========================================================================
# MAIN
# ===========================================================================

echo "========================================"
echo "  scip-ada E2E: Real-World Repos"
echo "========================================"
echo "  Cache dir: $REPOS_DIR"
echo "  scip_ada:  $SCIP_ADA"
echo ""

test_ada_toml
test_ada_traits_containers
test_pragmarc

echo ""
echo "========================================"
echo "  Results: $PASS passed, $FAIL failed (of $TOTAL checks)"
echo "========================================"

if [ "$FAIL" -gt 0 ]; then
  echo ""
  echo "Failures:"
  printf "$ERRORS"
  exit 1
fi

echo "All checks passed!"
