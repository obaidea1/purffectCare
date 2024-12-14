import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purffectcare/shared/component/constant.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> itemData;

  const ItemDetailsScreen({Key? key, required this.itemData}) : super(key: key);

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
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
            Row(
              children: [
                Text('Quantity:'),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                ),
                Text('$quantity'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print(widget.itemData['item_id']);
                addToCart(widget.itemData['item_id'], quantity);
              },
              child: const Text('Add to Cart',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  void addToCart(String? itemId, int quantity) async {
    if (itemId == null || itemId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item ID is missing!')),
      );
      return;
    }

    var userId = uId;
    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID is missing!')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('cart').add({
      'user_id': userId,
      'item_id': itemId,
      'quantity': quantity,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item added to cart!')),
    );
  }
}