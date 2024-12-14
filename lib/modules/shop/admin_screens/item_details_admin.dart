import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purffectcare/shared/component/constant.dart';

class AdminItemDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> itemData;

  const AdminItemDetailsScreen({Key? key, required this.itemData}) : super(key: key);

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<AdminItemDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.itemData['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.itemData['image_url']),
            SizedBox(height: 20),
            Text(widget.itemData['description']),
            SizedBox(height: 10),
            Text('Price: ${widget.itemData['price']}'),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void addToCart(String itemId, int quantity) async {
    var userId = uId;
    FirebaseFirestore.instance.collection('cart').add({
      'user_id': userId,
      'item_id': itemId,
      'quantity': quantity,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item added to cart!')),
    );
  }
}