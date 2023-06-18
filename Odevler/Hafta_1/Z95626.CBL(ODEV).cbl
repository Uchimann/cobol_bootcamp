       IDENTIFICATION DIVISION.
      *-----------------------
       PROGRAM-ID.    ODEV
       AUTHOR.        Otto B. Fun.
      *--------------------
       ENVIRONMENT DIVISION.
      *--------------------
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRINT-LINE ASSIGN TO PRTLINE.
           SELECT ACCT-REC   ASSIGN TO ACCTREC.
      *SELECT yan tümcesi dahili bir dosya adı oluşturur
      *ASSIGN yan tümcesi, harici bir veri kaynağı için bir ad oluşturur,
      *z/OS tarafından kullanılan JCL DDNAME ile ilişkilidir
      *Örneğin. ACCTREC, CBL0001J JCL dosyasında &SYSUID..DATA'ya bağlanmıştır.
      *burada &SYSUID. z/OS kullanıcı kimliğiniz anlamına gelir
      *Örneğin. kullanıcı kimliğiniz Z54321 ise,
      *ACTREC için kullanılan veri seti Z54321.DATA'dır.
       DATA DIVISION.
      *-------------
       FILE SECTION.
       FD  PRINT-LINE RECORDING MODE F.
       01  PRINT-REC.
           05  ACCT-NO-O      PIC X(8).
           05  ACCT-LIMIT-O   PIC $$,$$$,$$9.99.
           05  ACCT-BALANCE-O PIC $$,$$$,$$9.99.
      * PIC $$,$$$,$$9.99 -- Bölüm 7.2.3'te PIC için alternatif,
      * farklı basamak miktarlarına izin vermek için $ kullanılması
      * ve .99 yerine v99 çıktıda dönem gösterimine izin vermek için
           05  LAST-NAME-O    PIC X(20).
           05  FIRST-NAME-O   PIC X(15).
           05  COMMENTS-O     PIC X(50).
      * 05 seviyesi 01 seviyesinden yüksek olduğu için,
      * tüm değişkenler PRINT-REC'e aittir (bkz. bölüm 7.3.3)
      *
       FD  ACCT-REC RECORDING MODE F.
       01  ACCT-FIELDS.
           05  ACCT-NO            PIC X(8).
           05  ACCT-LIMIT         PIC S9(7)V99 COMP-3.
           05  ACCT-BALANCE       PIC S9(7)V99 COMP-3.
      * PIC S9(7)v99 -- yedi hane artı bir işaret hanesi değeri
      * COMP-3 -- paketlenmiş BCD (ikili kodlu ondalık) gösterimi
           05  LAST-NAME          PIC X(20).
           05  FIRST-NAME         PIC X(15).
           05  CLIENT-ADDR.
               10  STREET-ADDR    PIC X(25).
               10  CITY-COUNTY    PIC X(20).
               10  USA-STATE      PIC X(15).
           05  RESERVED           PIC X(7).
           05  COMMENTS           PIC X(50).
      *
       WORKING-STORAGE SECTION.
       01 FLAGS.
         05 LASTREC           PIC X VALUE SPACE.
      *------------------
       PROCEDURE DIVISION.
      *------------------
       OPEN-FILES.
           OPEN INPUT  ACCT-REC.
           OPEN OUTPUT PRINT-LINE.
      *
       READ-NEXT-RECORD.
           PERFORM READ-RECORD
      * Döngüye girmeden önce önceki ifade gereklidir.
      * Her iki döngü koşulu LASTREC = 'Y'
      * ve YAZ-KAYIT çağrısı, OKUMA-KAYIT'ın sahip olmasına bağlıdır.
      * daha önce idam edildi.
      * Döngü bir sonraki satırda PERFORM UNTIL ile başlar.
           PERFORM UNTIL LASTREC = 'Y'
               PERFORM WRITE-RECORD
               PERFORM READ-RECORD
           END-PERFORM
           .
      *
       CLOSE-STOP.
           CLOSE ACCT-REC.
           CLOSE PRINT-LINE.
           GOBACK.
      *
       READ-RECORD.
           READ ACCT-REC
               AT END MOVE 'Y' TO LASTREC
           END-READ.
      *
       WRITE-RECORD.
           MOVE ACCT-NO      TO  ACCT-NO-O.
           MOVE ACCT-LIMIT   TO  ACCT-LIMIT-O.
           MOVE ACCT-BALANCE TO  ACCT-BALANCE-O.
           MOVE LAST-NAME    TO  LAST-NAME-O.
           MOVE FIRST-NAME   TO  FIRST-NAME-O.
           MOVE COMMENTS     TO  COMMENTS-O.
           WRITE PRINT-REC.
      *
