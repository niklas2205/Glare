import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:glare/screens/home/blocs/home_screen_bloc/home_screen_bloc.dart';
import 'package:glare/screens/home/blocs/home_screen_bloc/home_screen_event.dart';
import 'package:glare/screens/home/blocs/get_event_bloc/get_event_bloc.dart';
import 'package:glare/screens/home/blocs/get_venue_bloc/get_venue_bloc.dart';
import 'package:glare/screens/home/views/Event_list.dart';
import 'package:glare/screens/home/views/Venue_list.dart';
import '../blocs/home_screen_bloc/home_screen_state.dart';
import '../blocs/user_bloc/user_bloc.dart';

class HomeScreen1 extends StatelessWidget {
  const HomeScreen1({super.key});

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
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: const Text(
              'Event List',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Color(0xFF13B8A8)),
            ),
            actions: [
              IconButton(
                onPressed: () {}, 
                icon: const Icon(CupertinoIcons.heart, color: Color(0xFF13B8A8)),
              ),
              IconButton(
                onPressed: () {
                  context.read<SignInBloc>().add(SignOutRequired());
                },
                icon: const Icon(CupertinoIcons.arrow_right_to_line, color: Color(0xFF13B8A8)),
              ),
              BlocBuilder<HomeScreenBloc, HomeScreenState>(
                builder: (context, state) {
                  return Switch(
                    value: state.view == HomeScreenView.venues,
                    onChanged: (bool value) {
                      context.read<HomeScreenBloc>().add(
                        ToggleViewEvent(value ? HomeScreenView.venues : HomeScreenView.events)
                      );
                    },
                    activeColor: Color(0xFF13B8A8),
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.white30,
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<HomeScreenBloc, HomeScreenState>(
            builder: (context, homeState) {
              if (homeState.view == HomeScreenView.events) {
                return BlocBuilder<GetEventBloc, GetEventState>(
                  builder: (context, eventState) {
                    if (eventState is GetEventSuccess) {
                      return EventListWidget(eventState: eventState);
                    }
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF13B8A8)));
                  },
                );
              } else if (homeState.view == HomeScreenView.venues) {
                return BlocBuilder<GetVenueBloc, GetVenueState>(
                  builder: (context, venueState) {
                    if (venueState is GetVenueSuccess) {
                      return VenueListWidget(state: venueState);
                    }
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF13B8A8)));
                  },
                );
              }
              return const Center(child: Text("No view selected"));
            },
          ),
        ),
      ),
    );
  }
}