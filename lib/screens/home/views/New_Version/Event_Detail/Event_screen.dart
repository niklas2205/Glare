import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glare/screens/background_screen/background_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_repository/user_repository.dart';
import 'package:venue_repository/venue_repository.dart';

import '../../../blocs/event_like_bloc/event_like_bloc.dart';
import '../../../blocs/favourite_venue_bloc/favourite_venue_bloc.dart';
import '../../../blocs/get_venue_bloc/get_venue_bloc.dart';
import '../../../blocs/user_bloc/user_bloc.dart';

import '../explore_screen/venue_card.dart';

class EventDetail extends StatelessWidget {
  final String name;
  final String venue;
  final String description;
  final String pictureUrl;
  final int age;
  final String eventId;
  final String venueId;

  const EventDetail({
    required this.name,
    required this.venue,
    required this.description,
    required this.pictureUrl,
    required this.age,
    required this.eventId,
    required this.venueId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageHeight = screenHeight * 0.26;
    final double widgetWidth = screenWidth * 0.82;
    final double likesWidgetHeight = screenHeight * 0.06;

    // Fetch initial like count for the event
    context.read<EventLikeBloc>().add(LoadEventLikeCount(eventId));

    // Fetch venue details using venueId
    context.read<GetVenueBloc>().add(GetVenue());

    return Scaffold(
      body: Stack(
        children: [
          BackgroundScreen(),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: screenWidth,
                      height: imageHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        image: DecorationImage(
                          image: NetworkImage(pictureUrl),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    Positioned(
                      top: screenHeight * 0.05,
                      left: 20,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  transform: Matrix4.translationValues(0, -likesWidgetHeight / 2, 0),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                  child: BlocBuilder<EventLikeBloc, EventLikeState>(
                    builder: (context, state) {
                      int likesCount = 0;
                      if (state is EventLikeSuccess) {
                        likesCount = state.likesCount[eventId] ?? 0;
                      }
                      return Container(
                        width: widgetWidth,
                        height: likesWidgetHeight,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF8FFA58)),
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xFF1A1A1A),
                        ),
                        child: Center(
                          child: Text(
                            '$likesCount Likes',
                            style: GoogleFonts.getFont(
                              'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: const Color(0xFFE0E0E0),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomTitleWithButtons(
                  name: name,
                  eventId: eventId,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Information',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      InformationBox(width: widgetWidth, description: description, age: age),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Venue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      BlocBuilder<GetVenueBloc, GetVenueState>(
                        builder: (context, state) {
                          if (state is GetVenueSuccess) {
                            final venue = state.venues.firstWhere(
                              (venue) => venue.venueId == venueId,
                              orElse: () => Venue.empty(),
                            );
                            if (venue.venueId.isEmpty) {
                              return const Text(
                                'Venue not found',
                                style: TextStyle(color: Colors.red),
                              );
                            }
                            final double cardWidth = screenWidth * 0.82;
                            final double cardHeight = MediaQuery.of(context).size.height * 0.12;
                            final double imageSize = cardHeight - 16;
                            return VenueCard(
                              venue: venue,
                              isFavorite: context.read<UserBloc>().state is UserLoaded &&
                                  (context.read<UserBloc>().state as UserLoaded)
                                      .favoriteVenueIds
                                      .contains(venue.venueId),
                              userId: context.read<UserBloc>().state is UserLoaded
                                  ? (context.read<UserBloc>().state as UserLoaded).user.userId
                                  : '',
                              cardWidth: cardWidth,
                              cardHeight: cardHeight,
                              imageSize: imageSize,
                            );
                          } else if (state is GetVenueFailure) {
                            return const Text(
                              'Failed to load venue',
                              style: TextStyle(color: Colors.red),
                            );
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTitleWithButtons extends StatelessWidget {
  final String name;
  final String eventId;

  const CustomTitleWithButtons({required this.name, required this.eventId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure that the LoadEventLikeCount event is dispatched to load the like state
    context.read<EventLikeBloc>().add(LoadEventLikeCount(eventId));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      height: 56.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.getFont(
              'Inter',
              fontWeight: FontWeight.normal,
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1A1A1A),
                  border: Border.all(color: Color(0xFF8FFA58)),
                ),
                child: BlocBuilder<EventLikeBloc, EventLikeState>(
                  builder: (context, state) {
                    bool isLiked = false;
                    if (state is EventLikeSuccess) {
                      isLiked = state.likedEvents.contains(eventId);
                    }
                    return IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Color(0xFF8FFA58) : Colors.white,
                      ),
                      onPressed: () {
                        final userRepository = context.read<UserRepository>();
                        userRepository.getCurrentUser().then((user) {
                          if (user != null) {
                            if (isLiked) {
                              context.read<EventLikeBloc>().add(UnlikeEvent(userId: user.userId, eventId: eventId));
                            } else {
                              context.read<EventLikeBloc>().add(LikeEvent(userId: user.userId, eventId: eventId));
                            }
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1A1A1A),
                  border: Border.all(color: Color(0xFF8FFA58)),
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class InformationBox extends StatelessWidget {
  final double width;
  final String description;
  final int age;

  const InformationBox({required this.width, Key? key, required this.description, required this.age}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF8FFA58)),
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFF1A1A1A),
      ),
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 42),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRow(
            iconPath: 'assets/icons/user_8_x2.svg',
            text: '${age}+',
          ),
          const InfoRow(
            iconPath: 'assets/icons/dollar_circle_2_x2.svg',
            text: '€10.00',
          ),
          const InfoRow(
            iconPath: 'assets/icons/vector_521_x2.svg',
            text: 'Genre',
          ),
          const AddressRow(
            address: '123 Address Street, 7601',
            iconPath: 'assets/icons/buliding_11_x2.svg',
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 13.8, 0),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.getFont(
                  'Public Sans',
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w100,
                  fontSize: 16,
                  height: 1.8,
                  color: const Color(0xFFBDBDBD),
                ),
                children: [
                  TextSpan(
                    text: description,
                    style: GoogleFonts.getFont(
                      'Inter',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
                  TextSpan(
                    text: '. ',
                    style: GoogleFonts.getFont(
                      'Public Sans',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
                  TextSpan(
                    text: 'Read More...',
                    style: GoogleFonts.getFont(
                      'Inter',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 1.3,
                      color: Color(0xFF8FFA58),
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
}

class InfoRow extends StatelessWidget {
  final String iconPath;
  final String text;

  const InfoRow({required this.iconPath, required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            width: 24,
            height: 24,
            child: SvgPicture.asset(
              iconPath,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.getFont(
                'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.5,
                letterSpacing: 0.1,
                color: Color(0xFF8FFA58),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddressRow extends StatelessWidget {
  final String address;
  final String iconPath;

  const AddressRow({required this.address, required this.iconPath, Key? key}) : super(key: key);

  Future<void> _launchMapsUrl(String query) async {
    final googleMapsUrl = Uri.parse('comgooglemaps://?q=$query');
    final appleMapsUrl = Uri.parse('https://maps.apple.com/?q=$query');
    final webUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else if (await canLaunchUrl(appleMapsUrl)) {
      await launchUrl(appleMapsUrl);
    } else {
      await launchUrl(webUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            width: 24,
            height: 24,
            child: SvgPicture.asset(
              iconPath,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => _launchMapsUrl(address),
              child: Text(
                address,
                style: GoogleFonts.getFont(
                  'Public Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  height: 1.5,
                  letterSpacing: 0.1,
                  color: Color(0xFF8FFA58),
                  decorationColor: Color(0xFF8FFA58),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20), // Add some spacing before the icon
          Container(
            width: 24,
            height: 24,
            child: SvgPicture.asset(
              'assets/vectors/send_24_x2.svg',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
