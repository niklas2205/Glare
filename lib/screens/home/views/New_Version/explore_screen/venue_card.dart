import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/screens/home/views/ClickTracking.dart';
import 'package:glare/screens/home/views/New_Version/Event_Venue_Detail/Venue_screen.dart';
import 'package:user_repository/user_repository.dart';
import 'package:venue_repository/venue_repository.dart';

import '../../../blocs/event_list_by_Ids_bloc/event_list_by_ids_bloc.dart';
import '../../../blocs/favourite_venue_bloc/favourite_venue_bloc.dart';
import '../../../blocs/user_bloc/user_bloc.dart';

class VenueCard extends StatelessWidget {
  final Venue venue;
  final bool isFavorite;
  final String userId;
  final double cardWidth;
  final double cardHeight;
  final double imageSize;

  const VenueCard({
    Key? key,
    required this.venue,
    required this.isFavorite,
    required this.userId,
    required this.cardWidth,
    required this.cardHeight,
    required this.imageSize,
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
            onTap: () {
              ClickTrackingService().incrementVenueCardClick(venue.venueId);
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
                                venue.address.length > 23 
                                    ? '${venue.address.substring(0, 23)}...' 
                                    : venue.address,
                                style: const TextStyle(
                                  color: Color(0xFF8FFA58),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                venue.genres.join(', '),
                                style: const TextStyle(
                                  color: Color(0xFF8FFA58),
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
                          context.read<FavouriteVenueBloc>().add(RemoveVenueFromFavorites(userId, venue.venueId));
                        } else {
                          context.read<FavouriteVenueBloc>().add(AddVenueToFavorites(userId, venue.venueId));
                        }
                        context.read<UserBloc>().add(RefreshUserFavorites(userId));
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
  }
}
