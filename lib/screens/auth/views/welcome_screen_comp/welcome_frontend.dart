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
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 500, // Position from the top of the parent Stack
      left: 20, // Position from the left of the parent Stack
      child: Container(
        width: 350,
        height: 308, // Fixed height
        child: Column(
          mainAxisSize: MainAxisSize.min, // Makes the height hug its children
          children: <Widget>[
            _buildTextSection(),
            _buildEmailButton(),
            _buildGoogleButton(),
            _buildAppleButton(),
            _loginPrompt(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(7.5, 0, 7.5, 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(30, 0, 30.3, 8),
            child: Text(
              'Lorem Ipsum',
              style: GoogleFonts.getFont(
                'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 40,
                height: 1.5,
                color: const Color(0xFFFFFFFF),
              ),
            ),
          ),
          Text(
            'Lorem ipsum dolor sit amet consectetur.',
            style: GoogleFonts.getFont(
              'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              height: 1.5,
              letterSpacing: 0.1,
              color: const Color(0xFFBDBDBD),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailButton() {
    return Container(
      width: 322,
      height: 48,
      margin: const EdgeInsets.only(bottom: 10),
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

  Widget _buildGoogleButton() {
    return Container(
      width: 322,
      height: 48,
      margin: const EdgeInsets.only(bottom: 10),
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
            const SizedBox(width: 10), // Add spacing between image and text
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

  Widget _buildAppleButton() {
    return Container(
      width: 322,
      height: 48,
      margin: const EdgeInsets.only(bottom: 10),
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
            const SizedBox(width: 10), // Add spacing between image and text
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
  Widget _loginPrompt() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0.5, 0, 0, 0),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.getFont(
            'Public Sans',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 1.6,
            color: const Color(0xFF212B36),
          ),
          children: [
            TextSpan(
              text: 'Already have an account? ',
              style: GoogleFonts.getFont(
                'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.3,
                color: const Color(0xFFFFFFFF),
              ),
            ),
            WidgetSpan(
              child: InkWell(
                onTap: () {
                  onContinueWithLogin();
                },
                child: Text(
                  'Login',
                  style: GoogleFonts.getFont(
                    'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 1.3,
                    color: const Color(0xFF8FFA58),
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
