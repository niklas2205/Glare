import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/screens/background_screen/background_screen.dart';
import 'package:user_repository/user_repository.dart';
import '../../blocs/onboarding_bloc/onboarding_bloc.dart';
import 'onboarding_screen_foreground.dart'; // Make sure this import points to your foreground widget


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_screen_foreground.dart';
import 'onboarding_screen_frontend2.dart'; // Import your UI elements from the OnboardingScreenForeground file

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 1;

  void _goToNextPage() {
    setState(() {
      _currentPage = 2;
    });
  }

  void _goBack() {
    setState(() {
      _currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompletionSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is OnboardingFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        child: Stack(
          children: [
            BackgroundScreen(),
            SingleChildScrollView(
              child: _currentPage == 1
                  ? OnboardingScreenForeground(onNext: _goToNextPage)
                  : AdditionalDetailsScreen(onBack: _goBack),
            ),
          ],
        ),
      ),
    );
  }
}
