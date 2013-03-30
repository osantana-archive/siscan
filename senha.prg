*
* Reimpressao de Senha do Usuario
*

SAVE SCREEN TO TMP
DO WHILE .T.
   SELECT ALUNO
   SET ORDER TO 2
   GO  TOP
   MOLDURA(12,01,18,76,STDMOLD,.T.,"Reimpressäo de Senha",STDINVE)
   SETCOLOR(STDMOLD+","+STDINVE)
   HNUMERO = 0
   @ 13,05 SAY "Entre com o Número:"
   HNUMERO = KINPUT(13,25,4,.T.)
   IF HNUMERO = "PHIL"
      EXIT
   ENDIF
   IF VAL(HNUMERO) = 0
      LOOP
   ENDIF
   HNUMERO = STRZERO(VAL(HNUMERO),4,0)
   SEEK HNUMERO
   IF .NOT. FOUND()
      MESSAGE("Registro Näo Existe !!!")
      LOOP
   ENDIF
   MESSAGE()
   LIN = 1
   KPRINT(@LIN,00,CHR(14)+"   Senha")
   KPRINT(@LIN,00,"")
   KPRINT(@LIN,00,NOME)
   KPRINT(@LIN,00,"    Numero     Senha")
   KPRINT(@LIN,00,"    "+CONTA+"       "+SENHA)
   KRODAP(@LIN)
ENDDO
RESTORE SCREEN FROM TMP
RETURN
