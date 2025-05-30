import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/comment_model.dart';

class FirestoreService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  static String get _uid => _auth.currentUser!.uid;

  static Future<void> addToCart(Map<String, dynamic> product) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('cart')
        .doc(product['id'].toString())
        .set(product);
  }

  static Future<void> addComment(Comment comment) async {
  await FirebaseFirestore.instance.collection('guestbook').add({
    'name': comment.name,
    'text': comment.text,
    'userId': comment.userId,
    'timestamp': comment.timestamp,
    'productId': comment.productId,
  });

}

  static Stream<List<Comment>> getComments(String productId) {
    return _firestore
        .collection('guestbook')
        .where('productId', isEqualTo: productId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Comment.fromJson(doc.data())).toList());
  }

  static Future<void> removeFromCart(String productId) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('cart')
        .doc(productId)
        .delete();
  }

  static Future<void> addToFavorites(Map<String, dynamic> product) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('favorites')
        .doc(product['id'].toString())
        .set(product);
  }

  static Future<void> removeFromFavorites(String productId) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('favorites')
        .doc(productId)
        .delete();
  }

  static Stream<List<Map<String, dynamic>>> getCart() {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('cart')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  static Stream<List<Map<String, dynamic>>> getFavorites() {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
