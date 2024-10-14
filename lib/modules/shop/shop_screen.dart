import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'item_detail_screen.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('items').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No items available in the shop.'));
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return ListTile(
              leading: Image.network(data['image_url'], width: 50, height: 50),
              title: Text(data['name']),
              subtitle: Text('Price: ${data['price']}'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ItemDetailsScreen(itemData: data)),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}