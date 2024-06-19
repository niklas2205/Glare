import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:glare/screens/home/blocs/home_screen_bloc/home_screen_bloc.dart';
import 'package:glare/screens/home/blocs/user_bloc/user_bloc.dart';
import 'package:glare/screens/home/views/New_Version/explore_screen/EventList_screen.dart';
import 'package:glare/screens/home/views/New_Version/explore_screen/togglebutton.dart';
import 'package:glare/screens/home/views/New_Version/explore_screen/venuelist_screen.dart';


import '../../../../background_screen/background_screen.dart';

import '../../../blocs/get_event_bloc/get_event_bloc.dart';
import '../../../blocs/home_screen_bloc/home_screen_event.dart';
import '../../../blocs/home_screen_bloc/home_screen_state.dart';


import '../../../blocs/search_event_bloc/search_event_bloc.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(LoadUserData());

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User Error: ${state.message}')),
          );
        }
      },
      child: BlocProvider<HomeScreenBloc>(
        create: (context) => HomeScreenBloc(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Stack(
            children: [
              BackgroundScreen(),
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          const Text(
                            'Current Location',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 1),
                          const Text(
                            'Munich, Germany',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 25),
                          BlocBuilder<HomeScreenBloc, HomeScreenState>(
                            builder: (context, state) {
                              return CustomToggleButton(
                                isVenueSelected: state.view == HomeScreenView.venues,
                                onToggle: (bool isVenue) {
                                  context.read<HomeScreenBloc>().add(
                                    ToggleViewEvent(isVenue ? HomeScreenView.venues : HomeScreenView.events),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
                        builder: (context, homeState) {
                          if (homeState.view == HomeScreenView.events) {
                            return BlocProvider(
                              create: (context) => SearchBloc(context.read<GetEventBloc>()),
                              child: EventListScreen(),
                            );
                          } else if (homeState.view == HomeScreenView.venues) {
                            return VenueListScreen();
                          } else {
                            return const Center(child: Text("No view selected"));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}