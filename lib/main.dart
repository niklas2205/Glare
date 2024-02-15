import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart'; // Adjust the import path if necessary


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Stellen Sie sicher, dass Flutter-Widgets initialisiert sind
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp()); // Ersetzen Sie MyApp durch den Namen Ihrer App-Klasse
}



class NoAnimationBottomNavigationBarItem extends StatelessWidget {
  final IconData iconData;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NoAnimationBottomNavigationBarItem({
    Key? key,
    required this.iconData,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(iconData, color: isSelected ? Colors.black : Colors.grey),
          Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.grey)),
        ],
      ),
    );
  }
}


class Venue {
  final String imagePath;
  final String title;
  final String location;
  final int ageRequirement;

  Venue({
    required this.imagePath,
    required this.title,
    required this.location,
    required this.ageRequirement,
  });
}
class Event {
  final String imagePath;
  final String title;
  final String location;
  final DateTime date; // Example property

  Event({
    required this.imagePath,
    required this.title,
    required this.location,
    required this.date,
  });
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glare Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Glare Testing'),
    );
  }
}


class VenueSearch extends SearchDelegate<Venue?> {
  final List<Venue> venues;

  VenueSearch(this.venues);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // This can be modified as per your requirement
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = venues.where((venue) {
      return venue.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index].title),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => VenueDetailPage(venue: suggestions[index]),
            ));
          },
        );
      },
    );
  }

  @override
  void showResults(BuildContext context) {
    // Custom implementation for showing results, if needed
  }
}
class EventSearch extends SearchDelegate<Event?> {
  final List<Event> events;

  EventSearch(this.events);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // You can modify this as per your requirement
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = events.where((event) {
      return event.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index].title),
          subtitle: Text('${suggestions[index].location}, ${suggestions[index].date}'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EventDetailPage(event: suggestions[index]), // You need to create an EventDetailPage
            ));
          },
        );
      },
    );
  }

  @override
  void showResults(BuildContext context) {
    // Custom implementation for showing results, if needed
  }
}

class VenueDetailPage extends StatelessWidget {
  final Venue venue;

  const VenueDetailPage({Key? key, required this.venue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(venue.title), // Venue name in the app bar
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(venue.imagePath, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    venue.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Location: ${venue.location}'),
                  const SizedBox(height: 5),
                  Text('Age Requirement: ${venue.ageRequirement}+'),
                  // Add more details as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventDetailPage extends StatelessWidget {
  final Event event;

  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title), // Event name in the app bar
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(event.imagePath, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    event.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Location: ${event.location}'),
                  const SizedBox(height: 5),
                  Text('Date: ${event.date}'),
                  // Add more event details as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Define the list of widgets/pages corresponding to each BottomNavigationBarItem
  final List<Widget> _pages = [
    const Center(child: Text('Socials Page')), // Placeholder for the Socials page
    const Center(child: Text('Event Tinder Page')), // Placeholder for the Event Tinder page
    const VenuesPage(), // Your custom Venues page
    const Center(child: Text('Settings Page')), // Placeholder for the Settings page
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _pages.elementAt(_selectedIndex), // Display the widget corresponding to the selected index
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Socials',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swipe),
            label: 'Event Tinder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Venues',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}




class VenuesPage extends StatefulWidget {
  const VenuesPage({Key? key}) : super(key: key);

  @override
  _VenuesPageState createState() => _VenuesPageState();
}

class _VenuesPageState extends State<VenuesPage> {
  bool showVenues = true; // Toggle state
  final List<Venue> venues = [
    Venue(
      imagePath: 'assets/images/089_logo.png',
      title: '089 Bar',
      location: 'Adresse',
      ageRequirement: 18,
    ),
    Venue(
      imagePath: "assets/images/P1_logo.png",
      title: 'P1 Club & Bar',
      location: 'Adresse',
      ageRequirement: 21,
    ),
    Venue(
      imagePath: "assets/images/Drella_logo.png",
      title: "Call me Drella",
      location: "Adresse",
      ageRequirement: 18,
    ),
    // Add more dummy venues as needed
  ];

List<Event> events = [];
Future<void> fetchEventsFromFirestore() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('events').get();
  events = querySnapshot.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>)).toList();
}
}
  // Dummy events list
  final List<Event> events = [
    // Add your events data
    Event(
      imagePath: "assets/images/Event1.png",
      title: "Love Tuesday",
      location: "089 Bar",
      date: DateFormat("d MMMM yyyy HH:mm", 'en_US').parse("13 February 2024 22:00"),
    ),
    Event(
      imagePath: "assets/images/Event2.png",
      title: "Monday Funday",
      location: "089 Bar",
      date: DateFormat("d MMMM yyyy HH:mm", 'en_US').parse("12 February 2024 22:00"),
    ),
    Event(
      imagePath: "assets/images/Event3.png",
      title: "Schnaps & Liebe",
      location: "089 Bar",
      date: DateFormat("d MMMM yyyy HH:mm", 'en_US').parse("17 February 2024 22:00")
    )
    // Add more events
  ]..sort((a, b) => a.date.compareTo(b.date));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venues and Events'),
        leading: IconButton(
          icon: Icon(showVenues ? Icons.event : Icons.location_city),
          onPressed: () {
            setState(() {
              showVenues = !showVenues;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (showVenues) {
                showSearch(
                  context: context,
                  delegate: VenueSearch(venues),
                );
              } else {
                showSearch(
                  context: context,
                  delegate: EventSearch(events), // Use EventSearch for events
                );
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: showVenues ? venues.length : events.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (showVenues) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VenueDetailPage(venue: venues[index]),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EventDetailPage(event: events[index]), // Assuming you have an EventDetailPage
                  ),
                );
              }
            },
            child: showVenues
                ? VenueItem(venue: venues[index])
                : EventItem(event: events[index]), // Assuming you have an EventItem widget
          );
        },
      ),
    );
  }
}



class VenueItem extends StatelessWidget {
  final Venue venue;

  const VenueItem({Key? key, required this.venue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      elevation: 5,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(10.0)),
            child: Image.asset(
              venue.imagePath,
              width: 140, // Set your desired image width
              height: 100, // Set your desired image height
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    venue.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5), // Spacing between title and location
                  Text('Location: ${venue.location}'),
                  const SizedBox(height: 5), // Spacing between location and age requirement
                  Text('Age Requirement: ${venue.ageRequirement}+'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class EventItem extends StatelessWidget {
  final Event event;

  const EventItem({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(event.imagePath, width: 50, height: 50), // Adjust size as needed
        title: Text(event.title),
        subtitle: Text('${event.location}, ${event.date}'),
        // Add more event details here
      ),
    );
  }
}

