       IDENTIFICATION DIVISION.
       PROGRAM-ID. WEEK3.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IDX-FILE   ASSIGN TO IDXFILE
                             ORGANIZATION INDEXED
                             ACCESS RANDOM
                             RECORD KEY IDX-KEY
                             STATUS ST-IDX-FILE.
           SELECT INP-FILE ASSIGN TO INPFILE
                             STATUS ST-INP-FILE.
           SELECT OUT-FILE   ASSIGN TO OUTFILE
                             STATUS ST-OUT-FILE.
       DATA DIVISION.
       FILE SECTION.
       FD  OUT-FILE RECORDING MODE F.
         01  OUT-REC.
           03 REC-ID-O          PIC 9(5).
           03 REC-SPACE-1       PIC X(2).
           03 REC-DVZ-O         PIC 9(3).
           03 REC-SPACE-2       PIC X(2).
           03 REC-NAME-O        PIC X(15).
           03 REC-SRNAME-O      PIC X(15).
           03 REC-DATE-O        PIC 9(8).
           03 REC-SPACE-3       PIC X(2).
           03 REC-BALANCE-O     PIC 9(15).
       FD  INP-FILE RECORDING MODE F.
         01  INP-REC.
           03 INP-ID            PIC X(5).
           03 INP-DVZ           PIC X(3).
       FD  IDX-FILE.
         01  IDX-REC.
           03 IDX-KEY.
             05 IDX-ID          PIC S9(5) COMP-3.
             05 IDX-DVZ         PIC S9(3) COMP.
           03 IDX-NAME          PIC X(15).
           03 IDX-SRNAME        PIC X(15).
           03 IDX-DATE          PIC S9(7) COMP-3.
           03 IDX-BALANCE       PIC S9(15) COMP-3.
       WORKING-STORAGE SECTION.
         01  WS-WORK-AREA.
           03 INT-DATE          PIC 9(7).
           03 GREG-DATE         PIC 9(8).
           03 ST-INP-FILE       PIC 9(2).
              88 INP-FILE-EOF                   VALUE 10.
              88 INP-SUCCES                     VALUE 00 97.
           03 ST-OUT-FILE       PIC 9(2).
              88 OUT-SUCCES                     VALUE 00 97.
           03 ST-IDX-FILE       PIC 9(2).
              88 IDX-SUCCES                     VALUE 00 97.
         01 DATECALC.
           05 REC-DATE-INT      PIC 9(08).
           05 REC-NDATE-INT     PIC 9(08).
           05 REC-LDAY          PIC 9(08).

       PROCEDURE DIVISION.
      *ONCE H100-OPEN-FILES PARAGRAFI ILE DOSYALARIMIZI ACIYORUZ
      *KAYIT OKUYORUZ. ARDINDAN H200-PROCCESS PARAGRAFINI DOSYA SONUNA GELENE KADAR TEKRAR EDIYORUZ.
      *H999-PROGRAM-EXIT PARAGRAFI ILE DOSYALARIMIZI KAPATIYORUZ.
       0000-MAIN.
           PERFORM H100-OPEN-FILES
           READ INP-FILE
           PERFORM H200-PROCCES UNTIL INP-FILE-EOF
           PERFORM H999-PROGRAM-EXIT.
       0000-END. EXIT.
      *DOSYALARI OKUYORUZ VE HATA ALMA DURUMUNDA HATA MESAJI YAZDIRIYORUZ ARDINDAN H999-PROGRAM-EXIT ILE
      *DOSYALARIMIZI KAPATIYORUZ.
       H100-OPEN-FILES.
           OPEN INPUT  INP-FILE.
           OPEN OUTPUT OUT-FILE.
           OPEN INPUT IDX-FILE.
           IF (ST-INP-FILE NOT = 0) AND (ST-INP-FILE NOT = 97)
           DISPLAY 'UNABLE TO OPEN INPFILE: ' ST-INP-FILE
           MOVE ST-INP-FILE TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
           IF (ST-OUT-FILE NOT = 0) AND (ST-OUT-FILE NOT = 97)
           DISPLAY 'UNABLE TO OPEN OUTFILE: ' ST-OUT-FILE
           MOVE ST-OUT-FILE TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
           IF (ST-IDX-FILE NOT = 0) AND (ST-IDX-FILE NOT = 97)
           DISPLAY 'UNABLE TO OPEN IDXFILE: ' ST-IDX-FILE
           MOVE ST-IDX-FILE TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
       H100-END. EXIT.
      *ID VE DVZ DEGISKENLERIMIZI INTEGER'A DONUSTURUP GIRIS DOSYASINDAN KAYITLARIMIZI OKUYORUZ.
       H200-PROCCES.
           COMPUTE IDX-ID = FUNCTION NUMVAL(INP-ID)
           COMPUTE IDX-DVZ = FUNCTION NUMVAL(INP-DVZ)
           READ IDX-FILE KEY IS IDX-KEY
           INVALID KEY PERFORM H210-INVALID-MESSAGE
           NOT INVALID KEY PERFORM H220-VALID-MESSAGE.
       H200-END. EXIT.
      *GECERSIZ ANAHTAR GIRILDIGINI DISPLAY ILE EKRANA BASTIRIYORUZ
       H210-INVALID-MESSAGE.
           DISPLAY 'INVALID KEY, PLEASE CHECK IT : ' IDX-KEY.
           READ INP-FILE.
       H210-END. EXIT.
      *GECERLI BIR ANAHTARLA KARSILASTIGIMIZDA KAYIT ALANLARINI ILGILI CIKTI ALANLARINA TASIYORUZ VE CIKTI DOSYAMIZA KAYDI YAZIYORUZ
       H220-VALID-MESSAGE.
           COMPUTE INT-DATE = FUNCTION INTEGER-OF-DAY(IDX-DATE)
           COMPUTE GREG-DATE = FUNCTION DATE-OF-INTEGER(INT-DATE)
           MOVE IDX-ID TO REC-ID-O
           MOVE IDX-DVZ TO REC-DVZ-O
           MOVE IDX-NAME TO REC-NAME-O
           MOVE IDX-SRNAME TO REC-SRNAME-O
           MOVE GREG-DATE TO REC-DATE-O
           MOVE IDX-BALANCE TO REC-BALANCE-O
           MOVE ".." TO REC-SPACE-1 
           MOVE ".." TO REC-SPACE-2 
           MOVE ".." TO REC-SPACE-3 
           IF REC-DVZ-O = 840
           PERFORM H230-PRICE
           END-IF 
           WRITE OUT-REC
           READ INP-FILE.
       H220-END. EXIT.
      *BU PARAGRAFTA BELIRLI BIR TARIHE GORE HESAPLAMA YAPIYORUZ VE KAYIT BAKIYEMIZE EKLEME YAPIYORUZ
       H230-PRICE.
           IF REC-DATE-O < 19600101
           COMPUTE REC-BALANCE-O  = REC-BALANCE-O  + 3000
           ELSE IF REC-DATE-O < 19650101
           COMPUTE REC-BALANCE-O  = REC-BALANCE-O  + 2750
           ELSE IF REC-DATE-O < 19700101
           COMPUTE REC-BALANCE-O  = REC-BALANCE-O  + 2500
           ELSE IF REC-DATE-O < 19750101
           COMPUTE REC-BALANCE-O  = REC-BALANCE-O  + 2250
           ELSE IF REC-DATE-O < 19800101
           COMPUTE REC-BALANCE-O  = REC-BALANCE-O  + 2000
           ELSE IF REC-DATE-O < 19850101
           COMPUTE REC-BALANCE-O  = REC-BALANCE-O  + 1750
           ELSE IF REC-DATE-O < 19900101
           COMPUTE REC-BALANCE-O  = REC-BALANCE-O  + 1500
           ELSE IF REC-DATE-O < 19950101
           COMPUTE REC-BALANCE-O  = REC-BALANCE-O  + 1250
           ELSE IF REC-DATE-O < 20230101
           COMPUTE REC-BALANCE-O  = REC-BALANCE-O  + 250
           END-IF.
       H230-END. EXIT.
      *DOSYALARIMIZI KAPATIP PROGRAMI SONLANDIRIYORUZ
       H999-PROGRAM-EXIT.
           CLOSE INP-FILE.
           CLOSE OUT-FILE.
           CLOSE IDX-FILE.
           STOP RUN.
      *
