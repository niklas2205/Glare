import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glare/screens/home/views/Event_list.dart';
import 'package:glare/screens/home/views/New_Version/explore_screen/day_selector.dart';
import 'package:glare/screens/home/views/New_Version/explore_screen/searchbar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/day_selector_bloc/day_selector_bloc.dart';
import '../../../blocs/get_event_bloc/get_event_bloc.dart';
import '../../../blocs/search_event_bloc/search_event_bloc.dart';


class EventListScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  Future<void> _refreshEvents(BuildContext context) async {
    // Reload events using the EventBloc or a similar mechanism
    context.read<GetEventBloc>().add(LoadEvents());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DaySelectorBloc(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomSearchBar(
              onChanged: (query) {
                context.read<SearchBloc>().add(SearchQueryChanged(query));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DaySelector(
              onDaySelected: (selectedDate) {
                scrollToEvent(context, selectedDate);
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _refreshEvents(context),
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF13B8A8)));
                  } else if (state is SearchSuccess) {
                    final sortedEvents = state.events..sort((a, b) => a.date!.compareTo(b.date!));
                    return EventListWidget(events: sortedEvents, scrollController: _scrollController);
                  } else if (state is SearchFailure) {
                    return Center(child: Text(state.error));
                  } else if (state is SearchInitial) {
                    final eventState = context.read<GetEventBloc>().state;
                    if (eventState is GetEventSuccess) {
                      final sortedEvents = eventState.events..sort((a, b) => a.date!.compareTo(b.date!));
                      return EventListWidget(events: sortedEvents, scrollController: _scrollController);
                    }
                  }
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF13B8A8)));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void scrollToEvent(BuildContext context, DateTime selectedDate) {
    final eventState = context.read<GetEventBloc>().state;
    if (eventState is GetEventSuccess) {
      final index = eventState.events.indexWhere((event) {
        final eventDate = event.date;
        return eventDate != null &&
               eventDate.year == selectedDate.year &&
               eventDate.month == selectedDate.month &&
               eventDate.day == selectedDate.day;
      });

      if (index != -1) {
        // Calculate the scroll offset for the date header
        double offset = 0.0;
        for (int i = 0; i < index; i++) {
          if (i == 0 || !_isSameDate(eventState.events[i - 1].date!, eventState.events[i].date!)) {
            offset += 50; // Height of the date header (adjust as necessary)
          }
          offset += 100; // Height of each event item (adjust as necessary)
        }

        _scrollController.animateTo(
          offset,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}
