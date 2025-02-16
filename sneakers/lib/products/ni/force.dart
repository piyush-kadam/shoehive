import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AirForcePage extends StatefulWidget {
  const AirForcePage({super.key});

  @override
  _AirForcePageState createState() => _AirForcePageState();
}

class _AirForcePageState extends State<AirForcePage> {
  String selectedColor = 'Bright White';
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
                'Added Nike Air Force\nSize: $selectedSize, Color: $selectedColor to cart!',
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
        title: Text(
          'Nike Air Force',
          style: GoogleFonts.poppins(),
        ),
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
                        'assets/images/nike/air force 2.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/nike/air force 1.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Product Title and Price
              Text(
                'Nike Air Force',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Rs 3500',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              // Product Info
              Text(
                'The Nike Air Force comes with classic style for a timeless look.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Select Color
              Text(
                'Color: Bright White',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white, // Bright White color
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Select Size
              Text(
                'Select Size:',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 10,
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
                            'name': 'Nike Air Force',
                            'size': selectedSize,
                            'color': selectedColor,
                            'price': 3500,
                            'image': 'assets/images/nike/air force 2.jpg',
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
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                    ),
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
