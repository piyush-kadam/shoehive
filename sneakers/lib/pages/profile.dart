import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sneakers/pages/adress.dart';
import 'package:sneakers/pages/feedback.dart';
import 'package:sneakers/pages/orders.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email = '';
  File? _avatarImage;
  String address = '';

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
    _loadUserDetails();
  }

  _fetchUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        email = user.email ?? 'No Email';
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'userEmail', email); // Save email to SharedPreferences
    }
  }

  _loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? avatarPath = prefs.getString('avatarPath');
    String? savedAddress = prefs.getString('savedAddress');
    setState(() {
      if (avatarPath != null) {
        _avatarImage = File(avatarPath);
      }
      if (savedAddress != null && savedAddress.isNotEmpty) {
        address = savedAddress;
      }
    });

    // Save the address to SharedPreferences for use in receipt
    if (savedAddress != null) {
      prefs.setString('userAddress', savedAddress);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatarPath', pickedImage.path);
      setState(() {
        _avatarImage = File(pickedImage.path);
      });
    }
  }

  void _navigateToAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddressPage()),
    ).then((_) {
      _loadUserDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[800],
                    backgroundImage: _avatarImage != null
                        ? FileImage(_avatarImage!)
                        : const AssetImage('assets/images/SH/avatar.jpg')
                            as ImageProvider,
                    child: _avatarImage == null
                        ? const Icon(
                            Icons.edit,
                            size: 30,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Email: $email',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _navigateToAddress,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      'Your Address',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      address.isNotEmpty
                          ? address
                          : 'Click to add your address',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: address.isEmpty ? Colors.blue : Colors.grey[600],
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrdersPage()),
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      'Your Orders',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text('Click to view your orders'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FeedbackPage()),
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      'Provide Feedback',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text('Click to provide feedback'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Contact Us: ShoeHive@gmail.com',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
