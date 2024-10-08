import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:glare/screens/auth/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:glare/screens/auth/views/onboarding/onboarding_screen.dart';
import 'package:user_repository/user_repository.dart';

class PostAuthScreen extends StatefulWidget {
  @override
  _PostAuthScreenState createState() => _PostAuthScreenState();
}

class _PostAuthScreenState extends State<PostAuthScreen> {
  bool _onboardingChecked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_onboardingChecked) {
      _onboardingChecked = true;
      _checkOnboardingStatus();
    }
  }

  Future<void> _checkOnboardingStatus() async {
    // Fetch user data
    try {
      final MyUser? user = await context.read<UserRepository>().getCurrentUser();
      print('PostAuthScreen - Fetched user data: $user');

      bool isComplete = true;

      // if (user == null || user.age == null || user.age! <= 0) {
      if (user == null|| user.name == "") {
        isComplete = false;
        print("PostAuthScreen - Age is incomplete.");
      }

      if (isComplete) {
        print("PostAuthScreen - Onboarding complete, navigating to /home");
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        print("PostAuthScreen - Onboarding required, navigating to /onboarding");
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
      }
    } catch (e) {
      print("PostAuthScreen - Error checking onboarding status: $e");
      // Handle error, e.g., show a dialog or navigate to an error screen
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can show a loading indicator or a splash image here
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
