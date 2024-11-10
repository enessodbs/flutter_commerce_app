import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/data/entity/category.dart';
import 'package:flutter_ecommerce_app/data/entity/product.dart';
import 'package:flutter_ecommerce_app/ui/cubit/anasayfa_cubit.dart';
import 'package:flutter_ecommerce_app/ui/cubit/kategori_cubit.dart';
import 'package:flutter_ecommerce_app/ui/views/detay.dart';
import 'package:flutter_ecommerce_app/ui/views/kategori.dart';
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
        title: const Text("Tecno App",style: TextStyle(fontFamily: "Playfair",fontSize: 30,fontWeight: FontWeight.bold),),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kategoriler arasındaki boşluğu küçülttük
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height *
                      0.04, // Boşluğu daralttık
                  child: GridView.builder(
                    itemCount: kategoriler.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.5 / 0.4,
                    ),
                    itemBuilder: (context, index) {
                      var kategori = kategoriler[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        margin: const EdgeInsets.all(1.0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    KategoriUrunleri(kategori: kategori),
                              ),
                            );
                            print(kategori.name);
                          },
                          child: Text(
                            kategori.name,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
