import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/const/constant.dart';
import 'package:flutter_ecommerce_app/data/entity/category.dart';
import 'package:flutter_ecommerce_app/data/entity/product.dart';
import 'package:flutter_ecommerce_app/ui/cubit/anasayfa_cubit.dart';
import 'package:flutter_ecommerce_app/ui/cubit/kategori_cubit.dart';
import 'package:flutter_ecommerce_app/ui/views/detay.dart';
import 'package:flutter_ecommerce_app/ui/views/sepet.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  @override
  void initState() {
    super.initState();
    context.read<AnasayfaCubit>().urunleriYukle();
    context.read<KategoriCubit>().kategoriler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Techno App",
          style: baslikStyle
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Sepet(),
                      ));
                },
                icon: const Icon(Icons.shopping_bag_outlined)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Bar
              _buildSearchBar(context),

              // Category List
              _buildCategory(),

              // List of products (Grid of Cards)
              _buildProductsGrid(),
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder<KategoriCubit, List<Kategori>> _buildCategory() {
    return BlocBuilder<KategoriCubit, List<Kategori>>(
      builder: (context, kategoriler) {
        if (kategoriler.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: kategoriler.map((kategori) {
                    return Container(
                      width: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: TextButton(
                        onPressed: () {
                          context
                              .read<AnasayfaCubit>()
                              .urunleriYukle(kategori: kategori.name);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Center(
                          child: Text(
                            kategori.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "Literata",
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text("Kategoriler yüklenemedi veya boş."),
          );
        }
      },
    );
  }

  Widget _buildProductsGrid() {
    return BlocBuilder<AnasayfaCubit, List<Product>>(
      builder: (context, productList) {
        if (productList.isNotEmpty) {
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: productList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              var product = productList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetaySayfa(
                          product: product,
                        ),
                      ));
                },
                child: Card(
                  color: Colors.white,
                  elevation: 10,
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
                          height: 120,
                          width: 120,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.ad,
                        style: const TextStyle(fontWeight: FontWeight.bold,),
                      ),
                      Text("₺${product.fiyat}"),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Padding _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CupertinoSearchTextField(
        placeholder: "Ara",
        onChanged: (searchText) {
          context.read<AnasayfaCubit>().ara(searchText);
        },
      ),
    );
  }
}
