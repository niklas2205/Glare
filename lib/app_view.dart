import 'package:event_repository/event_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:glare/screens/auth/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:glare/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:glare/screens/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:glare/screens/auth/views/onboarding/onboarding.dart';
import 'package:glare/screens/auth/views/sign_in/sign_in_screen.dart';
import 'package:glare/screens/auth/views/sign_up/sign_up_screen.dart';
import 'package:glare/screens/home/blocs/home_screen_bloc/home_screen_bloc.dart';
import 'package:glare/screens/home/blocs/get_event_bloc/get_event_bloc.dart';
import 'package:glare/screens/home/blocs/get_venue_bloc/get_venue_bloc.dart';
import 'package:glare/screens/home/views/home_screen1.dart';
import 'package:user_repository/user_repository.dart';
import 'package:venue_favorite_repository/venue_fav_repo.dart';
import 'package:venue_repository/venue_repository.dart';

import 'screens/auth/views/welcome_screen_comp/welcome_screen.dart';
import 'screens/home/blocs/favourite_venue_bloc/favourite_venue_bloc.dart';
import 'screens/home/blocs/user_bloc/user_bloc.dart';


class MainAppView extends StatelessWidget {
  final UserRepository userRepository;

  const MainAppView({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glare Events',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8FFA58),
          onPrimary: Colors.black,
          surface: Colors.black,
          onSurface: Color(0xFF8FFA58),
          background: Colors.black,
          onBackground: Color(0xFF8FFA58)
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Color(0xFF8FFA58)),
          displayMedium: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: Color(0xFF8FFA58)),
          displaySmall: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Color(0xFF8FFA58)),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF13B8A8),
          textTheme: ButtonTextTheme.primary,
        )
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            // Set up multiple blocs to manage various aspects of the app
            return MultiBlocProvider(
              providers: [
                BlocProvider<SignInBloc>(
                  create: (context) => SignInBloc(userRepository),
                ),
                BlocProvider<SignUpBloc>(
                  create: (context) => SignUpBloc(userRepository),
                ),
                BlocProvider<GetEventBloc>(
                  create: (context) => GetEventBloc(FirebaseEventRepo())..add(GetEvent()),
                ),
                BlocProvider<HomeScreenBloc>(
                  create: (context) => HomeScreenBloc(),
                ),
                BlocProvider<GetVenueBloc>(
                  create: (context) => GetVenueBloc(FirebaseVenueRepo())..add(GetVenue()),
                ),
                BlocProvider<UserBloc>(
                  create: (context) => UserBloc(userRepository: userRepository),
                ),
                BlocProvider<FavouriteVenueBloc>(
                  create: (context) => FavouriteVenueBloc(context.read<DatabaseRepository>()),
                ),
                BlocProvider<OnboardingBloc>(
                  create: (context) => OnboardingBloc(userRepository: userRepository)..add(OnboardingStarted()),
                ),
              ],
              child: BlocConsumer<OnboardingBloc, OnboardingState>(
                listener: (context, onboardingState) {
                  if (onboardingState is OnboardingCompletionSuccess) {
                    Navigator.of(context).pushReplacementNamed('/home');
                  }
                },
                builder: (context, onboardingState) {
                  if (onboardingState is OnboardingLoadInProgress) {
                    return const CircularProgressIndicator();
                  } else if (onboardingState is OnboardingDataSubmitted) {
                    return const HomeScreen1();
                  } else if (onboardingState is OnboardingInitial || onboardingState is OnboardingDataSubmitted) {
                    return const OnboardingScreen();
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            );
          } else {
            return const WelcomeScreen();
          }
        }
      ),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen1(),
        '/signIn': (context) => const SignInScreen(),
        '/signUp': (context) => const SignUpScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}