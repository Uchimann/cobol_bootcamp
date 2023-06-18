       IDENTIFICATION DIVISION.
      *-----------------------
       PROGRAM-ID.    ODEV
       AUTHOR.        Otto B. Fun.
      *--------------------
       ENVIRONMENT DIVISION.
      *Aşağıdaki satır, programın giriş-çıkış bölümünün başlangıcını belirtir.
       INPUT-OUTPUT SECTION.
      *Aşağıdaki satır, programın dosya kontrol bölümünün başlangıcını belirtir.
       FILE-CONTROL.
      *12. satırda, "PRINT-LINE" adlı bir dosya seçilir ve "PRTLINE" adıyla ataması yapılır.
      *13. satırda, "ACCT-REC" adlı bir dosya seçilir ve "ACCTREC" adıyla ataması yapılır.
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
      *Alt satır, "PRINT-LINE" adlı dosyanın formatının "F" (fixed) olduğunu belirtir.
       FD  PRINT-LINE RECORDING MODE F.
      *"PRINT-REC" adlı bir kayıt tanımlanır. Bu kayıt, "PRINT-LINE" dosyasının yapısını temsil eder.
      *30. satır, "ACCT-NO-O" adlı bir alan tanımlar. Bu alan, 8 karakter uzunluğunda bir alandır ve "PRINT-REC" kaydının bir parçasıdır.
      *31. satır, "ACCT-LIMIT-O" adlı bir alan tanımlar. Bu alan, dolar simgeleri ve ondalık basamakları içeren bir miktardır.
      *ve "PRINT-REC" kaydının bir parçasıdır.
       01  PRINT-REC.
           05  ACCT-NO-O      PIC X(8).
           05  ACCT-LIMIT-O   PIC $$,$$$,$$9.99.
           05  ACCT-BALANCE-O PIC $$,$$$,$$9.99.
      * 37. Satır,"LAST-NAME-O" adlı bir alan tanımlar. Bu alan, 20 karakter uzunluğunda bir alandır ve "PRINT-REC" kaydının bir parçasıdır.
           05  LAST-NAME-O    PIC X(20).
           05  FIRST-NAME-O   PIC X(15).
           05  COMMENTS-O     PIC X(50).
      * 05 seviyesi 01 seviyesinden düşük olduğu için,
      * tüm değişkenler PRINT-REC'e aittir.
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
      *60.satır, "LASTREC" adlı bir alan tanımlar. Bu alan, "SPACE" değeriyle başlatılan bir karakter alanıdır.
       WORKING-STORAGE SECTION.
       01 FLAGS.
         05 LASTREC           PIC X VALUE SPACE.
      *------------------
       PROCEDURE DIVISION.
      *------------------
      *66.satır, "ACCT-REC" adlı dosyanın giriş olarak açılmasını sağlar.
      *67. satır, "PRINT-LINE" adlı dosyanın çıkış olarak açılmasını sağlar.
       OPEN-FILES.
           OPEN INPUT  ACCT-REC.
           OPEN OUTPUT PRINT-LINE.
      *70. satır, bir sonraki kaydı okuyan bir işlemi başlatır.
       READ-NEXT-RECORD.
           PERFORM READ-RECORD
      *71.satır "READ-RECORD" işlemini gerçekleştirir.
      *"LASTREC" 'in 'Y' olmadığı sürece bir döngünün devam etmesini sağlar.
      *PERFORM WRITE-RECORD- "WRITE-RECORD" işlemini gerçekleştirir.
      *PERFORM READ-RECORD- "READ-RECORD" işlemini gerçekleştirir.
      * END-PERFORM, döngünün sonunu belirtir.
      * Döngü bir sonraki satırda PERFORM UNTIL ile başlıyor.
           PERFORM UNTIL LASTREC = 'Y'
               PERFORM WRITE-RECORD
               PERFORM READ-RECORD
           END-PERFORM
           .
      *Bu satır, dosyaların kapatılmasını ve programın sonlanmasını sağlar. 
      *GOBACK programın sonlandığını belirtir.
       CLOSE-STOP.
           CLOSE ACCT-REC.
           CLOSE PRINT-LINE.
           GOBACK.
      *-------------
      *-----------
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
