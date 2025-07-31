import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:everis_fridays_pubs_app/pub_card.dart';
import 'package:everis_fridays_pubs_app/models/pubs.dart';

class AffordablePubsScreen extends StatefulWidget {
  @override
  _AffordablePubsScreenState createState() => _AffordablePubsScreenState();
}

class _AffordablePubsScreenState extends State<AffordablePubsScreen> {
  List<Pubs> pubs = [];
  bool isLoading = true;
  bool _sortAscending = true;

  void _sortPubs() {
    final newOrder = _sortAscending ? 'desc' : 'asc';
    fetchAffordablePubs(sortOrder: newOrder).then((_) {
      setState(() => _sortAscending = !_sortAscending);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAffordablePubs();
  }

  Future<void> fetchAffordablePubs({String sortOrder = 'asc'}) async {
    final response = await http.get(
      Uri.parse(
        'http://192.168.1.145:1338/api/pubs/affordable?sort=$sortOrder',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        pubs = data.map((json) => Pubs.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to load pubs: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Affordable Pubs'),
        backgroundColor: const Color.fromARGB(255, 109, 6, 137),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: const Color.fromARGB(255, 217, 0, 255),
              ),
              onPressed: _sortPubs,
              child: Text(
                _sortAscending
                    ? 'Sort descending by Price'
                    : 'Sort ascending by Price',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : pubs.isEmpty
                ? const Center(child: Text("No pubs found"))
                : ListView.builder(
                    itemCount: pubs.length,
                    itemBuilder: (context, index) => PubCard(pubs[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
