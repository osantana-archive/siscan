*
* Imprime Totalizacao
*

SAVE SCREEN TO TMP
DO WHILE .T.
   SELECT ALUNO
   SET ORDER TO 2
   GO  TOP
   MOLDURA(12,01,18,76,STDMOLD,.T.,"Totaliza‡„o",STDINVE)
   SETCOLOR(STDMOLD+","+STDINVE)
   HNUMERO = 0
   @ 13,05 SAY "Entre com o N£mero:"
   @ 13,32 SAY "Senha:"
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
      MESSAGE("Registro N„o Existe !!!")
      LOOP
   ENDIF
   MESSAGE()
   HSENHA = KINPUT(13,39,4,.F.)
   IF HSENHA = "PHIL"
      EXIT
   ENDIF
   IF VAL(HSENHA) = 0
      LOOP
   ENDIF
   HSENHA  = STRZERO(VAL(HSENHA ),4,0)
   IF SENHA <> HSENHA
      MESSAGE("Senha Incorreta !!!")
      LOOP
   ENDIF
   MESSAGE()
   IF SALDOS >= 1
      MESSAGE("O Saldo s¢ Pode ser Retirado uma Vez por Semana...")
      INKEY(2)
      MESSAGE()
      EXIT
   ENDIF
   ST = SOMATORIA(HNUMERO)
   TO = ST - CREDITO
   SELECT ALUNO
   IF CREDITO <= ST
      IF BLOQUEIO > IF(TIPOPGTO = "S",1,IF(TIPOPGTO = "Q",2,IF(TIPOPGTO = "M",4,1)))
         FOR HSEMANAS = 1 TO INT(BLOQUEIO/2)
            TO = TO + ROUND(TO*D_JUROS,2)
         NEXT
      ENDIF
   ENDIF
   LIN  = 1
   KPRINT(@LIN,00,CHR(14)+"   Total")
   KPRINT(@LIN,00,"")
   KPRINT(@LIN,00,"Numero.: " + HNUMERO)
   KPRINT(@LIN,00,"Valor..: " + TRANSFORM(ST,"9,999.99"))
   IF BLOQUEIO > IF(TIPOPGTO = "S",1,IF(TIPOPGTO = "Q",2,IF(TIPOPGTO = "M",4,1)))
      KPRINT(@LIN,00,"Juros..: " + TRANSFORM(TO-(ST-CREDITO),"9,999.99"))
   ENDIF
   KPRINT(@LIN,00,"Credito: " + TRANSFORM(CREDITO,"9,999.99"))
   KPRINT(@LIN,00,"         --------")
   KPRINT(@LIN,00,"Total..: " + TRANSFORM(TO,"9,999.99"))
   KPRINT(@LIN,00,"")
   KRODAP(@LIN)
   IF REC_LOCK(0)
      REPLACE SALDOS WITH 1
      UNLOCK
   ENDIF
ENDDO
RESTORE SCREEN FROM TMP
RETURN
