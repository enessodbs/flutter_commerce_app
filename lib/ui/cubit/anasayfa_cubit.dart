import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/data/entity/product.dart';
import 'package:flutter_ecommerce_app/data/repo/product_repo.dart';

class AnasayfaCubit extends Cubit<List<Product>> {
  AnasayfaCubit() : super(<Product>[]);

  var productRepo = ProductRepo();

  Future<void> urunleriYukle({String kategori = "Tüm Ürünler"}) async {
    var liste = await productRepo.urunleriYukle(kategori: kategori);
    emit(liste);
  }

  Future<void> ara(String aramaKelimesi) async {
    var liste = await productRepo.urunAra(aramaKelimesi);
    emit(liste);
  }
}
