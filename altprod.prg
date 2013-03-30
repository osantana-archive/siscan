*
* Alteracao de Produto
*

SAVE SCREEN TO TMP
DO WHILE .T.
   MESSAGE()
   SELECT PRODUTO
   MOLDURA(12,01,18,76,STDMOLD,.T.,"Alteraçäo de Produtos",STDINVE)
   SETCOLOR(STDMOLD+","+STDINVE)
   LOADVARS()
   HCODPROD = 0
   @ 13,05 SAY "Código do Produto:" GET HCODPROD PICTURE "999"
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF LASTKEY() = 27 .OR. HCODPROD = 0
      EXIT
   ENDIF
   HCODPROD = STRZERO(HCODPROD,3,0)
   SETCOLOR(STDINVE)
   @ 13,24 SAY HCODPROD
   SETCOLOR(STDMOLD)
   SEEK HCODPROD
   IF .NOT. FOUND()
      MESSAGE("Registro näo Existe !!! Tecle algo...")
      INKEY(0)
      MESSAGE()
      LOOP
   ENDIF
   COPYVARS()
   @ 13,05 SAY "Código do Produto:" GET XCODPROD  PICTURE "!!!"
   @ 15,05 SAY "Nome do Produto:  " GET XNOMEPROD PICTURE "@!"
   @ 17,05 SAY "Valor do Produto: " GET XVALOR PICTURE "9,999.99"
   SET CURSOR ON
   READ
   SET CURSOR OFF
   REG = RECNO()
   SEEK XCODPROD
   IF FOUND() .AND. RECNO() <> REG
      MESSAGE("Esse Código já Existe !!! Tecle Algo...")
      INKEY(0)
      MESSAGE()
      LOOP
   ELSE
      IF .NOT. LASTKEY() = 27
         GO REG
         IF REC_LOCK(0)
            SAVEVARS()
            UNLOCK
         ENDIF
      ENDIF
   ENDIF
ENDDO
RESTORE SCREEN FROM TMP
RETURN
