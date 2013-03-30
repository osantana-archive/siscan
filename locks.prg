****
*  Locks.prg
*
*  Assumes SET EXCLUSIVE OFF
*
*   UDF's for:
*   Command          Purpose
*   -----------------------   ------------------------
*   1. USE <file> [EXCLUSIVE] Share/Deny others USE
*   2. FLOCK()       Lock current file
*   3. RLOCK()/LOCK()      Lock current record
*   4. APPEND BLANK     Lock new blank record


****
*  NET_USE function
*
*  Trys to open a file for exclusive or shared use.
*  SET INDEXes in calling procedure if successful.
*  Pass the following parameters
*    1. Character - name of the .DBF file to open
*    2. Logical - mode of open (exclusive/.NOT. exclusive)
*    3. Numeric - seconds to wait (0 = wait forever)
*
*  Example:
*    IF NET_USE("Accounts", .T., 5)
*       SET INDEX TO Name
*    ELSE
*       ? "Account file not available"
*    ENDIF

FUNCTION NET_USE
PARAMETERS file, ex_use, wait
PRIVATE forever

forever = (wait = 0)
DO WHILE (forever .OR. wait > 0)
   IF ex_use                    && exclusive
      USE &file EXCLUSIVE
   ELSE
      USE &file         && shared
   ENDIF
   IF .NOT. NETERR()           && USE succeeds
      RETURN (.T.)
   ENDIF
   INKEY(1)                && wait 1 second
   wait = wait - 1
ENDDO
RETURN (.F.)         && USE fails
* End - NET_USE


****
*  FIL_LOCK function
*
*  Trys to lock the current shared file 
*  Pass the following parameter
*    1. Numeric - seconds to wait (0 = wait forever)
*
* Example:
*    IF FIL_LOCK(5)
*      REPLACE ALL Price WITH Price * 1.1
*    ELSE
*      ? "File not available"
*    ENDIF 

FUNCTION FIL_LOCK
PARAMETERS wait
PRIVATE forever

IF FLOCK()
   RETURN (.T.)      && locked
ENDIF
      
forever = (wait = 0)
DO WHILE (forever .OR. wait > 0)
   INKEY(.5)         && wait 1/2 second
   wait = wait - .5

   IF FLOCK()
      RETURN (.T.)      && locked
   ENDIF
ENDDO
RETURN (.F.)         && not locked
* End - FIL_LOCK


****
*  REC_LOCK function
*
*  Trys to lock the current record
*  Pass the following parameter
*    1. Numeric - seconds to wait (0 = wait forever)
*
* Example:
*   IF REC_LOCK(5)
*      REPCLACE Price WITH newprice
*   ELSE
*      ? "Record not available"
*   ENDIF  

FUNCTION REC_LOCK 
PARAMETERS wait
PRIVATE forever

IF RLOCK()
   RETURN (.T.)      && locked
ENDIF

forever = (wait = 0)
DO WHILE (forever .OR. wait > 0)
   IF RLOCK()
      RETURN (.T.)      && locked
   ENDIF
      
   INKEY(.5)         && wait 1/2 second
   wait = wait - .5
ENDDO
RETURN (.F.)         && not locked
* End - REC_LOCK


****
*   ADD_REC function
*
*  Returns true if record appended.  The new record is current
*  and locked.
*  Pass the following parameter
*    1. Numeric - seconds to wait (0 = wait forever)
*

FUNCTION ADD_REC
PARAMETERS wait
PRIVATE forever

APPEND BLANK
IF .NOT. NETERR()
   RETURN (.T.)
ENDIF

forever = (wait = 0)
DO WHILE (forever .OR. wait > 0)
   APPEND BLANK
   IF .NOT. NETERR()
      RETURN .T.
   ENDIF
   INKEY(.5)         && wait 1/2 second
   wait = wait - .5
ENDDO
RETURN (.F.)         && not locked
* End ADD_REC

* EOF - Locks.prg
