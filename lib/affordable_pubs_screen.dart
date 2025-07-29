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
        pubs = data;
        isLoading = false;
      });
    } else {
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
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: pubs.length,
                    itemBuilder: (context, index) {
                      final pub = pubs[index];
                      return ListTile(
                        title: Text(pub['name']),
                        subtitle: Text('Price: €${pub['avgPrice']}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
