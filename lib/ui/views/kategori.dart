// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/data/entity/category.dart';
import 'package:flutter_ecommerce_app/data/entity/product.dart';
import 'package:flutter_ecommerce_app/ui/cubit/kurun_cubit.dart';

class KategoriUrunleri extends StatefulWidget {
  final Kategori kategori;

  KategoriUrunleri({
    Key? key,
    required this.kategori,
  }) : super(key: key);

  @override
  State<KategoriUrunleri> createState() => _KategoriUrunleriState();
}

class _KategoriUrunleriState extends State<KategoriUrunleri> {
  @override
  void initState() {
    super.initState();
    // Kategoriye göre ürünleri yükle
    context.read<KategoriUrunCubit>().urunleriYukle(widget.kategori.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kategori.name),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildProductsGrid(), // Grid burada yer alıyor
      ),
    );
  }

  // Ürünleri Grid formatında gösterme
  Widget _buildProductsGrid() {
    return BlocBuilder<KategoriUrunCubit, List<Product>>(
      builder: (context, productList) {
        if (productList.isNotEmpty) {
          return GridView.builder(
            physics:
                const NeverScrollableScrollPhysics(), // GridView'in kaydırılmasını devre dışı bırakıyoruz
            shrinkWrap:
                true, // GridView'in gereksiz yere yer kaplamasını önlüyoruz
            itemCount: productList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Griddeki sütun sayısı
            ),
            itemBuilder: (context, index) {
              var product = productList[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        "http://kasimadalan.pe.hu/urunler/resimler/${product.resim}",
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.ad,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("₺${product.fiyat}"),
                  ],
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(), // Yükleme göstergesi
          );
        }
      },
    );
  }
}
