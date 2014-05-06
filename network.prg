* Program    Network.prg
* Copyright  1986, Nantucket Corporation, Culver City, California
* Date       10/86
* Notes      Demonstrate networking functions
*            Useful for execution from two or more network workstations
*            operating on the same, shared file. Shows interaction between
*            workstations for attempts to get EXCLUSIVE use of files,
*            or to get FLOCK()'s and RLOCK()'s while using files
*            non-EXCLUSIVEly. Accepts zero, one, or two command line
*            parameters. First. if supplied, is name of DBF file to be USEd;
*            second is name of NTX file for indexing.

SET PROCEDURE TO locks
SET EXCLUSIVE OFF
* Initialize...
bell   =  chr(7)          && rings bell
recno  =  0               && recno for GOTO
reccnt =  0               && RECCOUNT() for current file
choice =  1               && output from MENU
is_ex  = .F.              && logical for EXCLUSIVE open
is_closed = .T.           && logical for CLOSE DATABASES
IF ISCOLOR()
  reverse = 'N/W'         && reverse video
  flashing = 'N*/W'       && flashing reverse video
ELSE
  reverse = 'I'           && reverse video
  flashing = 'I*'         && flashing reverse video
ENDIF
PARAMETER filename,indxname
CLEAR
TEXT  
 ÚÄÄÄÄÄÄÄÄÄÄ ACTIVITIES ÄÄÄÄÄÄÄÄÄÄÄÄ¿ ÉÍ CURRENT FILES ÍÍËÍÍ FLOCK STATUS ÍÍÍ»
 ³  1. USE<file>/CLOSE<file>        ³ º Data :           º                   º
 ³  2. SET INDEX                    ³ º Indx :           º                   º
 ³  3. FLOCK() current file         ³ º Usage:           º                   º
 ³  4. RLOCK() current record       ³ ÌÍ CURRENT RECORD ÍÎÍÍ RLOCK STATUS ÍÍÍ¹
 ³  6. GOTO RECORD                  ³ º                  º                   º
 ³  5. UNLOCK ALL                   ³ º                  º                   º
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
ENDTEXT
paramcnt = PCOUNT()
IF paramcnt >=1
  filename = filename+SUBSTR('        ',1,8-LEN(filename))
  DO multi_use WITH .T.
  IF paramcnt = 2 .AND. .NOT. is_closed
    indxname = indxname+SUBSTR('        ',1,8-LEN(indxname))
    DO indx_opn WITH .T.
  ELSE
    indxname = SPACE(8)
  ENDIF
ELSE
  indxname = SPACE(8)
  filename = SPACE(8)
