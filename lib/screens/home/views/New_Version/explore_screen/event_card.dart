import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glare/screens/home/views/ClickTracking.dart';
import 'package:user_repository/user_repository.dart';

import '../../../blocs/event_like_bloc/event_like_bloc.dart';
import '../Event_Venue_Detail/Event_screen.dart';


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

  String _truncateWithEllipsis(int cutoff, String text) {
    return (text.length <= cutoff) ? text : '${text.substring(0, cutoff)}...';
  }

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
              if (event.eventId != null) {
                ClickTrackingService().incrementEventCardClick(event.eventId!);
              }
              final bool result = await Navigator.push<bool>(
                context,
                MaterialPageRoute<bool>(
                  builder: (BuildContext context) => BlocProvider.value(
                    value: context.read<EventLikeBloc>(),
                    child: EventDetail(
                      name: event.eventname ?? 'Default Event Name',
                      venue: event.venue ?? 'Default Venue',
                      description: event.description ?? 'No description available.',
                      pictureUrl: event.picture ?? 'https://via.placeholder.com/150',
                      age: event.age ?? 0,
                      eventId: event.eventId ?? 'No Event ID',
                      venueId: event.venueId ?? 'No Venue ID',
                      eventTag: event.eventTag ?? [],
                      location: event.location ?? 'No location specified.',
                      price: event.price ?? 'No price information.',
                      ticket: event.ticket ?? '',
                    ),
                  ),
                ),
              ) ?? false;

              if (result) {
                if (event.eventId != null) {
                  context.read<EventLikeBloc>().add(LoadEventLikeCount(event.eventId!));
                }
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
                      // Image section
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            event.picture ?? 'https://via.placeholder.com/150',
                            width: imageSize,
                            height: imageSize,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/default_event.png',
                                width: imageSize,
                                height: imageSize,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      // Event details
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Event name
                              Text(
                                _truncateWithEllipsis(16, event.eventname ?? 'Default Event Name'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              // Venue name
                              Text(
                                event.venue ?? 'Default Venue',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 2),
                              // Likes count
                              BlocBuilder<EventLikeBloc, EventLikeState>(
                                builder: (context, state) {
                                  bool isLiked = false;
                                  int likesCount = 0;
                                  if (state is EventLikeSuccess) {
                                    isLiked = state.likedEvents.contains(event.eventId);
                                    likesCount = state.likesCount[event.eventId] ?? 0;
                                  }
                                  return Text(
                                    '$likesCount Going',
                                    style: const TextStyle(
                                      color: Color(0xFF8FFA58),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                              const Spacer(),
                              // Event tags
                              Row(
                                children: (event.eventTag ?? []).map((tag) {
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
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Like and Age widgets
                  Positioned(
                    top: cardHeight * 0.24,
                    right: cardWidth * 0.06,
                    child: Column(
                      children: [
                        BlocBuilder<EventLikeBloc, EventLikeState>(
                          builder: (context, state) {
                            bool isLiked = false;
                            if (state is EventLikeSuccess) {
                              isLiked = state.likedEvents.contains(event.eventId);
                            }
                            return GestureDetector(
                              onTap: () async {
                                final user = await context.read<UserRepository>().getCurrentUser();
                                if (user != null && event.eventId != null) {
                                  if (isLiked) {
                                    context.read<EventLikeBloc>().add(UnlikeEvent(userId: user.userId, eventId: event.eventId!));
                                  } else {
                                    context.read<EventLikeBloc>().add(LikeEvent(userId: user.userId, eventId: event.eventId!));
                                  }
                                }
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isLiked ? const Color(0xFF8FFA58) : const Color(0xFF1A1A1A),
                                  border: isLiked ? null : Border.all(color: const Color(0xFF8FFA58)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/bx_party.svg',
                                    color: isLiked ? const Color(0xFF1A1A1A) : const Color(0xFF8FFA58),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1A1A1A),
                            border: Border.all(color: const Color(0xFF8FFA58)),
                          ),
                          child: Center(
                            child: Text(
                              '${event.age ?? 'N/A'}+',
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
