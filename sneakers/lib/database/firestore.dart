import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Get collection reference
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  // Save order to the database
  Future<void> saveOrderToDatabase(Map<String, dynamic> orderData) async {
    try {
      await orders.add(orderData);
      print("Order saved successfully!");
    } catch (e) {
      print("Error saving order: $e");
    }
  }

  // Fetch orders by user email
  Future<List<Map<String, dynamic>>> fetchOrdersByEmail(String email) async {
    try {
      // Query the orders collection where 'email' matches the given email
      QuerySnapshot orderSnapshot =
          await orders.where('email', isEqualTo: email).get();

      // Prepare the list of orders, including the document ID as 'orderId'
      List<Map<String, dynamic>> ordersList = orderSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['orderId'] = doc.id; // Add document ID as 'orderId'
        return data;
      }).toList();

      return ordersList;
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }
}
