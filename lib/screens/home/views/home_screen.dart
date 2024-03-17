import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:glare/screens/home/blocs/get_event_bloc/get_event_bloc.dart';
import 'package:glare/screens/home/views/Event_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Row(
          children: [
            Text(
              'Event List',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(CupertinoIcons.heart),
          ),
          IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(SignOutRequired());
            },
            icon: const Icon(CupertinoIcons.arrow_right_to_line),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<GetEventBloc, GetEventState>(
          builder: (context, state) {
            if (state is GetEventSuccess) {
              return ListView.builder(
                itemCount: state.events.length,
                itemBuilder: (context, int i) {
                  var event = state.events[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    child: Material(
                      elevation: 3,
                      color: const Color.fromARGB(215, 148, 240, 142),
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          var event = state.events[i]; // Get the specific event data
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => EventDetail(
                                name: event.eventname, // Pass the event name
                                venue: event.venue, // Pass the event venue
                                description: event.description, // Pass the event description
                                pictureUrl: event.picture, // Pass the event picture URL
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 80,
                          margin: const EdgeInsets.symmetric(
                            vertical: 8, 
                            horizontal: 5,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    event.picture,
                                    height: 90,
                                    width: 110,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, top: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        event.eventname,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        event.venue,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(CupertinoIcons.hand_thumbsup),
                                  iconSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is GetEventLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: Text("An error has occurred"),
              );
            }
          },
        ),
      ),
    );
  }
}
