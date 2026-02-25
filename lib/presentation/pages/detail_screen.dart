import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String city;
  final String temp;

  const DetailScreen({super.key, required this.city, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1B4B), Color(0xFF3B0764)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),

            const SizedBox(height: 20),

            Text(
              city,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            Center(
              child: Text(
                temp,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}