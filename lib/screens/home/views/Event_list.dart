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

import 'package:intl/intl.dart';

class EventListWidget extends StatelessWidget {
  final List<Event> events;
  final ScrollController scrollController;

  const EventListWidget({
    Key? key,
    required this.events,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupedEvents = _groupEventsByDate(events);

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.zero, // Ensure no padding at the start
      itemCount: groupedEvents.length,
      itemBuilder: (context, index) {
        final group = groupedEvents[index];
        if (group is DateTime) {
          return _buildDateHeader(group);
        } else if (group is Event) {
          return _buildEventRow(context, group);
        }
        return const SizedBox.shrink();
      },
    );
  }

  List<dynamic> _groupEventsByDate(List<Event> events) {
    List<dynamic> groupedEvents = [];
    DateTime? currentDate;

    for (var event in events) {
      if (event.date != null && (currentDate == null || !_isSameDate(currentDate, event.date!))) {
        currentDate = event.date;
        groupedEvents.add(currentDate);
      }
      groupedEvents.add(event);
    }

    return groupedEvents;
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  Widget _buildDateHeader(DateTime date) {
    final formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(date);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Text(
        formattedDate,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildEventRow(BuildContext context, Event event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Material(
        elevation: 5,
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
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
          child: Container(
            height: 100,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
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
                            color: Color(0xFF13B8A8),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          event.venue,
                          style: const TextStyle(
                            color: Color(0xFF13B8A8),
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
                    icon: const Icon(CupertinoIcons.hand_thumbsup, color: Color(0xFF13B8A8)),
                    iconSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}