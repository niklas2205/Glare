import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // For TapGestureRecognizer
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInFore1 extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback loginWithEmail;
  final VoidCallback registerWithEmail;
  final VoidCallback forgotPasswordbutton;
  final VoidCallback onContinueWithApple;

  const SignInFore1({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.loginWithEmail,
    required this.registerWithEmail,
    required this.forgotPasswordbutton,
    required this.onContinueWithApple,
  }) : super(key: key);

  @override
  _SignInFore1State createState() => _SignInFore1State();
}

class _SignInFore1State extends State<SignInFore1> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Margins
    final double horizontalMargin = screenWidth * 0.04; // 4% of screen width
    final double topMargin = screenHeight * 0.1; // 10% of screen height

    return Container(
      margin: EdgeInsets.fromLTRB(horizontalMargin, topMargin, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // headerWithBackButton(context), // Uncomment if needed
          welcomeTextWidget(context),
          socialLoginButtons(context),
          dividerWithText(context),
          emailAndPasswordFields(context, widget.emailController, widget.passwordController),
          forgotPassword(context, widget.forgotPasswordbutton),
          loginButton(context, widget.loginWithEmail),
          registerButton(context, widget.registerWithEmail),
        ],
      ),
    );
  }

  Widget welcomeTextWidget(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double leftMargin = screenWidth * 0.05; // 5% of screen width

    return Container(
      margin: EdgeInsets.fromLTRB(leftMargin, 7, 0, 0),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Glare,',
            style: GoogleFonts.getFont(
              'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              height: 1.5,
              color: const Color(0xFF8FFA58),
            ),
          ),
          Text(
            'Enter Your Details Below',
            style: GoogleFonts.getFont(
              'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              height: 1.5,
              color: const Color(0xFFE0E0E0),
            ),
          ),
        ],
      ),
    );
  }

  Widget socialLoginButtons(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  final double buttonWidth = (screenWidth * 0.85 - 16) / 2; // Adjusted width for two buttons
  final double buttonHeight = 48;
  final double horizontalMargin = screenWidth * 0.05; // 5% of screen width
  final double topMargin = screenHeight * 0.04; // 4% of screen height
  final double spacing = 16.0;

  return Container(
    margin: EdgeInsets.fromLTRB(horizontalMargin, topMargin, horizontalMargin, 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Google Sign-In Button
        GestureDetector(
          onTap: () {
            // Implement your Google Sign-In logic here
          },
          child: Container(
            height: buttonHeight,
            width: buttonWidth,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x52919EAB)),
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xFFFFFFFF),
            ),
            alignment: Alignment.center,
            child: Image.asset('assets/icons/ic_google.png', width: 24, height: 24),
          ),
        ),
        SizedBox(width: spacing),
        // Custom Apple Sign-In Button with only SVG logo
        GestureDetector(
          onTap: widget.onContinueWithApple,
          child: Container(
            height: buttonHeight,
            width: buttonWidth,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x52919EAB)),
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xFF1A1A1A),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/icons/apple.svg',
              width: 24,
              height: 24,
              color: Colors.white, // Optional: if you want the icon to be white
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget dividerWithText(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalMargin = screenWidth * 0.05; // 5% of screen width

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: const Color(0xFFBDBDBD),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'OR',
              style: GoogleFonts.getFont(
                'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.6,
                color: const Color(0xFFBDBDBD),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: const Color(0xFFBDBDBD),
            ),
          ),
        ],
      ),
    );
  }

  Widget emailAndPasswordFields(BuildContext context, TextEditingController emailController, TextEditingController passwordController) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double fieldWidth = screenWidth * 0.9; // 90% of screen width
    final double fieldHeight = 56; // Or adjust based on screen height
    final double horizontalPadding = screenWidth * 0.05; // 5% of screen width
    final double verticalSpacing = screenHeight * 0.015; // 1.5% of screen height

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(horizontalPadding, verticalSpacing, horizontalPadding, 0),
          child: Container(
            width: fieldWidth,
            height: fieldHeight,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF8FFA58), width: 1), // Added green border
              borderRadius: BorderRadius.circular(100),
            ),
            child: TextField(
              controller: emailController,
              style: GoogleFonts.getFont(
                'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: const Color(0xFFFFFFFF),
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                hintText: 'Email address',
                hintStyle: GoogleFonts.getFont(
                  'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: const Color(0xFFFFFFFF),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Adjust content padding to center the text properly
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(horizontalPadding, verticalSpacing, horizontalPadding, 0),
          child: Container(
            width: fieldWidth,
            height: fieldHeight,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF8FFA58), width: 1), // Added green border
              borderRadius: BorderRadius.circular(100),
            ),
            child: TextField(
              style: GoogleFonts.getFont(
                'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: const Color(0xFFFFFFFF),
              ),
              controller: passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                hintText: 'Password',
                hintStyle: GoogleFonts.getFont(
                  'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: const Color(0xFFFFFFFF),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: SvgPicture.asset(
                      _obscureText
                          ? 'assets/icons/eye-slash.svg'
                          : 'assets/icons/Icon_eye.svg',
                      colorFilter: const ColorFilter.mode(Color(0xFF8FFA58), BlendMode.srcIn),
                    ),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Adjust content padding to center the text properly
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget forgotPassword(BuildContext context, VoidCallback controller) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = screenWidth * 0.05; // 5% of screen width
    final double topPadding = screenHeight * 0.02; // 2% of screen height
    final double rightPadding = screenWidth * 0.11; // Adjust as needed for right padding

    return Align(
      alignment: Alignment.centerRight, // Align to the right
      child: Padding(
        padding: EdgeInsets.fromLTRB(horizontalPadding, topPadding, rightPadding, 24), // Adjusted top padding to move it further down
        child: InkWell(
          onTap: () {
            controller();
          },
          child: Text(
            'Forgot password?',
            style: GoogleFonts.getFont(
              'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              height: 1.6,
              color: const Color(0xFF8FFA58),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton(BuildContext context, VoidCallback controller) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double buttonWidth = screenWidth * 0.9; // 90% of screen width
    final double buttonHeight = 48; // Or adjust based on screen height
    final double horizontalMargin = screenWidth * 0.05; // 5% of screen width
    final double topMargin = screenHeight * 0.02; // 2% of screen height

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      margin: EdgeInsets.fromLTRB(horizontalMargin, topMargin, horizontalMargin, 0),
      child: ElevatedButton(
        onPressed: controller,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8FFA58),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Text(
          'Login',
          style: GoogleFonts.getFont(
            'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: const Color(0xFF000000),
          ),
        ),
      ),
    );
  }

  Widget registerButton(BuildContext context, VoidCallback controller) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double topPadding = screenHeight * 0.03; // 3% of screen height
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.05; // 5% of screen width

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, topPadding, horizontalPadding, 0),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.getFont(
              'Public Sans',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 1.6,
              color: const Color(0xFFFFFFFF),
            ),
            children: [
              const TextSpan(
                text: 'Don’t have an account?',
              ),
              const TextSpan(text: ' '),
              TextSpan(
                text: 'Register Now!',
                style: GoogleFonts.getFont(
                  'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: const Color(0xFF8FFA58),
                ),
                recognizer: TapGestureRecognizer()..onTap = controller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
