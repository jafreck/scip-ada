  package body Utils is
//             ^^^^^ definition scip-ada . Multi_Unit . Utils/
     function Add (X, Y : Integer) return Integer is
//            ^^^ definition scip-ada . Multi_Unit . Add().
//                 ^ definition scip-ada . Multi_Unit . X.
//                    ^ definition scip-ada . Multi_Unit . Y.
     begin
        return X + Y;
     end Add;
  
     function Factorial (N : Natural) return Positive is
//            ^^^^^^^^^ definition scip-ada . Multi_Unit . Factorial().
//                       ^ definition scip-ada . Multi_Unit . N.
     begin
        if N <= 1 then
           return 1;
        else
           return N * Factorial (N - 1);
        end if;
     end Factorial;
  end Utils;
  
