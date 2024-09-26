import 'package:event_repository/event_repository.dart';
import 'package:flutter/gestures.dart';
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
import '../../../blocs/event_list_by_Ids_bloc/event_list_by_ids_bloc.dart';
import '../../../blocs/favourite_venue_bloc/favourite_venue_bloc.dart';
import '../../../blocs/get_venue_bloc/get_venue_bloc.dart';
import '../../../blocs/user_bloc/user_bloc.dart';

import 'Venue_screen.dart';
class EventDetail extends StatelessWidget {
  final String name;
  final String venue;
  final String description;
  final String pictureUrl;
  final int age;
  final String eventId;
  final String venueId;
  final List<String> eventTag;
  final String location; 
  final String price;

  const EventDetail({
    required this.name,
    required this.venue,
    required this.description,
    required this.pictureUrl,
    required this.age,
    required this.eventId,
    required this.venueId,
    required this.eventTag,
    required this.location,
    required this.price,
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
                          Navigator.pop(context, true); // Return true to indicate an update
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
                      bool isLiked = false;
                      if (state is EventLikeSuccess) {
                        likesCount = state.likesCount[eventId] ?? 0;
                        isLiked = state.likedEvents.contains(eventId);
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
                  eventTag: eventTag,
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
                      InformationBox(
                        width: widgetWidth,
                        description: description,
                        age: age,
                        location: location,
                        price: price,
                      ),
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
                            return _buildVenueRow(context, venue);
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

  Widget _buildVenueRow(BuildContext context, Venue venue) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = screenWidth * 0.82;
    final double cardHeight = MediaQuery.of(context).size.height * 0.12;
    final double imageSize = cardHeight - 16;

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoaded) {
          bool isFavorite = userState.favoriteVenueIds.contains(venue.venueId);
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
                        builder: (BuildContext context) => BlocProvider(
                          create: (context) => EventListByIdsBloc(
                            context.read<EventRepo>(),
                            context.read<UserRepository>(),
                          )..add(FetchEventsByIds(venue.eventIds)),
                          child: VenueDetail(
                            name: venue.venuename,
                            address: venue.address,
                            description: venue.description,
                            pictureUrl: venue.picture,
                            instagram: venue.instagram,
                            website: venue.website,
                            eventIds: venue.eventIds,
                            genres: venue.genres,
                          ),
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
                                  venue.picture,
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
                                      venue.venuename,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      venue.address,
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
                            onPressed: () {
                              if (isFavorite) {
                                context.read<FavouriteVenueBloc>().add(RemoveVenueFromFavorites(userState.user.userId, venue.venueId));
                              } else {
                                context.read<FavouriteVenueBloc>().add(AddVenueToFavorites(userState.user.userId, venue.venueId));
                              }
                              context.read<UserBloc>().add(RefreshUserFavorites(userState.user.userId));
                            },
                            icon: Icon(
                              isFavorite ? Icons.star : Icons.star_border,
                              color: isFavorite ? const Color(0xFF8FFA58) : Colors.white,
                            ),
                            iconSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class CustomTitleWithButtons extends StatelessWidget {
  final String name;
  final String eventId;
  final List<String> eventTag;

  const CustomTitleWithButtons({
    required this.name,
    required this.eventId,
    required this.eventTag,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Adjusted layout to handle long event names
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Name
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.getFont(
                    'Inter',
                    fontWeight: FontWeight.normal,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                  softWrap: true,
                ),
              ),
              const SizedBox(width: 10),
              // Like Button
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1A1A1A),
                  border: Border.all(
                    color: const Color(0xFF8FFA58),
                    width: 0.5
                    ),
                ),
                child: BlocBuilder<EventLikeBloc, EventLikeState>(
                  builder: (context, state) {
                    bool isLiked = false;
                    if (state is EventLikeSuccess) {
                      isLiked = state.likedEvents.contains(eventId);
                    }
                    return GestureDetector(
                      onTap: () {
                        final userRepository = context.read<UserRepository>();
                        userRepository.getCurrentUser().then((user) {
                          if (user != null) {
                            if (isLiked) {
                              context.read<EventLikeBloc>().add(
                                  UnlikeEvent(userId: user.userId, eventId: eventId));
                            } else {
                              context.read<EventLikeBloc>().add(
                                  LikeEvent(userId: user.userId, eventId: eventId));
                            }
                          }
                        });
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isLiked ? const Color(0xFF8FFA58) : const Color(0xFF1A1A1A),
                          border: isLiked ? null : Border.all(color: const Color(0xFF8FFA58)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            'assets/icons/bx_party.svg',
                            color: isLiked ? const Color(0xFF1A1A1A) : const Color(0xFF8FFA58),
                            width: 25,
                            height: 25,
                            
                          ),
                        ),
                      ),
                    );
                  },
                ),

              ),
            ],
          ),
          const SizedBox(height: 4),
          // Event Tags
          Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: eventTag.map((tag) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 0, 0, 0.23),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}





