import 'package:flutter_ecommerce_app/data/entity/product.dart';

class ProductCevap {
  List<Product> product;
  int success;
  ProductCevap({
    required this.product,
    required this.success,
  });

  factory ProductCevap.fromJson(Map<String, dynamic> json) {
    var jsonArray = json["urunler"] as List? ?? [];
    int success = json["success"] as int;
    var product = jsonArray
        .map((jsonUrunNesnesi) => Product.fromJson(jsonUrunNesnesi))
        .toList();
    return ProductCevap(product: product, success: success);
  }
}
