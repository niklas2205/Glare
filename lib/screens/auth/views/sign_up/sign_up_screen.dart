

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:glare/screens/auth/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:glare/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:glare/screens/auth/views/onboarding/onboarding_screen.dart';
import 'package:glare/screens/auth/views/sign_in/sign_in_screen.dart';
import 'package:glare/screens/auth/views/sign_up/sign_up_foreground.dart';
import 'package:glare/screens/background_screen/background_screen.dart';
import 'package:user_repository/user_repository.dart';



import '../../blocs/sign_up_bloc/sign_up_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          // Navigate to the onboarding screen with the newly created user
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<OnboardingBloc>(
                      create: (context) => OnboardingBloc(userRepository: context.read<AuthenticationBloc>().userRepository)
                        ..add(OnboardingStarted()),
                    ),
                  ],
                  child: OnboardingScreen(),
                );
              },
            ),
          );
        } else if (state is SignUpFailure) {
          // Display a SnackBar if registration fails
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Registration Failed! Email taken.'),
            backgroundColor: Colors.red,
          ));
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            BackgroundScreen(),
            Form(
              key: _formKey,
              child: SignUpFore1(
              
                emailController: emailController,
                passwordController: passwordController,
                confirmPasswordController: confirmPasswordController,
                registerWithEmail: _registerUser,
                loginWithEmail: _loginWithEmail,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registerUser() {
    // Printing the values in email and password controllers
    print('Attempting to register with email: ${emailController.text} and password: ${passwordController.text}');

    // Check if the form inputs are valid
    if (_formKey.currentState!.validate()) {
      // Additional debug to confirm validation passed
      print('Form validation passed');

      // Ensure the email and password fields are not empty
      if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
        // Create a new MyUser instance with the relevant data
        MyUser myUser = MyUser(
          userId: '', // ID will be set after authentication typically
          email: emailController.text,
          // Assuming other fields will be added later
        );

        // Submit the registration request to the bloc
        context.read<SignUpBloc>().add(SignUpRequired(myUser, passwordController.text));
      } else {
        // Log or handle cases where email or password is empty
        print('Email or password field is empty');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Email and password cannot be empty!'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      // Log validation failure
      print('Form validation failed');
    }
  }

  void _loginWithEmail() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return BlocProvider<SignInBloc>(
          create: (_) => SignInBloc(context.read<AuthenticationBloc>().userRepository),
          child: const SignInScreen(),
        );
      }),
    );
  }
}
















//       child: Form(
//         key: _formKey,
//         child: Align(
//           alignment: Alignment.topCenter,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
// 								const SizedBox(height: 20),
// 								SizedBox(
// 									width: MediaQuery.of(context).size.width * 0.9,
// 									child: MyTextField(
// 										controller: emailController,
// 										hintText: 'Email',
// 										obscureText: false,
// 										keyboardType: TextInputType.emailAddress,
// 										prefixIcon: const Icon(CupertinoIcons.mail_solid),
// 										validator: (val) {
// 											if(val!.isEmpty) {
// 												return 'Please fill in this field';													
// 											}  else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val))  {
// 												return 'Please enter a valid email';
// 											}
// 											return null;
// 										}
// 									),
// 								),
// 								const SizedBox(height: 10),
// 								SizedBox(
// 									width: MediaQuery.of(context).size.width * 0.9,
// 									child: MyTextField(
// 										controller: passwordController,
// 										hintText: 'Password',
// 										obscureText: obscurePassword,
// 										keyboardType: TextInputType.visiblePassword,
// 										prefixIcon: const Icon(CupertinoIcons.lock_fill),
// 										onChanged: (val) {
// 											if(val!.contains(RegExp(r'[A-Z]'))) {
// 												setState(() {
// 													containsUpperCase = true;
// 												});
// 											} else {
// 												setState(() {
// 													containsUpperCase = false;
// 												});
// 											}																			
// 											if(val.length >= 8) {
// 												setState(() {
// 													contains8Length = true;
// 												});
// 											} else {
// 												setState(() {
// 													contains8Length = false;
// 												});
// 											}
// 											return null;
// 										},
// 										suffixIcon: IconButton(
// 											onPressed: () {
// 												setState(() {
// 													obscurePassword = !obscurePassword;
// 													if(obscurePassword) {
// 														iconPassword = CupertinoIcons.eye_fill;
// 													} else {
// 														iconPassword = CupertinoIcons.eye_slash_fill;
// 													}
// 												});
// 											},
// 											icon: Icon(iconPassword),
// 										),
// 										validator: (val) {
// 											if(val!.isEmpty) {
// 												return 'Please fill in this field';			
// 											} 
//                       //else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val))  {
// 												//return 'Please enter a valid password';
// 											//}
// 											return null;
// 										}
// 									),
// 								),
// 								const SizedBox(height: 10),
// 								SizedBox(
// 									width: MediaQuery.of(context).size.width * 0.9,
// 									child: MyTextField(
// 										controller: nameController,
// 										hintText: 'Name',
// 										obscureText: false,
// 										keyboardType: TextInputType.name,
// 										prefixIcon: const Icon(CupertinoIcons.person_fill),
// 										validator: (val) {
// 											if(val!.isEmpty) {
// 												return 'Please fill in this field';													
// 											} else if(val.length > 30) {
// 												return 'Name too long';
// 											}
// 											return null;
// 										}
// 									),
// 								),

