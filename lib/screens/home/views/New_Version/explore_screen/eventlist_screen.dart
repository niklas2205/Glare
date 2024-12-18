import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glare/screens/home/blocs/bloc/event_scroll_bloc.dart';
import 'package:glare/screens/home/blocs/event_like_bloc/event_like_bloc.dart';
import 'package:glare/screens/home/views/Event_list.dart';
import 'package:glare/screens/home/views/New_Version/explore_screen/day_selector.dart';
import 'package:glare/screens/home/views/New_Version/explore_screen/event_card.dart';
import 'package:glare/screens/home/views/New_Version/explore_screen/searchbar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import '../../../blocs/day_selector_bloc/day_selector_bloc.dart';
import '../../../blocs/get_event_bloc/get_event_bloc.dart';
import '../../../blocs/search_event_bloc/search_event_bloc.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EventListScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  late Map<DateTime, int> dateIndexMap; // Maps date headers to their index in the grouped list
  late List<dynamic> groupedEvents;    // The combined list of date headers and events

  EventListScreen({Key? key}) : super(key: key);

  Future<void> _refreshEventsAndLikes(BuildContext context) async {
    final getEventBloc = context.read<GetEventBloc>();
    final eventLikeBloc = context.read<EventLikeBloc>();
    final userRepository = context.read<UserRepository>();

    final user = await userRepository.getCurrentUser();

    // Fetch and update events
    getEventBloc.add(LoadEvents());

    // Fetch and update liked events
    if (user != null) {
      eventLikeBloc.add(LoadLikedEvents(user.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DaySelectorBloc(),
      child: BlocBuilder<GetEventBloc, GetEventState>(
        builder: (context, eventState) {
          List<Event> events = [];
          if (eventState is GetEventSuccess) {
            events = List.of(eventState.events)..sort((a, b) => a.date!.compareTo(b.date!));
          }

          // Precompute groupedEvents so we can map dates to indices
          groupedEvents = _groupEventsByDate(events);
          dateIndexMap = _buildDateIndexMap(groupedEvents);

          return BlocProvider(
            create: (context) => EventScrollBloc(
              groupedEvents: groupedEvents,
              dateIndexMap: dateIndexMap,
              headerHeight: 50, // Adjust as necessary
              eventHeight: 100, // Adjust as necessary
            ),
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
                      // Scroll to the selected date in the vertical event list
                      scrollToEvent(context, selectedDate);
                    },
                  ),
                ),
                Expanded(
                  child: BlocListener<EventScrollBloc, EventScrollState>(
                    listener: (context, state) {
                      // When the visible date changes due to scroll, update DaySelectorBloc
                      if (state.visibleDate != null) {
                        context.read<DaySelectorBloc>().add(SelectDay(state.visibleDate!));
                      }
                    },
                    child: RefreshIndicator(
                      onRefresh: () => _refreshEventsAndLikes(context),
                      child: BlocBuilder<SearchBloc, SearchState>(
                        builder: (context, state) {
                          List<Event> displayEvents = events;
                          if (state is SearchLoading) {
                            return const Center(child: CircularProgressIndicator(color: Color(0xFF8FFA58)));
                          } else if (state is SearchSuccess) {
                            displayEvents = state.events..sort((a, b) => a.date!.compareTo(b.date!));
                          } else if (state is SearchFailure) {
                            return Center(child: Text(state.error));
                          }

                          final listItems = _groupEventsByDate(displayEvents);

                          // Add scroll listener to update EventScrollBloc about offset changes
                          _scrollController.addListener(() {
                            context.read<EventScrollBloc>().add(EventScrollEvent(_scrollController.offset));
                          });

                          return ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.zero,
                            itemCount: listItems.length,
                            itemBuilder: (context, index) {
                              final item = listItems[index];
                              if (item is DateTime) {
                                return _buildDateHeader(context, item);
                              } else if (item is Event) {
                                final double cardWidth = MediaQuery.of(context).size.width * 0.82;
                                final double cardHeight = 100;
                                final double imageSize = cardHeight - 16;
                                return EventCard(
                                  event: item,
                                  cardWidth: cardWidth,
                                  cardHeight: cardHeight,
                                  imageSize: imageSize,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void scrollToEvent(BuildContext context, DateTime selectedDate) {
    if (dateIndexMap.containsKey(selectedDate)) {
      final index = dateIndexMap[selectedDate]!;
      double offset = _calculateOffsetForIndex(index, groupedEvents);

      _scrollController.animateTo(
        offset,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  double _calculateOffsetForIndex(int index, List<dynamic> groupedEvents) {
    double headerHeight = 50;
    double eventHeight = 100;
    double offset = 0.0;

    for (int i = 0; i < index; i++) {
      if (groupedEvents[i] is DateTime) {
        offset += headerHeight;
      } else {
        offset += eventHeight;
      }
    }

    return offset;
  }

  List<dynamic> _groupEventsByDate(List<Event> events) {
    List<dynamic> groupedEvents = [];
    DateTime? currentDate;

    for (var event in events) {
      if (event.date != null && (currentDate == null || !_isSameDate(currentDate, event.date!))) {
        currentDate = event.date;
        groupedEvents.add(currentDate);
      }
      groupedEvents.add(event);
    }

    return groupedEvents;
  }

  Map<DateTime, int> _buildDateIndexMap(List<dynamic> groupedEvents) {
    final map = <DateTime, int>{};
    for (int i = 0; i < groupedEvents.length; i++) {
      final item = groupedEvents[i];
      if (item is DateTime) {
        map[item] = i;
      }
    }
    return map;
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  Widget _buildDateHeader(BuildContext context, DateTime date) {
    final formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(date);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = screenWidth * 0.82;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: (screenWidth - cardWidth) / 2),
      child: Text(
        formattedDate,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}