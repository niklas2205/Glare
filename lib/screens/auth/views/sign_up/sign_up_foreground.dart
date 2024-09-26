import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // For TapGestureRecognizer
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpFore1 extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback registerWithEmail;
  final VoidCallback loginWithEmail;

  const SignUpFore1({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.registerWithEmail,
    required this.loginWithEmail,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = screenWidth * 0.08;

    return Container(
      margin: EdgeInsets.fromLTRB(horizontalPadding, 81, horizontalPadding, 0),
      height: 759,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // headerWithBackButton(context),
          welcomeTextWidget(),
          SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                inputField('Email address', emailController),
                passwordField('Password', passwordController),
                passwordField('Confirm Password', confirmPasswordController),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 24),
            width: 322,
            child: ElevatedButton(
              onPressed: () {
                if (passwordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Passwords do not match!'),
                    backgroundColor: Colors.red,
                  ));
                } else if (!isValidPassword(passwordController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Password must be 7-25 characters long, include at least one uppercase letter and one number.'),
                    backgroundColor: Colors.red,
                  ));
                } else if (!isValidEmail(emailController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please enter a valid email address.'),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  registerWithEmail();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(0, 11, 0, 11),
                backgroundColor: const Color(0xFF8FFA58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(
                'Register',
                style: GoogleFonts.getFont(
                  'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  height: 1.7,
                  color: const Color(0xFF000000),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          termsAndPrivacy(),
          loginPrompt(loginWithEmail),
        ],
      ),
    );
  }

  // Widget headerWithBackButton(BuildContext context) {
  //   return Row(
  //     children: [
  //       GestureDetector(
  //         onTap: () {
  //           Navigator.pop(context);
  //         },
  //         child: Transform.rotate(
  //           angle: 3.14159, // 180 degrees in radians
  //           child: SvgPicture.asset(
  //             'assets/icons/Profile_screen/ic_expand_more.svg',
  //             width: 24,
  //             height: 24,
  //             color: Color(0xFF8FFA58),
  //           ),
  //         ),
  //       ),
  //       SizedBox(width: 10), // Adjust the spacing as needed
  //       welcomeTextWidget(),
  //     ],
  //   );
  // }

  Widget welcomeTextWidget() {
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Welcome to Glare,',
                style: GoogleFonts.getFont(
                  'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  height: 1.5,
                  color: const Color(0xFF8FFA58),
                ),
              ),
            ),
          ),
          Text(
            'Register with your email address today.',
            style: GoogleFonts.getFont(
              'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              height: 1.5,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputField(String placeholder, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      height: 56,
      width: 322,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF8FFA58)),
        borderRadius: BorderRadius.circular(100),
        color: const Color(0xFF1A1A1A),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 2, 0, 0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: GoogleFonts.getFont(
              'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              height: 1.5,
              color: const Color(0xFFFFFFFF),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          style: GoogleFonts.getFont(
            'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 1.5,
            color: const Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }

  Widget passwordField(String placeholder, TextEditingController controller) {
    bool _obscureText = true;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
          height: 56,
          width: 322,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF8FFA58)),
            borderRadius: BorderRadius.circular(100),
            color: const Color(0xFF1A1A1A),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 2, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: placeholder,
                      hintStyle: GoogleFonts.getFont(
                        'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.5,
                        color: const Color(0xFFFFFFFF),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: GoogleFonts.getFont(
                      'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 1.5,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: SizedBox(
                      height: 37,
                      width: 37,
                      child: SvgPicture.asset(
                        _obscureText
                            ? 'assets/icons/eye-slash.svg'
                            : 'assets/icons/Icon_eye.svg',
                        color: const Color(0xFF8FFA58),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isValidEmail(String email) {
    bool emailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    return emailValid;
  }

  bool isValidPassword(String password) {
    bool lengthValid = password.length >= 7 && password.length <= 25;
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasNumber = password.contains(RegExp(r'[0-9]'));
    return lengthValid && hasUppercase && hasNumber;
  }

  Widget termsAndPrivacy() {
    return Container(
      margin: const EdgeInsets.fromLTRB(26.6, 0, 26.6, 35),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.getFont(
            'Public Sans',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 1.6,
            color: const Color(0xFFE0E0E0),
          ),
          children: [
            TextSpan(
              text: 'By signing up, I agree to Glare’s ',
              style: GoogleFonts.getFont(
                'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.3,
              ),
            ),
            TextSpan(
              text: 'Terms of Service',
              style: GoogleFonts.getFont(
                'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                decoration: TextDecoration.underline,
                height: 1.3,
                color: const Color(0xFF8FFA58),
                decorationColor: const Color(0xFF8FFA58),
              ),
            ),
            const TextSpan(
              text: ' and ',
            ),
            TextSpan(
              text: 'Privacy Policy',
              style: GoogleFonts.getFont(
                'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                decoration: TextDecoration.underline,
                height: 1.3,
                color: const Color(0xFF8FFA58),
                decorationColor: const Color(0xFF8FFA58),
              ),
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }

  Widget loginPrompt(VoidCallback controller) {
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
                  controller();
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