* Software Cantina
*

* >>> Setar Configuracoes
SET MESSAGE TO 23 CENTER
SET EXCLUSIVE OFF
SET SCOREBOARD OFF
SET WRAP ON
SET CONFIRM ON
SET DELETED ON
SET PROCEDURE TO SISCANP
SET PROCEDURE TO LOCKS
SET CENTURY ON
SET DATE BRITISH

* >>> Configuracoes do Menu
SETPRC(0,0)
SET CURSOR OFF
SET COLOR TO W+/N,N/W
STDMOLD = "W+/N"
STDINVE = "N/W"
STDALER = "W+/R"

* >>> Grava Tela do DOS
YDOS = ROW()
SAVE SCREEN TO SCRDOS
PARAMETERS MAQUINA,DIRET,PASS
MAQUINA = IF(TYPE("MAQUINA") = "U","PC1",MAQUINA)
DIRET   = IF(TYPE("DIRET")   = "U",".\",DIRET)
PASS    = IF(TYPE("PASS")    = "U",""   ,PASS   )
IF MAQUINA <> "PC1"
   KEYBOARD "OE"
ENDIF

* >>> Tela Inicial
CLEAR SCREEN
MOLDURA(00,00,24,79,"W+/N",.T.,"Arkhan Informática - Sistema de Controle de Contas - "+MAQUINA,"N/W",.F.)
@ 23,70 SAY "by Arkhan"
SAVE SCREEN TO ENTRASCR

* >>> Geradores de Aleatorios

PUBLIC AL[3],INDAL
INDAL = 1
@ 23,05 SAY "Aleatórios: "
AL[1] = RIGHT(STR(INT(SECONDS() * 100)),4)
FOR TMP = 1 TO VAL(AL[1]) / 4
  @ 23,17 SAY STRZERO(TMP,4)
NEXT
AL[2] = RIGHT(STR(INT(SECONDS() * 100)),3)
FOR TMP = 1 TO VAL(AL[2]) / 4
  @ 23,23 SAY STRZERO(TMP,4)
NEXT
AL[3] = RIGHT(STR(INT(SECONDS() * 100)),4)
MESSAGE()

* >>> Banco de Dados e Operacoes com Datas
DO BANCO
PUBLIC D_HOJE
D_DIAS = 30
IF MAQUINA = "PC1"
   IF .NOT. FILE("DATAS.MEM")
      IF     DOW(DATE()) = 6
         DO SEXTA
      ELSEIF DOW(DATE()) = 2
         DO SEGUNDA
         DO RELATOR
      ENDIF
      D_HOJE  = DATE()
      SAVE TO DATAS.MEM ALL LIKE D_*
   ELSE
      RESTORE FROM DATAS.MEM ADDITIVE
      IF D_HOJE <> DATE()
         IF     DOW(DATE()) = 6
            DO SEXTA
         ELSEIF DOW(DATE()) = 2
            IF DOW(D_HOJE) = 6
               DO SEGUNDA
               DO RELATOR
            ENDIF
         ENDIF
         D_HOJE = DATE()
         SAVE TO DATAS.MEM ALL LIKE D_*
      ENDIF
   ENDIF
ENDIF

* >>> Usuario
PUBLIC XUSUARIO
XUSUARIO = SPACE(6)
IF MAQUINA ="PC1"
   DO WHILE .T.
      @ 20,03 SAY "Usuário: " GET XUSUARIO PICTURE "@!"
      SET CONFIRM ON
      SET CURSOR ON
      READ
      SET CURSOR OFF
      SET CONFIRM OFF
      IF LASTKEY() = 27 .OR. EMPTY(XUSUARIO)
         MESSAGE("N╞o é possível utilizar o sistema sem definir um usuário...")
         LOOP
      ELSE
         EXIT
      ENDIF
   ENDDO
   HAND = FCREATE(diret+"\USER.$$$")
   IF FERROR() <> 0
      CLEAR SCREEN
      ? "Erro Usuario PC1"
      QUIT
   ENDIF
   FWRITE(HAND,XUSUARIO,LEN(XUSUARIO))
   FCLOSE(HAND)
   RESTORE SCREEN FROM ENTRASCR
ELSE
   HAND = FOPEN(diret+"\USER.$$$",2)
   IF FERROR() <> 0
      CLEAR SCREEN
      ? "Erro de Usuario"
      QUIT
   ENDIF
   BYTES = FSEEK(HAND,0,2)
   FSEEK(HAND,0)
   FREAD(HAND,@XUSUARIO,BYTES)
   FCLOSE(HAND)
ENDIF

* >>> Menu
DO WHILE .T.
   @ 04,05      PROMPT "   Produtos   "
   @ 04,COL()+3 PROMPT "    Contas    "
   @ 04,COL()+3 PROMPT "   Operaçöes   "
   @ 04,COL()+3 PROMPT "   Finaliza   "
   SAVE SCREEN TO VARTELA
   MENU TO OPC
   ARROWS(.T.)
   STORE 1 TO OP1
   DO CASE
      CASE OPC = 1
         SAVE SCREEN
         MOLDURA(05,05,12,18,STDMOLD)
         @ 06,06 PROMPT "Inclusäo    "
         @ 07,06 PROMPT "Alteraçäo   "
         @ 08,06 PROMPT "Exclusäo    "
         @ 09,06 PROMPT "Consulta    "
         @ 10,06 PROMPT "Des/Bloqueia"
         @ 11,06 PROMPT "Retorna     "
         MENU TO OP1
         ARROWS(.F.)
         DO CASE
            CASE OP1 = 1
               DO INCPROD
            CASE OP1 = 2
               DO ALTPROD
            CASE OP1 = 3
               DO EXCPROD
            CASE OP1 = 4
               DO CONPROD
            CASE OP1 = 5
               DO BLOPROD
         ENDCASE
         RESTORE SCREEN
      CASE OPC = 2
         SAVE SCREEN
         MOLDURA(05,22,17,35,STDMOLD)
         @ 06,23 PROMPT "Abertura    "
         @ 07,23 PROMPT "Encerramento"
         @ 08,23 PROMPT "Pagamento   "
         @ 09,23 PROMPT "Haver       "
         @ 10,23 PROMPT "Totaliza    "
         @ 11,23 PROMPT "Senha       "
         @ 12,23 PROMPT "Mudança     "
         @ 13,23 PROMPT "Relaçäo     "
         @ 14,23 PROMPT "Listagem    "
         @ 15,23 PROMPT "Cancela     "
         @ 16,23 PROMPT "Retorna     "
         MENU TO OP1
         ARROWS(.F.)
         DO CASE
            CASE OP1 = 1
               DO INCALUN
            CASE OP1 = 2
               DO ENCALUN
            CASE OP1 = 3
               DO PAGAMENT
            CASE OP1 = 4
               DO CREALUN
            CASE OP1 = 5
               DO TOTALIZ
            CASE OP1 = 6
               DO SENHA
            CASE OP1 = 7
               DO MUDANCA
            CASE OP1 = 8
               DO RELACAO
            CASE OP1 = 9
               DO LISTAGE
            CASE OP1 = 10
               DO CANLAN
         ENDCASE
         RESTORE SCREEN
      CASE OPC = 3
         SAVE SCREEN
         MOLDURA(05,39,15,53,STDMOLD)
         @ 06,40 PROMPT "Entrada      "
         @ 07,40 PROMPT "Devedores    "
         @ 08,40 PROMPT "Sexta        "
         @ 09,40 PROMPT "Segunda      "
         @ 10,40 PROMPT "Totais Caixa "
         @ 11,40 PROMPT "Reindexar    "
         @ 12,40 PROMPT "Dev. Antigos "
         @ 13,40 PROMPT "Rel. Periodo "
         @ 14,40 PROMPT "Retorna      "
         MENU TO OP1
         ARROWS(.F.)
         DO CASE
         CASE OP1 = 1
            DO ENTRA
         CASE OP1 = 2
            DO RELATOR
         CASE OP1 = 3
            DO SEXTA
         CASE OP1 = 4
            DO SEGUNDA
         CASE OP1 = 5
            DO TOTCAIXA
         CASE OP1 = 6
            DO REIND
         CASE OP1 = 7
            DO RELDEV
         CASE OP1 = 8
            DO RELPGTO
         ENDCASE
         RESTORE SCREEN
      CASE OPC = 4
         SAVE SCREEN
         MOLDURA(05,57,08,70,STDMOLD)
         @ 06,58 PROMPT "    Sim     "
         @ 07,58 PROMPT "    Näo     "
         MENU TO OP1
         IF OP1 = 1
            SET CURSOR OFF
            CLOSE ALL
            IF MAQUINA = "PC1"
               SET EXCLUSIVE ON
               USE LANCAMEN
               PACK
               USE ALUNO
               PACK
               USE PRODUTO
               PACK
               USE MORTO
               PACK
               CLOSE ALL
               MESSAGE("Coloque o Disquete no Drive... Tecle Algo...")
               IF INKEY(0) <> 27
                  COPY FILE ALUNO.DBF    TO A:ALUNO.DBF
                  COPY FILE LANCAMEN.DBF TO A:LANCAMEN.DBF
                  COPY FILE PRODUTO.DBF  TO A:PRODUTO.DBF
               ENDIF
            ENDIF
            EXIT
         ENDIF
         RESTORE SCREEN
   ENDCASE
   ARROWS(.F.)
ENDDO
SET COLOR TO W/N
RESTORE SCREEN FROM SCRDOS
@ YDOS,00 SAY ""
SET CURSOR ON
RETURN
