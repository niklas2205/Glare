import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_repository/user_repository.dart';


import '../../../../auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../../../background_screen/background_screen.dart';
import '../../../blocs/user_bloc/user_bloc.dart';

 // Import your BackgroundScreen file

class ProfileMain extends StatelessWidget {
  const ProfileMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundScreen(),  // Background is at the back
          Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/antoine-j-A_0C42zmz1Q-unsplash.png',  // Ensure the file name and path are correct
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.26,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.26,
                    color: Colors.black.withOpacity(0.2),  // 20% black overlay
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Settings Screen'),
                      IconButton(
                        onPressed: () {
                          context.read<SignInBloc>().add(SignOutRequired());
                        },
                        icon: const Icon(CupertinoIcons.arrow_right_to_line, color: Color(0xFF13B8A8)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoaded) {
                final user = state.user;
                return Column(
                  children: [
                    ProfilePictureWidget(name: user.name ?? 'User'),
                    const SizedBox(height: 20),
                    const SettingsContainer(),  // Added the SettingsContainer widget
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}






class ProfilePictureWidget extends StatelessWidget {
  final String name;

  const ProfilePictureWidget({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: (MediaQuery.of(context).size.height * 0.185), // Adjust the position as needed
      left: (MediaQuery.of(context).size.width * 0.33), // Center the circle horizontally
      child: Column(
        children: [
          CustomPaint(
            painter: DottedBorderPainter(color: Color(0xFF8FFA58), strokeWidth: 2),
            child: Container(
              width: (MediaQuery.of(context).size.width * 0.33),
              height: (MediaQuery.of(context).size.width * 0.33),
              child: Stack(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/IMG.png',  // Ensure the file name and path are correct
                      fit: BoxFit.cover,
                      width: (MediaQuery.of(context).size.width * 0.33),
                      height: (MediaQuery.of(context).size.width * 0.33),
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width * 0.33),
                    height: (MediaQuery.of(context).size.width * 0.33),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.7),  // 70% black overlay
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, color: Colors.white, size: 24),
                          SizedBox(height: 4),
                          Text('Update photo', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}



class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  DottedBorderPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double dashWidth = 5.0, dashSpace = 3.0;
    final path = Path();
    path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));  // Extend the radius to cover more area
    final PathMetric pathMetric = path.computeMetrics().first;
    for (double i = 0; i < pathMetric.length; i += dashWidth + dashSpace) {
      final extractPath = pathMetric.extractPath(i, i + dashWidth);
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.82,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'General'),
          _buildSettingsOption(
            context,
            icon: 'assets/icons/Profile_screen/direct.svg',
            text: 'My Account',
            onTap: () {},
          ),
          _buildSettingsOption(
            context,
            icon: 'assets/icons/Profile_screen/direct.svg',
            text: 'Manage Friends',
            onTap: () {},
          ),
          _buildSettingsOption(
            context,
            icon: 'assets/icons/Profile_screen/direct.svg',
            text: 'Inbox',
            onTap: () {},
          ),
          _buildSectionTitle(context, 'Information'),
          _buildSettingsOption(
            context,
            icon: 'assets/icons/Profile_screen/direct.svg',
            text: 'Terms & Conditions',
            onTap: () {},
          ),
          _buildSettingsOption(
            context,
            icon: 'assets/icons/Profile_screen/direct.svg',
            text: 'Privacy Policy',
            onTap: () {},
          ),
          _buildSettingsOption(
            context,
            icon: 'assets/icons/Profile_screen/direct.svg',
            text: 'About This App',
            onTap: () {},
          ),
          _buildSectionTitle(context, 'Help & Support'),
          _buildSettingsOption(
            context,
            icon: 'assets/icons/Profile_screen/direct.svg',
            text: 'FAQ',
            onTap: () {},
          ),
          _buildSettingsOption(
            context,
            icon: 'assets/icons/Profile_screen/direct.svg',
            text: 'Contact Us',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Text(
        title,
        style: GoogleFonts.getFont(
          'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          height: 1.4,
          letterSpacing: 0.1,
          color: Color(0xFFFFFFFF),
        ),
      ),
    );
  }

  Widget _buildSettingsOption(BuildContext context, {required String icon, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF8FFA58)),
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF282828),
          boxShadow: [
            BoxShadow(
              color:  Color(0x1A000000),
              offset:  Offset(4, 4),
              blurRadius: 2,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 14, 16.4, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(icon),
                  ),
                  Text(
                    text,
                    style: GoogleFonts.getFont(
                      'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 1.5,
                      letterSpacing: 0.1,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ],
              ),
              Transform(
                transform: Matrix4.identity()..rotateZ(-1.5727238767),
                child: SvgPicture.asset(
                 'assets/icons/Profile_screen/direct.svg',
                  width: 11.2,
                  height: 6.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
