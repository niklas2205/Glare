import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glare/screens/home/views/New_Version/Profile_screen/Manage_friends.dart';
import 'package:glare/screens/home/views/New_Version/Profile_screen/My_account.dart';
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
    final double profilePictureTopPadding = MediaQuery.of(context).size.height * 0.115;
    return Scaffold(
      body: Stack(
        children: [
          BackgroundScreen(), // Background is at the back
          Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/antoine-j-A_0C42zmz1Q-unsplash.png', // Ensure the file name and path are correct
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.26,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.26,
                    color: Colors.black.withOpacity(0.2), // 20% black overlay
                  ),
                ],
              ),
              SizedBox(height: profilePictureTopPadding),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SettingsContainer(),
                          LogoutButton(), // Added the new logout button
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoaded) {
                final user = state.user;
                return Positioned(
                  top: MediaQuery.of(context).size.height * 0.18, // Adjust the position as needed
                 
                  child: Column(
                    children: [
                      ProfilePictureWidget(name: user.name ?? 'User'),
                      const SizedBox(height: 10),
                    ],
                  ),
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
    return Column(
      children: [
        CustomPaint(
          painter: DottedBorderPainter(color: Color(0xFF8FFA58), strokeWidth: 2),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.33,
            height: MediaQuery.of(context).size.width * 0.33,
            child: Stack(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/IMG.png', // Ensure the file name and path are correct
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.33,
                    height: MediaQuery.of(context).size.width * 0.33,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.33,
                  height: MediaQuery.of(context).size.width * 0.33,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.7), // 70% black overlay
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
    path.addOval(Rect.fromLTWH(0, 0, size.width, size.height)); // Extend the radius to cover more area
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

