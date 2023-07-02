Bu programın amacı, bir veritabanında (INP-FILE) bulunan giriş kayıtlarını (INP-REC) okuyarak
bir indeks dosyasında (IDX-FILE) karşılık gelen kayıtları (IDX-REC) bulmak ve çıktı dosyasına (OUT-FILE) yazmaktır. 
Bu işlem, her giriş kaydının anahtarını (IDX-KEY) kullanarak indeks dosyasında bir eşleme yaparak gerçekleştirilir.

Programın çalışma mantığı şu şekildedir:
1. Dosyaların açılması (INP-FILE, OUT-FILE, IDX-FILE).
2. Giriş dosyasından (INP-FILE) bir kaydın okunması (INP-REC).
3. Okunan kaydın anahtar değeri (INP-ID, INP-DVZ) kullanılarak indeks dosyasında (IDX-FILE) eşleşen bir kaydın aranması (READ IDX-FILE KEY IS IDX-KEY).
   - Eğer eşleşen bir kayıt bulunamazsa, geçersiz anahtar mesajı gösterilir (H210-INVALID-MESSAGE) ve bir sonraki giriş kaydı okunur.
   - Eğer eşleşen bir kayıt bulunursa, geçerli mesaj gösterilir (H220-VALID-MESSAGE) ve çıktı dosyasına kayıt yazılır (WRITE OUT-REC).
     Daha sonra bir sonraki giriş kaydı okunur.
4. Tüm giriş kayıtları işlenene kadar adımlar 2-3 tekrarlanır.
5. Programın sonlandırılması ve dosyaların kapatılması (H999-PROGRAM-EXIT).

Bu program, bir veritabanı kaydının indeks dosyası kullanılarak hızlı bir şekilde bulunmasını ve çıktı dosyasına yazılmasını
sağlayan basit bir endeksleme işlemi gerçekleştirir.
