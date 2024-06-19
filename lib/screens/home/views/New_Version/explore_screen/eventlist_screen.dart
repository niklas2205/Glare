import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glare/screens/home/views/Event_list.dart';
import 'package:glare/screens/home/views/New_Version/explore_screen/searchbar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/get_event_bloc/get_event_bloc.dart';
import '../../../blocs/search_event_bloc/search_event_bloc.dart';



class EventListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomSearchBar(
            onChanged: (query) {
              context.read<SearchBloc>().add(SearchQueryChanged(query));
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF13B8A8)));
              } else if (state is SearchSuccess) {
                return EventListWidget(events: state.events);
              } else if (state is SearchFailure) {
                return Center(child: Text(state.error));
              } else if (state is SearchInitial) {
                final eventState = context.read<GetEventBloc>().state;
                if (eventState is GetEventSuccess) {
                  return EventListWidget(events: eventState.events);
                }
              }
              return const Center(child: CircularProgressIndicator(color: Color(0xFF13B8A8)));
            },
          ),
        ),
      ],
    );
  }
}