ENDIF
@ 1,38 SAY 'ÉÍ CURRENT FILES ÍÍËÍÍ FLOCK STATUS ÍÍÍ»'
DO WHILE choice > 0
  
  @  2,4 PROMPT '1. USE<file>/CLOSE<file>  '
  @  3,4 PROMPT '2. SET INDEX              '
  @  4,4 PROMPT '3. FLOCK() current file   '
  @  5,4 PROMPT '4. RLOCK() current record '
  @  6,4 PROMPT '5. GOTO RECORD            '
  @  7,4 PROMPT '6. UNLOCK ALL             '
  MENU TO choice
  IF (choice # 1 .AND. is_closed) .OR.;
    (is_ex .AND. STR(choice,1) $ '346')
    LOOP
  ENDIF
  
  DO CASE
    CASE choice = 1                          && USE
      DO multi_use
    CASE choice = 2                          && SET INDEX
      DO indx_opn
    CASE choice=3                            && FLOCK()
      DO show_loc WITH fil_lock(1),'F'
    CASE choice=4                            && RLOCK()
      DO show_loc WITH rec_lock(1),'R'
    CASE choice=5                            && GOTO
      @ 7,44 SAY SPACE(10)
      recno=RECNO()
      @ 7,41 GET recno PICTURE '99999'
      READ
      @ 7,41 SAY SPACE(5)
      GOTO recno
      DO show_rec
    CASE choice=6                            && UNLOCK
      UNLOCK ALL
      DO show_loc WITH .T.
  ENDCASE
ENDDO

***
PROCEDURE multi_use
*            Attempt to USE a database file. Filename may be supplied as
*            first command line parameter or via main menu option 1.

  PARAMETER commline
  IF PCOUNT() = 0
    USE
    @ 2,47 SAY SPACE(10)
    @ 3,47 SAY SPACE(10)
    @ 4,47 SAY SPACE(10)
    @ 3,59 SAY SPACE(17)
    @ 7,44 SAY SPACE(10)
    @ 7,59 SAY SPACE(17)
    @ 9,0 CLEAR
    is_closed = .T.
    SAVE SCREEN
    CLEAR
    ?    
    ?    
    ?   
    RUN dir *.dbf
    @ 2,0 SAY 'Leave blank to close file'
    @ 1,0 SAY 'Database File: 'GET filename PICTURE "@K@!" valid valfile(TRIM(filename),'DBF')
    READ
    ex = ' '
    RESTORE SCREEN
  ENDIF
  IF .NOT. EMPTY(filename)
    IF FILE('&FILENAME..DBF')
      @ 2,47 SAY filename
      @ 2,16 SAY ' EXCLUSIVE?   '
      @ 2,29 PROMPT 'Y'
      @ 2,31 PROMPT 'N'
      MENU TO ex
      is_ex = (ex = 1)
      @  2,4 SAY '1. USE<file>/CLOSE<file>     '
      IF net_use('&filename.',is_ex, 1)
        is_closed = .F.
        @ 4,47 SAY  IIF(is_ex,'Exclusive ','Shared    ')
        reccnt=IIF(FCOUNT()>12, 12, FCOUNT())
        DO show_loc WITH .T.
        DO show_rec
      ELSE
        @ 2,47 SAY 'USE failed'
        ?? bell
        is_closed = .T.
      ENDIF
    ENDIF
  ENDIF
  RETURN
*ENDPROC multi_use

PROCEDURE show_rec
*            Show number and contents of current record.

  PRIVATE recno
  @ 7,44 SAY SPACE(10)
  IF .NOT.( BOF() .OR. EOF() )
    recno=STR(RECNO(),5)
    @ 9,0 TO reccnt+11,79
    @ 9,2 SAY " FIELDNAME ÄÄ CONTENTS "
    FOR i = 1 TO reccnt    && Room for 11 fields
      fld=FIELDNAME(i)
      @ 10 + i, 3 SAY  fld
      IF TYPE('&fld')= 'C'
        @ 10 + i, 16 SAY SUBSTR(&fld,1,65)
      ELSE
        @ 10 + i, 16 SAY &fld
      ENDIF
    NEXT
  ELSE
    recno = IF(EOF(),'*EOF*','*BOF*')
    @ 11,14 CLEAR TO reccnt+10,78
  ENDIF
  @ 7,44 SAY SUBSTR(ltrim(recno)+'     ',1,5)
  RETURN
*ENDPROC show_rec


PROCEDURE show_loc
*            Show status of locks on current file and record. Note that
*            locking is meaningful only if DBF file is in shared (i.e.,
*            non-EXCLUSIVE) use.

  PARAMETER pas_fail,loc_type
  DISPLAY =  IF(pas_fail,reverse,flashing)
  SET COLOR TO &DISPLAY
  IF is_ex
    @ 3,59 SAY 'Not Applicable   '
    @ 7,59 SAY 'Not Applicable   '
  ELSE
    IF PCOUNT() = 1                 
      @ 3,59 SAY 'Not FLOCKed      '
      @ 7,59 SAY 'Not RLOCKed      '
    ELSE
      IF loc_type = 'R'
        @ 7,59 SAY IF(pas_fail,'Rec '+ltrim(STR(RECNO(),5))+' RLOCKed','RLOCK() failed   ')
        IF .NOT. pas_fail
          ?? bell
          SET COLOR TO &reverse
          @ 3,59 SAY 'Not FLOCKed      '
          INKEY(2)
          @ 7,59 SAY 'Not RLOCKed      '
        ENDIF
        @ 3,59 SAY 'Not FLOCKed      '
      ELSE
        @ 3,59 SAY IF(pas_fail,TRIM(filename)+' FLOCKed ','FLOCK() failed   ')
        IF .NOT. pas_fail
          ?? bell
          SET COLOR TO &reverse
          @ 7,59 SAY 'Not RLOCKed      '
          INKEY(2)
          @ 3,59 SAY 'Not FLOCKed      '
        ENDIF
        @ 7,59 SAY 'Not RLOCKed      '
      ENDIF
    ENDIF
  ENDIF
  SET COLOR TO
  RETURN
*ENDPROC show_loc

PROCEDURE indx_opn
*            Attempt to SET INDEX to an index file. Filename may be supplied
*            as second command line parameter or via main menu option 2.

  PARAMETER commline
  IF PCOUNT() = 0
    @ 3,47 SAY SPACE(9)
    SAVE SCREEN
    SET INDEX TO
    CLEAR
    ?    
    ?    
    RUN dir *.ntx
    @ 2,0 SAY 'Leave blank to close file'
    @ 1,1 SAY 'SET INDEX TO? ' GET indxname PICTURE '@K!!!!!!!!' valid valfile(TRIM(indxname),'NTX')
    READ
    RESTORE SCREEN
  ENDIF
  IF .NOT. EMPTY(valfile(indxname,'NTX'))
    IF FILE('&INDXNAME..NTX')
      SET INDEX TO &indxname
      @ 3,47 SAY '&INDXname'
    ENDIF
  ENDIF
  DO show_rec
  RETURN
*ENDPROC indx_opn



FUNCTION valfile
*            Validate existence of files to be opened

  PARAMETER name,TYPE
  IF FILE('&name..&type')
    RETURN (.T.)
  ENDIF
  IF EMPTY(name)
    RETURN (.T.)
  ENDIF
  @ 1,40 SAY TRIM(name) + ".&TYPE not found"
  RETURN (.F.)
*ENDFUNCTION VALFILE

*EOF MULTI.PRG


