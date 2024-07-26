import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_repository/event_repository.dart';
import 'package:glare/screens/home/views/New_Version/Event_Venue_Detail/Event_screen.dart';
import 'package:user_repository/user_repository.dart';
import 'package:intl/intl.dart';
import '../blocs/event_like_bloc/event_like_bloc.dart';
import 'New_Version/explore_screen/event_card.dart';

class EventListWidget extends StatefulWidget {
  final List<Event> events;
  final ScrollController scrollController;

  const EventListWidget({
    Key? key,
    required this.events,
    required this.scrollController,
  }) : super(key: key);

  @override
  _EventListWidgetState createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  late EventLikeBloc _eventLikeBloc;

  @override
  void initState() {
    super.initState();
    _eventLikeBloc = context.read<EventLikeBloc>();

    // Fetch initial like counts for all events
    widget.events.forEach((event) {
      _eventLikeBloc.add(LoadEventLikeCount(event.eventId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupedEvents = _groupEventsByDate(widget.events);

    return BlocBuilder<EventLikeBloc, EventLikeState>(
      builder: (context, state) {
        return ListView.builder(
          controller: widget.scrollController,
          padding: EdgeInsets.zero, // Ensure no padding at the start
          itemCount: groupedEvents.length,
          itemBuilder: (context, index) {
            final group = groupedEvents[index];
            if (group is DateTime) {
              return _buildDateHeader(context, group);
            } else if (group is Event) {
              bool isLiked = false;
              int likesCount = 0;
              if (state is EventLikeSuccess) {
                isLiked = state.likedEvents.contains(group.eventId);
                likesCount = state.likesCount[group.eventId] ?? 0;
              }
              final double cardWidth = MediaQuery.of(context).size.width * 0.82;
              final double cardHeight = MediaQuery.of(context).size.height * 0.132;
              final double imageSize = cardHeight - 16;
              return EventCard(
                event: group,
                cardWidth: cardWidth,
                cardHeight: cardHeight,
                imageSize: imageSize,
                isLiked: isLiked,
                likesCount: likesCount,
              );
            }
            return const SizedBox.shrink();
          },
        );
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
