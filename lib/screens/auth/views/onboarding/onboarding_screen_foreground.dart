import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_repository/user_repository.dart';

import '../../blocs/onboarding_bloc/onboarding_bloc.dart';

class OnboardingScreenForeground extends StatefulWidget {
  final Function onNext;

  OnboardingScreenForeground({required this.onNext});

  @override
  _OnboardingScreenForegroundState createState() => _OnboardingScreenForegroundState();
}

class _OnboardingScreenForegroundState extends State<OnboardingScreenForeground> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final List<String> genders = ['Male', 'Female', 'Diverse', 'Rather not say'];
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 55, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildHeaderTitle(context),
          buildTellUs(),
          buildInputField('First Name', firstNameController),
          buildInputField('Last Name', lastNameController),
          buildInputField('Phone', phoneController),
          buildInputField('Age', ageController),
          buildDropdownField(context),
          buildNavigationRow(context),
          buildSkipForNowButton(context),
        ],
      ),
    );
  }

  Widget buildHeaderTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(33, 0, 0, 30.5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Glare',
          style: GoogleFonts.majorMonoDisplay(
            fontWeight: FontWeight.w400,
            fontSize: 30,
            color: const Color(0xFF8FFA58),
          ),
        ),
      ),
    );
  }

  Widget buildTellUs() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 45),
      width: 326,
      height: 32,
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Tell us about Yourself',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Container(
      width: 322,
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF8FFA58)),
        borderRadius: BorderRadius.circular(100),
        color: const Color(0xFF1A1A1A),
      ),
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: TextFormField(
          controller: controller,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: label,
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
            hintStyle: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField(BuildContext context) {
    return Container(
      width: 322,
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF8FFA58)),
        borderRadius: BorderRadius.circular(100),
        color: const Color(0xFF1A1A1A),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 24),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
          hintText: 'Select Gender',
          hintStyle: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.5),
            fontSize: 16,
          ),
        ),
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 16,
        ),
        dropdownColor: const Color(0xFF1A1A1A),
        onChanged: (String? newValue) {
          setState(() {
            selectedGender = newValue;
          });
          BlocProvider.of<OnboardingBloc>(context).add(GenderChanged(newValue!));
        },
        items: genders.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget buildNavigationRow(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildNavigationButton(context, 'Next', const Color(0xFF8FFA58), const Color(0xFF1A1A1A)),
      ],
    );
  }

  Widget buildNavigationButton(BuildContext context, String text, Color bgColor, Color textColor) {
    return Container(
      width: 322,
      height: 48,
      margin: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(bgColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: const BorderSide(color: Color(0xFF8FFA58)),
            ),
          ),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        onPressed: () {
          final updatedUser = MyUser(
            userId: context.read<AuthenticationBloc>().state.user!.userId,
            email: context.read<AuthenticationBloc>().state.user!.email,
            name: firstNameController.text + ' ' + lastNameController.text,
            age: int.tryParse(ageController.text),
            phoneNumber: phoneController.text,
            gender: selectedGender,
          );
          BlocProvider.of<OnboardingBloc>(context).add(OnboardingInfoSubmitted(updatedUser));
          widget.onNext();
        },
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget buildSkipForNowButton(BuildContext context) {
    return Container(
      width: 322,
      height: 48,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: () {
          BlocProvider.of<OnboardingBloc>(context).add(SkipOnboarding());
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          "Skip for Now",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
