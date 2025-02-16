import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneakers/database/firestore.dart'; // Import FirestoreService
import 'package:permission_handler/permission_handler.dart'; // Add permission_handler

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<Map<String, dynamic>> cartItems = [];
  double totalPrice = 0.0;
  String userEmail = "user@example.com";
  String userAddress = "123 Street, City, Country";
  String transactionDateTime =
      DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
  bool _isLoading = false;

  // FirestoreService instance
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    loadCart();
    fetchProfileData(); // Fetch user profile data
  }

  // Load cart data
  Future<void> loadCart() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> savedCart = prefs.getStringList('cart') ?? [];
      setState(() {
        cartItems = savedCart
            .map((item) => Map<String, dynamic>.from(jsonDecode(item)))
            .toList();
        totalPrice = cartItems.fold(0, (sum, item) => sum + item['price']);
      });
    } catch (e) {
      print("Error loading cart: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fetch user profile data
  Future<void> fetchProfileData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('userEmail');
      String? address = prefs.getString('userAddress');

      if (email != null && address != null) {
        setState(() {
          userEmail = email;
          userAddress = address;
        });
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    }
  }

  // Generate and download PDF receipt
  Future<void> generateAndDownloadPDF() async {
    // Request storage permissions
    PermissionStatus status = await Permission.storage.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission denied.")),
      );
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Receipt", style: const pw.TextStyle(fontSize: 24)),
            pw.Divider(),
            pw.Text("Email: $userEmail"),
            pw.Text("Address: $userAddress"),
            pw.Text("Date & Time: $transactionDateTime"),
            pw.Divider(),
            pw.Column(
              children: cartItems.map((item) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("${item['quantity']}x ${item['name']}"),
                    pw.Text("Rs ${item['price'].toStringAsFixed(2)}"),
                  ],
                );
              }).toList(),
            ),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("TOTAL AMOUNT:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("Rs ${totalPrice.toStringAsFixed(2)}"),
              ],
            ),
          ],
        ),
      ),
    );

    try {
      Directory? outputDirectory;

      // For Android 10 and above (Scoped Storage), use app-specific directory
      if (Platform.isAndroid) {
        outputDirectory = await getExternalStorageDirectory();
      } else {
        outputDirectory = await getApplicationDocumentsDirectory();
      }

      if (outputDirectory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Unable to get directory to save the PDF.")),
        );
        return;
      }

      print("PDF will be saved at: ${outputDirectory.path}");

      final file = File("${outputDirectory.path}/receipt.pdf");
      await file.writeAsBytes(await pdf.save());

      // Check if the file exists
      if (await file.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Receipt downloaded successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error saving receipt.")),
        );
      }
    } catch (e) {
      print("Error saving PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error downloading receipt.")),
      );
    }
  }

  // Save order to Firestore and confirm payment
  Future<void> confirmPayment() async {
    // Save order to Firestore
    Map<String, dynamic> orderData = {
      'email': userEmail,
      'address': userAddress,
      'cartItems': cartItems,
      'totalPrice': totalPrice,
      'transactionDateTime': transactionDateTime,
    };
    await firestoreService.saveOrderToDatabase(orderData);

    // Clear the cart from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(
        'cart'); // This will remove the cart items from SharedPreferences

    // Show confirmation and generate PDF receipt
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Successful!")),
    );
    await generateAndDownloadPDF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Details'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(
                  child: Text(
                    'No items to display.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.grey.shade300, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  'RECEIPT',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              const Divider(thickness: 1, color: Colors.black),
                              Text('Email: $userEmail',
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('Address: $userAddress',
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('Date & Time: $transactionDateTime',
                                  style: const TextStyle(fontSize: 16)),
                              const Divider(thickness: 1, color: Colors.black),
                              ...cartItems.map(
                                (item) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          '${item['quantity']}x ${item['name'] ?? 'Unnamed Product'}'),
                                      Text(
                                          'Rs ${item['price'].toStringAsFixed(2)}'),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(thickness: 1, color: Colors.black),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'TOTAL AMOUNT:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Rs ${totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await confirmPayment();
                        },
                        child: const Text('CONFIRM PAYMENT'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
