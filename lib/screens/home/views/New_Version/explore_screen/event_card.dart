import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user_repository/user_repository.dart';

import '../../../blocs/event_like_bloc/event_like_bloc.dart';
import '../Event_Venue_Detail/Event_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final double cardWidth;
  final double cardHeight;
  final double imageSize;
  final bool isLiked;
  final int likesCount;

  const EventCard({
    Key? key,
    required this.event,
    required this.cardWidth,
    required this.cardHeight,
    required this.imageSize,
    required this.isLiked,
    required this.likesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Material(
          elevation: 5,
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              final bool result = await Navigator.push<bool>(
                context,
                MaterialPageRoute<bool>(
                  builder: (BuildContext context) => EventDetail(
                    name: event.eventname,
                    venue: event.venue,
                    description: event.description,
                    pictureUrl: event.picture,
                    age: event.age,
                    eventId: event.eventId,
                    venueId: event.venueId,
                    eventTag: event.eventTag,
                  ),
                ),
              ) ?? false; // Default to false if the result is null

              if (result) {
                context.read<EventLikeBloc>().add(LoadEventLikeCount(event.eventId));
                final user = await context.read<UserRepository>().getCurrentUser();
                if (user != null) {
                  context.read<EventLikeBloc>().add(LoadLikedEvents(user.userId));
                }
              }
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
                              const SizedBox(height: 2),
                              Text(
                                '$likesCount Going',
                                style: const TextStyle(
                                  color: Color(0xFF8FFA58),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                              const Spacer(), // Pushes the tags to the bottom
                              Row(
                                children: event.eventTag.map((tag) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1A1A1A),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                      child: Text(
                                        tag,
                                        style: const TextStyle(
                                          color: Color(0xFF8FFA58),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 8), // Adjust the gap as needed
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: cardHeight * 0.24,
                    right: cardWidth * 0.06,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final user = await context.read<UserRepository>().getCurrentUser();
                            if (user != null) {
                              if (isLiked) {
                                context.read<EventLikeBloc>().add(UnlikeEvent(userId: user.userId, eventId: event.eventId));
                              } else {
                                context.read<EventLikeBloc>().add(LikeEvent(userId: user.userId, eventId: event.eventId));
                              }
                            }
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isLiked ? Color(0xFF8FFA58) : const Color(0xFF1A1A1A),
                              border: isLiked ? null : Border.all(color: Color(0xFF8FFA58)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0), // Adjust the padding as needed
                              child: SvgPicture.asset(
                                '/Users/niklasheckmann/Desktop/Development/Glare/assets/icons/bx_party.svg',
                                color: isLiked ? Color(0xFF1A1A1A) : Color(0xFF8FFA58),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10), // Adjust the gap as needed
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1A1A1A),
                            border: Border.all(color: Color(0xFF8FFA58)),
                          ),
                          child: Center(
                            child: Text(
                              '${event.age}+',
                              style: const TextStyle(
                                color: Color(0xFF8FFA58),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}

