import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:glare/screens/home/blocs/user_bloc/user_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:user_repository/user_repository.dart';

import '../../../../background_screen/background_screen.dart';
import '../../../blocs/user_update_bloc/user_update_bloc.dart';



class PersonalDetails extends StatefulWidget {
  const PersonalDetails({Key? key}) : super(key: key);

  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  // Removed ageController
  final List<String> genders = ['Male', 'Female', 'Diverse', 'Rather not say'];
  String? selectedGender;

  DateTime? selectedDateOfBirth; // Added this variable

  @override
  void initState() {
    super.initState();
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      final user = userState.user;
      nameController.text = user.name ?? '';
      emailController.text = user.email;
      phoneController.text = user.phoneNumber ?? '';
      selectedGender = user.gender ?? genders.last;
      selectedDateOfBirth = user.dateOfBirth; // Initialize date of birth
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserUpdateBloc, UserUpdateState>(
    listener: (context, state) {
      if (state is UserUpdateSuccess) {
        // Dispatch event to refresh user data
        context.read<UserBloc>().add(FetchUserData());

        // Navigate back one screen
        Navigator.pop(context);
      } else if (state is UserUpdateFailure) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user data')),
        );
      }
    },
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          BackgroundScreen(),
          Column(
            children: [
              const SizedBox(height: 60), // Space for the status bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Transform.rotate(
                        angle: 3.14159, // 180 degrees in radians
                        child: SvgPicture.asset(
                          'assets/icons/Profile_screen/ic_expand_more.svg',
                          width: 24,
                          height: 24,
                          color: const Color(0xFF8FFA58),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Personal Details',
                      style: TextStyle(
                        color: Color(0xFF8FFA58),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildInputField('Name', nameController),
                          buildInputField('Email', emailController),
                          buildInputField('Phone', phoneController),
                          buildDateOfBirthField(context), // Replaced age field
                          buildDropdownField(context),
                          buildUpdateButton(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Container(
      width: 322,
      height: 82, // Increased height to include the title
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF8FFA58)),
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xFF1A1A1A),
            ),
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
                  contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                  hintStyle: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // New method for Date of Birth field
  Widget buildDateOfBirthField(BuildContext context) {
    return Container(
      width: 322,
      height: 82, // Increased height to include the title
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date of Birth',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF8FFA58)),
                borderRadius: BorderRadius.circular(100),
                color: const Color(0xFF1A1A1A),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                selectedDateOfBirth != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDateOfBirth!)
                    : 'Select Date of Birth',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: selectedDateOfBirth != null
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to display the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateOfBirth ?? DateTime.now().subtract(Duration(days: 365 * 18)),
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
      height: 82, // Increased height to include the title
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF8FFA58)),
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xFF1A1A1A),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
              },
              items: genders.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUpdateButton(BuildContext context) {
    return Container(
      width: 322,
      height: 48,
      margin: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFF8FFA58)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: const BorderSide(color: Color(0xFF8FFA58)),
            ),
          ),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        onPressed: () {
          final updatedUser = {
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'phoneNumber': phoneController.text.trim(),
            'dateOfBirth': selectedDateOfBirth, // Updated field
            'gender': selectedGender,
          };
          context.read<UserUpdateBloc>().add(UpdateUserDetails(updatedUser));
        },
        child: const Text(
          'Update',
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
