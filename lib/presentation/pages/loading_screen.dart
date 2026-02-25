import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/presentation/pages/dashboard_screen.dart';



class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  double progress = 0;
  int messageIndex = 0;
  late Timer timer;

  List<String> messages = [
    "Nous téléchargeons les données…",
    "C’est presque fini…",
    "Plus que quelques secondes avant le résultat…"
  ];

  @override
  void initState() {
    super.initState();
    startLoading();
  }

  void startLoading() {
    timer = Timer.periodic(const Duration(milliseconds: 80), (t) {
      setState(() {
        progress += 1;

        if (progress % 30 == 0) {
          messageIndex = (messageIndex + 1) % messages.length;
        }

        if (progress >= 100) {
          t.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const DashboardScreen(),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E1B4B),
              Color(0xFF3B0764),
            ],
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              const SizedBox(height: 60),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(
                  Icons.cloud_outlined,
                  size: 45,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 60),
              SizedBox(
                height: 200,
                width: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    CircularProgressIndicator(
                      value: progress / 100,
                      strokeWidth: 10,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation(
                          Colors.purpleAccent),
                    ),

                    Text(
                      "${progress.toInt()}%",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    messages[messageIndex],
                    key: ValueKey(messageIndex),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}