import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:glare/screens/auth/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:glare/screens/auth/views/onboarding/onboarding_screen.dart';
import 'package:glare/screens/auth/views/welcome_screen_comp/welcome_screen.dart';
import 'package:user_repository/user_repository.dart';

class PostAuthScreen extends StatefulWidget {
  @override
  _PostAuthScreenState createState() => _PostAuthScreenState();
}

class _PostAuthScreenState extends State<PostAuthScreen> {
  bool _timeoutOccurred = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();

    // Set a timeout of 10 seconds
    Future.delayed(Duration(seconds: 10), () {
      if (mounted && !_timeoutOccurred) {
        _timeoutOccurred = true;
        // Navigate to WelcomeScreen if still on PostAuthScreen after timeout
        Navigator.of(context).pushReplacementNamed('/welcome');
      }
    });
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      final MyUser? user = await context.read<UserRepository>().getCurrentUser();

      if (_timeoutOccurred || !mounted) return; // Prevent navigation if timeout occurred

      if (user == null) {
        Navigator.of(context).pushReplacementNamed('/welcome');
        return;
      }

      if (user.name == null || user.name!.isEmpty) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      } else {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (_timeoutOccurred || !mounted) return;
      Navigator.of(context).pushReplacementNamed('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
