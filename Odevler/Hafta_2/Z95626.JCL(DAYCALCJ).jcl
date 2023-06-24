//DAYCALCJ JOB 1,NOTIFY=&SYSUID
//***************************************************/
//* Copyright Contributors to the COBOL Programming Course
//* SPDX-License-Identifier: CC-BY-4.0
//***************************************************/
//COBRUN  EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(DCALC),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(DCALC),DISP=SHR
//***************************************************/
// IF RC < 5 THEN
//***************************************************/
//*Run satirinda DCALC adli cobol dosyamizi calistiriyoruz.
//*STEPLIB, programın çalışması için gereken yürütme kütüphanesini belirtir.
//*DD veri tanımı belirtir.. DSN= ifadesi, kütüphane adını &SYSUID..LOAD olarak ayarlar.
//*DISP=SHR ifadesi, kütüphanenin paylaşılan (shared) modda açılmasını belirtir.
//* islemlerimiz DATEREC VE PRTLINE uzerinde gerceklesiyor.
//***************************************************/
//*DATEREC adında veri tanimi belirtiyoruz. DSN= ifadesi, veri setinin adını &SYSUID..QSAM.BB olarak ayarlar.
//*PRTLINE kismi, çıktı veri dosyasının adını ve yerini belirtir. 
//*PRTLINE adlı bir veri tanımı belirtilir. 
//*DSN= ifadesi, veri setinin adını &SYSUID..QSAM.CC olarak ayarlar. 
//*DISP=(NEW,CATLG,DELETE) ifadesi, veri setinin yeni oluşturulacağını
//*kataloglanacağını ve işlem sonunda silineceğini belirtir.
//*SPACE= ifadesi, veri setinin alanını belirler. 
//*DCB= ifadesi, veri setinin kayıt formatını ve boyutunu belirler. 
//*UNIT=3390 ifadesi, kullanılacak birim türünü belirtir (3390 birim türü).
//***************************************************/
//RUN     EXEC PGM=DCALC
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//DATEREC   DD DSN=&SYSUID..QSAM.BB,DISP=SHR
//PRTLINE   DD DSN=&SYSUID..QSAM.CC,DISP=(NEW,CATLG,DELETE),
//             SPACE=(TRK,(20,20),RLSE),
//             DCB=(RECFM=FB,LRECL=58,BLKSIZE=0),UNIT=3390
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//*SYSOUT satiri, çıktıyı nereye yönlendireceğimizi belirtir. SYSOUT adlı bir veri tanımı belirtilir. 
//*SYSOUT=* ifadesi, çıktının sistem çıktı bölümüne yönlendirileceğini belirtir. 
//*OUTLIM=15000 ifadesi, çıktının maksimum uzunluğunu belirler (15000 karakter).
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
//***************************************************/
// ELSE
// ENDIF
