import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_repository/event_repository.dart';
import 'package:glare/screens/home/blocs/get_event_bloc/get_event_bloc.dart';
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
      if (event.eventId != null) {
        _eventLikeBloc.add(LoadEventLikeCount(event.eventId!));
      }
    });

    // Load liked events for the current user
    _loadLikedEvents();
  }

  Future<void> _loadLikedEvents() async {
    final user = await context.read<UserRepository>().getCurrentUser();
    if (user != null) {
      _eventLikeBloc.add(LoadLikedEvents(user.userId));
    }
  }

  Future<void> _refreshEventsAndLikes(BuildContext context) async {
    final getEventBloc = context.read<GetEventBloc>();
    final userRepository = context.read<UserRepository>();

    // Fetch and update events
    getEventBloc.add(LoadEvents());

    // Fetch and update liked events
    final user = await userRepository.getCurrentUser();
    if (user != null) {
      _eventLikeBloc.add(LoadLikedEvents(user.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedEvents = _groupEventsByDate(widget.events);

    return ListView.builder(
      controller: widget.scrollController,
      padding: EdgeInsets.zero, // Ensure no padding at the start
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
