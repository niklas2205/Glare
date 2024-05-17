import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/Style_img/kajetan-sumila-EUAzJnKSNQg-unsplash.png',
            ),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 942,
          child: Container(
            padding: const EdgeInsets.fromLTRB(34, 15, 26.6, 0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: -1,
                  top: 40,
                  child: Text(
                    'Glare',
                    style: GoogleFonts.majorMonoDisplay(
                      fontWeight: FontWeight.w400,
                      fontSize: 30,
                      color: const Color(0xFF8FFA58),
                    ),
                  ),
                ),
                // Top fade overlay
                _buildFadeOverlay(
                  top: -30, // Adjust the top position as needed
                  height: 100, // Height of the fade effect
                  left: -118, // Adjust left position
                  right: -118, // Adjust right position
                ),
                // Bottom fade overlay
                _buildFadeOverlay(
                  bottom: 0, // Adjust the bottom position as needed
                  height: 400, // Height of the fade effect
                  left: -118, // Adjust left position
                  right: -118, // Adjust right position
                ),

                _buildFadeOverlay(
                  bottom: 0,
                  height: 500, 
                  left: -118, 
                  right: -118)
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a fade overlay with adjustable position and size
  Widget _buildFadeOverlay({
    double? top,
    double? bottom,
    required double height,
    required double left,
    required double right,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: top != null ? Alignment.topCenter : Alignment.bottomCenter,
            end: top != null ? Alignment.bottomCenter : Alignment.topCenter,
            colors: const [
              Color.fromARGB(255, 0, 0, 0), // Semi-transparent black
              Colors.transparent, // Fully transparent
            ],
          ),
        )
      ),
    );
  }
}