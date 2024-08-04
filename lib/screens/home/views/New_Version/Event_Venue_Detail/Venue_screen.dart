import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glare/screens/home/views/New_Version/explore_screen/event_card.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_repository/user_repository.dart';

import '../../../../background_screen/background_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/event_like_bloc/event_like_bloc.dart';
import '../../../blocs/event_list_by_Ids_bloc/event_list_by_ids_bloc.dart';



class VenueDetail extends StatelessWidget {
  final String name;
  final String address;
  final String description;
  final String pictureUrl;
  final String instagram;
  final String website;
  final List<String> eventIds;
  final List<String> genres;

  const VenueDetail({
    required this.name,
    required this.address,
    required this.description,
    required this.pictureUrl,
    required this.instagram,
    required this.website,
    required this.eventIds,
    required this.genres,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageHeight = screenHeight * 0.26;
    final double widgetWidth = screenWidth * 0.82;

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
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                  child: CustomTitleWithButtons(name: name),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIconButtonWithBorder(
                            icon: Icons.favorite_border,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 10),
                          _buildIconButtonWithBorder(
                            icon: Icons.share,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Container(
                      //   width: widgetWidth,
                      //   height: 50,
                      //   decoration: BoxDecoration(
                      //     border: Border.all(color: const Color(0xFF8FFA58), width: 2.0),
                      //     borderRadius: BorderRadius.circular(30),
                      //     color: const Color(0xFF1A1A1A),
                      //   ),
                      //   child: const Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Icon(Icons.star, color: Color(0xFF8FFA58)),
                      //       Icon(Icons.star, color: Color(0xFF8FFA58)),
                      //       Icon(Icons.star, color: Color(0xFF8FFA58)),
                      //       Icon(Icons.star, color: Color(0xFF8FFA58)),
                      //       Icon(Icons.star, color: Color(0xFF8FFA58)),
                      //     ],
                      //   ),
                      // ),
                      // Text(
                      //   '5.0 Star Rating (52 Reviews) See Reviews',
                      //   style: GoogleFonts.getFont(
                      //     'Inter',
                      //     fontWeight: FontWeight.w500,
                      //     fontSize: 14,
                      //     color: const Color(0xFF8FFA58),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About The Venue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      InformationBox(
                        width: widgetWidth,
                        address: address,
                        description: description,
                        genres: genres,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                  child: const Text(
                    'Upcoming Events',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                  child: BlocBuilder<EventListByIdsBloc, EventListByIdsState>(
                    builder: (context, state) {
                      if (state is EventListByIdsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is EventListByIdsLoaded) {
                        final sortedEvents = state.events..sort((a, b) => a.date!.compareTo(b.date!));
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: sortedEvents.map((event) {
                            final double cardWidth = screenWidth * 0.82;
                            final double cardHeight = MediaQuery.of(context).size.height * 0.132;
                            final double imageSize = cardHeight - 16;
                            final bool isFirstOfDate = sortedEvents.indexOf(event) == 0 ||
                                !_isSameDate(
                                    sortedEvents[sortedEvents.indexOf(event) - 1].date!, event.date!);
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isFirstOfDate)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                      DateFormat('EEEE, dd MMMM yyyy').format(event.date!),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                EventCard(
                                  event: event,
                                  cardWidth: cardWidth,
                                  cardHeight: cardHeight,
                                  imageSize: imageSize,
                                  isLiked: state.likedEvents.contains(event.eventId),
                                  likesCount: state.likesCount[event.eventId] ?? 0,
                                ),
                              ],
                            );
                          }).toList(),
                        );
                      } else if (state is EventListByIdsError) {
                        return const Text(
                          'Failed to load events',
                          style: TextStyle(color: Colors.red),
                        );
                      }
                      return const SizedBox.shrink();
                    },
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

  Widget _buildIconButtonWithBorder({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: const Color(0xFF8FFA58), width: 2.0),
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF8FFA58)),
        onPressed: onPressed,
      ),
    );
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}

class CustomTitleWithButtons extends StatelessWidget {
  final String name;

  const CustomTitleWithButtons({required this.name, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      height: 56.0,
      child: Center(
        child: Text(
          name,
          style: GoogleFonts.getFont(
            'Inter',
            fontWeight: FontWeight.normal,
            fontSize: 30,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class InformationBox extends StatelessWidget {
  final double width;
  final String address;
  final String description;
  final List<String> genres;

  const InformationBox({
    required this.width,
    required this.address,
    required this.description,
    required this.genres,
    Key? key,
  }) : super(key: key);

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
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF8FFA58)),
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF1A1A1A),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/icons/vector_521_x2.svg',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  genres.join(', '),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF8FFA58),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/icons/buliding_11_x2.svg',
                width: 24,
                height: 24,
                color: const Color(0xFF8FFA58),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () => _launchMapsUrl(address),
                  child: Text(
                    address,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8FFA58),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/icons/Vector.svg',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
