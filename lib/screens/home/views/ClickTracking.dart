import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClickTrackingService {
  // Singleton pattern
  static final ClickTrackingService _instance = ClickTrackingService._internal();

  factory ClickTrackingService() {
    return _instance;
  }

  ClickTrackingService._internal();

  // Maps to store click counts
  final Map<String, int> eventCardClickCounts = {};
  final Map<String, int> ticketClickCounts = {};
  final Map<String, int> venueCardClickCounts = {};

  // Increment event card click count
  void incrementEventCardClick(String eventId) {
    eventCardClickCounts[eventId] = (eventCardClickCounts[eventId] ?? 0) + 1;
  }

  // Increment ticket link click count
  void incrementTicketClick(String eventId) {
    ticketClickCounts[eventId] = (ticketClickCounts[eventId] ?? 0) + 1;
  }

  // Increment venue card click count
  void incrementVenueCardClick(String venueId) {
    venueCardClickCounts[venueId] = (venueCardClickCounts[venueId] ?? 0) + 1;
  }

  // Flush counts to Firestore
  Future<void> flushCountsToFirestore() async {
    if (eventCardClickCounts.isEmpty &&
        ticketClickCounts.isEmpty &&
        venueCardClickCounts.isEmpty) {
      return; // Nothing to update
    }

    final batch = FirebaseFirestore.instance.batch();

    // Update event card click counts
    eventCardClickCounts.forEach((eventId, count) {
      final eventDocRef = FirebaseFirestore.instance.collection('events').doc(eventId);
      batch.update(eventDocRef, {
        'cardTapCount': FieldValue.increment(count),
      });
    });

    // Update ticket link click counts
    ticketClickCounts.forEach((eventId, count) {
      final eventDocRef = FirebaseFirestore.instance.collection('events').doc(eventId);
      batch.update(eventDocRef, {
        'ticketTapCount': FieldValue.increment(count),
      });
    });

    // Update venue card click counts
    venueCardClickCounts.forEach((venueId, count) {
      final venueDocRef = FirebaseFirestore.instance.collection('venues').doc(venueId);
      batch.update(venueDocRef, {
        'cardTapCount': FieldValue.increment(count),
      });
    });

    // Commit the batch
    try {
      await batch.commit();
      // Reset the local counts after successful commit
      eventCardClickCounts.clear();
      ticketClickCounts.clear();
      venueCardClickCounts.clear();
    } catch (e) {
      // Handle exceptions (e.g., network errors)
      print('Error updating click counts: $e');
    }
  }

  // Periodic flushing (optional)
  Timer? _timer;

  void startPeriodicFlush() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      flushCountsToFirestore();
    });
  }

  void stopPeriodicFlush() {
    _timer?.cancel();
  }
}
