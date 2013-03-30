*
* Exclusao de Produtos
*

SAVE SCREEN TO TMP
DO WHILE .T.
   MESSAGE()
   SELECT PRODUTO
   SET ORDER TO 1
   MOLDURA(12,01,18,76,STDMOLD,.T.,"Exclus„o de Produtos",STDINVE)
   SETCOLOR(STDMOLD+","+STDINVE)
   LOADVARS()
   HCODPROD = 0
   @ 13,05 SAY "C¢digo do Produto:" GET HCODPROD PICTURE "999"
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
      MESSAGE("Registro n„o Existe !!! Tecle Algo...")
      INKEY(0)
      MESSAGE()
      LOOP
   ENDIF
   COPYVARS()
   @ 13,05 SAY "C¢digo do Produto:" GET XCODPROD  PICTURE "!!!"
   @ 15,05 SAY "Nome do Produto:  " GET XNOMEPROD PICTURE "@!"
   @ 17,05 SAY "Valor do Produto: " GET XVALOR PICTURE "9,999.99"
   CLEAR GETS
   ARROWS(.F.)
   OPCTMP = 2
   @ 23,02 SAY "Deseja Apagar esse Registro ? "
   @ 23,COL()+2 PROMPT "  Sim  "
   @ 23,COL()+2 PROMPT "  N„o  "
   MENU TO OPCTMP
   ARROWS(.T.)
   IF OPCTMP = 1
      IF REC_LOCK(0)   
         DELETE
         UNLOCK
      ENDIF
   ENDIF      
ENDDO
RESTORE SCREEN FROM TMP
RETURN
