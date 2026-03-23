  package Utils is
//        ^^^^^ definition scip-ada . Multi_Unit . Utils/
//        kind Namespace
     function Add (X, Y : Integer) return Integer;
//            ^^^ definition scip-ada . Multi_Unit . Add().
//            kind Function
//                 ^ definition scip-ada . Multi_Unit . X.
//                 kind Variable
//                    ^ definition scip-ada . Multi_Unit . Y.
//                    kind Variable
     function Factorial (N : Natural) return Positive;
//    ^^^^^ reference scip-ada . Multi_Unit . Utils/
//     ^^^^^ reference scip-ada . Multi_Unit . Utils/
//            ^^^^^^^^^ definition scip-ada . Multi_Unit . Factorial().
//            kind Function
//                       ^ definition scip-ada . Multi_Unit . N.
//                       kind Variable
  end Utils;
//    ^^^^^ reference scip-ada . Multi_Unit . Utils/
//         ^^^^^ reference scip-ada . Multi_Unit . Utils/
//             ^ reference scip-ada . Multi_Unit . X.
//                 ^ reference scip-ada . Multi_Unit . Y.
  
//       ^^^ reference scip-ada . Multi_Unit . Add().
//          ^^^ reference scip-ada . Multi_Unit . Add().
