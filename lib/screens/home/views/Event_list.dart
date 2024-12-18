import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_repository/event_repository.dart';
import 'package:glare/screens/home/blocs/get_event_bloc/get_event_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:intl/intl.dart';
import '../blocs/event_like_bloc/event_like_bloc.dart';
import 'New_Version/explore_screen/event_card.dart';

class EventListWidget extends StatelessWidget {
  final List<Event> events;

  const EventListWidget({
    Key? key,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupedEvents = _groupEventsByDate(events);

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: groupedEvents.length,
      itemBuilder: (context, index) {
        final group = groupedEvents[index];
        if (group is DateTime) {
          return _buildDateHeader(context, group);
        } else if (group is Event) {
          final double cardWidth = MediaQuery.of(context).size.width * 0.82;
          final double cardHeight = 100;
          final double imageSize = cardHeight - 16;
          return EventCard(
            event: group,
            cardWidth: cardWidth,
            cardHeight: cardHeight,
            imageSize: imageSize,
          );
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

  Widget _buildDateHeader(BuildContext context, DateTime date) {
    final formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(date);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = screenWidth * 0.82;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: (screenWidth - cardWidth) / 2),
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
}