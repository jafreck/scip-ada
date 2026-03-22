  package body Utils is
//             ^^^^^ definition scip-ada . . . Utils/
     function Add (X, Y : Integer) return Integer is
//            ^^^ definition scip-ada . . . Add().
//                 ^ definition scip-ada . . . X.
//                    ^ definition scip-ada . . . Y.
     begin
        return X + Y;
     end Add;
  
     function Factorial (N : Natural) return Positive is
//            ^^^^^^^^^ definition scip-ada . . . Factorial().
//                       ^ definition scip-ada . . . N.
     begin
        if N <= 1 then
           return 1;
        else
           return N * Factorial (N - 1);
        end if;
     end Factorial;
  end Utils;
  
