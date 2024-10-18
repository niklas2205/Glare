import 'package:flutter/material.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:glare/screens/auth/blocs/onboarding_bloc/onboarding_bloc.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _timeoutOccurred = false;

  @override
  void initState() {
    super.initState();

    // Set a timeout of 10 seconds
    Future.delayed(Duration(seconds: 10), () {
      if (mounted && !_timeoutOccurred) {
        _timeoutOccurred = true;
        // Navigate to WelcomeScreen if still on SplashScreen after timeout
        Navigator.of(context).pushReplacementNamed('/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, authState) {
          if (_timeoutOccurred) return; // Prevent navigation if timeout occurred

          if (authState.status == AuthenticationStatus.authenticated) {
            context.read<OnboardingBloc>().add(OnboardingStarted());
          } else if (authState.status == AuthenticationStatus.unauthenticated) {
            Navigator.of(context).pushReplacementNamed('/welcome');
          } else if (authState.status == AuthenticationStatus.error) {
            // Handle authentication error
            Navigator.of(context).pushReplacementNamed('/welcome');
          }
        },
        builder: (context, authState) {
          if (authState.status == AuthenticationStatus.authenticated) {
            return BlocConsumer<OnboardingBloc, OnboardingState>(
              listener: (context, onboardingState) {
                if (_timeoutOccurred) return;

                if (onboardingState is OnboardingCompletionSuccess) {
                  Navigator.of(context).pushReplacementNamed('/home');
                } else if (onboardingState is OnboardingRequired) {
                  Navigator.of(context).pushReplacementNamed('/onboarding');
                } else if (onboardingState is OnboardingFailure) {
                  Navigator.of(context).pushReplacementNamed('/welcome');
                }
              },
              builder: (context, onboardingState) {
                return Center(child: CircularProgressIndicator());
              },
            );
          } else if (authState.status == AuthenticationStatus.error) {
            // Show error message or navigate away
            return Center(child: Text('An error occurred.'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
