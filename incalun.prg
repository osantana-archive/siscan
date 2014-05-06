*
* Abertura de Contas / Inclusao de Alunos
*

SAVE SCREEN TO TMP
DO WHILE .T.
   SELECT ALUNO
   MOLDURA(12,01,21,76,STDMOLD,.T.,"Abertura de Contas",STDINVE)
   SETCOLOR(STDMOLD+","+STDINVE)
   @ 20,03 SAY "Senha: [    ]"
   LOADVARS()
   @ 14,03 SAY "Nome......:" GET XNOME     PICTURE "@!"
   @ 15,03 SAY "Endere‡o..:" GET XENDERECO PICTURE "@!"
   @ 16,03 SAY "Bairro....:" GET XBAIRRO   PICTURE "@!"
   @ 16,52 SAY "CEP.......:" GET XCEP      PICTURE "99.999-999"
   @ 17,03 SAY "Cidade....:" GET XCIDADE   PICTURE "@!"
   @ 17,52 SAY "Estado....:" GET XESTADO   PICTURE "@!"
   @ 18,03 SAY "Telefone..:" GET XTELEFONE PICTURE "(999) 999-9999"
   @ 18,52 SAY "Tipo Pgto.:" GET XTIPOPGTO PICTURE "!"
   CLEAR GETS
   
* CONTA

   SET ORDER TO 2
   GO BOTTOM
   IF VAL(CONTA) + 1 > 9999
      GO TOP
      TMPCONTA = VAL(CONTA)
      DO WHILE .NOT. EOF()
         SKIP +1
         IF VAL(CONTA) <> TMPCONTA + 1
            XCONTA = STRZERO(TMPCONTA + 1,4,0)
            EXIT
         ENDIF
         TMPCONTA = VAL(CONTA)
      ENDDO
   ELSE
      XCONTA = STRZERO(VAL(CONTA) + 1,4,0)
   ENDIF
   @ 13,03 SAY "Conta.....:" GET XCONTA PICTURE "9999"
   CLEAR GETS

* RG

   @ 13,21 SAY "RG: " GET XRG PICTURE "999.999.999-!"
   SET CONFIRM OFF
   SET CURSOR ON
   READ
   SET CURSOR OFF
   SET CONFIRM ON
   IF LASTKEY() = 27 .OR. EMPTY(XRG)
      EXIT
   ENDIF
   SET ORDER TO 3
   GO TOP
   SEEK XRG
   IF FOUND()
      @ 13,03 SAY "Conta.....:" GET CONTA    PICTURE "9999"
      @ 14,03 SAY "Nome......:" GET NOME     PICTURE "@!"
      @ 15,03 SAY "Endere‡o..:" GET ENDERECO PICTURE "@!"
      @ 16,03 SAY "Bairro....:" GET BAIRRO   PICTURE "@!"
      @ 16,52 SAY "CEP.......:" GET CEP      PICTURE "99.999-999"
      @ 17,03 SAY "Cidade....:" GET CIDADE   PICTURE "@!"
      @ 17,52 SAY "Estado....:" GET ESTADO   PICTURE "@!"
      @ 18,03 SAY "Telefone..:" GET TELEFONE PICTURE "(999) 999-9999"
      @ 18,52 SAY "Tipo Pgto.:" GET TIPOPGTO PICTURE "!"
      @ 20,03 SAY "Senha: [****]"
      CLEAR GETS
      IF CONFIRM("Aluno j  cadastrado...Reimprimir senha ?")
         LIN = 01
         KPRINT(@LIN,00,CHR(14) + " Nova Conta")
         KPRINT(@LIN,00,"")
         KPRINT(@LIN,00,XNOME)
         KPRINT(@LIN,00,"    Conta      Senha")
         KPRINT(@LIN,00,"    "+CONTA+"       "+SENHA)
         KRODAP(@LIN)
      ENDIF
      EXIT
   ENDIF

* OUTROS DADOS
   
   @ 14,03 SAY "Nome......:" GET XNOME     PICTURE "@!"
   @ 15,03 SAY "Endere‡o..:" GET XENDERECO PICTURE "@!"
   @ 16,03 SAY "Bairro....:" GET XBAIRRO   PICTURE "@!"
   @ 16,52 SAY "CEP.......:" GET XCEP      PICTURE "99.999-999"
   @ 17,03 SAY "Cidade....:" GET XCIDADE   PICTURE "@!"
   @ 17,52 SAY "Estado....:" GET XESTADO   PICTURE "@!"
   @ 18,03 SAY "Telefone..:" GET XTELEFONE PICTURE "(999) 999-9999"
   @ 18,52 SAY "Tipo Pgto.:" GET XTIPOPGTO PICTURE "!" VALID (XTIPOPGTO="S" .OR. XTIPOPGTO="Q" .OR. XTIPOPGTO="M")
   SET CONFIRM OFF
   SET CURSOR ON
   READ
   SET CURSOR OFF
   SET CONFIRM ON
   IF LASTKEY() = 27 .OR. EMPTY(XNOME)
      EXIT
   ENDIF   

* SENHA
   
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
   XBLOQUEIO = 00      && Bloqueios (branco/vermelho/azul)
   XCREDITO  = 00      && Valor em haver
   XSALDOS   = 00      && Quantidade de extratos tirados

   ADD_REC(0)
   SAVEVARS()
   COMMIT
   UNLOCK
   
   LIN = 01
   KPRINT(@LIN,00,CHR(14) + " Nova Conta")
   KPRINT(@LIN,00,"")
   KPRINT(@LIN,00,XNOME)
   KPRINT(@LIN,00,"    Conta      Senha")
   KPRINT(@LIN,00,"    "+CONTA+"       "+SENHA)
   KRODAP(@LIN)

ENDDO
RESTORE SCREEN FROM TMP
RETURN
