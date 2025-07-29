import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AffordablePubsScreen extends StatefulWidget {
  @override
  _AffordablePubsScreenState createState() => _AffordablePubsScreenState();
}

class _AffordablePubsScreenState extends State<AffordablePubsScreen> {
  List<dynamic> pubs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAffordablePubs();
  }

  Future<void> fetchAffordablePubs() async {
    final maxPrice = 15; // You can make this dynamic
    final response = await http.get(
      Uri.parse('http://localhost:1337/api/pubs/affordable?maxPrice=$maxPrice'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        pubs = data;
        isLoading = false;
      });
    } else {
      // Error handling
      setState(() {
        isLoading = false;
      });
      print("Failed to load pubs: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Affordable Pubs')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pubs.length,
              itemBuilder: (context, index) {
                final pub = pubs[index];
                return ListTile(
                  title: Text(pub['name']),
                  subtitle: Text('Price: €${pub['price']}'),
                );
              },
            ),
    );
  }
}
