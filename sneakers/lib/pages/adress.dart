import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  String address = '';
  bool addressSaved = false;
  TextEditingController manualAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  // Load the saved address from SharedPreferences
  Future<void> _loadSavedAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedAddress = prefs.getString('savedAddress');
    setState(() {
      if (savedAddress != null && savedAddress.isNotEmpty) {
        address = savedAddress;
        addressSaved = true;
      }
    });
  }

  // Save the address to SharedPreferences
  Future<void> _saveAddress() async {
    if (manualAddressController.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('savedAddress', manualAddressController.text);
      setState(() {
        address = manualAddressController.text;
        manualAddressController.clear();
        addressSaved = true;
      });
    }
  }

  // Delete the saved address from SharedPreferences
  Future<void> _deleteAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedAddress');
    setState(() {
      address = '';
      addressSaved = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Your Address')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!addressSaved)
              TextField(
                controller: manualAddressController,
                decoration: const InputDecoration(
                  labelText: 'Enter Address Manually',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 20),
            if (!addressSaved)
              ElevatedButton(
                onPressed: _saveAddress,
                child: const Text('Save Address'),
              ),
            if (addressSaved)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text('Saved Address: $address'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            manualAddressController.text = address;
                            addressSaved = false;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: _deleteAddress,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
