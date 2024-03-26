import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/app_view.dart';
import 'package:glare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:venue_favorite_repository/venue_fav_repo.dart';

class MainApp extends StatelessWidget {
  final UserRepository userRepository;

  const MainApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(userRepository: userRepository),
        ),
        RepositoryProvider<DatabaseRepository>(
          create: (context) => DatabaseRepository(),
        ),
      ],
      child: MainAppView(userRepository: userRepository), // Pass it here
    );
  }
}