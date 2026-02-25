import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  bool isDarkMode = true;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
    AnimationController(vsync: this, duration: Duration(seconds: 2))
      ..repeat(reverse: true);

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
  }

  toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    List<Color> darkGradient = [
      Color(0xFF1E1B4B),
      Color(0xFF3B0764),
    ];

    List<Color> lightGradient = [
      Color(0xFF6D83F2),
      Color(0xFFB06AB3),
    ];

    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode ? darkGradient : lightGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: toggleTheme,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Icon(
                        isDarkMode
                            ? Icons.wb_sunny_outlined
                            : Icons.nightlight_round,
                        color:
                        isDarkMode ? Colors.yellow : Colors.indigo,
                      ),
                    ),
                  ),
                ),
              ),

              Spacer(),

              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    size: 55,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 40),

              AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 400),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
                child: Text("WeatherLux"),
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Gardez une longueur d'avance sur les éléments",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ),

              SizedBox(height: 60),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoadingScreen(),
                    ),
                  );
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white.withOpacity(0.85),
                  ),
                  child: Center(
                    child: Text(
                      "Commencer l'expérience",
                      style: GoogleFonts.poppins(
                        color: Colors.indigo,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildDot(true),
                  buildDot(false),
                  buildDot(false),
                ],
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDot(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 10 : 8,
      height: isActive ? 10 : 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.white : Colors.white24,
      ),
    );
  }
}