import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/data/entity/sepet.dart';
import 'package:flutter_ecommerce_app/data/repo/product_repo.dart';

class SepetCubit extends Cubit<List<CartProduct>> {
  SepetCubit() : super([]);

  var productRepo = ProductRepo();

  Future<void> sepetListele(String kullaniciAdi) async {
    try {
      var liste = await productRepo.sepetListele(kullaniciAdi);
      print(liste);
      emit(liste);
    } catch (error) {
      print('Error fetching cart list: $error');
      emit([]);
    }
  }

  Future<void> urunSil(String kullaniciAdi, int sepetId) async {
    try {
      await productRepo.sepetUrunSil(kullaniciAdi, sepetId);
      await sepetListele(kullaniciAdi);
    } catch (error) {
      // Handle error (show error message, etc.)
      print('Error removing product from cart: $error');
    }
  }
}
