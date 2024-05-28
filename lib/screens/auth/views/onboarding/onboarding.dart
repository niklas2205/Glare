import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/screens/auth/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:user_repository/user_repository.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingBloc>(
      create: (context) => OnboardingBloc(userRepository: context.read<UserRepository>())
        ..add(OnboardingStarted()),
      child: const Scaffold(
        body: Center(
          child: Text('Onboarding Screen'),
        ),
      ),
    );
  }
}