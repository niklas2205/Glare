import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomToggleButton extends StatelessWidget {
  final bool isVenueSelected;
  final Function(bool) onToggle;

  const CustomToggleButton({
    required this.isVenueSelected,
    required this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = screenWidth * 0.82; // 82% of the screen width

    return Container(
      width: buttonWidth,
      height: 45,
      alignment: Alignment.center,
      child: Container(
        width: buttonWidth,
        height: 45,
        padding: const EdgeInsets.all(4.0), // Padding inside the container to make the buttons smaller
        decoration: BoxDecoration(
          color: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onToggle(false),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: isVenueSelected ? const Color(0xFF000000) : const Color(0xFF8FFA58),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        offset: Offset(0, 5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Events',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: isVenueSelected ? const Color(0xFF8FFA58) : const Color(0xFF000000),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(width: 4.0), // Space between the two buttons
            Expanded(
              child: GestureDetector(
                onTap: () => onToggle(true),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: isVenueSelected ? const Color(0xFF8FFA58) : const Color(0xFF000000),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        offset: Offset(0, 5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Venues',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: isVenueSelected ? const Color(0xFF000000) : const Color(0xFF8FFA58),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}