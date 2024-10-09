import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
  // Removed ageController
  final List<String> genders = ['Male', 'Female', 'Diverse', 'Rather not say'];
  String? selectedGender;

  DateTime? selectedDateOfBirth; // Added this variable

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
          buildDateOfBirthField(context), // Replaced age field with date of birth field
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

  // New method for Date of Birth field
  Widget buildDateOfBirthField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        width: 322,
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF8FFA58)),
          borderRadius: BorderRadius.circular(100),
          color: const Color(0xFF1A1A1A),
        ),
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        child: Text(
          selectedDateOfBirth != null
              ? DateFormat('yyyy-MM-dd').format(selectedDateOfBirth!)
              : 'Date of Birth',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: selectedDateOfBirth != null
                ? Colors.white
                : Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  // Method to display the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 18)), // Default to 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(), // Customize as needed
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDateOfBirth) {
      setState(() {
        selectedDateOfBirth = picked;
      });
    }
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
    padding: EdgeInsets.zero,
    margin: const EdgeInsets.only(bottom: 24),
    child: DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        value: selectedGender,
        hint: Text(
          'Gender',
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.5),
            fontSize: 16,
          ),
        ),
        items: genders.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedGender = newValue;
          });
        },
        customButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                selectedGender ?? 'Gender',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: selectedGender == null
                      ? Colors.white.withOpacity(0.5)
                      : Colors.white,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF8FFA58),
                size: 24,
              ),
            ),
          ],
        ),
        buttonStyleData: ButtonStyleData(
          height: 56,
          padding: EdgeInsets.zero,  // Remove padding, handled by customButton
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: const Color(0xFF1A1A1A),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF1A1A1A),
            border: Border.all(color: const Color(0xFF8FFA58)),
          ),
          maxHeight: 200,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
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
        onPressed: () async {
          // Validation: Ensure date of birth is selected
          if (selectedDateOfBirth == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please select your date of birth')),
            );
            return;
          }

          // Retrieve the current user to get userId and email
          final MyUser? currentUser = await context.read<UserRepository>().getCurrentUser();
          final String userId = currentUser?.userId ?? '';
          final String email = currentUser?.email ?? '';

          final String firstName = firstNameController.text.trim();
          final String lastName = lastNameController.text.trim();
          final String fullName = '$firstName $lastName'.trim();

          final updatedUser = MyUser(
            userId: userId,
            email: email,
            name: fullName,
            dateOfBirth: selectedDateOfBirth, // Updated field
            phoneNumber: phoneController.text.trim(),
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
