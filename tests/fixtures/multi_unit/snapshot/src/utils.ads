  package Utils is
//        ^^^^^ definition scip-ada . . . Utils/
//        kind Namespace
     function Add (X, Y : Integer) return Integer;
//            ^^^ definition scip-ada . . . Add().
//            kind Function
//            documentation
//            > function Add (X, Y : Integer) return Integer
//                 ^ definition scip-ada . . . X.
//                 kind Variable
//                 documentation
//                 > function Add (X, Y : Integer) return Integer
//                    ^ definition scip-ada . . . Y.
//                    kind Variable
//                    documentation
//                    > function Add (X, Y : Integer) return Integer
     function Factorial (N : Natural) return Positive;
//    ^^^^^ reference scip-ada . . . Utils/
//     ^^^^^ reference scip-ada . . . Utils/
//            ^^^^^^^^^ definition scip-ada . . . Factorial().
//            kind Function
//            documentation
//            > function Factorial (N : Natural) return Positive
//                       ^ definition scip-ada . . . N.
//                       kind Variable
//                       documentation
//                       > function Factorial (N : Natural) return Positive
  end Utils;
//    ^^^^^ reference scip-ada . . . Utils/
//         ^^^^^ reference scip-ada . . . Utils/
//             ^ reference scip-ada . . . X.
//                 ^ reference scip-ada . . . Y.
  
//       ^^^ reference scip-ada . . . Add().
//          ^^^ reference scip-ada . . . Add().
