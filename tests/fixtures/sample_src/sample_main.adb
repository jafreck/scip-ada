with Sample;

procedure Sample_Main is
   P1 : Sample.Point := (X => 1, Y => 2);
   P2 : Sample.Point := (X => 3, Y => 4);
   P3 : Sample.Point;
   S  : Sample.Shape;
   C  : Sample.Circle;
   A  : Float;
begin
   P3 := Sample."+" (P1, P2);
   S.Origin := P1;
   Sample.Draw (S);
   A := Sample.Area (S);
   C := (Origin => P1, Radius => 5.0);
   Sample.Draw (Sample.Shape (C));
   A := Sample.Area (C);
end Sample_Main;
