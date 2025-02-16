import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sneakers/database/firestore.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    String userEmail = FirebaseAuth.instance.currentUser!.email!;
    List<Map<String, dynamic>> fetchedOrders =
        await _firestoreService.fetchOrdersByEmail(userEmail);
    setState(() {
      orders = fetchedOrders;
      isLoading = false; // Stop loading once data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader
          : orders.isEmpty
              ? const Center(
                  child: Text('No orders found.')) // Show no orders text
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text('Order ID: ${order['orderId']}'),
                            subtitle: Text(
                              'Transaction Date: ${order['transactionDateTime']}',
                            ),
                            trailing: Text('Total: Rs${order['totalPrice']}'),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Items:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                for (var item in order['cartItems'])
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      '${item['name']} (Color: ${item['color']}, Size: ${item['size']}) - Rs${item['price']}',
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
