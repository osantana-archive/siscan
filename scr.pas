{ SCR.PAS - TSR Screensaver for PoS Terminal }
{ (c) 1994 Osvaldo Santana Neto              }

program scr_saver;

{$M 15000,0,0}

uses dos,crt;

const tmp_ativ = 3276;
      tmp_troc = 0055;

var oldint09 : pointer;
    tempo    : byte;
    total    : word;
    ativo    : boolean;
    x,y      : byte;
    scr      : array[0..1999] of word absolute $B800:0000;
    tel      : array[0..1999] of word;
    loopi    : word;

procedure say(x,y : byte; msg : string);
var aux : word;
begin
   for aux := 1 to length(msg) do
      mem[$B800:((y*80+x)*2)+(aux*2)-2] := ord(msg[aux]);
end;

procedure int09; interrupt;
begin
   total := 0;
   if ativo then begin
      move(tel,scr,4000);
      ativo := false;
   end;
   inline($9C/$FF/$1E/oldint09);
end;

procedure int60; interrupt;
begin
   total := 0;
   if ativo then begin
      move(tel,scr,4000);
      ativo := false;
   end;
end;

procedure int1C; interrupt;
begin
   if (total = tmp_ativ) and (not ativo) then begin
      ativo := true;
      for loopi := 0 to 1999 do begin
         tel[loopi] := scr[loopi];
         scr[loopi] := $0720;
      end;
   end;
   if ativo then begin
      if tempo = tmp_troc then begin
         say(x,y,'              ');
         x := random(65);
         y := random(24);
         say(x,y,'Tecle ENTRA...');
         tempo := 0;
      end;
      inc(tempo);
   end
   else inc(total);
end;

begin
   randomize;
   ativo := false;
   tempo := 55;
   total := 00;
   x     := 00;
   y     := 00;
   getintvec($09,oldint09);
   setintvec($09,@int09);
   setintvec($60,@int60);
   setintvec($1C,@int1c);
   keep(0);
end.
