import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/data/repo/product_repo.dart';

class DetaySayfaCubit extends Cubit<void> {
  DetaySayfaCubit() : super(0);

  var productRepo = ProductRepo();

  Future<void> urunEkle(String ad, String resim, String kategori, int fiyat,
      String marka, int siparisAdeti, String kullaniciAdi) async {
    await productRepo.urunEkle(
        ad, resim, kategori, fiyat, marka, siparisAdeti, kullaniciAdi);
    print("$ad adlı ürün, $siparisAdeti adet sepete eklendi. $kullaniciAdi");
  }
}
