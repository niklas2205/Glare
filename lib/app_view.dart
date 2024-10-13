import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:glare/screens/auth/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:glare/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:glare/screens/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:glare/screens/auth/views/sign_in/sign_in_screen.dart';
import 'package:glare/screens/auth/views/sign_up/sign_up_screen.dart';
import 'package:glare/screens/home/blocs/recomended_venue_bloc/recomended_venue_bloc.dart';
import 'package:glare/screens/home/blocs/change_genre_bloc/change_genre_bloc.dart';
import 'package:glare/screens/home/blocs/event_like_bloc/event_like_bloc.dart';
import 'package:glare/screens/home/blocs/home_screen_bloc/home_screen_bloc.dart';
import 'package:glare/screens/home/blocs/get_event_bloc/get_event_bloc.dart';
import 'package:glare/screens/home/blocs/get_venue_bloc/get_venue_bloc.dart';
import 'package:glare/screens/home/blocs/recomended_events_bloc/recomended_events_bloc.dart';

import 'package:glare/screens/home/views/New_Version/Profile_screen/Add_friends.dart';
import 'package:glare/screens/home/views/New_Version/Profile_screen/Manage_friends.dart';
import 'package:glare/screens/home/views/New_Version/main_screen.dart';
import 'package:glare/splash_screen.dart';
import 'package:user_repository/user_repository.dart';
import 'package:venue_favorite_repository/venue_fav_repo.dart';
import 'package:venue_repository/venue_repository.dart';

import 'screens/auth/views/onboarding/onboarding_screen.dart';
import 'screens/auth/views/welcome_screen_comp/welcome_screen.dart';
import 'screens/home/blocs/event_list_by_Ids_bloc/event_list_by_ids_bloc.dart';
import 'screens/home/blocs/favourite_venue_bloc/favourite_venue_bloc.dart';
import 'screens/home/blocs/friends_bloc/friends_bloc.dart';
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
        RepositoryProvider<VenueRepo>(    // Add this line
          create: (_) => FirebaseVenueRepo(),  // Implement the FirebaseVenueRepo
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
            create: (context) => OnboardingBloc(userRepository: userRepository),
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
          BlocProvider<FriendsBloc>(
            create: (context) => FriendsBloc(userRepository: userRepository),
          ),
          BlocProvider<RecommendedEventsBloc>(
            create: (context) => RecommendedEventsBloc(
              eventRepo: context.read<EventRepo>(),
              eventLikeBloc: context.read<EventLikeBloc>(),
            ),
          ),
          BlocProvider<RecommendedVenuesBloc>(
            create: (context) => RecommendedVenuesBloc(
              venueRepo: context.read<VenueRepo>(),
              userBloc: context.read<UserBloc>(),
            ),
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
          home: SplashScreen(),
          routes: {
            '/welcome': (context) => const WelcomeScreen(),
            '/home': (context) => const MainScreen(),
            '/signIn': (context) => const SignInScreen(),
            '/signUp': (context) => const SignUpScreen(),
            '/onboarding': (context) => OnboardingScreen(),
            // '/manage_friends': (context) => ManageFriends(),
            '/add_friends': (context) => const AddFriends(),
          },
        ),
      ),
    );
  }
}


  Widget _buildHome(BuildContext context, AuthenticationState authState) {
    if (authState.status == AuthenticationStatus.authenticated) {
      return OnboardingWrapper();
    } else if (authState.status == AuthenticationStatus.unauthenticated) {
      return const WelcomeScreen();
    } else {
      return SplashScreen();
    }
  }


class OnboardingWrapper extends StatefulWidget {
  @override
  _OnboardingWrapperState createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  @override
  void initState() {
    super.initState();
    // Add the OnboardingStarted event when the widget is initialized
    context.read<OnboardingBloc>().add(OnboardingStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          if (state is OnboardingCompletionSuccess) {
            print('Onboarding complete, navigating to home');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed('/home');
            });
            return SizedBox.shrink();
          } else if (state is OnboardingRequired) {
            print('Onboarding required, navigating to onboarding');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed('/onboarding');
            });
            return SizedBox.shrink();
          } else if (state is OnboardingLoadInProgress) {
            return Center(child: CircularProgressIndicator());
          } else {
            // Default case
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
