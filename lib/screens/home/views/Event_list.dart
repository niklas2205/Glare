// EventListWidget.dart
import 'package:event_repository/event_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glare/screens/home/blocs/event_like_bloc/event_like_bloc.dart';

import 'package:glare/screens/home/views/Event_screen.dart';


// EventListWidget.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:user_repository/user_repository.dart';


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
          return _buildDateHeader(context, group);
        } else if (group is Event) {
          return _buildEventCard(context, group);
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
              child: Row(
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
                          _buildLikeButton(context, event),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLikeButton(BuildContext context, Event event) {
    return FutureBuilder<MyUser?>(
      future: context.read<UserRepository>().getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No user data');
        } else {
          final user = snapshot.data!;
          return BlocBuilder<EventLikeBloc, EventLikeState>(
            builder: (context, state) {
              if (state is EventLikeLoading) {
                return CircularProgressIndicator();
              } else if (state is EventLikeFailure) {
                return Text('Error: ${state.error}');
              }
              return IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  context.read<EventLikeBloc>().add(LikeEvent(userId: user.userId, eventId: event.eventId));
                },
              );
            },
          );
        }
      },
    );
  }
}
