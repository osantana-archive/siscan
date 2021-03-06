MESSAGE("Aguarde... Criando �ndices...")

SET DEFAULT TO &DIRET

REIND = .T.
TMPHAND = FOPEN("LANC001.NTX",2)
IF FERROR() = 0
   REIND = .F.
ENDIF
FCLOSE(TMPHAND)


SELECT 1
IF NET_USE("LANCAMEN",.F.,0)
   IF MAQUINA = "PC1" .AND. REIND
      INDEX ON FLAG     TO LANC001
      INDEX ON CODIGO   TO LANC002
      INDEX ON CODIGO+DTOS(DATALCTO) TO LANC003
   ENDIF
   SET INDEX TO LANC001,LANC002,LANC003
ELSE
   WARNING("Erro ao abrir o arquivo LANCAMEN.DBF")
ENDIF

SELECT 2
IF NET_USE("PRODUTO",.F.,0)
   IF MAQUINA = "PC1" .AND. REIND
      INDEX ON CODPROD TO PROD001
   ENDIF
   SET INDEX TO PROD001
ELSE
   WARNING("Erro ao abrir o arquivo PRODUTO.DBF")
ENDIF

SELECT 3
IF NET_USE("ALUNO",.F.,5)
   IF MAQUINA = "PC1" .AND. REIND
      INDEX ON NOME  TO ALUN001
      INDEX ON CONTA TO ALUN002
      INDEX ON RG    TO ALUN003
   ENDIF
   SET INDEX TO ALUN001,ALUN002,ALUN003
ELSE
   WARNING("Erro ao abrir o arquivo ALUNO.DBF")
ENDIF
MESSAGE()

SELECT 4
IF NET_USE("MORTO",.F.,0)
   IF MAQUINA = "PC1" .AND. REIND
      INDEX ON USUARIO+CODIGO TO MORT001
   ENDIF
   SET INDEX TO MORT001
ELSE
   WARNING("Erro ao abrir o arquivo MORTO.DBF")
ENDIF
RETURN
