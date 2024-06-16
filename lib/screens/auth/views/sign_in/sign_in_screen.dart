import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:glare/screens/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:glare/screens/auth/views/sign_in/sign_in_foreground.dart';
import 'package:glare/screens/auth/views/sign_up/sign_up_screen.dart';
import 'package:glare/screens/background_screen/background_screen.dart';
import 'package:user_repository/user_repository.dart';

import '../../../../app_view.dart';
import '../../../../components/my_text_field.dart';
import '../../blocs/sign_in_bloc/sign_in_bloc.dart';



class SignInScreen extends StatefulWidget { 
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? _errorMsg;
  bool signInRequired = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          print('Sign in success in BlocListener');
          setState(() {
            signInRequired = false;
          });
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MainAppView(userRepository: context.read<UserRepository>()),
            ),
          );
        } else if (state is SignInProcess) {
          print('Sign in process in BlocListener');
          setState(() {
            signInRequired = true;
          });
        } else if (state is SignInFailure) {
          print('Sign in failure in BlocListener');
          setState(() {
            signInRequired = false;
            _errorMsg = 'Invalid email or password';
          });
        } else {
          print('Unknown state in BlocListener: $state');
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            BackgroundScreen(),
            Form(
              key: _formKey,
              child: SignInFore1(
                emailController: emailController,
                passwordController: passwordController,
                loginWithEmail: _loginWithEmail,
                registerWithEmail: _registerWithEmail,
                forgotPasswordbutton: _forgotPassword,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loginWithEmail() {
    if (_formKey.currentState!.validate()) {
      print('Attempting sign in with email: ${emailController.text}');
      context.read<SignInBloc>().add(SignInRequired(
        emailController.text,
        passwordController.text,
      ));
    }
  }

  void _registerWithEmail() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return BlocProvider<SignUpBloc>(
            create: (_) => SignUpBloc(context.read<UserRepository>()),
            child: const SignUpScreen(),
          );
        },
      ),
    );
  }

  void _forgotPassword() {
    // Handle forgot password logic
  }
}


//       child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 child: MyTextField(
//                     controller: emailController,
//                     hintText: 'Email',
//                     obscureText: false,
//                     keyboardType: TextInputType.emailAddress,
//                     prefixIcon: const Icon(CupertinoIcons.mail_solid),
//                     errorMsg: _errorMsg,
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return 'Please fill in this field';
//                       } 
//                       else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val))  {
//                       return 'Please enter a valid email';
//                       }
//                       return null;
//                     }
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 child: MyTextField(
//                   controller: passwordController,
//                   hintText: 'Password',
//                   obscureText: obscurePassword,
//                   keyboardType: TextInputType.visiblePassword,
//                   prefixIcon: const Icon(CupertinoIcons.lock_fill),
//                   errorMsg: _errorMsg,
//                   validator: (val) {
//                     if (val!.isEmpty) {
//                       return 'Please fill in this field';
//                     } 
//                     return null;
//                   },
//                   suffixIcon: IconButton(
//                     onPressed: () {
//                       setState(() {
//                         obscurePassword = !obscurePassword;
//                         if (obscurePassword) {
//                           iconPassword = CupertinoIcons.eye_fill;
//                         } else {
//                           iconPassword = CupertinoIcons.eye_slash_fill;
//                         }
//                       });
//                     },
//                     icon: Icon(iconPassword),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               !signInRequired
//                   ? SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.9,
//                       height: 50,
//                       child: TextButton(
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               context.read<SignInBloc>().add(SignInRequired(
//                                   emailController.text,
//                                   passwordController.text));
//                             }
//                           },
//                           style: TextButton.styleFrom(
//                               elevation: 3.0,
//                               backgroundColor:
//                                   Theme.of(context).colorScheme.primary,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(60))),
//                           child: const Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 25, vertical: 5),
//                             child: Text(
//                               'Sign In',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           )),
//                     )
//                   : const CircularProgressIndicator()
//             ],
//           )),
//     );
//   }
// }
