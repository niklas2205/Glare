import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/screens/auth/views/welcome_screen_comp/welcome_frontend.dart';
import 'package:glare/screens/background_screen/background_screen.dart';

import 'welcome_screen_comp/welcome_backg.dart';

import '../../../blocs/authentication_bloc/authentication_bloc.dart';
import '../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../blocs/sign_up_bloc/sign_up_bloc.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
//import 'package:instax/screens/authentication/sign_in_screen.dart';
//import 'package:instax/screens/authentication/sign_up_screen.dart';

import 'package:google_fonts/google_fonts.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void _onContinueWithEmailPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return BlocProvider<SignUpBloc>(
            create: (_) => SignUpBloc(
              context.read<AuthenticationBloc>().userRepository,
            ),
            child: const SignUpScreen(),
          );
        },
      ),
    );
    print("Continue with Email Pressed");
  }

  void _onContinueWithGooglePressed() {
    // Handle continue with Google logic
    print("Continue with Google Pressed");
  }

  void _onContinueWithApplePressed() {
    // Handle continue with Apple logic
    print("Continue with Apple Pressed");
  }

  void _onContinueWithLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return BlocProvider<SignInBloc>(
            create: (_) => SignInBloc(
              context.read<AuthenticationBloc>().userRepository,
            ),
            child: const SignInScreen(),
          );
        },
      ),
    );
    print("Continue with Login Pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WelcomeBackground(), // Background widget
          WelcomeFrontend(
            onContinueWithEmail: _onContinueWithEmailPressed,
            onContinueWithGoogle: _onContinueWithGooglePressed,
            onContinueWithApple: _onContinueWithApplePressed,
            onContinueWithLogin: _onContinueWithLogin,
          ),
        ],
      ),
    );
  }
}














//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             fit: BoxFit.cover,
//             image: AssetImage(
//               'assets/Style_img/kajetan-sumila-EUAzJnKSNQg-unsplash.png',
//             ),
//           ),
//         ),
//         child: SizedBox(
//           width: double.infinity,
//           height: 942,
//           child: Container(
//             padding: const EdgeInsets.fromLTRB(34, 15, 26.6, 0),
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 Positioned(
//                   left: -1,
//                   top: 40,
//                   child: Text(
//                     'Glare',
//                     style: GoogleFonts.getFont(
//                       'Major Mono Display',
//                       fontWeight: FontWeight.w400,
//                       fontSize: 30,
//                       color: const Color(0xFF8FFA58),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }










//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
// 			backgroundColor: Theme.of(context).colorScheme.background,
// 			appBar: AppBar(
// 				elevation: 0,
// 				backgroundColor: Colors.transparent,
// 			),
// 			body: SingleChildScrollView(
// 				child: SizedBox(
// 					height: MediaQuery.of(context).size.height,
// 					child: Padding(
// 						padding: const EdgeInsets.symmetric(horizontal: 20),
// 						child: Column(
// 							children: [
// 								const Text(
// 									'Welcome Back !',
// 									style: TextStyle(
// 										fontSize: 24,
// 										fontWeight: FontWeight.bold
// 									),
// 								),
// 								const SizedBox(height: kToolbarHeight),
// 								TabBar(
// 									controller: tabController,
// 									unselectedLabelColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
// 									labelColor: Theme.of(context).colorScheme.onBackground,
// 									tabs: const [
// 										Padding(
// 											padding: EdgeInsets.all(12.0),
// 											child: Text(
// 												'Sign In',
// 												style: TextStyle(
// 													fontSize: 18,
// 												),
// 											),
// 										),
// 										Padding(
// 											padding: EdgeInsets.all(12.0),
// 											child: Text(
// 												'Sign Up',
// 												style: TextStyle(
// 													fontSize: 18,
// 												),
// 											),
// 										),
// 									]
// 								),
// 								Expanded(
// 									child: TabBarView(
// 										controller: tabController,
// 										children: [
// 											BlocProvider<SignInBloc>(
// 												create: (context) => SignInBloc(
// 													context.read<AuthenticationBloc>().userRepository
// 												),
// 												child: const SignInScreen(),
// 											),
// 											BlocProvider<SignUpBloc>(
// 												create: (context) => SignUpBloc(
// 													context.read<AuthenticationBloc>().userRepository
// 												),
// 												child: const SignUpScreen(),
// 											),
// 										]
// 									),
// 								)
// 							],
// 						),
// 					),
// 				),
// 			),
// 		);
//   }
// }