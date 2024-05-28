import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';

class SignInFore1 extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback loginWithEmail;
  final VoidCallback registerWithEmail;
  final VoidCallback forgotPasswordbutton;

  const SignInFore1({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.loginWithEmail,
    required this.registerWithEmail,
    required this.forgotPasswordbutton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 81, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          welcomeTextWidget(),
          socialLoginButtons(),
          dividerWithText(),
          EmailAndPasswordFields(emailController, passwordController),
          forgotPassword(forgotPasswordbutton),
          loginButton(loginWithEmail),
          registerbutton(registerWithEmail),
        ],
      ),
    );
  }



  Widget welcomeTextWidget() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 7, 0, 0),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 6.7, 8),
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



  Widget socialLoginButtons() {
    return Container(
      width: 322,
      height: 48,
      margin: const EdgeInsets.fromLTRB(20, 31, 0, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: 48,
              width: 153,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0x52919EAB)),
                borderRadius: BorderRadius.circular(100),
                color: const Color(0xFFFFFFFF),
              ),
              alignment: Alignment.center,
              child: Image.asset('assets/icons/ic_google.png', width: 24, height: 24),
            ),
          ),
          Expanded(
            child: Container(
              height: 48,
              width: 153,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0x52919EAB)),
                borderRadius: BorderRadius.circular(100),
                color: const Color(0xFF1A1A1A),
              ),
              alignment: Alignment.center,
              child: Image.asset('assets/icons/apple.png', width: 24, height: 24),
            ),
          ),
        ],
      ),
    );
  }


// Additional classes like DividerWithText, EmailAndPasswordFields, LoginButton, and RegisterText would be defined similarly.

  Widget dividerWithText() {
    return Container(
      width: 322,
      height: 22,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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



Widget EmailAndPasswordFields(TextEditingController emailController, TextEditingController passwordController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(23, 10, 20, 0), // Moved slightly to the left and down
        child: Container(
          width: 322,
          height: 56,
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
        padding: const EdgeInsets.fromLTRB(23, 22, 20, 0), // Consistent padding as email field
        child: Container(
          width: 322,
          height: 56,
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
            obscureText: true,
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
                child: Image.asset('assets/icons/Icon_eye.png', height: 22.3),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Adjust content padding to center the text properly
            ),
          ),
        ),
      ),
    ],
  );
}




  Widget loginButton (VoidCallback controller) {
    return Container(
      width: 322,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 20),
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


  Widget registerbutton(VoidCallback controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 27, 20, 0),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.getFont(
              'Public Sans',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 1.6,
              color: const Color(0xFF212B36),
            ),
            children: [
              const TextSpan(
                text: 'Don’t have an account?',
                style: TextStyle(color: Color(0xFFFFFFFF)),
              ),
              const TextSpan(text: ' '),
              WidgetSpan(
                child: InkWell(
                  onTap: () {
                    controller();
                  },
                  child: Text(
                    'Register Now!',
                    style: GoogleFonts.getFont(
                      'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: const Color(0xFF8FFA58),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget forgotPassword(VoidCallback controller) {
    return Align(
      alignment: Alignment.centerRight, // Align to the right
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 42, 24), // Adjusted top padding to move it further down
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
}
