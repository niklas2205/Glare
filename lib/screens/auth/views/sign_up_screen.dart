import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:user_repository/user_repository.dart';

import '../../../components/my_text_field.dart';
import '../blocs/sign_up_bloc/sign_up_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final favoriteGenreController = TextEditingController();
  final phoneNumberController = TextEditingController();
  DateTime? selectedDate; // Nullable DateTime for age
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool contains8Length = false;

  // Function to show a date picker
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          return;
        }
      },
      child: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
								const SizedBox(height: 20),
								SizedBox(
									width: MediaQuery.of(context).size.width * 0.9,
									child: MyTextField(
										controller: emailController,
										hintText: 'Email',
										obscureText: false,
										keyboardType: TextInputType.emailAddress,
										prefixIcon: const Icon(CupertinoIcons.mail_solid),
										validator: (val) {
											if(val!.isEmpty) {
												return 'Please fill in this field';													
											}  else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val))  {
												return 'Please enter a valid email';
											}
											return null;
										}
									),
								),
								const SizedBox(height: 10),
								SizedBox(
									width: MediaQuery.of(context).size.width * 0.9,
									child: MyTextField(
										controller: passwordController,
										hintText: 'Password',
										obscureText: obscurePassword,
										keyboardType: TextInputType.visiblePassword,
										prefixIcon: const Icon(CupertinoIcons.lock_fill),
										onChanged: (val) {
											if(val!.contains(RegExp(r'[A-Z]'))) {
												setState(() {
													containsUpperCase = true;
												});
											} else {
												setState(() {
													containsUpperCase = false;
												});
											}																			
											if(val.length >= 8) {
												setState(() {
													contains8Length = true;
												});
											} else {
												setState(() {
													contains8Length = false;
												});
											}
											return null;
										},
										suffixIcon: IconButton(
											onPressed: () {
												setState(() {
													obscurePassword = !obscurePassword;
													if(obscurePassword) {
														iconPassword = CupertinoIcons.eye_fill;
													} else {
														iconPassword = CupertinoIcons.eye_slash_fill;
													}
												});
											},
											icon: Icon(iconPassword),
										),
										validator: (val) {
											if(val!.isEmpty) {
												return 'Please fill in this field';			
											} 
                      //else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val))  {
												//return 'Please enter a valid password';
											//}
											return null;
										}
									),
								),
								const SizedBox(height: 10),
								SizedBox(
									width: MediaQuery.of(context).size.width * 0.9,
									child: MyTextField(
										controller: nameController,
										hintText: 'Name',
										obscureText: false,
										keyboardType: TextInputType.name,
										prefixIcon: const Icon(CupertinoIcons.person_fill),
										validator: (val) {
											if(val!.isEmpty) {
												return 'Please fill in this field';													
											} else if(val.length > 30) {
												return 'Name too long';
											}
											return null;
										}
									),
								),

                // Age (Date) Input
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    controller: TextEditingController(
                      text: selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                          : ''),
                    decoration: const InputDecoration(
                      hintText: 'Select Age',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please select your age';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Favorite Genre Input
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                    controller: favoriteGenreController,
                    hintText: 'Favorite Genre (Optional)',
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    prefixIcon: const Icon(Icons.music_note),
                  ),
                ),
                const SizedBox(height: 10),

                // Phone Number Input
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                    controller: phoneNumberController,
                    hintText: 'Phone Number (Optional)',
                    obscureText: false,
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 10),
								SizedBox(height: MediaQuery.of(context).size.height * 0.02),
								!signUpRequired
									? SizedBox(
											width: MediaQuery.of(context).size.width * 0.5,
											child: TextButton(
												onPressed: () {
													if (_formKey.currentState!.validate()) {
														MyUser myUser = MyUser(
                              userId: '', // Will be set after authentication
                              email: emailController.text,
                              name: nameController.text,
                              hasActiveCart: false, // Assuming default is false
                              age: selectedDate ?? DateTime.now(), // Use the selected date or a default
                              favoriteGenre: favoriteGenreController.text.isNotEmpty 
                                  ? favoriteGenreController.text 
                                  : null, // Set to null if empty
                              phoneNumber: phoneNumberController.text.isNotEmpty 
                                  ? phoneNumberController.text 
                                  : null, // Set to null if empty
                            );
														setState(() {
															context.read<SignUpBloc>().add(
																SignUpRequired(
																	myUser,
																	passwordController.text
																)
															);
														});																			
													}
												},
												style: TextButton.styleFrom(
													elevation: 3.0,
													backgroundColor: Theme.of(context).colorScheme.primary,
													foregroundColor: Colors.white,
													shape: RoundedRectangleBorder(
														borderRadius: BorderRadius.circular(60)
													)
												),
												child: const Padding(
													padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
													child: Text(
														'Sign Up',
														textAlign: TextAlign.center,
														style: TextStyle(
															color: Colors.white,
															fontSize: 16,
															fontWeight: FontWeight.w600
														),
													),
												)
											),
										)
									: const CircularProgressIndicator()
							],
						),
					),
        )
      ),
		);
  }
}