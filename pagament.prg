*
* Pagamento de Contas
*

SAVE SCREEN TO TMP
DO WHILE .T.
   SELECT ALUNO
   SET ORDER TO 2
   GO  TOP
   MOLDURA(12,01,18,76,STDMOLD,.T.,"Pagamento de Contas",STDINVE)
   SETCOLOR(STDMOLD+","+STDINVE)
   HNUMERO   = 0
   HSENHA    = 0
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
   @ 13,32 SAY ALUNO->NOME
   SUBTOTAL = SOMATORIA(HNUMERO)
   IF SUBTOTAL <= 0
      MESSAGE("Conta já foi Paga !!!")
      LOOP
   ENDIF
   IF CREDITO > SUBTOTAL
      MESSAGE("Sua conta tem R$ "+STR(CREDITO,7,2)+" em haver.")
      LOOP
   ENDIF   
   MESSAGE()
   SELECT LANCAMEN
   SET ORDER TO 2
   GO TOP
   SEEK HNUMERO
   DATA1COMPRA = DATALCTO
   SELECT ALUNO
   TOTAL   = SUBTOTAL - CREDITO
   D_JUROS = 0.00
   JUROS   = 0.00
   IF DATE()-DATA1COMPRA > D_DIAS
      CORANT = SETCOLOR("N/W")
      @ 17,35 SAY "Deve a "+STRZERO(DATE()-DATA1COMPRA,4)+" dias"
      SETCOLOR(CORANT)
      @ 14,05 SAY "Juros....:" GET D_JUROS PICTURE "99.99"
      SET CONFIRM ON
      SET CURSOR ON
      READ
      SET CURSOR OFF
      SET CONFIRM OFF
      IF LASTKEY() = 27
         LOOP
      ENDIF
      JUROS = ROUND(TOTAL*(D_JUROS/100),2)
      TOTAL = TOTAL + JUROS
   ENDIF
   HDINHEIRO = 0
   @ 15,05 SAY "Dinheiro..:" + TRANSFORM(TOTAL,"@E9,999.99")
   SELECT LANCAMEN
   GO TOP
   SELECT ALUNO
   @ 16,05 SAY "Valor em Dinheiro: " GET HDINHEIRO PICTURE "9,999.99"
   SET CONFIRM ON
   SET CURSOR ON
   READ
   SET CURSOR OFF
   SET CONFIRM OFF
   IF LASTKEY() = 27
      EXIT
   ENDIF
   IF VAL(TRANSFORM(TOTAL,"9,999.99")) > HDINHEIRO
      MESSAGE("Dinheiro Insuficiente para Pagamento de Conta...")
      INKEY(0)
      MESSAGE()
      LOOP
   ENDIF
   LIN   = 1
   SELECT LANCAMEN
   SET ORDER TO 2
   GO TOP
   KPRINT(@LIN,00,CHR(14)+" Pagamento")
   KPRINT(@LIN,00,"")
   KPRINT(@LIN,00,"Numero: "+HNUMERO)
   KPRINT(@LIN,00,ALUNO->NOME)
   KPRINT(@LIN,00,"")
   KPRINT(@LIN,00,"DATA |QTD|PRO-|VALOR DO")
   KPRINT(@LIN,00,"PED. |   |DUTO|PEDIDO  ")
   KPRINT(@LIN,00,"-----+---+----+--------")
   DO WHILE .NOT. EOF()
      IF CODIGO = HNUMERO
         KPRINT(@LIN,00,STRZERO(DAY  (DATALCTO),2,0)+"/"+;
                        STRZERO(MONTH(DATALCTO),2,0)+"|"+;
                        STRZERO(QTDPROD        ,3,0)+"| "+;
                        STRZERO(VAL(CODPROD)   ,3,0)+"|"+;
                        TRANSFORM(VALOR,"9,999.99"))
      ENDIF
      SKIP +1
   ENDDO
   SELECT ALUNO
   KPRINT(@LIN,00,"               --------")
   KPRINT(@LIN,00,"Sub-Total:     " + TRANSFORM(SUBTOTAL,"9,999.99"))
   KPRINT(@LIN,00,"Credito..:     " + TRANSFORM(CREDITO ,"9,999.99"))
   KPRINT(@LIN,00,"Juros....:     " + TRANSFORM(JUROS   ,"9,999.99"))
   KPRINT(@LIN,00,"               --------")
   KPRINT(@LIN,00,"Total....:     " + TRANSFORM(TOTAL          ,"9,999.99"))
   KPRINT(@LIN,00,"Dinheiro.:     " + TRANSFORM(HDINHEIRO      ,"9,999.99"))
   KPRINT(@LIN,00,"Troco....:     " + TRANSFORM(HDINHEIRO-TOTAL,"9,999.99"))
   KPRINT(@LIN,00,"")
   KPRINT(@LIN,00,"")
   KPRINT(@LIN,00,"")
   KPRINT(@LIN,00,CHR(14)+"Via do Caixa")
   KPRINT(@LIN,00,"")
   KPRINT(@LIN,00,"Numero: "+HNUMERO)
   KPRINT(@LIN,00,ALUNO->NOME)
   KPRINT(@LIN,00,"")
   KPRINT(@LIN,00,"Total....:     " + TRANSFORM(TOTAL          ,"9,999.99"))
   KPRINT(@LIN,00,"Dinheiro.:     " + TRANSFORM(HDINHEIRO      ,"9,999.99"))
   KPRINT(@LIN,00,"Juros....:     " + TRANSFORM(JUROS          ,"9,999.99"))
   KPRINT(@LIN,00,"Troco....:     " + TRANSFORM(HDINHEIRO-TOTAL,"9,999.99"))
   KPRINT(@LIN,00,"Deve a " + STRZERO(DATE()-DATA1COMPRA,4) + " dias")
   KRODAP(@LIN)
   IF REC_LOCK(0)
      REPLACE CREDITO  WITH 0
      REPLACE BLOQUEIO WITH 0
      UNLOCK
   ENDIF
   SELECT  LANCAMEN
   GO TOP
   IF FIL_LOCK(0)
     DO WHILE .NOT. EOF()
        IF CODIGO = HNUMERO
           SELECT MORTO
           APPEND BLANK
           IF REC_LOCK(0)
              REPLACE CODIGO   WITH LANCAMEN->CODIGO
              REPLACE QTDPROD  WITH LANCAMEN->QTDPROD
              REPLACE CODPROD  WITH LANCAMEN->CODPROD
              REPLACE VALOR    WITH LANCAMEN->VALOR
              REPLACE FLAG     WITH LANCAMEN->FLAG
              REPLACE USUARIO  WITH LANCAMEN->USUARIO
              REPLACE DATALCTO WITH LANCAMEN->DATALCTO
           ENDIF
           SELECT LANCAMEN
           IF REC_LOCK(0)
              DELETE
              UNLOCK
           ENDIF
        ENDIF
        SKIP +1
     ENDDO
     UNLOCK ALL
   ENDIF
ENDDO
RESTORE SCREEN FROM TMP
RETURN
