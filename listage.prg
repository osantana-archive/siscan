*
* Consulta de Alunos
*

SAVE SCREEN TO TMP
ARROWS(.F.)
SELECT ALUNO
SET ORDER TO 1
GO TOP
DECLARE MAT1[IF(PASS="300477",6,5)]
DECLARE MAT2[IF(PASS="300477",6,5)]
DECLARE MAT3[IF(PASS="300477",6,5)]
MAT1[1] = "CONTA"
MAT1[2] = "NOME"
MAT1[3] = "STRZERO(INT(BLOQUEIO/2),2,0)"
MAT1[4] = "TIPOPGTO"
MAT1[5] = "CREDITO"
IF PASS = "300477"
   MAT1[6] = "SENHA"
ENDIF
MAT2[1] = "N�mero"
MAT2[2] = "Nome"
MAT2[3] = "Semanas"
MAT2[4] = "TipoPgto."
MAT2[5] = "Cr�dito"
IF PASS = "300477"
   MAT2[6] = "Senha"
ENDIF
FOR TMP1 = 1 TO IF(PASS="300477",6,5)
   MAT3[TMP1] = "���"
NEXT
MOLDURA(12,01,21,76,STDMOLD,.T.,"Consulta de Alunos",STDINVE)
SETCOLOR(STDMOLD+","+STDINVE) 
SET CURSOR OFF
DBEDIT(13,02,20,75,MAT1,"","",MAT2,MAT3)
ARROWS(.T.)
RESTORE SCREEN FROM TMP
RETURN
