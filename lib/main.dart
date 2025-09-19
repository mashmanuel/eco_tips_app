import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const EcoTipsApp());
}

class EcoTipsApp extends StatelessWidget {
  const EcoTipsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco Tips App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  static const Color _gradientStartColor = Color(0xFFD4FC79);
  static const Color _gradientEndColor = Color(0xFF96E6A1);

  final List<String> ecoTips = [
    "🌱 Turn off lights when you leave the room.",
    "♻️ Use reusable bags instead of plastic ones.",
    "🚿 Take shorter showers to save water.",
    "🔌 Unplug chargers when not in use.",
    "📦 Recycle paper, glass, and plastic whenever possible.",
    "💡 Use energy-efficient light bulbs.",
  ];

  int _currentTipIndex = 0;
  bool _isFavorite = false;

  late AnimationController _iconController;
  double _buttonScale = 1.0;

  @override
  void initState() {
    super.initState();
    try {
      _iconController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
        lowerBound: 0.7,
        upperBound: 1.0,
      );
      _iconController.forward();
    } catch (e) {
      debugPrint('Error initializing animation controller: $e');
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _nextTip() {
    setState(() {
      _buttonScale = 0.9;
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          _buttonScale = 1.0;
          _currentTipIndex = (_currentTipIndex + 1) % ecoTips.length;
          _isFavorite = false;
        });
      });
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _gradientStartColor,
              _gradientEndColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ Bouncing eco icon
                ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _iconController,
                    curve: Curves.elasticOut,
                  ),
                  child: const AnimatedOpacity(
                    duration: Duration(milliseconds: 1200),
                    opacity: 1,
                    child: Icon(Icons.eco, color: Colors.white, size: 80),
                  ),
                ),

                const SizedBox(height: 20),

                // ✅ AnimatedSwitcher for tip card
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(0.0, 0.3),
                      end: Offset.zero,
                    ).animate(animation);
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: offsetAnimation, child: child),
                    );
                  },
                  child: Card(
                    key: ValueKey<int>(_currentTipIndex),
                    elevation: 8,
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        ecoTips[_currentTipIndex],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ✅ Buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated "Next Tip" button
                    AnimatedScale(
                      scale: _buttonScale,
                      duration: const Duration(milliseconds: 150),
                      child: ElevatedButton.icon(
                        onPressed: _nextTip,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                        ),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Next Tip"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.star : Icons.star_border,
                        color: _isFavorite ? Colors.amber : Colors.white,
                        size: 32,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
