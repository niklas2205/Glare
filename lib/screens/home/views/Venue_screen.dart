import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../background_screen/background_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class VenueDetail extends StatelessWidget {
  final String name;
  final String address;
  final String description;
  final String pictureUrl;
  final String instagram;
  final String website;

  const VenueDetail({
    required this.name,
    required this.address,
    required this.description,
    required this.pictureUrl,
    required this.instagram,
    required this.website,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageHeight = screenHeight * 0.26;
    final double widgetWidth = screenWidth * 0.82;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundScreen(),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: screenWidth,
                      height: imageHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        image: DecorationImage(
                          image: NetworkImage(pictureUrl),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    Positioned(
                      top: screenHeight * 0.05,
                      left: 20,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                  child: CustomTitleWithButtons(name: name),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIconButtonWithBorder(
                            icon: Icons.favorite_border,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 10),
                          _buildIconButtonWithBorder(
                            icon: Icons.share,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: widgetWidth,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF8FFA58), width: 2.0),
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xFF1A1A1A),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star, color: Color(0xFF8FFA58)),
                            Icon(Icons.star, color: Color(0xFF8FFA58)),
                            Icon(Icons.star, color: Color(0xFF8FFA58)),
                            Icon(Icons.star, color: Color(0xFF8FFA58)),
                            Icon(Icons.star, color: Color(0xFF8FFA58)),
                          ],
                        ),
                      ),
                      Text(
                        '5.0 Star Rating (52 Reviews) See Reviews',
                        style: GoogleFonts.getFont(
                          'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: const Color(0xFF8FFA58),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About The Venue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      InformationBox(
                        width: widgetWidth,
                        address: address,
                        description: description,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButtonWithBorder({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: const Color(0xFF8FFA58), width: 2.0),
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF8FFA58)),
        onPressed: onPressed,
      ),
    );
  }
}

class CustomTitleWithButtons extends StatelessWidget {
  final String name;

  const CustomTitleWithButtons({required this.name, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      height: 56.0,
      child: Center(
        child: Text(
          name,
          style: GoogleFonts.getFont(
            'Inter',
            fontWeight: FontWeight.normal,
            fontSize: 30,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class InformationBox extends StatelessWidget {
  final double width;
  final String address;
  final String description;

  const InformationBox({
    required this.width,
    required this.address,
    required this.description,
    Key? key,
  }) : super(key: key);

  Future<void> _launchMapsUrl(String query) async {
    final googleMapsUrl = Uri.parse('comgooglemaps://?q=$query');
    final appleMapsUrl = Uri.parse('https://maps.apple.com/?q=$query');
    final webUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else if (await canLaunchUrl(appleMapsUrl)) {
      await launchUrl(appleMapsUrl);
    } else {
      await launchUrl(webUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF8FFA58)),
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFF1A1A1A),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/icons/buliding_11_x2.svg',
                width: 24,
                height: 24,
                color: Color(0xFF8FFA58),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () => _launchMapsUrl(address),
                  child: Text(
                    address,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8FFA58),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/icons/vector_521_x2.svg',
                width: 24,
                height: 24,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/icons/Vector.svg',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

