import 'dart:async';
import 'package:event_repository/event_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_repository/user_repository.dart';

class CachingService {
  Timer? _timer;
  final UserRepository userRepository;
  final EventRepo eventRepository;

  CachingService({
    required this.userRepository,
    required this.eventRepository,
  });

  Future<void> cacheData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load and cache liked events
    final user = await userRepository.getCurrentUser();
    if (user != null) {
      final likedEvents = await userRepository.getLikedEvents(user.userId);
      final likesCountMap = <String, int>{};
      for (var eventId in likedEvents) {
        final count = await eventRepository.getEventLikesCount(eventId);
        likesCountMap[eventId] = count;
      }

      await prefs.setStringList('likedEvents', likedEvents);
      await prefs.setStringList('likesCount', likesCountMap.entries.map((e) => '${e.key}:${e.value}').toList());
    }
  }

  Future<Map<String, dynamic>> loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load cached liked events
    final likedEvents = prefs.getStringList('likedEvents') ?? [];
    final likesCountList = prefs.getStringList('likesCount') ?? [];
    final likesCountMap = <String, int>{};
    for (var entry in likesCountList) {
      final splitEntry = entry.split(':');
      likesCountMap[splitEntry[0]] = int.parse(splitEntry[1]);
    }

    return {
      'likedEvents': likedEvents,
      'likesCount': likesCountMap,
    };
  }

  void startPeriodicSync() {
    _timer = Timer.periodic(Duration(minutes: 5), (timer) async {
      await cacheData();
    });
  }

  void stopPeriodicSync() {
    _timer?.cancel();
  }
}
