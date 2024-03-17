import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:glare/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:glare/screens/home/blocs/get_event_bloc/get_event_bloc.dart';

import 'screens/auth/views/welcome_screen.dart';
import 'screens/home/views/home_screen.dart';

class MainAppView extends StatelessWidget {
  const MainAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Glare Events',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: const ColorScheme.light(
                background: Colors.white,
                onBackground: Colors.black,
                primary: Colors.blue,
                onPrimary: Colors.white)),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: ((context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SignInBloc(
                        context.read<AuthenticationBloc>().userRepository),
                  ),
                  BlocProvider(
                    create: (context) => GetEventBloc(
                      FirebaseEventRepo()
                    )..add(GetEvent()),
                  ),
                ],
                child: const HomeScreen(),
              );
            } else {
              return const WelcomeScreen();
            }
          }),
        ));
  }
}
