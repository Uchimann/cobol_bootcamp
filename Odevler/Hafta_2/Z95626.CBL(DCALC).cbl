       IDENTIFICATION DIVISION.
       PROGRAM-ID. DCALC.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
      *--Fıle control kısmında cobol dosyasında kullanacağımız PRINT-LINE değişkenini oluşturup
      *--bu değişkeni jcl dosyasında dizini belirlediğimiz PRTLINE değişkenine hizalıyoruz(bağlıyoruz)
      * aynı islemleri DATE-REC için de yapıyoruz.
       FILE-CONTROL.
           SELECT PRINT-LINE ASSIGN TO PRTLINE
                             STATUS ST-PRINT-LINE.
           SELECT DATE-REC   ASSIGN TO DATEREC
                             STATUS ST-DATE-REC.
       DATA DIVISION.
       FILE SECTION.
      *PRINT-LINE dosyamızı açıyoruz ve PRINT-REC adında değişken yapısı ismi belirleyip, alt elemanlarını tanımlıyoruz
      *(burdaki sıralamanın okunacak dosyadaki verilerin sıralaması ile aynı olduguna dikkat etmenizi isterim)
      *bu sekil olmasının sebebi verileri sırayla sabit uzunluktaki bir yere yazdıracagımız icin diye yorumladim
       FD  PRINT-LINE RECORDING MODE F.
         01  PRINT-REC.
           03 REC-ID-O          PIC X(4).
           03 REC-NAME-O        PIC X(15).
           03 REC-SRNAME-O      PIC X(15).
           03 REC-DATE-O        PIC 9(08).
           03 REC-NDATE-O       PIC 9(08).
           03 REC-LDAY-O        PIC 9(08).
       FD  DATE-REC RECORDING MODE F.
         01  DATEIN.
           03 REC-ID            PIC X(4).
           03 REC-NAME          PIC X(15).
           03 REC-SRNAME        PIC X(15).
           03 REC-DATE          PIC 9(08).
           03 REC-NDATE         PIC 9(08).

       WORKING-STORAGE SECTION.
         01  WS-WORK-AREA.
           03 ST-DATE-REC        PIC 9(2).
           88 DATE-REC-EOF                   VALUE 10.
           03 ST-PRINT-LINE      PIC 9(2).
         01 DATECALC.
           05 REC-DATE-INT      PIC 9(08).
           05 REC-NDATE-INT     PIC 9(08).
           05 REC-LDAY          PIC 9(08).

      *--------------------
      *Main paragrafimiz H100-OPEN_FILES paragrafını bitene kadar calistiriyor.
      *ardindan H200 paragrafimiz DATE-REC-EOF degeri, degerimize gelene kadar calisiyor
      *h999 ile dosyaları kapatip programi sonlandiriyoruz.
       PROCEDURE DIVISION.
       0000-MAIN.
           PERFORM H100-OPEN-FILES
           PERFORM H200-READ-NEXT-RECORD UNTIL DATE-REC-EOF
           PERFORM H999-PROGRAM-EXIT.
       0000-END. EXIT.
      *---- H100 programi ilk once  DATA-REC dosyasini input olarak aciyor
      *daha sonra PRINT-LINE degiskenini output olarak aciyor.
      * eger dosya durumları 0 ve 97 değil ise  hata mesaji verip return code degiskenimize, file status degerini atiyoruz
      *00 ve 97 durumunda dosya basarili sekilde acilmistir. 97 durumunda Vsam icin, dosyanin bir önceki aciliminda duzgun sekilde
      *acilmadigi anlamina gelir.
      *ayni islemleri diger dosya durumlarimiz icin yapiyoruz.
       H100-OPEN-FILES.
           OPEN INPUT  DATE-REC.
           OPEN OUTPUT PRINT-LINE.
           IF (ST-DATE-REC NOT = 0) AND (ST-DATE-REC NOT = 97)
           DISPLAY 'UNABLE TO OPEN INPFILE: ' ST-DATE-REC
           MOVE ST-DATE-REC TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
           IF (ST-PRINT-LINE NOT = 0) AND (ST-PRINT-LINE NOT = 97)
           DISPLAY 'UNABLE TO OPEN OUTFILE: ' ST-PRINT-LINE
           MOVE ST-PRINT-LINE TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
           READ DATE-REC.
           IF (ST-DATE-REC NOT = 0) AND (ST-DATE-REC NOT = 97)
           DISPLAY 'UNABLE TO READ INPFILE: ' ST-DATE-REC
           MOVE ST-DATE-REC TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
       H100-END. EXIT.
      *CALL-RECORD paragrafimiz calistiriliyor. CALL-RECORD'dan geri gelisinde dosyadan bir satir okuyoruz.
       H200-READ-NEXT-RECORD.
               PERFORM CALC-RECORD
               READ DATE-REC.
       H200-END. EXIT.
      *suanki ve dogum tarihini integere donusturup bir degiskene atiyoruz. Ardindan
      *Write record paragrafimizi calistiriyoruz.
       CALC-RECORD.
           COMPUTE REC-DATE-INT = FUNCTION INTEGER-OF-DATE(REC-DATE)
           COMPUTE REC-NDATE-INT = FUNCTION INTEGER-OF-DATE(REC-NDATE)
           COMPUTE REC-LDAY = REC-NDATE-INT - REC-DATE-INT
           PERFORM WRITE-RECORD.
       CALC-END. EXIT.
      *Bu paragraf, okunan degiskenleri, karsilik gelen yazdirilacak dosyamizda kullanacagimiz degiskenlere atiyor.
      *Sonrasinda PRINT-REC degisken yapisini yazdiriyoruz. (ordaki alt degiskenler sirasiyla yazdiriliyor)
       WRITE-RECORD.
           MOVE REC-ID       TO  REC-ID-O.
           MOVE REC-NAME     TO  REC-NAME-O.
           MOVE REC-SRNAME   TO  REC-SRNAME-O.
           MOVE REC-DATE     TO  REC-DATE-O.
           MOVE REC-NDATE    TO  REC-NDATE-O.
           MOVE REC-LDAY     TO  REC-LDAY-O.
           WRITE PRINT-REC.
       WRITE-END. EXIT.
      *dosyalari kapatip programi durduruyoruz.
       H999-PROGRAM-EXIT.
           CLOSE DATE-REC.
           CLOSE PRINT-LINE.
           STOP RUN.

      *
