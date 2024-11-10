import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    context.read<SepetCubit>().sepetListele("enessodbs");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sepet"),
        centerTitle: true,
      ),
      body: BlocBuilder<SepetCubit, List<CartProduct>>(
        builder: (context, cartProducts) {
          if (cartProducts.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: cartProducts.length,
            itemBuilder: (context, index) {
              var cartProduct = cartProducts[index];
              var product = cartProduct.product;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.network(
                        "http://kasimadalan.pe.hu/urunler/resimler/${product.resim}",
                        width: 80, // Adjust size as necessary
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.ad,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text("Adet: ${cartProduct.siparisAdeti}"),
                        ],
                      ),
                      const Spacer(), // This pushes the following Column to the far right
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              context
                                  .read<SepetCubit>()
                                  .urunSil("enessodbs", cartProduct.sepetId);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                          Text(
                            "Fiyat: ${product.fiyat} ₺",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
