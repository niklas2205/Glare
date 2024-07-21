import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user_repository/user_repository.dart';

import '../../../blocs/event_like_bloc/event_like_bloc.dart';
import '../Event_Detail/Event_screen.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final double cardWidth;
  final double cardHeight;
  final double imageSize;

  const EventCard({
    Key? key,
    required this.event,
    required this.cardWidth,
    required this.cardHeight,
    required this.imageSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dispatch LoadEventLikeCount event to ensure like count is loaded
    context.read<EventLikeBloc>().add(LoadEventLikeCount(event.eventId));

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
                    age: event.age,
                    eventId: event.eventId,
                    venueId: event.venueId,
                  ),
                ),
              ).then((_) {
                // Refresh the like state when returning from EventDetail
                context.read<EventLikeBloc>().add(LoadEventLikeCount(event.eventId));
              });
            },
            child: BlocListener<EventLikeBloc, EventLikeState>(
              listener: (context, state) {
                if (state is EventLikeSuccess) {
                  // Rebuild widget when state changes
                  // Here we are only listening to the state change
                }
              },
              child: BlocBuilder<EventLikeBloc, EventLikeState>(
                builder: (context, state) {
                  bool isLiked = false;
                  int likesCount = 0;
                  if (state is EventLikeSuccess) {
                    isLiked = state.likedEvents.contains(event.eventId);
                    likesCount = state.likesCount[event.eventId] ?? 0;
                  }
                  return Container(
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
                                  width: imageSize,
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
                                    Text(
                                      '$likesCount Going',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                      ),
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
                          child: IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Color(0xFF8FFA58) : Colors.white,
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
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
