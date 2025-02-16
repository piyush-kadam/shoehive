import 'package:flutter/material.dart';
import 'package:sneakers/products/ad/forum.dart';
import 'package:sneakers/products/co/black.dart';
import 'package:sneakers/products/co/blue.dart';
import 'package:sneakers/products/co/dd.dart';
import 'package:sneakers/products/co/orange.dart';
import 'package:sneakers/products/nb/NB1906R.dart';
import 'package:sneakers/products/nb/NB9060.dart';
import 'package:sneakers/products/ni/force.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';

  final List<Map<String, String>> products = [
    {
      'name': 'Converse DD',
      'description': 'Sleek design...',
      'image': 'assets/images/converse/dd m.jpg',
      'route': 'dd',
      'brand': 'Converse'
    },
    {
      'name': 'Converse Orange',
      'description': 'Add a pop...',
      'image': 'assets/images/converse/converse orange M.jpg',
      'route': 'orange',
      'brand': 'Converse'
    },
    {
      'name': 'Converse Blue',
      'description': 'Cool tones...',
      'image': 'assets/images/converse/blue M.jpg',
      'route': 'blue',
      'brand': 'Converse'
    },
    {
      'name': 'Converse Black',
      'description': 'Classic...',
      'image': 'assets/images/converse/Converse black M.jpg',
      'route': 'black',
      'brand': 'Converse'
    },
    {
      'name': 'Nike Air Max',
      'description': 'Comfort...',
      'image': 'assets/images/nike/air force M.jpg',
      'route': 'airmax',
      'brand': 'Nike'
    },
    {
      'name': 'Adidas UltraBoost',
      'description': 'Boost...',
      'image': 'assets/images/adidas/ss M.jpg',
      'route': 'ultraboost',
      'brand': 'Adidas'
    },
    {
      'name': 'New Balance 1960R',
      'description': 'Comfortable...',
      'image': 'assets/images/NB/6r M.jpg',
      'route': 'nb990',
      'brand': 'New Balance'
    },
    {
      'name': 'New Balance 9060',
      'description': 'Elevate...',
      'image': 'assets/images/NB/9060 M.jpg',
      'route': 'nb9060',
      'brand': 'New Balance'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      query = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search for products...',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: 'Enter product name or brand',
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black),
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                      padding: const EdgeInsets.only(top: 10.0),
                      itemCount: products
                          .where((product) {
                            return product['name']!
                                    .toLowerCase()
                                    .contains(query) ||
                                product['brand']!.toLowerCase().contains(query);
                          })
                          .toList()
                          .length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3 / 4,
                      ),
                      itemBuilder: (context, index) {
                        var product = products.where((product) {
                          return product['name']!
                                  .toLowerCase()
                                  .contains(query) ||
                              product['brand']!.toLowerCase().contains(query);
                        }).toList()[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                switch (product['route']) {
                                  case 'dd':
                                    return const DDPage();
                                  case 'orange':
                                    return const OrangePage();
                                  case 'blue':
                                    return const BluePage();
                                  case 'black':
                                    return const BlackPage();
                                  case 'airmax':
                                    return const AirForcePage();
                                  case 'ultraboost':
                                    return const ForumPage();
                                  case 'nb990':
                                    return const NB1906RPage();
                                  case 'nb9060':
                                    return const NB9060Page();
                                  default:
                                    return Container();
                                }
                              }),
                            );
                          },
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                  child: Container(
                                    width: double.infinity,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(product['image']!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name']!,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        product['description']!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
