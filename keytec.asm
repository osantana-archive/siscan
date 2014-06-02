;
; Gerenciador de Teclado Numerico Keytec
;

   org   100H
   jmp   inicio

newint0b:
   sti    
   push  ax
   push  cx
   push  dx
   push  ds
   push  cs
   pop   ds
   cli
   mov   dx, 02F8h
   in    al, dx
   mov   ah, 05h
   mov   cl, al
   int   16h
   int   60h
   sti    
   mov   al,20h
   out   20h,al
   pop   ds
   pop   dx
   pop   cx
   pop   ax
iret   

cabec db 'KEYTEC - LEITOR DE TECLADOS AUXILIARES PADRAO R2-232C',13,10
      db 'Desenvolvido por: Osvaldo Santana Neto e Wagner Longo Castro'
      db 13,10,'$'

inicio:
   push  cs
   pop   ds
   mov   dx, Offset cabec    ; Imprime cabecalho.
   mov   ah,09h
   int   21h

   xor   cx,cx
   mov   dx,2FBH
   mov   al, 80h
   out   dx,al
   push  dx
   call  tempo
   xor   ax,ax
   mov   dx,2F9H
   out   dx,al
   call  tempo
   dec   dx
   mov   al,60h      ; 60h
   out   dx,al
   call  tempo
   pop   dx
   mov   al,0Ah      ; 1Ah
   out   dx,al
   call  tempo

   mov   ax,250BH
   mov   dx,Offset newint0b
   int   21H
   
   mov   dx,2FCH
   mov   al,0Bh      ; 0Bh
   out   dx,al
   mov   dx,2F9H
   mov   al,01       ; 01h
   out   dx,al
   mov   dx,21H
   in    al,dx
   and   al,-9
   out   dx,al
   
   mov   ax,3100H
   mov   dx,15H
   int   21H

tempo:
C1N1F4H: jcxz  C1N1F6H
C1N1F6H: jcxz  C1N1F8H
C1N1F8H: jcxz  C1N1FAH
C1N1FAH: jcxz  C1N1FCH
C1N1FCH: jcxz  C1N1FEH
C1N1FEH: jcxz  C1N200H
C1N200H: jcxz  C1N202H
C1N202H: jcxz  C1N204H
C1N204H: jcxz  C1N206H
C1N206H: jcxz  C1N208H
C1N208H: jcxz  C1N20AH
C1N20AH: jcxz  C1N20CH
C1N20CH: 
ret    
