import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_ecommerce_app/data/entity/category.dart';
import 'package:flutter_ecommerce_app/data/entity/product.dart';
import 'package:flutter_ecommerce_app/data/entity/sepet.dart';

class ProductRepo {
  // Ürünleri JSON'dan parse etme metodu
  List<Product> parseProductCevap(String result) {
    try {
      var jsonResult = json.decode(result); // JSON verisini ayrıştırıyoruz
      print("JSON Verisi: $jsonResult");

      if (jsonResult['urunler'] == null) {
        print("Product verisi bulunamadı");
        return []; // Boş liste döndür
      }

      // JSON verisi doğruysa, 'urunler' alanını listeye çevirip döndürüyoruz
      var productList = (jsonResult['urunler'] as List)
          .map((item) => Product.fromJson(item))
          .toList();

      return productList;
    } catch (e) {
      print("JSON Ayrıştırma Hatası: $e");
      return []; // Hata durumunda boş liste döndür
    }
  }

  // Ürünleri yükleme metodu
  Future<List<Product>> urunleriYukle() async {
    var url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php";
    var cevap = await Dio().get(url);
    return parseProductCevap(cevap.data.toString());
  }

  // Sepetteki ürünleri listeleme metodu
  Future<List<CartProduct>> sepetListele(String kullaniciAdi) async {
    var url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php";
    var veri = {"kullaniciAdi": kullaniciAdi};
    try {
      var cevap = await Dio().post(url, data: FormData.fromMap(veri));
      print("API Yanıtı: ${cevap.data.toString()}");
      var jsonResult = json.decode(cevap.data.toString());
      print(jsonResult.toString());
      var sepetListesi = (jsonResult['urunler_sepeti'] as List?)
              ?.map((item) => CartProduct.fromJson(item))
              .toList() ??
          [];
      return sepetListesi;
    } catch (e) {
      print("Sepet Listeleme Hatası: $e");
      return [];
    }
  }

  // Ürün arama metodu
  Future<List<Product>> urunAra(String aramaKelimesi) async {
    try {
      List<Product> urunler = await urunleriYukle();
      List<Product> aramaSonucu = urunler
          .where((urun) =>
              urun.ad.toLowerCase().contains(aramaKelimesi.toLowerCase()))
          .toList();
      return aramaSonucu;
    } catch (e) {
      print("Ürün Arama Hatası: $e");
      return [];
    }
  }

  // Sepete ürün ekleme metodu
  Future<void> urunEkle(String ad, String resim, String kategori, int fiyat,
      String marka, int siparisAdeti, String kullaniciAdi) async {
    var url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php";
    var veri = {
      "ad": ad,
      "resim": resim,
      "kategori": kategori,
      "fiyat": fiyat,
      "marka": marka,
      "siparisAdeti": siparisAdeti,
      "kullaniciAdi": kullaniciAdi
    };
    try {
      var cevap = await Dio().post(url, data: FormData.fromMap(veri));
      print("Ürün Ekleme Başarılı: ${cevap.data.toString()}");
    } catch (e) {
      print("Ürün Ekleme Hatası: $e");
    }
  }

  // Sepetten ürün silme metodu
  Future<void> sepetUrunSil(String kullaniciAdi, int sepetId) async {
    var url = "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php";
    var veri = {"kullaniciAdi": kullaniciAdi, "sepetId": sepetId};
    try {
      var cevap = await Dio().post(url, data: FormData.fromMap(veri));
      print("Sepet Ürün Silme Başarılı: ${cevap.data.toString()}");
    } catch (e) {
      print("Sepet Ürün Silme Hatası: $e");
    }
  }

  // Kategorileri yükleme metodu
  Future<List<Kategori>> kategoriler() async {
    var kategoriler = <Kategori>[];

    var teknoloji = Kategori(name: "Teknoloji", imagePath: "images/laptop.png");
    var kozmetik = Kategori(name: "Kozmetik", imagePath: "images/ruj.png");
    var aksesuar = Kategori(name: "Aksesuar", imagePath: "images/kulaklik.png");

    kategoriler.add(teknoloji);
    kategoriler.add(aksesuar);
    kategoriler.add(kozmetik);

    return kategoriler;
  }

  // Kategoriye göre ürün yükleme metodu
  Future<List<Product>> urunleriKategoriyeGoreYukle(String kategori) async {
    var url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php";
    var cevap = await Dio().get(url);
    var tumUrunler = parseProductCevap(cevap.data.toString());

    // Kategoriye göre filtreleme işlemi
    return tumUrunler.where((urun) => urun.kategori == kategori).toList();
  }
}