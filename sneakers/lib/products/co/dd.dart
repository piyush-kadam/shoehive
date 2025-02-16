import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DDPage extends StatefulWidget {
  const DDPage({super.key});

  @override
  _DDPageState createState() => _DDPageState();
}

class _DDPageState extends State<DDPage> {
  String selectedColor = 'Default';
  int selectedSize = 0;
  final List<int> availableSizes = [6, 7, 8, 9, 10, 11];

  Future<void> addToCart(Map<String, dynamic> item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedCart = prefs.getStringList('cart') ?? [];
    savedCart.add(jsonEncode(item));
    await prefs.setStringList('cart', savedCart);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Row(
          children: [
            const Icon(
              Icons.shopping_cart,
              color: Colors.black,
              size: 30,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Added Converse DD\nSize: $selectedSize, Color: $selectedColor to cart!',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.blueAccent,
          onPressed: () async {
            savedCart.removeLast(); // Remove the last added item
            await prefs.setStringList('cart', savedCart); // Update cart
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Item removed from the cart.'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dungeons X Dragons', style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Images
              SizedBox(
                height: 220,
                child: PageView(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/converse/dd 1.jpg',
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/converse/dd 2.jpg',
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/converse/dd 3.jpg',
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Product Title and Price
              Text(
                'Converse DXD',
                style: GoogleFonts.poppins(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Rs 3200',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Product Info
              Text(
                'The Converse DXD combines style and comfort with a sleek design.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),
              // Select Color
              Text(
                'Color: $selectedColor',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = 'Default';
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor == 'Default'
                              ? Colors.black
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Select Size
              Text(
                'Select Size:',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: availableSizes.map((size) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSize = size;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              selectedSize == size ? Colors.black : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color:
                            selectedSize == size ? Colors.black : Colors.white,
                      ),
                      child: Text(
                        size.toString(),
                        style: GoogleFonts.poppins(
                          color: selectedSize == size
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Add to Cart Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedSize == 0
                      ? null
                      : () {
                          addToCart({
                            'name': 'Converse DXD',
                            'size': selectedSize,
                            'color': selectedColor,
                            'price': 3200,
                            'image': 'assets/images/converse/dd 1.jpg',
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add to Cart',
                    style:
                        GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
