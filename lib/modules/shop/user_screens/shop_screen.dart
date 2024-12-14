import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../item_detail_screen.dart';

class UserShopScreen extends StatelessWidget {
  const UserShopScreen({super.key});

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
            var item_id = doc.id;
            var data = doc.data() as Map<String, dynamic>;
            return ListTile(
              leading: Image.network(data['image_url'], width: 50, height: 50),
              title: Text(data['name']),
              subtitle: Text('Price: ${data['price']}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetailsScreen(
                      itemData: {
                        'item_id': item_id, // Ensure this key exists
                        'name': data['name'],
                        'description': data['description'],
                        'price':data['price'],
                        'image_url': data['image_url'],
                      },
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}