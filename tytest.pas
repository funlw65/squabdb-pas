program tytest;

uses sysutils,ty,squabdbty{,raylib,raygui};

var
  pigeons : breeds;

procedure print_breed;
begin
  write(pigeons.name +' ');
  write(pigeons.category + ' ');
  writeln(pigeons.origin);
  writeln(pigeons.description);
  writeln;
end;

begin
  d_dbfpath('data');
  if(d_open('squabdb','x') = S_OKAY) then begin
    if(d_keyfrst(NAME_FLD) = S_OKAY) then begin
      if(d_recread(@pigeons) = S_OKAY) then begin
        print_breed;
        while((d_keynext(NAME_FLD)) = S_OKAY) do begin
          d_recread(@pigeons);
          print_breed;
        end;
      end
      else writeln('Error d_recread!');
    end
    else writeln('Error d_keyfrst!');
    //
    d_close();  
  end
  else writeln('Error opening the database!');
end.
