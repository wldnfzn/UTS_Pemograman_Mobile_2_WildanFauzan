# 🧠 BAGIAN A – TEORI

## 1. Bagaimana State Management dengan Cubit Membantu Pengelolaan Transaksi dengan Logika Diskon Dinamis

State management menggunakan **Cubit** sangat membantu dalam aplikasi kasir yang memiliki proses transaksi dengan diskon dinamis karena mampu memisahkan logika bisnis dari UI dan memperbarui tampilan secara reaktif.

### a. Pemisahan Logika dan UI (Separation of Concerns)
Cubit menyimpan seluruh logika seperti:
- Perhitungan harga
- Perhitungan diskon
- Update jumlah item
- Total harga akhir

UI hanya menampilkan state yang diberikan oleh Cubit → kode lebih bersih dan mudah dirawat.

### b. Update State Secara Reaktif
Ketika jumlah item berubah, Cubit akan:
- Menghitung ulang total harga
- Menghitung diskon dinamis
- Mengirimkan state baru ke UI

UI otomatis *rerender* tanpa `setState()` → lebih efisien dan stabil.

### c. Mendukung Logika Diskon yang Kompleks
Cubit mempermudah implementasi diskon seperti:
- Diskon 10% jika total > 50.000
- Diskon untuk menu tertentu
- Diskon bertingkat (tiered discount)

Semua logika berada di satu fungsi sehingga state lebih konsisten.

### d. Lebih Mudah Dites (Testable)
Karena logika bisnis tidak bercampur dengan UI, unit test pada perhitungan diskon dapat dilakukan tanpa widget testing.

---

## 2. Perbedaan Diskon Per Item dan Diskon Total Transaksi

### a. Diskon Per Item
Diskon diterapkan langsung pada item tertentu sebelum total transaksi dihitung.

**Karakteristik:**
- Berlaku untuk produk tertentu
- Potongan dihitung per item
- Cocok untuk promo item spesifik

**Contoh:**
Harga Ayam Geprek = 20.000  
Diskon 15% → Harga menjadi 17.000  
Beli 2 → Total = 34.000

### b. Diskon Total Transaksi
Diskon diterapkan pada total akhir setelah semua item dijumlahkan.

**Karakteristik:**
- Berlaku pada total belanja
- Biasanya memiliki syarat (minimal belanja, membership, dst)

**Contoh:**
Total belanja = 60.000  
Diskon 10% → Potongan 6.000  
Total bayar = 54.000

### Tabel Perbedaan

| Jenis Diskon | Diterapkan Pada | Contoh |
|--------------|----------------|--------|
| Diskon Per Item | Harga tiap item | Ayam Geprek diskon 15% |
| Diskon Total Transaksi | Total belanja akhir | Diskon 10% untuk total ≥ 50k |

---

## 3. Manfaat Widget Stack pada Tampilan Kategori Menu Flutter

Widget **Stack** digunakan untuk menumpuk widget secara bertingkat sehingga cocok untuk membuat tampilan kategori menu yang modern dan interaktif.

### a. Membuat UI Lebih Menarik
Stack dapat menampilkan:
- Gambar kategori sebagai background
- Teks kategori di atas gambar
- Ikon atau tombol overlay

### b. Mendukung Layout yang Tidak Bisa Dibuat dengan Row/Column
Stack dapat membuat:
- Label yang melayang
- Ikon di pojok
- Overlay pada gambar

### c. Mendukung Efek Overlay atau Badge Promo
Contoh kegunaan:
- Layer gelap untuk menampilkan teks lebih jelas
- Badge “Promo”
- Highlight kategori tertentu

### d. Fleksibel dan Responsif
Dengan `Alignment` dan `Positioned`, Stack tetap tampil rapi di berbagai ukuran layar.
