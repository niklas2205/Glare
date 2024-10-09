import 'dart:async';

import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/screens/background_screen/background_screen.dart';
import 'package:glare/screens/home/blocs/recomended_venue_bloc/recomended_venue_bloc.dart';
import 'package:glare/screens/home/blocs/event_like_bloc/event_like_bloc.dart';
import 'package:glare/screens/home/blocs/recomended_events_bloc/recomended_events_bloc.dart';
import 'package:glare/screens/home/blocs/user_bloc/user_bloc.dart';
import 'package:glare/screens/home/views/New_Version/explore_screen/venue_card.dart';
import 'package:glare/screens/home/views/New_Version/home_screen/Promotional_event_card.dart';
import 'package:glare/screens/home/views/Venue_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:venue_repository/venue_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final paddingHorizontal = screenWidth * 0.1;
    final paddingVertical = screenHeight * 0.00;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background widget
          BackgroundScreen(),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
              vertical: paddingVertical,
            ),
            
            // Wrap the content in SingleChildScrollView
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.08),
                  Text(
                    'Upcoming Events',
                    style: GoogleFonts.getFont(
                      'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF8FFA58),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Event Carousel
                  BlocProvider(
                    create: (context) => RecommendedEventsBloc(
                      eventRepo: context.read<EventRepo>(),
                      eventLikeBloc: context.read<EventLikeBloc>(),
                    )..fetchRecommendedEvents(),
                    child: BlocBuilder<RecommendedEventsBloc, List<Event>>(
                      builder: (context, recommendedEvents) {
                        if (recommendedEvents.isEmpty) {
                          return const Center(child: Text('No recommended events'));
                        }
                        return EventCarousel(events: recommendedEvents);
                      },
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Recommended Venues Header
                  Text(
                    'Recommended for you',
                    style: GoogleFonts.getFont(
                      'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF8FFA58),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Recommended Venues List
                  BlocProvider(
                    create: (context) => RecommendedVenuesBloc(
                      venueRepo: context.read<VenueRepo>(),
                      userBloc: context.read<UserBloc>(),
                    ),
                    child: BlocListener<UserBloc, UserState>(
                      listener: (context, userState) {
                        if (userState is UserLoaded) {
                          // Dispatch FetchRecommendedVenues only when the user data is loaded
                          context.read<RecommendedVenuesBloc>().add(const FetchRecommendedVenues());
                        }
                      },
                      child: BlocBuilder<RecommendedVenuesBloc, RecommendedVenuesState>(
                        builder: (context, state) {
                          if (state is RecommendedVenuesLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is RecommendedVenuesLoaded) {
                            return _buildVenueList(context, state.venues, screenWidth);
                          } else if (state is RecommendedVenuesEmpty) {
                            return const Center(child: Text('No recommended venues'));
                          } else if (state is RecommendedVenuesError) {
                            return Center(child: Text(state.message));
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom method to build the venue list
  Widget _buildVenueList(BuildContext context, List<Venue> venues, double screenWidth) {
    final double cardWidth = screenWidth * 0.82;
    final double cardHeight = 100;
    final double imageSize = cardHeight - 16;

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        String userId = '';
        List<String> favoriteVenues = [];

        if (userState is UserLoaded) {
          userId = userState.user.userId;
          favoriteVenues = userState.favoriteVenueIds;
        }

        // Adjust ListView.builder
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: venues.length,
          physics: const NeverScrollableScrollPhysics(), // Disable inner scrolling
          shrinkWrap: true, // Let ListView take the minimum height
          itemBuilder: (context, int index) {
            final venue = venues[index];
            final isFavorite = favoriteVenues.contains(venue.venueId);

            return Padding(
              padding: const EdgeInsets.only(
                top: 0.0,
                bottom: 0,
              ),
              child: VenueCard(
                venue: venue,
                isFavorite: isFavorite,
                userId: userId,
                cardWidth: cardWidth,
                cardHeight: cardHeight,
                imageSize: imageSize,
              ),
            );
          },
        );
      },
    );
  }
}



class EventCarousel extends StatefulWidget {
  final List<Event> events; // List of events

  const EventCarousel({Key? key, required this.events}) : super(key: key);

  @override
  _EventCarouselState createState() => _EventCarouselState();
}

class _EventCarouselState extends State<EventCarousel> {
  final PageController _pageController = PageController();
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    // Set up the auto-rotation every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 7), (Timer timer) {
      if (_currentPage < widget.events.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Event PageView
        SizedBox(
          height: screenHeight * 0.35, // Adjusted the height for the carousel
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.events.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final event = widget.events[index];
              return Center(
                child: PromotionEventCard(event: event), // Your custom event card widget
              );
            },
          ),
        ),

        // Adjusted gap between the carousel and the circular indicators
        SizedBox(height: screenHeight * 0.03),

        // Circular indicators for the PageView
        SmoothPageIndicator(
          controller: _pageController,
          count: widget.events.length,
          effect: const ExpandingDotsEffect(
            activeDotColor: Color(0xFF8FFA58), // Green active dot color
            dotColor: Colors.grey,
            dotHeight: 10,
            dotWidth: 10,
            expansionFactor: 2.5,
          ),
        ),
      ],
    );
  }
}
