import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/screens/home/blocs/get_venue_bloc/get_venue_bloc.dart';
import 'package:glare/screens/home/views/Venue_screen.dart';
import 'package:venue_repository/venue_repository.dart';


import '../../auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import '../blocs/favourite_venue_bloc/favourite_venue_bloc.dart';
import '../blocs/user_bloc/user_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VenueListWidget extends StatelessWidget {
  final List<Venue> venues;

  const VenueListWidget({Key? key, required this.venues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoaded) {
          return ListView.builder(
            itemCount: venues.length,
            itemBuilder: (context, int i) {
              var venue = venues[i];
              bool isFavorite = userState.favoriteVenueIds.contains(venue.venueId);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: Material(
                  elevation: 3,
                  color: const Color.fromARGB(215, 148, 240, 142),
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => VenueDetail(
                            name: venue.venuename,
                            address: venue.address,
                            description: venue.description,
                            pictureUrl: venue.picture,
                            instagram: venue.instagram,
                            website: venue.website,
                          ),
                        ),
                      );
                    },
                    child: _buildVenueRow(venue, context, isFavorite, userState.user.userId),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildVenueRow(venue, BuildContext context, bool isFavorite, String userId) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          bool isFavorite = state.favoriteVenueIds.contains(venue.venueId);

          return Container(
            height: 80,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      venue.picture,
                      height: 90,
                      width: 110,
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
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          venue.address,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
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
                      isFavorite ? CupertinoIcons.hand_thumbsup_fill : CupertinoIcons.hand_thumbsup,
                      color: Colors.grey,
                    ),
                    iconSize: 20,
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'User data not available',
                style: TextStyle(
                  color: Colors.red, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
