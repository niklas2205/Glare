import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:glare/screens/home/blocs/user_bloc/user_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final TextEditingController ageController = TextEditingController();
  final List<String> genders = ['Male', 'Female', 'Diverse', 'Rather not say'];
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      final user = userState.user;
      nameController.text = user.name ?? '';
      emailController.text = user.email;
      phoneController.text = user.phoneNumber ?? '';
      ageController.text = user.age?.toString() ?? '';
      selectedGender = user.gender ?? genders.last;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          buildInputField('Age', ageController),
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
    );
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
            'name': nameController.text,
            'email': emailController.text,
            'phoneNumber': phoneController.text,
            'age': int.tryParse(ageController.text),
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
