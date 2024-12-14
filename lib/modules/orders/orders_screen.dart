import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrdersScreen extends StatefulWidget {
  @override
  _AdminOrdersScreenState createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Stream<QuerySnapshot> fetchOrders(String status) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: status)
        .snapshots();
  }

  void _showEditOrderDialog(BuildContext context, QueryDocumentSnapshot order) {
    String status = order['status'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Order Status"),
          content: DropdownButton<String>(
            value: status,
            items: ['pending', 'completed', 'cancelled']
                .map((status) => DropdownMenuItem(
              value: status,
              child: Text(status),
            ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  status = value;
                });
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('orders')
                    .doc(order.id)
                    .update({'status': status});
                Navigator.pop(context);
              },
              child: Text("Update",style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrdersList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: fetchOrders(status),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var orders = snapshot.data!.docs;
          if (orders.isEmpty) {
            return Center(child: Text("No $status orders."));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(order['name']),
                  subtitle: Text("Phone: ${order['phoneNumber']}\nQuantity: ${order['quantity']}\nPrice: \$${order['price']}"),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showEditOrderDialog(context, order),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading orders."));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:TabBar(
          dividerColor: Colors.white,
          controller: _tabController,
          tabs: [
            Tab(text: "Current Orders"),
            Tab(text: "Past Orders"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList('pending'), // Current Orders (Pending)
          _buildOrdersList('completed'), // Past Orders (Completed/Cancelled)
        ],
      ),
    );
  }
}
