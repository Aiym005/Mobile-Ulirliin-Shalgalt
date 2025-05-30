import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final favoriteProducts = provider.favorites
        .map((json) => Product.fromJson(json))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: favoriteProducts.isEmpty
          ? Center(child: Text('No favorites yet'))
          : ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (ctx, i) =>
                  ProductCard(product: favoriteProducts[i]),
            ),
    );
  }
}
