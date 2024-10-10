

import 'dart:math';

import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/screens/home/blocs/event_like_bloc/event_like_bloc.dart';
import 'package:glare/screens/home/views/New_Version/Event_Venue_Detail/Event_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// Make sure to import your EventLikeBloc and Event classes appropriately

class PromotionEventCard extends StatelessWidget {
  final Event event;

  const PromotionEventCard({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for dynamic sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.6; // 60% of screen width
    final cardHeight = screenHeight * 0.35; // Adjust as needed
    final imageHeight = cardHeight * 0.6; // Image fills the top 60% of the card
    final imageMargin = cardWidth * 0.05; // 5% margin for the image

    final diagonalInches = sqrt(pow(screenWidth, 2) + pow(screenHeight, 2)) / MediaQuery.of(context).devicePixelRatio;

    // Define the threshold height
    final double thresholdHeight = 700.0; // Initial height threshold

    // Extract date info and format month as abbreviated
    final eventDate = event.date ?? DateTime.now();
    final day = '${eventDate.day}';
    final month = DateFormat.MMM().format(eventDate); // Abbreviated month like "Oct"

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.only(right: screenWidth * 0.04), // Spacing between cards
      decoration: BoxDecoration(
        color: Colors.black, // Black background for the card
        borderRadius: BorderRadius.circular(20), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4), // Shadow effect
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          // Navigate to EventDetailPage
          Navigator.push<bool>(
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
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event image with margin
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: imageMargin,
                    left: imageMargin,
                    right: imageMargin,
                  ),
                  width: cardWidth - 2 * imageMargin, // Adjust width for the margin
                  height: imageHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), // Rounded edges for the image
                    image: event.picture != null
                        ? DecorationImage(
                            image: NetworkImage(event.picture!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: Colors.grey[300], // Placeholder color if no image
                  ),
                  child: event.picture == null
                      ? Icon(
                          Icons.event,
                          size: imageHeight * 0.5,
                          color: Colors.grey[700],
                        )
                      : null,
                ),
                // Date in a rounded rectangle on the top-left corner of the image
                Positioned(
                  top: imageMargin * 1.5,
                  left: imageMargin * 1.5,
                  child: Container(
                    width: cardWidth * 0.2, // Square with equal width and height
                    height: cardWidth * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.black, // Solid black background
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day,
                            style: GoogleFonts.getFont(
                              'Inter',
                              fontSize: screenWidth * 0.055,
                              color: const Color(0xFF8FFA58),
                              height: 1.0, // Reduces vertical space
                            ),
                          ),
                          Text(
                            month,
                            style: GoogleFonts.getFont(
                              'Inter',
                              fontSize: screenWidth * 0.03,
                              color: const Color(0xFF8FFA58),
                              height: 1.0, // Ensures tighter vertical spacing
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: cardHeight * 0.03),
            // Event name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: cardWidth * 0.05),
              child: Text(
                event.eventname ?? 'Unnamed Event',
                style: GoogleFonts.getFont(
                  'Inter',
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Venue name and age symbol positioned next to each other
            Padding(
              padding: EdgeInsets.symmetric(horizontal: cardWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    event.venue ?? 'Unknown Venue',
                    style: GoogleFonts.getFont(
                      'Inter',
                      fontSize: screenWidth * 0.035,
                      color: Colors.white70,
                    ),
                  ),
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
            // Likes count
            Padding(
              padding: EdgeInsets.symmetric(horizontal: cardWidth * 0.05),
              child: BlocBuilder<EventLikeBloc, EventLikeState>(
                builder: (context, state) {
                  int likesCount = 0;
                  if (state is EventLikeSuccess) {
                    likesCount = state.likesCount[event.eventId] ?? 0;
                  }
                  return Text(
                    '$likesCount Going',
                    style: GoogleFonts.getFont(
                      'Inter',
                      fontSize: screenWidth * 0.035,
                      color: const Color(0xFF8FFA58), // Green color for the likes count
                    ),
                  );
                },
              ),
            ),
            // Event tags (conditionally displayed)
            if (screenHeight >= thresholdHeight && diagonalInches < 7) // Conditional check
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: cardWidth * 0.05,
                  vertical: cardHeight * 0.01,
                ),
                child: Wrap(
                  spacing: 4,
                  children: (event.eventTag ?? []).map((tag) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.getFont(
                          'Inter',
                          fontSize: screenWidth * 0.03,
                          color: const Color(0xFF8FFA58),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
