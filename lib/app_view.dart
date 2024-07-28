import 'package:event_repository/event_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:glare/screens/auth/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:glare/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:glare/screens/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:glare/screens/auth/views/onboarding/onboarding_screen_foreground.dart';
import 'package:glare/screens/auth/views/sign_in/sign_in_screen.dart';
import 'package:glare/screens/auth/views/sign_up/sign_up_screen.dart';
import 'package:glare/screens/home/blocs/change_genre_bloc/change_genre_bloc.dart';
import 'package:glare/screens/home/blocs/event_like_bloc/event_like_bloc.dart';
import 'package:glare/screens/home/blocs/home_screen_bloc/home_screen_bloc.dart';
import 'package:glare/screens/home/blocs/get_event_bloc/get_event_bloc.dart';
import 'package:glare/screens/home/blocs/get_venue_bloc/get_venue_bloc.dart';
import 'package:glare/screens/home/views/New_Version/main_screen.dart';
import 'package:user_repository/user_repository.dart';
import 'package:venue_favorite_repository/venue_fav_repo.dart';
import 'package:venue_repository/venue_repository.dart';

import 'screens/auth/views/onboarding/onboarding_screen.dart';
import 'screens/auth/views/welcome_screen_comp/welcome_screen.dart';
import 'screens/home/blocs/event_list_by_Ids_bloc/event_list_by_ids_bloc.dart';
import 'screens/home/blocs/favourite_venue_bloc/favourite_venue_bloc.dart';
import 'screens/home/blocs/search_venue_bloc/search_venue_bloc.dart';
import 'screens/home/blocs/user_bloc/user_bloc.dart';
import 'screens/home/blocs/user_update_bloc/user_update_bloc.dart';


class MainAppView extends StatelessWidget {
  final UserRepository userRepository;

  const MainAppView({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (_) => userRepository,
        ),
        RepositoryProvider<EventRepo>(
          create: (_) => FirebaseEventRepo(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(userRepository: userRepository),
          ),
          BlocProvider<SignInBloc>(
            create: (context) => SignInBloc(context.read<AuthenticationBloc>().userRepository),
          ),
          BlocProvider<SignUpBloc>(
            create: (context) => SignUpBloc(context.read<AuthenticationBloc>().userRepository),
          ),
          BlocProvider<GetEventBloc>(
            create: (context) => GetEventBloc(context.read<EventRepo>())..add(GetEvent()),
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
            create: (context) {
              return OnboardingBloc(userRepository: userRepository)
                ..add(OnboardingStarted());
            },
          ),
          BlocProvider<EventLikeBloc>(
            create: (context) => EventLikeBloc(
              userRepository: context.read<UserRepository>(),
              eventRepository: context.read<EventRepo>(),
            ),
          ),
          BlocProvider<EventListByIdsBloc>(
            create: (context) => EventListByIdsBloc(
              context.read<EventRepo>(),
              context.read<UserRepository>(),
            ),
          ),
          BlocProvider<UserUpdateBloc>(
            create: (context) => UserUpdateBloc(userRepository: context.read<UserRepository>()),
          ),
          BlocProvider<ChangeGenreBloc>(
          create: (context) => ChangeGenreBloc(userRepository: userRepository),
        ),
        ],
        child: MaterialApp(
          title: 'Glare Events',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF8FFA58),
              onPrimary: Colors.black,
              surface: Colors.black,
              onSurface: Color(0xFF8FFA58),
              background: Colors.black,
              onBackground: Color(0xFF8FFA58),
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                fontSize: 72.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8FFA58),
              ),
              displayMedium: TextStyle(
                fontSize: 36.0,
                fontStyle: FontStyle.italic,
                color: Color(0xFF8FFA58),
              ),
              displaySmall: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Hind',
                color: Color(0xFF8FFA58),
              ),
            ),
            buttonTheme: const ButtonThemeData(
              buttonColor: Color(0xFF8FFA58),
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state.status == AuthenticationStatus.authenticated) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<OnboardingBloc>.value(
                      value: context.read<OnboardingBloc>(),
                    ),
                  ],
                  child: BlocBuilder<OnboardingBloc, OnboardingState>(
                    builder: (context, onboardingState) {
                      if (onboardingState is OnboardingCompletionSuccess) {
                        return const MainScreen();
                      } else {
                        return OnboardingScreen();
                      }
                    },
                  ),
                );
              } else if (state.status == AuthenticationStatus.unauthenticated) {
                print('Status Unauthenticated');
                return const WelcomeScreen();
              } else {
                return const WelcomeScreen();
              }
            },
          ),
          routes: {
            '/welcome': (context) => const WelcomeScreen(),
            '/home': (context) => const MainScreen(),
            '/signIn': (context) => const SignInScreen(),
            '/signUp': (context) => const SignUpScreen(),
            '/onboarding': (context) => OnboardingScreen(),
          },
        ),
      ),
    );
  }
}

