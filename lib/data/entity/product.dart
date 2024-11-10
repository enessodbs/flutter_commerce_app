class Product {
  int id;
  String ad;
  String resim;
  String kategori;
  int fiyat;
  String marka;

  Product({
    required this.id,
    required this.ad,
    required this.resim,
    required this.kategori,
    required this.fiyat,
    required this.marka,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      ad: json['ad'] as String,
      resim: json['resim'] as String,
      kategori: json['kategori'] as String,
      fiyat: json['fiyat'] as int,
      marka: json['marka'] as String,
    );
  }
}
