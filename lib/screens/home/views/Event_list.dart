import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_repository/event_repository.dart';
import 'package:glare/screens/home/views/Event_screen.dart';
import 'package:user_repository/user_repository.dart';
import 'package:intl/intl.dart';
import '../blocs/event_like_bloc/event_like_bloc.dart';

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

    return BlocProvider(
      create: (context) => EventLikeBloc(
        userRepository: context.read<UserRepository>(),
        eventRepository: context.read<EventRepo>(),
      ),
      child: BlocBuilder<EventLikeBloc, EventLikeState>(
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
                return _buildEventCard(context, group);
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  List<dynamic> _groupEventsByDate(List<Event> events) {
    List<dynamic> groupedEvents = [];
    DateTime? currentDate;

    for (var event in events) {
      if (event.date != null && (currentDate == null || !_isSameDate(currentDate, event.date))) {
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

  Widget _buildLikeButton(BuildContext context, Event event) {
    return BlocBuilder<EventLikeBloc, EventLikeState>(
      builder: (context, state) {
        if (state is EventLikeSuccess) {
          bool isLiked = state.likedEvents.contains(event.eventId);
          return IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.white,
            ),
            onPressed: () {
              final user = context.read<UserRepository>().getCurrentUser().then((user) {
                if (user != null) {
                  if (isLiked) {
                    context.read<EventLikeBloc>().add(UnlikeEvent(userId: user.userId, eventId: event.eventId));
                  } else {
                    context.read<EventLikeBloc>().add(LikeEvent(userId: user.userId, eventId: event.eventId));
                  }
                }
              });
            },
          );
        }
        return const Icon(
          Icons.favorite_border,
          color: Colors.white,
        );
      },
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = screenWidth * 0.82;
    final double cardHeight = MediaQuery.of(context).size.height * 0.132;
    final double imageSize = cardHeight - 16; // Smaller image size with some padding

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
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
              width: cardWidth,
              height: cardHeight,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            event.picture,
                            width: imageSize, // Smaller square image
                            height: imageSize,
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                event.venue,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 8),
                              BlocBuilder<EventLikeBloc, EventLikeState>(
                                builder: (context, state) {
                                  int likesCount = state is EventLikeSuccess
                                      ? state.likesCount[event.eventId] ?? 0
                                      : 0;
                                  return Text(
                                    '$likesCount Going',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _buildLikeButton(context, event),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}