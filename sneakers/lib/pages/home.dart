import 'dart:async';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sneakers/auth/auth_services.dart';
import 'package:sneakers/pages/NB.dart';
import 'package:sneakers/pages/adidas.dart';
import 'package:sneakers/pages/cart.dart';
import 'package:sneakers/pages/converse.dart';
import 'package:sneakers/pages/nike.dart';
import 'package:sneakers/pages/profile.dart';
import 'package:sneakers/pages/search.dart';
import 'package:sneakers/products/ad/samba.dart';
import 'package:sneakers/products/co/black.dart';
import 'package:sneakers/products/nb/NB550.dart';
import 'package:sneakers/products/ni/force.dart';

// Ensure you import your AuthService and all required pages

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Changed from final to mutable int

  // List of pages for navigation
  final List<Widget> _pages = [
    HomeContent(), // Fixed: Removed `_` from class name
    const SearchPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  // Logout function
  void logout(BuildContext context) async {
    final auth = AuthService();
    await auth.signOut();

    // Clear saved avatar and address from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('avatarPath');
    await prefs.remove('savedAddress');

    // Navigate to LoginPage and remove all previous routes
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Set a greyish background color
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          'SHOEHIVE', // The app name
          style: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _currentIndex = 2; // Set the Cart tab as selected
              });
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
          ),
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            color: Colors.black,
            height: 60.0,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 400),
            index: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index; // Update the selected tab
              });
            },
            items: const <Widget>[
              Icon(Icons.home, size: 18, color: Colors.white),
              Icon(Icons.search, size: 18, color: Colors.white),
              Icon(Icons.shopping_cart, size: 18, color: Colors.white),
              Icon(Icons.person, size: 18, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

// Renamed from `_HomeContent` to `HomeContent` to avoid private class errors
class HomeContent extends StatefulWidget {
  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final List<Map<String, dynamic>> bannerData = [
    {'image': 'assets/images/SH/new balance s.jpg', 'route': const NB550Page()},
    {'image': 'assets/images/SH/adidas s.jpg', 'route': const SambaPage()},
    {'image': 'assets/images/SH/nike s.jpg', 'route': const AirForcePage()},
    {'image': 'assets/images/SH/Converse s.jpeg', 'route': const BlackPage()},
  ];

  final List<Map<String, dynamic>> posterData = [
    {
      'image': 'assets/images/NB/NB poster.jpg',
      'brand': 'New Balance',
      'tagline': 'Balance Your Steps, Balance Your Life',
      'route': const NBPage(),
    },
    {
      'image': 'assets/images/nike/nike poster.jpg',
      'brand': 'Nike',
      'tagline': 'Just Do It with Nike',
      'route': const NikePage(),
    },
    {
      'image': 'assets/images/converse/CONVERSE poster.jpg',
      'brand': 'Converse',
      'tagline': 'Step into Style with Converse',
      'route': const ConversePage(),
    },
    {
      'image': 'assets/images/adidas/adidas poster.jpg',
      'brand': 'Adidas',
      'tagline': 'Impossible is Nothing with Adidas',
      'route': const AdidasPage(),
    },
  ];

  late PageController _bannerPageController;
  late Timer _bannerTimer;
  int _currentBanner = 0;
  int _currentPoster = 0;

  @override
  void initState() {
    super.initState();
    _bannerPageController = PageController(initialPage: _currentBanner);

    _bannerTimer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_currentBanner < bannerData.length - 1) {
        _currentBanner++;
      } else {
        _currentBanner = 0;
      }
      if (mounted) {
        _bannerPageController.animateToPage(
          _currentBanner,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer.cancel();
    _bannerPageController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: PageView.builder(
              controller: _bannerPageController,
              itemCount: bannerData.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => bannerData[index]['route']),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      bannerData[index]['image'] ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Poster Section with Manual Navigation
          Expanded(
            child: Stack(
              children: [
                // Poster content
                PageView.builder(
                  controller: PageController(initialPage: _currentPoster),
                  scrollDirection: Axis.horizontal,
                  itemCount: posterData.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPoster = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => posterData[index]['route']),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Brand name and tagline above the image
                          Text(
                            posterData[index]['brand']!,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            posterData[index]['tagline']!,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          // Image container
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: 250,
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                              color: Colors.grey[200],
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              posterData[index]['image']!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Left and right arrows
                Positioned(
                  left: 10,
                  top: MediaQuery.of(context).size.height * 0.3,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_left, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        _currentPoster = (_currentPoster == 0)
                            ? posterData.length - 1
                            : _currentPoster - 1;
                      });
                    },
                  ),
                ),
                Positioned(
                  right: 10,
                  top: MediaQuery.of(context).size.height * 0.3,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_right, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        _currentPoster =
                            (_currentPoster == posterData.length - 1)
                                ? 0
                                : _currentPoster + 1;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
