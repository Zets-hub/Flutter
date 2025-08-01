// ignore_for_file: prefer_const_constructors, use_super_parameters, unnecessary_null_comparison
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:everis_fridays_pubs_app/pub_card.dart';
import 'package:everis_fridays_pubs_app/models/pubs.dart';
import 'package:everis_fridays_pubs_app/affordable_pubs_screen.dart';

void main() => runApp(EverisFridayApp());

class EverisFridayApp extends StatefulWidget {
  const EverisFridayApp({Key? key}) : super(key: key);

  @override
  EverisFridayState createState() => EverisFridayState();
}

class EverisFridayState extends State<EverisFridayApp> {
  final List<Pubs> _listPubs = <Pubs>[];
  late Future<List<Pubs>> futurePubs;

  @override
  void initState() {
    super.initState();
    futurePubs = getPubs(_listPubs);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Everis Fridays Pub',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Everis Fridays Pub'),
          backgroundColor: Color.fromARGB(255, 92, 4, 169),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _buildPubs()),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(
                // ← This is the key change
                builder: (buttonContext) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.purpleAccent,
                  ),
                  onPressed: () {
                    Navigator.push(
                      buttonContext, // ← Use the Builder's context
                      MaterialPageRoute(
                        builder: (context) => AffordablePubsScreen(),
                      ),
                    );
                  },
                  child: const Text('Show Affordable Pubs'),
                ),
              ),
            ),
          ],
        ),
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

  Future<List<Pubs>> getPubs(List<Pubs> _listPubs) async {
    final Uri uri = Uri.parse('http://192.168.1.145:1338/api/pubs');
    final Response response = await get(uri);
    if (response.statusCode == 200) {
      List<dynamic> pubsListRaw = jsonDecode(response.body);
      _listPubs.clear();
      for (var i = 0; i < pubsListRaw.length; i++) {
        _listPubs.add(Pubs.fromJson(pubsListRaw[i]));
      }
      return _listPubs;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
// This file is part of the Everis Fridays Pubs App.
// It fetches pub data from a REST API and displays it in a list.
// hHOLA PABLOOO