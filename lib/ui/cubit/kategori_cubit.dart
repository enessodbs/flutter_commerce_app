import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/data/entity/category.dart';
import 'package:flutter_ecommerce_app/data/repo/product_repo.dart';

class KategoriCubit extends Cubit<List<Kategori>> {
  KategoriCubit() : super([]);

  final ProductRepo kRepo = ProductRepo();

  Future<void> kategoriler() async {
    try {
      var liste = await kRepo.kategoriler();
      emit(liste);
    } catch (e) {
      print("Kategori yüklenirken hata oluştu: $e");
      emit([]);
    }
  }
}