//                 // Age (Date) Input
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   child: TextFormField(
//                     controller: TextEditingController(
//                       text: selectedDate != null
//                           ? DateFormat('yyyy-MM-dd').format(selectedDate!)
//                           : ''),
//                     decoration: const InputDecoration(
//                       hintText: 'Select Age',
//                       prefixIcon: Icon(Icons.calendar_today),
//                     ),
//                     readOnly: true,
//                     onTap: () => _selectDate(context),
//                     validator: (val) {
//                       if (val == null || val.isEmpty) {
//                         return 'Please select your age';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 // Favorite Genre Input
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   child: MyTextField(
//                     controller: favoriteGenreController,
//                     hintText: 'Favorite Genre (Optional)',
//                     obscureText: false,
//                     keyboardType: TextInputType.text,
//                     prefixIcon: const Icon(Icons.music_note),
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 // Phone Number Input
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   child: MyTextField(
//                     controller: phoneNumberController,
//                     hintText: 'Phone Number (Optional)',
//                     obscureText: false,
//                     keyboardType: TextInputType.phone,
//                     prefixIcon: const Icon(Icons.phone),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
// 								SizedBox(height: MediaQuery.of(context).size.height * 0.02),
// 								!signUpRequired
// 									? SizedBox(
// 											width: MediaQuery.of(context).size.width * 0.5,
// 											child: TextButton(
// 												onPressed: () {
// 													if (_formKey.currentState!.validate()) {
// 														MyUser myUser = MyUser(
//                               userId: '', // Will be set after authentication
//                               email: emailController.text,
//                               name: nameController.text,
//                               hasActiveCart: false, // Assuming default is false
//                               age: selectedDate ?? DateTime.now(), // Use the selected date or a default
//                               favoriteGenre: favoriteGenreController.text.isNotEmpty 
//                                   ? favoriteGenreController.text 
//                                   : null, // Set to null if empty
//                               phoneNumber: phoneNumberController.text.isNotEmpty 
//                                   ? phoneNumberController.text 
//                                   : null, // Set to null if empty
//                             );
// 														setState(() {
// 															context.read<SignUpBloc>().add(
// 																SignUpRequired(
// 																	myUser,
// 																	passwordController.text
// 																)
// 															);
// 														});																			
// 													}
// 												},
// 												style: TextButton.styleFrom(
// 													elevation: 3.0,
// 													backgroundColor: Theme.of(context).colorScheme.primary,
// 													foregroundColor: Colors.white,
// 													shape: RoundedRectangleBorder(
// 														borderRadius: BorderRadius.circular(60)
// 													)
// 												),
// 												child: const Padding(
// 													padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
// 													child: Text(
// 														'Sign Up',
// 														textAlign: TextAlign.center,
// 														style: TextStyle(
// 															color: Colors.white,
// 															fontSize: 16,
// 															fontWeight: FontWeight.w600
// 														),
// 													),
// 												)
// 											),
// 										)
// 									: const CircularProgressIndicator()
// 							],
// 						),
// 					),
//         )
//       ),
// 		);
//   }
// }