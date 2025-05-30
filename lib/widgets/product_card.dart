import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    final isInCart = provider.cart.any((p) => p['id'] == product.id);
    final isFavorite = provider.favorites.any((p) => p['id'] == product.id);

    return Card(
      child: ListTile(
        leading: Image.network(product.image, width: 50),
        title: Text(product.title),
        subtitle: Text('\$${product.price}'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
              onPressed: () => provider.toggleFavorite(product.toJson()),
            ),
            IconButton(
              icon: Icon(isInCart ? Icons.shopping_cart : Icons.add_shopping_cart),
              onPressed: () => provider.toggleCart(product.toJson()),
            ),
          ],
        ),
      ),
    );
  }
}
