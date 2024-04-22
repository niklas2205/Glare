// EventListWidget.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glare/screens/home/blocs/get_event_bloc/get_event_bloc.dart';
import 'package:glare/screens/home/views/Event_screen.dart';


// EventListWidget.dart
class EventListWidget extends StatelessWidget {
  final GetEventSuccess eventState;

  const EventListWidget({Key? key, required this.eventState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: eventState.events.length,
      itemBuilder: (context, int i) {
        var event = eventState.events[i];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: Material(
              elevation: 3,
              color: const Color.fromARGB(215, 148, 240, 142),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => EventDetail(
                        name: event.eventname,
                        venue: event.venue,
                        description: event.description,
                        pictureUrl: event.picture,
                      ),
                    ),
                  );
                },
                child: _buildEventRow(event),
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildEventRow(dynamic event) {
    // Replace 'dynamic' with your event model class
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
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
    );
  }
