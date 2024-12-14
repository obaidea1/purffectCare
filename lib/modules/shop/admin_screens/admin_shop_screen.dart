import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purffectcare/modules/shop/admin_screens/add_item_Screen.dart';

import '../item_detail_screen.dart';
import 'item_details_admin.dart';

class AdminShopScreen extends StatelessWidget {
  const AdminShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddItemScreen()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No items available in the shop.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;

              // Get the fields with null checks to avoid errors
              String imageUrl = data['image_url'] ?? '';  // Use an empty string if null
              String name = data['name'] ?? 'Unnamed Item';  // Default name if null
              String price = data['price']?.toString() ?? '0';  // Default price if null

              return ListTile(
                leading: imageUrl.isNotEmpty
                    ? Image.network(imageUrl, width: 50, height: 50)
                    : const Icon(Icons.image, size: 50), // Show default icon if no image
                title: Text(name),
                subtitle: Text('Price: $price'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AdminItemDetailsScreen(itemData: data)),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
