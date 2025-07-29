// ignore_for_file: prefer_const_constructors, use_super_parameters, unnecessary_null_comparison
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:everis_fridays_pubs_app/pub_card.dart';
import 'package:everis_fridays_pubs_app/models/pubs.dart';
import 'package:everis_fridays_pubs_app/affordable_pubs_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Everis Fridays Pub',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const EverisFridayApp(),
    );
  }
}

class EverisFridayApp extends StatefulWidget {
  const EverisFridayApp({super.key});

  @override
  EverisFridayState createState() => EverisFridayState();
}

class EverisFridayState extends State<EverisFridayApp> {
  final List<Pubs> _listPubs = [];
  late Future<List<Pubs>> futurePubs;
  double? maxPrice;

  @override
  void initState() {
    super.initState();
    futurePubs = getPubs(_listPubs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Everis Fridays Pub'),
        backgroundColor: Color.fromARGB(255, 109, 6, 137),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _buildPubs()),

          // Botón para navegar a AffordablePubsScreen
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: const Color.fromARGB(255, 217, 0, 255),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AffordablePubsScreen(),
                  ),
                );
              },
              child: Text('Show Affordable Pubs'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPubs() {
    return FutureBuilder<List<Pubs>>(
      future: futurePubs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("No pubs found");
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => PubCard(snapshot.data![index]),
          );
        }
      },
    );
  }

  Future<List<Pubs>> getPubs(List<Pubs> _listPubs, {double? maxPrice}) async {
    final Uri uri = maxPrice != null
        ? Uri.parse(
            'http://192.168.1.145:1338/api/pubs/affordable?maxPrice=$maxPrice',
          )
        : Uri.parse('http://192.168.1.145:1338/api/pubs/affordable');

    final Response response = await get(uri);
    if (response.statusCode == 200) {
      List<dynamic> pubsListRaw = jsonDecode(response.body);
      _listPubs.clear();
      for (var i = 0; i < pubsListRaw.length; i++) {
        _listPubs.add(Pubs.fromJson(pubsListRaw[i]));
      }
      return _listPubs;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
// This file is part of the Everis Fridays Pubs App.
// It fetches pub data from a REST API and displays it in a list.
// hHOLA PABLOOO


/*REDACTED

 /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Everis Fridays Pub')),
      body: Center(child: _buildPubs()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final controller = TextEditingController();
          final value = await showDialog<double>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Set max price'),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Enter max price'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final value = double.tryParse(controller.text);
                    Navigator.pop(context, value);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );

          if (value != null) {
            setState(() {
              maxPrice = value;
              futurePubs = getPubs(_listPubs, maxPrice: maxPrice);
            });
          }
        },
        child: const Icon(Icons.filter_alt),
      ),
    );
  }*/

*/