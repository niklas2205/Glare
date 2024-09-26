import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class WelcomeFrontend extends StatelessWidget {
  final VoidCallback onContinueWithEmail;
  final VoidCallback onContinueWithGoogle;
  final VoidCallback onContinueWithApple;
  final VoidCallback onContinueWithLogin;

  const WelcomeFrontend({
    required this.onContinueWithEmail,
    required this.onContinueWithGoogle,
    required this.onContinueWithApple,
    required this.onContinueWithLogin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Calculate positions and sizes as percentages of screen dimensions
    final double bottomPosition = screenHeight * 0.03; // 5% from the bottom
    final double leftPosition = screenWidth * 0.05; // 5% from the left
    final double containerWidth = screenWidth * 0.9; // 90% of screen width

    return Positioned(
      bottom: bottomPosition,
      left: leftPosition,
      child: Container(
        width: containerWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // _buildTextSection(context),
            _buildEmailButton(context),
            _buildGoogleButton(context),
            _buildAppleButton(context),
            _loginPrompt(context),
          ],
        ),
      ),
    );
  }
  // Widget _buildTextSection(BuildContext context) {
  //   final double screenWidth = MediaQuery.of(context).size.width;
  //   final double horizontalMargin = screenWidth * 0.05; // 5% of screen width

  //   return Container(
  //     margin: EdgeInsets.fromLTRB(horizontalMargin, 0, horizontalMargin, 24),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           margin: EdgeInsets.only(bottom: 8),
  //           child: Text(
  //             'Lorem Ipsum',
  //             style: GoogleFonts.getFont(
  //               'Inter',
  //               fontWeight: FontWeight.w500,
  //               fontSize: 40,
  //               height: 1.5,
  //               color: const Color(0xFFFFFFFF),
  //             ),
  //           ),
  //         ),
  //         Text(
  //           'Lorem ipsum dolor sit amet consectetur.',
  //           style: GoogleFonts.getFont(
  //             'Inter',
  //             fontWeight: FontWeight.w400,
  //             fontSize: 16,
  //             height: 1.5,
  //             letterSpacing: 0.1,
  //             color: const Color(0xFFBDBDBD),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildEmailButton(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = screenWidth * 0.85; // 85% of screen width
    final double screenHeight = MediaQuery.of(context).size.height;
    final double buttonHeight = 48; // Fixed button height

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      margin: EdgeInsets.only(bottom: screenHeight * 0.012), // 1.2% of screen height
      child: ElevatedButton(
        onPressed: onContinueWithEmail,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8FFA58),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 20),
        ),
        child: Text(
          'Continue with Email',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            height: 1.7,
            color: const Color(0xFF000000),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = screenWidth * 0.85;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double buttonHeight = 48;

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      margin: EdgeInsets.only(bottom: screenHeight * 0.012),
      child: ElevatedButton(
        onPressed: onContinueWithGoogle,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/ic_google.png', height: 24),
            const SizedBox(width: 10),
            Text(
              'Continue with Google',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                height: 1.7,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppleButton(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = screenWidth * 0.85;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double buttonHeight = 48;

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      margin: EdgeInsets.only(bottom: screenHeight * 0.012),
      child: ElevatedButton(
        onPressed: onContinueWithApple,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/apple.png', height: 24),
            const SizedBox(width: 10),
            Text(
              'Continue with Apple',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                height: 1.7,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginPrompt(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.01), // 1% of screen height
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.getFont(
            'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 1.3,
            color: const Color(0xFFFFFFFF),
          ),
          children: [
            const TextSpan(
              text: 'Already have an account? ',
            ),
            TextSpan(
              text: 'Login',
              style: GoogleFonts.getFont(
                'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                height: 1.3,
                color: const Color(0xFF8FFA58),
              ),
              recognizer: TapGestureRecognizer()..onTap = onContinueWithLogin,
            ),
          ],
        ),
      ),
    );
  }
}