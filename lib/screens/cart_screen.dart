import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    final Map<String, Map<String, dynamic>> groupedCart = {};
    for (var json in provider.cart) {
      final product = Product.fromJson(json);
      final productId = product.id.toString();

      if (groupedCart.containsKey(productId)) {
        groupedCart[productId]!['quantity'] += 1;
      } else {
        groupedCart[productId] = {
          'product': product,
          'quantity': 1,
        };
      }
    }

    final cartItems = groupedCart.values.toList();

    double totalPrice = cartItems.fold(
      0.0,
      (sum, item) => sum + item['product'].price * item['quantity'],
    );

    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: cartItems.isEmpty
          ? Center(child: Text('🛒 Cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, i) {
                      final product = cartItems[i]['product'] as Product;
                      final quantity = cartItems[i]['quantity'] as int;

                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: Image.network(product.image,
                              width: 50, height: 50, fit: BoxFit.cover),
                          title: Text(product.title,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          subtitle: Text(
                              '₮${product.price} x $quantity = ₮${(product.price * quantity).toStringAsFixed(2)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  provider.removeFromCart(product);
                                },
                              ),
                              Text('$quantity'),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  provider.addToCart(product);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total: ₮${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
    );
  }
}
