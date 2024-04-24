import 'package:event_repository/event_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:glare/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:glare/screens/home/blocs/home_screen_bloc/home_screen_bloc.dart';
import 'package:glare/screens/home/blocs/get_event_bloc/get_event_bloc.dart';
import 'package:glare/screens/home/blocs/get_venue_bloc/get_venue_bloc.dart';
import 'package:glare/screens/home/views/home_screen1.dart';
import 'package:user_repository/user_repository.dart';
import 'package:venue_favorite_repository/venue_fav_repo.dart';
import 'package:venue_repository/venue_repository.dart';

import 'screens/auth/views/welcome_screen.dart';
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
            colorScheme: ColorScheme.dark(
                primary: Color(0xFF13B8A8),
                onPrimary: Colors.black,
                surface: Colors.black,
                onSurface: Color(0xFF13B8A8),
                background: Colors.black,
                onBackground: Color(0xFF13B8A8)),
            textTheme: TextTheme(
              headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Color(0xFF13B8A8)),
              headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: Color(0xFF13B8A8)),
              bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Color(0xFF13B8A8)),
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: Color(0xFF13B8A8),
              textTheme: ButtonTextTheme.primary,
            )
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: ((context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<SignInBloc>(
                    create: (context) => SignInBloc(
                      context.read<AuthenticationBloc>().userRepository,
                    ),
                  ),
                  BlocProvider<GetEventBloc>(
                    create: (context) => GetEventBloc(
                      FirebaseEventRepo(),
                    )..add(GetEvent()),
                  ),
                  // Add the HomeScreenBloc provider if it is required for HomeScreen1
                  BlocProvider<HomeScreenBloc>(
                    create: (context) => HomeScreenBloc(),
                  ),
                  // Add the GetVenueBloc provider here
                  BlocProvider<GetVenueBloc>(
                    create: (context) => GetVenueBloc(FirebaseVenueRepo())..add(GetVenue()) // Replace VenueRepo() with your venue repository instance
                  ),
                  // Adding UserBloc
                  BlocProvider<UserBloc>(
                    create: (context) => UserBloc(userRepository: userRepository),// Adjust UserRepository instantiation as per your project setup
                  ),
                   BlocProvider<FavouriteVenueBloc>(
                    create: (context) => FavouriteVenueBloc(context.read<DatabaseRepository>(),),
                   ),
                ],
                child: const HomeScreen1(),
              );
            } else {
              return const WelcomeScreen();
            }

          }),
        ));
  }
}
