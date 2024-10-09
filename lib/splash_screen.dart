import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:glare/screens/auth/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:glare/screens/auth/views/onboarding/onboarding_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Flags to track if navigation has been handled
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          // Listener for AuthenticationBloc
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, authState) {
              if (authState.status == AuthenticationStatus.authenticated) {
                // Trigger onboarding check
                context.read<OnboardingBloc>().add(OnboardingStarted());
              } else if (!_hasNavigated) {
                _hasNavigated = true;
                Navigator.of(context).pushReplacementNamed('/welcome');
              }
            },
          ),
          // Listener for OnboardingBloc
          BlocListener<OnboardingBloc, OnboardingState>(
            listener: (context, onboardingState) {
              if (onboardingState is OnboardingCompletionSuccess && !_hasNavigated) {
                _hasNavigated = true;
                Navigator.of(context).pushReplacementNamed('/home');
              } else if (onboardingState is OnboardingNotCompleted && !_hasNavigated) {
                _hasNavigated = true;
                Navigator.of(context).pushReplacementNamed('/onboarding');
              }
            },
          ),
        ],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}