*
* Encerramento de Conta / Exclusao de Aluno
*

SAVE SCREEN TO TMP
DO WHILE .T.
   SELECT ALUNO
   SET ORDER TO 2
   MOLDURA(12,01,21,76,STDMOLD,.T.,"Encerramento de Conta",STDINVE)
   SETCOLOR(STDMOLD+","+STDINVE)
   HNUMERO = 00
   @ 13,05 SAY "Entre com a conta:" GET HNUMERO PICTURE "9999"
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF LASTKEY() = 27 .OR. HNUMERO = 0
      EXIT
   ENDIF
   SEEK HNUMERO
   IF .NOT. FOUND()
      MESSAGE("Registro N„o Existe !!!")
      LOOP
   ENDIF
   MESSAGE()
   @ 13,05 SAY SPACE(26)
   COPYVARS()
   @ 13,03 SAY "Conta.....:" GET XCONTA   PICTURE "9999"
   @ 13,21 SAY "RG:"         GET XRG      PICTURE "999.999.999-!"
   @ 14,03 SAY "Nome......:" GET XNOME    PICTURE "@!"
   @ 15,03 SAY "Endere‡o..:" GET ENDERECO PICTURE "@!"
   @ 16,03 SAY "Bairro....:" GET BAIRRO   PICTURE "@!"
   @ 16,52 SAY "CEP.......:" GET CEP      PICTURE "99.999-999"
   @ 17,03 SAY "Cidade....:" GET CIDADE   PICTURE "@!"
   @ 17,52 SAY "Estado....:" GET ESTADO   PICTURE "@!"
   @ 18,03 SAY "Telefone..:" GET TELEFONE PICTURE "(999) 999-9999"
   @ 18,52 SAY "Tipo Pgto.:" GET TIPOPGTO PICTURE "!"
   @ 20,03 SAY "Senha: [****]"
   @ 20,35 SAY "Deve a "+STRZERO(INT(BLOQUEIO/2),2,0)+" semana(s)  Tipo Pgto.: "+TIPOPGTO
   CLEAR GETS
   IF CONFIRM("Deseja encerrar essa conta?",.F.)
      EXTRATO(XCONTA,"CODIGO=NCONTA")
      SELECT ALUNO
      IF REC_LOCK(0)
         DELETE
         UNLOCK
      ENDIF
      SELECT LANCAMEN
      IF FIL_LOCK(0)
         DELETE FOR CODIGO = XCONTA
         UNLOCK
      ENDIF
   ENDIF
ENDDO
RESTORE SCREEN FROM TMP
RETURN
