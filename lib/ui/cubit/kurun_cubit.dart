import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/data/entity/product.dart';
import 'package:flutter_ecommerce_app/data/repo/product_repo.dart';

class KategoriUrunCubit extends Cubit<List<Product>> {
  KategoriUrunCubit() : super([]);

  var productRepo = ProductRepo();

  Future<void> urunleriYukle(String kategori) async {
    var liste = await productRepo.urunleriKategoriyeGoreYukle(kategori);
    emit(liste);
  }
}
