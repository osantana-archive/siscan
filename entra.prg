*
* Entrada de Dados
*

SAVE SCREEN TO TMP
RESTORE SCREEN FROM ENTRASCR
MOLDURA(07,24,15,56,STDMOLD,.T.,"Pedido",STDINVE)
SAVE SCREEN TO TENTRA
SET CURSOR OFF
DO WHILE .T.
   SELECT ALUNO
   SET ORDER TO 2
   GO  TOP
   RESTORE SCREEN FROM TENTRA
   @ 11,25 TO 11,55
   SET COLOR TO N/W
   @ 11,34 SAY "  Produtos  "
   SET COLOR TO W+/N
   @ 09,27 SAY "N£mero: "
   @ 09,42 SAY "Senha: "
   @ 13,27 SAY "C¢digo: "
   @ 13,41 SAY "Quant.: "
   HNUMERO = KINPUT(09,35,04,.T.,"0",.T.)
   IF HNUMERO = "PHIL"
      EXIT
   ENDIF
   IF VAL(HNUMERO) = 0
      LOOP
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
   IF HNUMERO = "0001"
      MESSAGE("Deseja sair do sistema? (ENTER - Sim / Outra Tecla - N„o)")
      IF INKEY(0) = 13
         RESTORE SCREEN FROM VARTELA
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
         SET COLOR TO W/N
         RESTORE SCREEN FROM SCRDOS
         @ YDOS,00 SAY ""
         SET CURSOR ON
         QUIT
      ENDIF
      MESSAGE()
   ENDIF
   IF BLOQUEIO >= IF(TIPOPGTO = "S",2,IF(TIPOPGTO = "Q",4,IF(TIPOPGTO = "M",8,2)))
      MESSAGE("Conta Bloqueada por Falta de Pagamento...")
      INKEY(2)
      MESSAGE()
      LOOP
   ENDIF
   LIN = 1
   KPRINT(@LIN,05,CHR(14)+"PEDIDO")
   KPRINT(@LIN,00,"")
   KPRINT(@LIN,00,"DATA: "+DTOC(DATE()))
   KPRINT(@LIN,00,"")
   KPRINT(@LIN,00,"NUMERO: "+HNUMERO)
   KPRINT(@LIN,00,ALUNO->NOME)
   KPRINT(@LIN,00,"")
   KPRINT(@LIN,00,"QTD.  NOME")
   XCODIGO   = HNUMERO
   XDATALCTO = DATE()
   XFLAG     = IF(BLOQUEIO >= IF(TIPOPGTO = "S",1,IF(TIPOPGTO = "Q",3,IF(TIPOPGTO = "M",7,1))),1,0)
   SELECT LANCAMEN
   SET ORDER TO 1
   GO  TOP
   DO WHILE .T.
      @ 13,49 SAY SPACE(5)
      HCODPROD = KINPUT(13,35,03,.T.,"0",.T.)
      IF HCODPROD = "PHIL" .OR. VAL(HCODPROD) = 0
         EXIT
      ENDIF
      SELECT PRODUTO
      SET ORDER TO 1
      GO  TOP
      HCODPROD = STRZERO(VAL(HCODPROD),3,0)
      SEEK HCODPROD
      IF .NOT. FOUND()
         LOOP
      ENDIF
      IF BLOQ
         MESSAGE("O Produto N„o est  Dispon¡vel por Falta no Estoque...")
         INKEY(2)
         MESSAGE()
         LOOP
      ENDIF
      HNOME = NOMEPROD
      @ 18,27 SAY "PRODUTO: "+TRANSFORM(HNOME,"@S29")
      SELECT LANCAMEN
      SET ORDER TO 1
      MESSAGE("Tecle ENTER Ap¢s a Digita‡„o...")
      @ 13,53 SAY IF(HCODPROD="999" .OR. HCODPROD="998","g","")
      HQUANT  = KINPUT(13,49,IF(HCODPROD="999" .OR. HCODPROD="998",3,2),.T.,"1",.T.)
      MESSAGE()
      IF VAL(HQUANT) = 0
         LOOP
      ENDIF
      IF HQUANT = "PHIL"
         EXIT
      ENDIF
      @ 18,27 SAY SPACE(40)
      XQTDPROD = VAL(HQUANT)
      XCODPROD = HCODPROD
      XVALOR   = VAL(HQUANT)*(PRODUTO->VALOR)
      IF HCODPROD="999" .OR. HCODPROD="998"
         XVALOR = XVALOR / 1000
      ENDIF      
      IF ADD_REC(0)
         SAVEVARS()
         UNLOCK
      ENDIF
      KPRINT(@LIN,00,HQUANT+"  "+HNOME)
   ENDDO
   KRODAP(@LIN)
ENDDO
RESTORE SCREEN FROM TMP
RETURN
