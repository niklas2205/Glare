import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:glare/screens/auth/blocs/onboarding_bloc/onboarding_bloc.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthenticationStatus();
  }

  Future<void> _checkAuthenticationStatus() async {
    final authenticationBloc = context.read<AuthenticationBloc>();
    final onboardingBloc = context.read<OnboardingBloc>();

    // Wait for the AuthenticationBloc to finish its initial check
    await authenticationBloc.stream.firstWhere((state) =>
        state.status != AuthenticationStatus.unknown);

    if (authenticationBloc.state.status == AuthenticationStatus.authenticated) {
      // Check onboarding status
      onboardingBloc.add(OnboardingStarted());
      await onboardingBloc.stream.firstWhere((state) =>
          state is! OnboardingInitial);

      if (onboardingBloc.state is OnboardingCompletionSuccess) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
