//ODEVJ JOB 1,NOTIFY=&SYSUID
//***************************************************/
//* Copyright Contributors to the COBOL Programming Course
//* SPDX-License-Identifier: CC-BY-4.0
//***************************************************/
//COBRUN  EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(ODEV),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(ODEV),DISP=SHR
//***************************************************/
// IF RC = 0 THEN
//***************************************************/
//RUN     EXEC PGM=ODEV
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//ACCTREC   DD DSN=&SYSUID..DATA,DISP=SHR
//*Aşağıdaki satırda değişiklik yaptık.
//*Satırın ne yaptığını dosyanın en altında belirtiyoruz.
//PRTLINE   DD DSN=&SYSUID..ODEV.OUTPUT,DISP=(NEW,CATLG,DELETE),
//            SPACE=(CYL,(10,5))
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
//***************************************************/
//*DD: Data Definition (Veri Tanımı) anlamına gelir ve bir dosya tanımı oluşturmak için kullanılır.
//*DSN=&SYSUID..ODEV.OUTPUT: Bu bölümde DSN (Dataset Name) ile başlayan bir tanımlama yapılır. 
//*&SYSUID özel değişkeni, JCL'yi çalıştıran kullanıcının kimliğini temsil eder. 
//*ODEV.OUTPUT ise dosya adının bir parçasıdır ve burada dosyanın adını belirtir.
//*DISP=(NEW,CATLG,DELETE): Bu bölüm, dosya işlemi için kullanılacak yönergeleri belirtir.
//*NEW: Dosyanın yeni bir veri seti oluşturulmasını sağlar.
//*CATLG: Oluşturulan veri setinin bir katalogda listelenmesini sağlar.
//*DELETE: Dosyanın işlem tamamlandıktan sonra silinmesini sağlar.
//*SPACE=(CYL,(10,5)): Bu bölüm, dosya için ayrılan alanın boyutunu belirtir.
//*CYL: Silindir birimiyle alanın boyutunu belirtir.
//*(10,5): Dosya için ayrılan alanın minimum ve maksimum boyutunu belirtir. 
//*Buradaki değerler sırasıyla minimum 10 silindir ve yetmezde ek olarak 5 silindir olarak belirlenmiştir.
//*17.JCL satırı, PRTLINE adlı bir çıktı dosyasının oluşturulmasını, kataloglanmasını ve işlem tamamlandıktan sonra silinmesini sağlar. 
//*Dosya, kullanıcının kimliğini temsil eden &SYSUID ile başlayan bir ad ve ODEV.OUTPUT ile devam eden bir ad ile oluşturulur. 
//*Dosya boyutu, minimum 10 silindir ve maksimum 5 silindir olarak belirlenmiştir.
// ELSE
// ENDIF
