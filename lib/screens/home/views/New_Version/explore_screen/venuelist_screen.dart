import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/screens/home/views/New_Version/explore_screen/searchbar.dart';
import 'package:glare/screens/home/views/New_Version/explore_screen/venue_search_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_repository/venue_repository.dart';

import '../../../blocs/get_venue_bloc/get_venue_bloc.dart';
import '../../../blocs/search_venue_bloc/search_venue_bloc.dart';
import '../../Venue_list.dart';


class VenueListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomVenueSearchBar(
            onChanged: (query) {
              context.read<VenueSearchBloc>().add(VenueSearchQueryChanged(query));
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<VenueSearchBloc, VenueSearchState>(
            builder: (context, state) {
              if (state is VenueSearchLoading) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF13B8A8)));
              } else if (state is VenueSearchSuccess) {
                return VenueListWidget(venues: state.venues);
              } else if (state is VenueSearchFailure) {
                return Center(child: Text(state.error));
              } else if (state is VenueSearchInitial) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF13B8A8)));
              }
              return const Center(child: CircularProgressIndicator(color: Color(0xFF13B8A8)));
            },
          ),
        ),
      ],
    );
  }
}