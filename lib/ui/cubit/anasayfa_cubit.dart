import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/data/entity/product.dart';
import 'package:flutter_ecommerce_app/data/repo/product_repo.dart';

class AnasayfaCubit extends Cubit<List<Product>> {
  AnasayfaCubit() : super(<Product>[]);

  var productRepo = ProductRepo();

  Future<void> urunleriYukle() async {
    var liste = await productRepo.urunleriYukle();
    emit(liste);
  }

  List<Product> getProductsByCategory(String category) {
    return state.where((product) => product.kategori == category).toList();
  }

  Future<void> ara(String aramaKelimesi) async {
    var liste = await productRepo.urunAra(aramaKelimesi);
    emit(liste);
  }


}