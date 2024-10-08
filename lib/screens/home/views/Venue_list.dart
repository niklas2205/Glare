import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venue_repository/venue_repository.dart';


import '../blocs/user_bloc/user_bloc.dart';
import 'New_Version/explore_screen/venue_card.dart';

class VenueListWidget extends StatelessWidget {
  final List<Venue> venues;

  const VenueListWidget({Key? key, required this.venues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoaded) {
          final double screenWidth = MediaQuery.of(context).size.width;
          final double cardWidth = screenWidth * 0.82;
          final double cardHeight = 100;
          final double imageSize = cardHeight -16 ;

          return ListView.builder(
            padding: EdgeInsets.zero, // Ensure no padding at the start
            itemCount: venues.length,
            itemBuilder: (context, int i) {
              var venue = venues[i];
              bool isFavorite = userState.favoriteVenueIds.contains(venue.venueId);

              return VenueCard(
                venue: venue,
                isFavorite: isFavorite,
                userId: userState.user.userId,
                cardWidth: cardWidth,
                cardHeight: cardHeight,
                imageSize: imageSize,
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}