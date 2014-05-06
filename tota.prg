*
* Totalizacao
*

SAVE SCREEN TO TMP
RESTORE SCREEN FROM ENTRASCR
MOLDURA(07,24,11,56,STDMOLD,.T.,"Totaliza‡„o",STDINVE)
SAVE SCREEN TO TTOTA
SET CURSOR OFF
DO WHILE .T.
   SELECT ALUNO
   SET ORDER TO 2
   GO  TOP
   RESTORE SCREEN FROM TTOTA
   SET COLOR TO N/W
   @ 21,01 SAY ALIGN("Tecle + para pedidos.","C",78)
   SET COLOR TO W/N
   @ 09,27 SAY "N£mero: "
   @ 09,42 SAY "Senha: "
   HNUMERO = KINPUT(09,35,04,.T.,"0",.T.)
   IF HNUMERO = "PHIL" .OR. HNUMERO = "TOTA"
      EXIT
   ENDIF
   IF VAL(HNUMERO) = 0
      EXIT
   ENDIF
   SEEK HNUMERO
   IF .NOT. FOUND()
      LOOP
   ENDIF
   DO WHILE .T.
      HSENHA  = KINPUT(09,49,04,.F.,"0",.T.)
      IF HSENHA = "PHIL" .OR. VAL(HSENHA) = 0
         SAI = .T.
         EXIT
      ENDIF
      IF HSENHA <> SENHA
         MESSAGE("Senha Errada !!! Entre Novamente...")
         ? CHR(7)
         LOOP
      ELSE
         MESSAGE()
         SAI = .F.
         EXIT
      ENDIF
   ENDDO
   IF SAI
      LOOP
   ENDIF
   IF SALDOS >= 1
      @ 18,10 SAY "O Saldo s¢ Pode ser Retirado uma Vez por Semana..."
      ? CHR(7)      
      INKEY(5)
      @ 18,10 SAY "                                                  "
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