import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';
import '../models/comment_model.dart';
import 'dart:async'; 

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({required this.product, super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  List<Comment> _comments = [];
  StreamSubscription? _commentSubscription;
  StreamSubscription<User?>? _userSubscription; 
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();

    _userSubscription = FirebaseAuth.instance.userChanges().listen((user) {
      if (!mounted) return; 

      if (user != null) {
        setState(() => _loggedIn = true);

        _commentSubscription?.cancel();

        _commentSubscription = FirebaseFirestore.instance
            .collection('guestbook')
            .where('productId', isEqualTo: widget.product.id.toString())
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          if (!mounted) return;
          final loadedComments = snapshot.docs.map((doc) {
            final data = doc.data();
            return Comment.fromJson(data);
          }).toList();

          setState(() {
            _comments = loadedComments;
          });
        });
      } else {
        _commentSubscription?.cancel();

        setState(() {
          _loggedIn = false;
          _comments = [];
        });
      }
    });
  }

  void _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || user == null) return;

    final comment = Comment(
      name: user!.displayName ?? 'Anonymous',
      text: text,
      userId: user!.uid,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      productId: widget.product.id.toString(),
    );

    await FirestoreService.addComment(comment);
    _commentController.clear();
  }

  @override
  void dispose() {
    _commentSubscription?.cancel();
    _userSubscription?.cancel(); 
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(product.image, fit: BoxFit.contain),
            ),
            const SizedBox(height: 10),
            Text(product.title, style: const TextStyle(fontSize: 24)),
            Text('\$${product.price}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),

            if (_loggedIn)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _addComment,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            const Divider(),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Сэтгэгдлүүд', style: TextStyle(fontSize: 18)),
            ),

            if (_comments.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No comments yet.'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final c = _comments[index];
                  return ListTile(
                    title: Text(c.name),
                    subtitle: Text(c.text),
                    trailing: Text(
                      DateTime.fromMillisecondsSinceEpoch(c.timestamp)
                          .toLocal()
                          .toString()
                          .substring(0, 16),
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
