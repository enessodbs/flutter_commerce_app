import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/const/constant.dart';
import 'package:flutter_ecommerce_app/data/entity/sepet.dart';
import 'package:flutter_ecommerce_app/ui/cubit/sepet_cubit.dart';

class Sepet extends StatefulWidget {
  const Sepet({super.key});

  @override
  State<Sepet> createState() => _SepetState();
}

class _SepetState extends State<Sepet> {
  @override
  void initState() {
    super.initState();
    // Sepeti listele
    context.read<SepetCubit>().sepetListele("enessodbs");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Sepet", style: baslikStyle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildCardProduct(),
          const SizedBox(
            height: 200,
          )
        ],
      ),
      bottomSheet: _buildBottomSheet(),
    );
  }

  BlocBuilder<SepetCubit, List<CartProduct>> _buildBottomSheet() {
    return BlocBuilder<SepetCubit, List<CartProduct>>(
      builder: (context, cartProducts) {
        int toplam = context.read<SepetCubit>().toplamHesapla(cartProducts);

        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Toplam",
                        style: TextStyle(
                            fontSize: 20,
                            color: textColor,
                            fontFamily: "Bebas"),
                      ),
                      Text(
                        "$toplam ₺",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        backgroundColor: Colors.black, // Buton rengi
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Sepet Onay"),
                            content: const Text("Sepeti Onaylıyor musunuz??"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Hayır"),
                              ),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<SepetCubit>()
                                      .sepetiBosalt("enessodbs");
                                  Navigator.pop(context);
                                },
                                child: const Text("Evet"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        "Sepeti Onayla",
                        style: TextStyle(
                          color: Colors.white, // Yazı rengi
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  BlocBuilder<SepetCubit, List<CartProduct>> _buildCardProduct() {
    return BlocBuilder<SepetCubit, List<CartProduct>>(
      builder: (context, cartProducts) {
        // Sepetteki toplamı cubit üzerinden hesapla
        int toplam = context.read<SepetCubit>().toplamHesapla(cartProducts);

        return cartProducts.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Sepetinizde Ürün Bulunmamaktadır!"),
                  ],
                ),
              )
            : Expanded(
                // Ensures ListView takes available space
                child: ListView.builder(
                  itemCount: cartProducts.length,
                  itemBuilder: (context, index) {
                    var cartProduct = cartProducts[index];
                    var product = cartProduct.product;
                    return Card(
                      color: backgroundColor,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      elevation: 2, // Daha şık bir gölge
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Ürün resmini göster
                            Image.network(
                              "http://kasimadalan.pe.hu/urunler/resimler/${product.resim}",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Ürün adı
                                Text(
                                  product.ad,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                // Sipariş adedi
                                Text("Adet: ${cartProduct.siparisAdeti}"),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Ürünü silme butonu
                                IconButton(
                                  onPressed: () {
                                    // Silmeden önce kullanıcı onayı
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Ürün Sil"),
                                        content: const Text(
                                            "Bu ürünü sepetinizden silmek istediğinizden emin misiniz?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Hayır"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context
                                                  .read<SepetCubit>()
                                                  .urunSil("enessodbs",
                                                      cartProduct.sepetId);
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Evet"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                                // Ürün fiyatı
                                Text(
                                  "Fiyat: ${cartProduct.product.fiyat * cartProduct.siparisAdeti} ₺",
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
      },
    );
  }
}
