import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purffectcare/shared/cubit/cubit.dart';
import '../../shared/cubit/state.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {},
        builder: (BuildContext context, AppState state) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('cart').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> cartSnapshot) {
              if (cartSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!cartSnapshot.hasData || cartSnapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Your cart is empty.'));
              }

              final cartItems = cartSnapshot.data!.docs;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        var cartItem = cartItems[index].data() as Map<String, dynamic>;
                        String itemId = cartItem['item_id'];
                        int quantity = cartItem['quantity'];

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('items').doc(itemId).get(),
                          builder: (context, itemSnapshot) {
                            if (itemSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (!itemSnapshot.hasData || !itemSnapshot.data!.exists) {
                              return const Center(child: Text('Error fetching item details.'));
                            }

                            var itemData = itemSnapshot.data!.data() as Map<String, dynamic>;

                            return CartItemCard(
                              cartItemId: cartSnapshot.data!.docs[index].id,
                              productName: itemData['name'],
                              productPrice: itemData['price'],
                              quantity: quantity,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  if (cartItems.isNotEmpty)
                    FutureBuilder<double>(
                      future: _calculateTotal(cartItems),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final totalAmount = snapshot.data ?? 0.0;

                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Amount',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$${totalAmount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _placeOrder(context, cartItems, AppCubit.get(context).userModel.phone);
                                },
                                child: const Text(
                                  'Place Order - Cash on Delivery',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<double> _calculateTotal(List<QueryDocumentSnapshot> cartItems) async {
    double total = 0.0;

    for (var cartItem in cartItems) {
      var cartData = cartItem.data() as Map<String, dynamic>;
      String itemId = cartData['item_id'];
      int quantity = cartData['quantity'];

      var itemSnapshot = await FirebaseFirestore.instance.collection('items').doc(itemId).get();
      if (itemSnapshot.exists) {
        var itemData = itemSnapshot.data() as Map<String, dynamic>;
        total += (itemData['price'] as num) * quantity;
      }
    }

    return total;
  }

  void _placeOrder(BuildContext context, List<QueryDocumentSnapshot> cartItems, String? phoneNumber) {
    for (var cartItem in cartItems) {
      var cartData = cartItem.data() as Map<String, dynamic>;
      String itemId = cartData['item_id'];
      int quantity = cartData['quantity'];

      FirebaseFirestore.instance.collection('items').doc(itemId).get().then((itemSnapshot) {
        if (itemSnapshot.exists) {
          var itemData = itemSnapshot.data() as Map<String, dynamic>;

          FirebaseFirestore.instance.collection('orders').add({
            'name': itemData['name'],
            'price': itemData['price'],
            'quantity': quantity,
            'phoneNumber': phoneNumber,
            'status': 'current',
            'timestamp': FieldValue.serverTimestamp(),
          });

          FirebaseFirestore.instance.collection('cart').doc(cartItem.id).delete();
        }
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Your order has been placed successfully.')),
    );

    Navigator.pop(context);
  }
}
class CartItemCard extends StatelessWidget {
  final String cartItemId;
  final String productName;
  final int productPrice;
  final int quantity;

  const CartItemCard({
    Key? key,
    required this.cartItemId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(productName),
        subtitle: Text('Price: \$${productPrice.toStringAsFixed(2)}'),
        trailing: SizedBox(
          width: 130,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (quantity > 1) {
                    FirebaseFirestore.instance
                        .collection('cart')
                        .doc(cartItemId)
                        .update({'quantity': quantity - 1});
                  }
                },
              ),
              Text(quantity.toString()),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('cart')
                      .doc(cartItemId)
                      .update({'quantity': quantity + 1});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
