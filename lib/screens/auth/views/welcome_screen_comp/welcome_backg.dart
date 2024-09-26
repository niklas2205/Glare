import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeBackground extends StatelessWidget {
  const WelcomeBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            'assets/Style_img/kajetan-sumila-EUAzJnKSNQg-unsplash.png',
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.09, // Approximate 34 / 375
          screenHeight * 0.018, // Approximate 15 / 812
          screenWidth * 0.07, // Approximate 26.6 / 375
          0,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: screenWidth * (-0.0027), // Approximate -1 / 375
              top: screenHeight * 0.049, // Approximate 40 / 812
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
              top: screenHeight * (-0.037), // Adjusted
              height: screenHeight * 0.123, // Adjusted
              left: screenWidth * (-0.314), // Adjusted
              right: screenWidth * (-0.314),
            ),
            // Bottom fade overlay
            _buildFadeOverlay(
              bottom: 0,
              height: screenHeight * 0.492, // Adjusted
              left: screenWidth * (-0.314),
              right: screenWidth * (-0.314),
            ),
          ],
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
              Color.fromARGB(255, 0, 0, 0), // Opaque black
              Colors.transparent, // Transparent
            ],
          ),
        ),
      ),
    );
  }
}
