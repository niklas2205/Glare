// EventListWidget.dart
import 'package:event_repository/event_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glare/screens/home/blocs/get_event_bloc/get_event_bloc.dart';
import 'package:glare/screens/home/views/Event_screen.dart';


// EventListWidget.dart
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';


import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';


class EventListWidget extends StatelessWidget {
  final List<Event> events;

  const EventListWidget({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, int i) {
        var event = events[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: Material(
            elevation: 5,
            color: Colors.black, // Updated to match the black theme
            borderRadius: BorderRadius.circular(12), // Sleeker borderRadius
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
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

  Widget _buildEventRow(Event event) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12), // Updated borderRadius
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
                      color: Color(0xFF13B8A8), // Updated to neon green color
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.venue,
                    style: const TextStyle(
                      color: Color(0xFF13B8A8), // Updated to neon green color
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
              icon: const Icon(CupertinoIcons.hand_thumbsup, color: Color(0xFF13B8A8)), // Updated icon color to neon green
              iconSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}