class InformationBox extends StatefulWidget {
  final double width;
  final String description;
  final int age;
  final String location;
  final String price;

  const InformationBox({
    required this.width,
    required this.description,
    required this.age,
    required this.location,
    required this.price,
    Key? key,
  }) : super(key: key);

  @override
  _InformationBoxState createState() => _InformationBoxState();
}

class _InformationBoxState extends State<InformationBox> {
  bool isExpanded = false;

  void toggleDescription() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  Future<void> _launchMapsUrl(String query) async {
    final googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    final appleMapsUrl = Uri.parse('https://maps.apple.com/?q=$query');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else if (await canLaunchUrl(appleMapsUrl)) {
      await launchUrl(appleMapsUrl);
    } else {
      // Handle the case when neither URL can be launched
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch map for the address.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine whether to show the price and description rows
    final bool showPrice = widget.price.isNotEmpty;
    final bool showDescription = widget.description.isNotEmpty;

    // Check if description is longer than 100 characters
    final bool isLongDescription = widget.description.length > 100;

    // Determine the text to display based on the expanded state
    final String displayText = isExpanded || !isLongDescription
        ? widget.description
        : '${widget.description.substring(0, 100)}...';

    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF8FFA58)),
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF1A1A1A),
      ),
      padding: const EdgeInsets.all(14), // Consistent padding with Venue's InformationBox
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Age Row (Always Displayed)
          InfoRow(
            iconPath: 'assets/icons/user_8_x2.svg',
            text: '${widget.age}+',
          ),
          // Price Row (Conditionally Displayed)
          if (showPrice)
            InfoRow(
              iconPath: 'assets/icons/dollar_circle_2_x2.svg',
              text: '€${widget.price}',
            ),
          // Location Row (Always Displayed)
          LocationRow(
            location: widget.location,
            iconPath: 'assets/icons/buliding_11_x2.svg',
          ),
          // Description Row (Conditionally Displayed)
          if (showDescription)
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 13.8, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(
                      'assets/icons/Vector.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Description Text and Read More/Show Less Button
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.getFont(
                          'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(text: displayText),
                          if (isLongDescription)
                            TextSpan(
                              text: isExpanded ? ' Show Less' : ' Read More',
                              style: GoogleFonts.getFont(
                                'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: const Color(0xFF8FFA58), // App's green color
                              ),
                              recognizer: TapGestureRecognizer()..onTap = toggleDescription,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
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
      margin: const EdgeInsets.only(bottom: 8), // Consistent bottom margin
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8), // Consistent right margin
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
                'Inter', // Consistent font
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.5,
                letterSpacing: 0.1,
                color: const Color(0xFF8FFA58),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationRow extends StatelessWidget {
  final String location;
  final String iconPath;

  const LocationRow({required this.location, required this.iconPath, Key? key}) : super(key: key);

  Future<void> _launchMapsUrl(String query) async {
    final googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    final appleMapsUrl = Uri.parse('https://maps.apple.com/?q=$query');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else if (await canLaunchUrl(appleMapsUrl)) {
      await launchUrl(appleMapsUrl);
    } else {
      // Handle the case when neither URL can be launched
      // You might want to show a Snackbar or another form of feedback
      // For example:
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Could not launch maps')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8), // Consistent bottom margin
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8), // Consistent right margin
            width: 24,
            height: 24,
            child: SvgPicture.asset(
              iconPath,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => _launchMapsUrl(location),
              child: Text(
                location,
                style: GoogleFonts.getFont(
                  'Inter', // Consistent font
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  height: 1.5,
                  letterSpacing: 0.1,
                  color: const Color(0xFF8FFA58),
                  decorationColor: const Color(0xFF8FFA58),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}