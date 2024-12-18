import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'event_scroll_event.dart';
part 'event_scroll_state.dart';

class EventScrollBloc extends Bloc<EventScrollEvent, EventScrollState> {
  final List<dynamic> groupedEvents;
  final Map<DateTime, int> dateIndexMap;
  final double headerHeight;
  final double eventHeight;

  EventScrollBloc({
    required this.groupedEvents,
    required this.dateIndexMap,
    required this.headerHeight,
    required this.eventHeight,
  }) : super(const EventScrollState()) {
    on<EventScrollEvent>((event, emit) {
      // Determine visible date based on the current scroll offset.
      // We'll assume each date header has a fixed height (headerHeight)
      // and each event item has a fixed height (eventHeight).
      // This is a simplified approach. In a real app, consider using slivers
      // or a more dynamic approach.

      double currentOffset = event.offset;
      DateTime? currentVisibleDate;

      // We'll iterate through the dateIndexMap sorted by date to find the largest date index
      // whose position is <= currentOffset
      // This calculation depends on knowing how to compute offsets.
      // If we know each date header takes headerHeight and each event eventHeight,
      // we can reconstruct offsets. Another approach is to store a prefix offset array
      // during build.
      
      // For simplicity, let's do a rough calculation:
      // Build a prefix offset map:
      double cumulativeOffset = 0.0;
      DateTime? lastDate;
      final sortedDates = dateIndexMap.keys.toList()..sort();
      for (var date in sortedDates) {
        int dateIndex = dateIndexMap[date]!;
        // From start of list to this dateIndex, we have dateIndex items.
        // But we know that at these dateIndexes, a date header occurs.
        // groupedEvents has the pattern: dateHeader, event, event..., next dateHeader, etc.
        // We'll compute offsets by iterating through groupedEvents until we reach this dateIndex.
        // This is simplistic and not the most efficient, but it's illustrative.

        // Let's precompute offsets once:
        // Actually, let's do a single pass to store offsets of each date:
      }

      // More direct approach:
      // We'll create a helper that, given the offset and known structure, finds the currently visible date.
      currentVisibleDate = _findVisibleDateForOffset(event.offset);

      emit(state.copyWith(visibleDate: currentVisibleDate));
    });
  }

  DateTime? _findVisibleDateForOffset(double offset) {
    // Let's compute offsets by iterating through groupedEvents and track when we hit a date.
    // groupedEvents: [DateTime(dateHeader), Event, Event, DateTime(dateHeader), Event, ...]
    double currentOffset = 0.0;
    DateTime? currentDate;
    for (var item in groupedEvents) {
      if (item is DateTime) {
        // date header
        currentDate = item;
        currentOffset += headerHeight;
        if (currentOffset > offset) {
          return currentDate;
        }
      } else {
        // event
        currentOffset += eventHeight;
        if (currentOffset > offset && currentDate != null) {
          return currentDate;
        }
      }
    }
    return currentDate;
  }
}