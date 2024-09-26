import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glare/screens/background_screen/background_screen.dart';
import 'package:glare/screens/home/views/New_Version/Profile_screen/Manage_friends.dart';
import 'package:glare/screens/home/views/New_Version/Profile_screen/My_account.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_repository/user_repository.dart';


import '../../../../auth/blocs/sign_in_bloc/sign_in_bloc.dart';

import '../../../blocs/user_bloc/user_bloc.dart';

 // Import your BackgroundScreen file
class ProfileMain extends StatelessWidget {
  const ProfileMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.height * 0.26;
    final double profilePictureTopPadding = MediaQuery.of(context).size.height * 0.13;
    final double profilePicturePosition = MediaQuery.of(context).size.height * 0.175;

    return Scaffold(
      body: Stack(
        children: [
          // Background is at the back, filling the entire screen
          BackgroundScreen(),
          // Unsplash image and overlay, positioned at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: imageHeight,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/antoine-j-A_0C42zmz1Q-unsplash.png',
                    width: MediaQuery.of(context).size.width,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: imageHeight,
                    color: Colors.black.withOpacity(0.2), // 20% black overlay
                  ),
                ],
              ),
            ),
          ),
          // Profile picture overlaying the image and background
          Positioned(
            top: profilePicturePosition,
            left: 0,
            right: 0,
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  final user = state.user;
                  return Column(
                    children: [
                      ProfilePictureWidget(name: user.name ?? 'User'),
                      const SizedBox(height: 10),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          // The scrollable content, positioned below the image and profile picture
          Positioned(
            top: imageHeight + profilePictureTopPadding + 10 ,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SettingsContainer(),
                      LogoutButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.82,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 0.0),
      decoration: BoxDecoration(
        color: const Color(0xFF8FFA58), // Green background color
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: () {
          context.read<SignInBloc>().add(SignOutRequired());
          Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
        },
        child: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.black, // Black text color
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class ProfilePictureWidget extends StatelessWidget {
  final String name;

  const ProfilePictureWidget({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.height * 0.15;
    double borderSize = imageSize + 12; // Slightly larger than image size for the gap
    double gap = imageSize * 0.1;

    return Column(
      children: [
        SizedBox(
          width: borderSize,
          height: borderSize,
          child: CustomPaint(
            painter: DottedCirclePainter(
              color: const Color(0xFF8FFA58),
              strokeWidth: 2,
              gapSize: 3,
              dashSize: 6,
            ),
            child: Center(
              child: ClipOval(
                child: SvgPicture.asset(
                  'assets/images/glare_logo.svg', // Ensure the file name and path are correct
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: gap),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width, // Full width of the screen
            alignment: Alignment.center,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class DottedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gapSize;
  final double dashSize;

  DottedCirclePainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.gapSize = 3.0,
    this.dashSize = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create a paint object
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Calculate the radius
    double radius = (size.width / 2) - (strokeWidth / 2);

    // Calculate the circumference
    final circumference = 2 * pi * radius;

    // Calculate the number of dashes that can fit
    final totalDashLength = dashSize + gapSize;
    final dashCount = (circumference / totalDashLength).floor();

    // Calculate the angle between each dash
    final dashAngle = (2 * pi) / dashCount;

    // Draw the dashes
    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      final sweepAngle = (dashSize / circumference) * 2 * pi;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(DottedCirclePainter oldDelegate) => false;
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
          _buildCategoryBox(
            context,
            options: [
              _buildSettingsOption(
                context,
                icon: 'assets/icons/Profile_screen/user.svg',
                text: 'My Account',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyAccount(title: 'My Account'),
                    ),
                  );
                
                },
              ),
              _buildSettingsOption(
                context,
                icon: 'assets/icons/Profile_screen/people.svg',
                text: 'Manage Friends',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageFriends(),
                    ),
                  );
                
                },
              ),
              _buildSettingsOption(
                context,
                icon: 'assets/icons/Profile_screen/direct.svg',
                text: 'Inbox',
                onTap: () {},
              ),
            ],
          ),
          _buildSectionTitle(context, 'Information'),
          _buildCategoryBox(
            context,
            options: [
              _buildSettingsOption(
                context,
                icon: 'assets/icons/Profile_screen/document-text.svg',
                text: 'Terms & Conditions',
                onTap: () {},
              ),
              _buildSettingsOption(
                context,
                icon: 'assets/icons/Profile_screen/security-safe.svg',
                text: 'Privacy Policy',
                onTap: () {},
              ),
              _buildSettingsOption(
                context,
                icon: 'assets/icons/Profile_screen/mobile.svg',
                text: 'About This App',
                onTap: () {},
              ),
            ],
          ),
          _buildSectionTitle(context, 'Help & Support'),
          _buildCategoryBox(
            context,
            options: [
              _buildSettingsOption(
                context,
                icon: 'assets/icons/Profile_screen/message-question.svg',
                text: 'FAQ',
                onTap: () {},
              ),
              _buildSettingsOption(
                context,
                icon: 'assets/icons/Profile_screen/sms.svg',
                text: 'Contact Us',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBox(BuildContext context, {required List<Widget> options}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Add some padding inside the box
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF8FFA58),
          width: 2, // Increase the border thickness to 2 pixels
        ),
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF282828),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(4, 4),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: options,
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
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
        ),
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
            SvgPicture.asset(
              'assets/icons/Profile_screen/ic_expand_more.svg',
              width: 20, // Increased the size
              height: 20, // Increased the size
            ),
          ],
        ),
      ),
    );
  }
}

