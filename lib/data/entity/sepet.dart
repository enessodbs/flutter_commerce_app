import 'package:flutter_ecommerce_app/data/entity/product.dart';

class CartProduct {
  final Product product;
  final int siparisAdeti;
  final String kullaniciAdi;
  final int sepetId;

  CartProduct({
    required this.product,
    required this.siparisAdeti,
    required this.kullaniciAdi,
    required this.sepetId,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      product: Product(
        id: json['id'] ?? 0,
        ad: json['ad'] ?? '',
        resim: json['resim'] ?? '',
        kategori: json['kategori'] ?? '',
        fiyat: json['fiyat'] ?? 0,
        marka: json['marka'] ?? '',
      ),
      siparisAdeti: json['siparisAdeti'] ?? 1,
      kullaniciAdi: json['kullaniciAdi'] ?? '',
      sepetId: json['sepetId'] ?? 0,
    );
  }
}
