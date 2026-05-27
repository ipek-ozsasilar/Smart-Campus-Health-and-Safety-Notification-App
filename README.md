# Smart Campus Health & Safety Notification App

Kampüs içinde sağlık, güvenlik ve teknik olayların hızlıca bildirilebildiği, takip edilebildiği ve harita üzerinde görüntülenebildiği Flutter tabanlı bir mobil uygulama.

## Proje Amacı

Bu uygulama, kampüs kullanıcılarının yaşadıkları olayları (ör. güvenlik, sağlık, teknik arıza, kayıp eşya vb.) tek bir noktadan raporlayabilmesini ve ilgili birimlerin süreci daha şeffaf bir şekilde yönetebilmesini hedefler.

## Temel Özellikler

- Firebase Authentication ile e-posta/şifre ve Google ile giriş
- Bildirim oluşturma (kategori, başlık, açıklama, konum, opsiyonel görsel)
- Canlı bildirim akışı (Firestore stream)
- Bildirim arama ve filtreleme (kategori, durum, takip edilenler, birim)
- Bildirim detay ekranı ve harita üzerinde olay noktası görüntüleme
- Kullanıcıların bildirimleri takip etmesi ve durum değişikliği geri bildirimi
- Rol bazlı yapı (kullanıcı / admin)
- Admin panelinden bildirim durum güncelleme (Açık, İşlemde, Çözüldü)
- Acil durum duyurusu yayınlama (üst bant uyarısı)
- Profil ekranı (kullanıcı bilgileri, takip edilen bildirimler, ayarlar)

## Kullanılan Teknolojiler

- **Framework:** Flutter
- **Dil:** Dart
- **State Management:** Riverpod
- **Backend:** Firebase (Auth, Firestore, Storage)
- **Harita:** Google Maps Flutter
- **Konum:** Geolocator + Permission Handler

## Proje Yapısı

```text
lib/
  feature/
    admin/
    home/
    login/
    map/
    notification/
    profile/
  product/
    constant/
    enum/
    mixin/
    model/
    widget/
  main.dart
```

## Ekranlar (Screens)

- Giriş Ekranı
- Kayıt Ol Ekranı
- Ana Sayfa (Bildirim Listesi)
- Bildirim Oluşturma Ekranı
- Bildirim Detay Ekranı
- Harita Ekranı
- Profil Ekranı
- Admin Paneli
- Acil Durum Bildirimi Ekranı

## Screenshots

> Bu bölüme ekran görüntülerini sen ekleyebilirsin.  
> Örnek klasör: `docs/screenshots/`

### Login

<img width="295" height="646" alt="Image" src="https://github.com/user-attachments/assets/cddd410b-b023-43cc-aa5a-b3dd90b03eec" />
<img width="295" height="655" alt="Image" src="https://github.com/user-attachments/assets/c53ca72c-f151-43c6-9e10-f610113e7e56" />
<img width="292" height="648" alt="Image" src="https://github.com/user-attachments/assets/00d43efc-6fbf-4b0c-b153-fc1703d1ecd4" />


### Home

<img width="293" height="644" alt="Image" src="https://github.com/user-attachments/assets/d8f5be47-7e5b-4e7c-b831-c374c81dda83" />

### Create Notification

<img width="292" height="644" alt="Image" src="https://github.com/user-attachments/assets/173082b6-eeef-4e48-8f2f-7ea856fa3473" />
<img width="293" height="650" alt="Image" src="https://github.com/user-attachments/assets/3b7ea199-3489-4bd5-aa02-a7eebf9921ef" />

### Notification Detail

<img width="290" height="646" alt="Image" src="https://github.com/user-attachments/assets/f369b52f-c60e-4dbc-b801-3ec8b570ffed" />
<img width="286" height="651" alt="Image" src="https://github.com/user-attachments/assets/6cd0a12d-0e1d-4cb7-80f2-7e39e0028482" />

### Map

<img width="295" height="649" alt="Image" src="https://github.com/user-attachments/assets/0a6b5774-8342-497a-8a06-1eb126e55353" />

### Profile

<img width="289" height="650" alt="Image" src="https://github.com/user-attachments/assets/b1f7d920-c148-4fdf-951e-fc1d60d6d54c" />

## Kurulum

### 1) Gereksinimler

- Flutter SDK (önerilen: stable)
- Dart SDK (Flutter ile birlikte gelir)
- Android Studio veya VS Code
- Firebase projesi
- Google Maps API key

### 2) Projeyi indir

```bash
git clone <repo-url>
cd Smart-Campus-Health-and-Safety-Notification-App
```

### 3) Bağımlılıkları yükle

```bash
flutter pub get
```

### 4) Firebase kurulumu

Bu projede Firebase kullanılmaktadır. Kendi Firebase projenle şu adımları uygula:

1. Firebase Console'da Android/iOS uygulamalarını ekle.
2. `flutterfire configure` komutunu çalıştır.
3. Oluşan `firebase_options.dart` dosyasını `lib/` altına ekle.
4. Firestore ve Authentication servislerini aktif et.

### 5) Google Maps kurulumu

- Android için `android/app/src/main/AndroidManifest.xml` içine API key ekle.
- iOS için `ios/Runner/AppDelegate.swift` veya ilgili konfigürasyona API key ekle.

### 6) Uygulamayı çalıştır

```bash
flutter run
```

## Örnek Kullanım Akışı

1. Kullanıcı giriş yapar veya kayıt olur.
2. Ana sayfada mevcut bildirimleri görür, arama/filtre yapar.
3. Yeni bir olay için bildirim oluşturur ve konum seçer.
4. Bildirimi takip ederek durum güncellemelerini izler.
5. Admin rolündeki kullanıcılar panelden durum yönetimi yapar.

## Geliştirme Notları

- Uygulama karanlık tema odaklı bir arayüz kullanır.
- Veriler gerçek zamanlı olarak Firestore üzerinden dinlenir.
- Rol bilgisi `users` koleksiyonundaki `role` alanına göre yönetilir.

## Katkı

Geliştirme önerileri ve katkılar için pull request açabilir veya issue oluşturabilirsin.
