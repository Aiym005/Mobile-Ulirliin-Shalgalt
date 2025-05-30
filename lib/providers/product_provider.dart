import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cart = [];
  List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get cart => _cart;
  List<Map<String, dynamic>> get favorites => _favorites;
List<Product> _products = [];

  List<Product> get products => _products;

  void setProducts(List<Map<String, dynamic>> productList) {
    _products = productList.map((json) => Product.fromJson(json)).toList();
    notifyListeners();
  }
  Future<void> loadProducts() async {
    final productsData = await ApiService.fetchProducts();
    setProducts(productsData);
  }

  void startListeners() {
    FirestoreService.getCart().listen((data) {
      _cart = data;
      notifyListeners();
    });

    FirestoreService.getFavorites().listen((data) {
      _favorites = data;
      notifyListeners();
    });
  }

  Future<void> toggleCart(Map<String, dynamic> product) async {
    final id = product['id'].toString();
    if (_cart.any((p) => p['id'].toString() == id)) {
      await FirestoreService.removeFromCart(id);
    } else {
      await FirestoreService.addToCart(product);
    }
  }

  Future<void> toggleFavorite(Map<String, dynamic> product) async {
    final id = product['id'].toString();
    if (_favorites.any((p) => p['id'].toString() == id)) {
      await FirestoreService.removeFromFavorites(id);
    } else {
      await FirestoreService.addToFavorites(product);
    }
  }
  void addToCart(Product product) {
  _cart.add(product.toJson());
  notifyListeners();
}

void removeFromCart(Product product) {
  final index = _cart.indexWhere((json) => Product.fromJson(json).id == product.id);
  if (index != -1) {
    _cart.removeAt(index);
    notifyListeners();
  }
}

}
