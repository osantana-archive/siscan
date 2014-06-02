program Enviroment;

uses dos,crt;

Type FontHeaderType = Record
                      Header: Array [0..108] of char;
                      HiVer : Byte;
                      LoVer : Byte;
                      BperC : Byte;
                      FName : String[38];
     end;
     FontType = array[0..8191] of byte;

var FontHeader           : FontHeaderType;
    Font                 : FontType;
    f                    : file;
    FontOfs,FontSeg      : word;
 
begin
   mem[$0040:$0017] := mem[$0040:$0017] or $40;
   assign(f,'graph.fnt');
   reset(f,1);
   Blockread(f,FontHeader,SizeOf(FontHeader));
   Blockread(f,Font,256*FontHeader.BperC);
   FontSeg := Seg(Font);
   FontOfs := Ofs(Font);
   asm
      push bp
      mov es, FontSeg
      mov bp, FontOfs
      mov ah, 11h
      mov al, 10h
      mov bh, FontHeader.BperC
      mov bl, 0
      mov cx, 256
      mov dx, 0
      int 10h
      pop bp
      mov ax, 1003h
      mov bl, 00h
      int 10h
   end;
end.
