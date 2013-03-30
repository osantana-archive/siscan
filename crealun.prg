*
* Creditar
*

SAVE SCREEN TO TMP
DO WHILE .T.
   SELECT ALUNO
   SET ORDER TO 2
   MOLDURA(12,01,18,76,STDMOLD,.T.,"Creditar",STDINVE)
   SETCOLOR(STDMOLD+","+STDINVE)
   HNUMERO  = 00
   HCREDITO = 00
   @ 13,05 SAY "Entre com o N£mero:"
   HNUMERO = KINPUT(13,25,4,.T.)
   IF HNUMERO = "PHIL"
      EXIT
   ENDIF
   IF VAL(HNUMERO) = 0
      MESSAGE()
      LOOP
   ENDIF
   HNUMERO = STRZERO(VAL(HNUMERO),4,0)
   SEEK HNUMERO
   IF .NOT. FOUND()
      MESSAGE("Registro N„o Existe !!!")
      LOOP
   ENDIF
   MESSAGE()
   @ 15,05 SAY "Cr‚dito atual: " + TRANSFORM(CREDITO,"9,999.99")
   @ 14,05 SAY "Creditar.....:" GET HCREDITO PICTURE "9,999.99"
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF LASTKEY() = 27 .OR. HCREDITO = 0
      EXIT
   ENDIF
   BLOQ = .F.
   IF CONFIRM("Remover bloqueio de conta?")
      BLOQ = .T.
   ENDIF      
   IF REC_LOCK(0)
      IF BLOQ
         REPLACE BLOQUEIO WITH 0
      ENDIF
      REPLACE CREDITO WITH CREDITO + HCREDITO
      UNLOCK
   ENDIF
   FOR TMP1 = 1 TO 2
      LIN   = 1
      KPRINT(@LIN,00,CHR(14)+"  Creditar")
      KPRINT(@LIN,00,"")
      KPRINT(@LIN,00,"Numero: " + HNUMERO)
      KPRINT(@LIN,00,"")
      KPRINT(@LIN,00,"Creditado: "+TRANSFORM(HCREDITO,"9,999.99"))
      KPRINT(@LIN,00,"Credito..: "+TRANSFORM(CREDITO ,"9,999.99"))
      IF BLOQ
         KPRINT(@LIN,00,"Bloqueio Removido")
      ENDIF
      KRODAP(@LIN)
   NEXT TMP1
ENDDO
RESTORE SCREEN FROM TMP
RETURN
