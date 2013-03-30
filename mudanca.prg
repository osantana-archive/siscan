*
* Alteracao / Transferencia de Conta / Senha
*

SAVE SCREEN TO TMP
DO WHILE .T.
   SELECT ALUNO
   SET ORDER TO 2
   GO  TOP
   MOLDURA(12,01,21,76,STDMOLD,.T.,"Altera‡„o de Conta",STDINVE)
   HCODIGO = 0
   @ 13,05 SAY "Entre com o N£mero:" GET HCODIGO PICTURE "9999"
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF LASTKEY() = 27 .OR. HCODIGO = 0
      EXIT
   ENDIF
   HNUMERO = STRZERO(HCODIGO,4,0)
   SEEK HNUMERO
   IF .NOT. FOUND()
      MESSAGE("Registro N„o Existe!!!")
      LOOP
   ENDIF
   MESSAGE()
   @ 13,05 SAY SPACE(25)
   COPYVARS()
   @ 20,03 SAY "Senha: [****]"
   @ 13,21 SAY "RG:"         GET XRG       PICTURE "999.999.999-!"
   @ 14,03 SAY "Nome......:" GET XNOME     PICTURE "@!"
   @ 15,03 SAY "Endere‡o..:" GET XENDERECO PICTURE "@!"
   @ 16,03 SAY "Bairro....:" GET XBAIRRO   PICTURE "@!"
   @ 16,52 SAY "CEP.......:" GET XCEP      PICTURE "99.999-999"
   @ 17,03 SAY "Cidade....:" GET XCIDADE   PICTURE "@!"
   @ 17,52 SAY "Estado....:" GET XESTADO   PICTURE "@!"
   @ 18,03 SAY "Telefone..:" GET XTELEFONE PICTURE "(999) 999-9999"
*   @ 18,52 SAY "Tipo Pgto.:" GET XTIPOPGTO PICTURE "!" VALID (XTIPOPGTO="S" .OR. XTIPOPGTO="Q" .OR. XTIPOPGTO="M")
   CLEAR GETS
   HCONTA = VAL(XCONTA)
   @ 13,03 SAY "Conta.....:" GET HCONTA    PICTURE "9999"
   SET CURSOR ON
   SET CONFIRM OFF
   READ
   SET CURSOR OFF
   SET CONFIRM ON
   IF LASTKEY() = 27 .OR. EMPTY(HCONTA)
      LOOP
   ENDIF
   XCONTA = STRZERO(HCONTA,4,0)
   REGTMP = RECNO()
   GO TOP
   SEEK XCONTA
   IF FOUND() .AND. REGTMP <> RECNO()
      MESSAGE("Essa conta j  existe...")
      LOOP
   ENDIF
   GO REGTMP
   @ 20,03 SAY "Senha: [    ]"
   @ 13,21 SAY "RG:"         GET XRG       PICTURE "999.999.999-!"
   @ 14,03 SAY "Nome......:" GET XNOME     PICTURE "@!"
   @ 15,03 SAY "Endere‡o..:" GET XENDERECO PICTURE "@!"
   @ 16,03 SAY "Bairro....:" GET XBAIRRO   PICTURE "@!"
   @ 16,52 SAY "CEP.......:" GET XCEP      PICTURE "99.999-999"
   @ 17,03 SAY "Cidade....:" GET XCIDADE   PICTURE "@!"
   @ 17,52 SAY "Estado....:" GET XESTADO   PICTURE "@!"
   @ 18,03 SAY "Telefone..:" GET XTELEFONE PICTURE "(999) 999-9999"
*   @ 18,52 SAY "Tipo Pgto.:" GET XTIPOPGTO PICTURE "!" VALID (XTIPOPGTO="S" .OR. XTIPOPGTO="Q" .OR. XTIPOPGTO="M")
   SET CURSOR ON
   SET CONFIRM OFF
   READ
   SET CURSOR OFF
   SET CONFIRM ON
   IF LASTKEY() = 27
      LOOP
   ENDIF
   REGTMP = RECNO()
   SET ORDER TO 3
   GO  TOP
   SEEK XRG
   IF FOUND() .AND. REGTMP <> RECNO()
      MESSAGE("J  existe registro com esse RG...")
      LOOP
   ENDIF
   GO REGTMP
   SETCOLOR(STDINVE)
   @ 20,10 SAY "[    ]"
   EXIT_FLAG = .F.
   DO WHILE .T.
      SETCOLOR(STDINVE) 
      @ 20,10 SAY "[    ]"
      HSENHA = PASSWORD(20,11,"*",".",4)
      SETCOLOR(STDMOLD+","+STDINVE)
      IF LASTKEY() = 27
         EXIT_FLAG = .T.
         EXIT
      ENDIF
      IF EMPTY(HSENHA)
         HSENHA = ALEAT()
         @ 20,17 SAY "<- Senha gerada por Computador"
         SETCOLOR(STDINVE)
         @ 20,10 SAY "[****]"
         EXIT
      ELSE
         @ 20,17 SAY "<- Confirme a Senha !!!"
         SETCOLOR(STDINVE)
         @ 20,10 SAY "[    ]"
         ZSENHA = PASSWORD(20,11,"*",".",4)
         SETCOLOR(STDMOLD+","+STDINVE)
         @ 20,17 SAY SPACE(25)
         IF LASTKEY() = 27 .OR. ZSENHA <> HSENHA
            @ 20,17 SAY "<- Erro. Redigite."
            LOOP
         ENDIF
         EXIT
      ENDIF
   ENDDO
   IF EXIT_FLAG
      EXIT
   ENDIF
   SETCOLOR(STDMOLD+","+STDINVE)   
   HSENHA = STRZERO(VAL(HSENHA),4,0)
   MESSAGE()

   XSENHA    = HSENHA  && Senha do usu rio
   XBLOQUEIO = BLOQUEIO
   XCREDITO  = CREDITO
   XSALDOS   = SALDOS
   
   LIN = 1
   KPRINT(@LIN,00,CHR(14)+"Novo Numero")
   KPRINT(@LIN,00,"")
   KPRINT(@LIN,00,NOME)
   KPRINT(@LIN,00,"    Numero     Senha")
   KPRINT(@LIN,00,"    "+XCONTA+"      "+XSENHA)
   KRODAP(@LIN)

   IF REC_LOCK(0)
      SAVEVARS()
      UNLOCK
   ENDIF

   SELECT LANCAMEN
   IF FIL_LOCK(0)
      GO TOP
      REPLACE CODIGO WITH XCONTA FOR CODIGO = HNUMERO
      UNLOCK
    ENDIF
ENDDO
RESTORE SCREEN FROM TMP
RETURN
