*
* Cancela Lancamento
*

SAVE SCREEN TO TMP
DO WHILE .T.
   SELECT ALUNO
   SET ORDER TO 2
   SET DELETED OFF
   GO TOP
   MOLDURA(12,01,21,76,STDMOLD,.T.,"Cancela Lan‡amento",STDINVE)
   SETCOLOR(STDMOLD+","+STDINVE)
   HNUMERO = SPACE(4)
   @ 14,04 SAY "Entre com o N£mero:" GET HNUMERO PICTURE "9999"
   SET CONFIRM ON
   SET CURSOR ON
   READ
   SET CURSOR OFF
   SET CONFIRM OFF
   IF LASTKEY() = 27 .OR. EMPTY(HNUMERO)
      SET FILTER TO
      SET DELETED ON
      EXIT
   ENDIF
   HNUMERO = STRZERO(VAL(HNUMERO),4,0)
   SEEK HNUMERO
   IF .NOT. FOUND()
      MESSAGE("Registro N„o Encontrado...")
      LOOP
   ENDIF
   MESSAGE()
   SELECT LANCAMEN
   SET FILTER TO CODIGO = HNUMERO
   GO  TOP
   STORE .F. TO OK
   DECLARE MAT1[5],MAT2[5],MAT3[5]
   MAT1[1] = "CODIGO"
   MAT1[2] = "DATALCTO"
   MAT1[3] = "CODPROD"
   MAT1[4] = "VALOR"
   MAT1[5] = "IF(DELETED(),'Cancelado','         ')"
   MAT2[1] = "C¢digo"
   MAT2[2] = "Data"
   MAT2[3] = "Produto"
   MAT2[4] = "Valor"
   MAT2[5] = "Estado"
   MAT3[1] = "ÄÂÄ"
   MAT3[2] = "ÄÂÄ"
   MAT3[3] = "ÄÂÄ"
   MAT3[4] = "ÄÂÄ"
   MAT3[5] = "ÄÂÄ"
   SET ORDER TO 3
   GO TOP
   DBEDIT(13,02,20,75,MAT1,"UDF2","",MAT2,MAT3)
   SET FILTER TO
   COMMIT
ENDDO
SET DELETED ON
SET FILTER TO
RESTORE SCREEN FROM TMP
RETURN

FUNCTION UDF2
RET = 1
IF LASTKEY() = 13 .AND. OK
   IF DELETED()
      IF REC_LOCK(0)
         RECALL
         UNLOCK
      ENDIF
   ELSE
      IF REC_LOCK(0)
         DELETE
         UNLOCK
      ENDIF
   ENDIF
ENDIF
IF LASTKEY() = 27 .AND. OK
   RET = 0
ENDIF
STORE .T. TO OK
RETURN(RET)
