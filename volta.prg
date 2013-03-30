** Segunda
*

clear screen
save screen to entrascr
STDINVE="n/w"
STDALER="n/w"
maquina="PC1"
diret = "."
stdmold="+-+|+-+| "
set procedure to siscanp
set procedure to network
do banco
RESTORE SCREEN FROM ENTRASCR
SET CURSOR OFF
SELECT ALUNO
SET    ORDER TO 1
GO     TOP
REGISTRO = 1
MOLDURA(08,22,14,57,STDMOLD,.T.,"volta",STDINVE)
DO WHILE .NOT. EOF()
   PERCENT(REGISTRO,IF(RECCOUNT()<>0,RECCOUNT(),1),11,25,30,1)
   IF REC_LOCK(0)
      if bloqueio > 0
         REPLACE BLOQUEIO WITH BLOQUEIO - 1
         UNLOCK
      endif
   ENDIF
   SKIP +1
   REGISTRO = REGISTRO + 1
ENDDO
DO RELATOR
RESTORE SCREEN FROM ENTRASCR
RETURN
