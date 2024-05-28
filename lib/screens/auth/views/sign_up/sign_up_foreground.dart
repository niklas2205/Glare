import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';

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
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 81, 0, 0),
      height: 759,
      width: 362,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 24.4, 40),
            width: 322,
            height: 62,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
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
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // inputField('First name'),
                    // inputField('Last name'),
                    inputField('Email address', emailController),
                    passwordField('Password', 'assets/icons/Icon_eye.png',passwordController),
                    passwordField('Confirm Password', 'assets/icons/Icon_eye.png',confirmPasswordController),
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
                      // Check other password validity requirements
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Password must be 7-25 characters long, include at least one uppercase letter and one number.'),
                        backgroundColor: Colors.red,
                      ));
                    } else if (!isValidEmail(emailController.text)){

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please enter a valid email address.'),
                        backgroundColor: Colors.red,
                      ));
                    } else {
                      registerWithEmail(); // All checks passed, proceed with registration
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
                )
              ),
              termsAndPrivacy(),
              loginPrompt(loginWithEmail),
            ],
          ),
        ],
      ),
    );
  }

  Widget inputField(String placeholder, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 24),
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

  Widget passwordField(String placeholder, String iconPath, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 24),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
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
                  Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
                  child: Image.asset(iconPath),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
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
