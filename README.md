# ⌨️ Keyboard Lock for macOS

[![macOS](https://img.shields.io/badge/macOS-11.0%2B-blue?logo=apple&logoColor=white)](https://apple.com)
[![Swift](https://img.shields.io/badge/Swift-5.0%2B-orange?logo=swift&logoColor=white)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Apple%20Silicon%20%7C%20Intel-lightgrey)]()

**Keyboard Lock** adalah aplikasi macOS native yang ringan dan praktis untuk menonaktifkan seluruh input keyboard secara sementara. Sangat ideal saat Anda ingin membersihkan keyboard MacBook atau keyboard eksternal dari debu tanpa harus mematikan Mac, atau untuk mencegah ketikan tidak sengaja dari anak kecil atau hewan peliharaan.

---

## ✨ Fitur Utama

- 🔒 **Blokir Menyeluruh (Total Input Lock)**  
  Menelan seluruh event keyboard termasuk tombol karakter, tombol fungsi (F-keys), tombol media, brightness, volume, hingga tombol modifier menggunakan CoreGraphics `CGEventTap`.
- ⏱️ **Dua Metode Buka Kunci (Dual Unlock)**:
  1. **Kombinasi Fisik**: Tahan tombol **`Command Kiri (⌘)` + `Command Kanan (⌘)`** secara bersamaan selama **5 detik** (dilengkapi indikator progress bar dan hitungan mundur real-time).
  2. **Trackpad / Mouse**: Tombol buka kunci pada jendela aplikasi selalu dapat diklik kapan saja menggunakan kursor.
- ⚡ **Ringan & Murni Native**  
  Ditulis 100% menggunakan Swift dan Cocoa tanpa dependensi eksternal pihak ketiga (zero third-party dependencies).
- 🛡️ **Auto Recovery Event Tap**  
  Menangani kasus ketika macOS menonaktifkan event tap akibat timeout sistem secara otomatis.

---

## 📋 Kebutuhan Sistem

- **macOS 11.0 (Big Sur)** atau versi yang lebih baru (Apple Silicon & Intel).
- Izin **Accessibility** (Aksesibilitas) pada macOS.

---

## 🚀 Cara Build & Instalasi

Anda dapat melakukan build aplikasi ini langsung dari terminal tanpa perlu membuka Xcode:

### 1. Clone Repositori
```bash
git clone https://github.com/Frdalf/keyboard-lock.git
cd keyboard-lock
```

### 2. Jalankan Build Script
Pastikan script memiliki izin eksekusi lalu jalankan:
```bash
chmod +x build.sh
./build.sh
```

Script akan mengompilasi `KeyboardLock.swift` dengan optimasi `-O`, membungkusnya menjadi bundle `Keyboard Lock.app`, membuat `Info.plist`, dan melakukan ad-hoc code signing.

### 3. Pindahkan ke Applications
Pindahkan `Keyboard Lock.app` ke direktori aplikasi Anda:
```bash
mv "Keyboard Lock.app" /Applications/
```

---

## ⚙️ Pengaturan Izin Aksesibilitas (Accessibility)

Karena aplikasi ini bertugas mencegat dan menahan sinyal input keyboard pada tingkat sistem (via CoreGraphics `CGEventTap`), macOS mewajibkan izin aksesibilitas:

1. Buka **System Settings** (Pengaturan Sistem) di Mac Anda.
2. Pilih menu **Privacy & Security** (Privasi & Keamanan) › **Accessibility** (Aksesibilitas).
3. Klik tombol **+** atau aktifkan tombol toggle untuk **Keyboard Lock**.
4. Jika diminta, mulai ulang aplikasi `Keyboard Lock`.

> [!NOTE]
> Jika izin belum diberikan, aplikasi akan menampilkan dialog peringatan dan mengarahkan Anda ke pengaturan sistem.

---

## 📖 Cara Penggunaan

1. Buka aplikasi **Keyboard Lock**.
2. Klik tombol **"Kunci Keyboard"**.
3. Status akan berubah menjadi `🔒 Keyboard Terkunci`. Sekarang semua tombol fisik keyboard dinonaktifkan dan aman untuk dibersihkan.
4. Untuk membuka kembali:
   - Tekan dan tahan **`⌘ Kiri` + `⌘ Kanan`** bersamaan selama **5 detik**, **ATAU**
   - Klik tombol **"Buka Kunci (klik dengan trackpad)"** menggunakan mouse atau trackpad.

---

## 📂 Struktur File

```text
├── KeyboardLock.swift    # Logika penguncian (KeyLocker) & antarmuka aplikasi (AppDelegate)
├── build.sh              # Script otomatisasi build & packaging .app bundle
├── .gitignore            # File & folder yang diabaikan oleh Git
├── LICENSE               # Lisensi MIT
└── README.md             # Dokumentasi proyek
```

---

## 🛠️ GitHub Actions CI

Repositori ini telah dilengkapi dengan workflow CI otomatis (`.github/workflows/build.yml`) yang memverifikasi bahwa proyek dapat dikompilasi dengan sukses pada runner `macos-latest` setiap kali ada pembaruan kode.

---

## 📄 Lisensi

Proyek ini didistribusikan di bawah lisensi **MIT**. Silakan lihat file [LICENSE](LICENSE) untuk informasi lebih lanjut.
