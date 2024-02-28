import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/app.dart';
import 'package:glare/simple_bloc_observer.dart';
import 'package:user_repository/user_repository.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

//import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart'; // Adjust the import path if necessary


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(MainApp(FirebaseUserRepo())); // Ersetzen Sie MyApp durch den Namen Ihrer App-Klasse
}

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Please type an email';
                }
                return null;
              },
              onSaved: (input) => _email = input!,
              decoration: const InputDecoration(
                labelText: 'Email'
              ),
            ),
            TextFormField(
              validator: (input) {
                if (input!.length < 6) {
                  return 'Your password needs to be atleast 6 characters';
                }
                return null;
              },
              onSaved: (input) => _password = input!,
              decoration: const InputDecoration(
              labelText: 'Password'
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: register,
              child: const Text('Register'),
            ),      
          ],
        ),
      ),
    );
  }

  Future<void> register() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);

        // Create a new user model instance
        CustomUser newUser = CustomUser(
          email: _email,
          registrationType: 'email', // Since this is email registration
          uid: userCredential.user!.uid, // Get the UID from userCredential
        );


        // Save the user data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set(newUser.toMap());

        // Navigate to profile page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdditionalDetailsScreen(uid: userCredential.user!.uid),
          ),
        );
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }
}

class AdditionalDetailsScreen extends StatefulWidget {
  final String uid; // User ID passed from the registration screen

  const AdditionalDetailsScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _AdditionalDetailsScreenState createState() => _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState extends State<AdditionalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _secondName = '';
  DateTime _dateOfBirth = DateTime.now();
  TextEditingController _dateController = TextEditingController(); // Define the TextEditingController here


  Future<void> _saveAdditionalDetails() async {
    final formState = _formKey.currentState;
    if (formState != null && formState.validate()) {
      formState.save();

      try {
        // Update the Firestore document with the additional details
        await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
          'firstName': _firstName,
          'surname': _secondName,  // 'surname' is used instead of 'secondName'
          'DOB': _dateOfBirth.toIso8601String(),  // Storing the date as a string
        });

        // Navigate to another screen or home page after saving details
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Home')));
      } catch (e) {
        // Handle any errors here
        print(e.toString());
        // Optionally, show an error message to the user
      }
    }
  }

    Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0]; // Format the date as required
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Additional Details')),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'First Name'),
              onSaved: (value) => _firstName = value ?? '',
              validator: (value) => value!.isEmpty ? 'Please enter your first name' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Surname'),
              onSaved: (value) => _secondName = value ?? '',
              validator: (value) => value!.isEmpty ? 'Please enter your second name' : null,
            ),
            TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date of Birth'),
              onTap: () => _selectDate(context),
              readOnly: true, // Makes the field read-only
            ),
         
            // Add a date picker for date of birth
            ElevatedButton(
              onPressed: _saveAdditionalDetails,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () => _loginWithEmailPassword(context),
                child: const Text("Log in"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
                },
                child: const Text("Register with Email"),
              ),
              ElevatedButton(
                onPressed: () => _signInWithGoogle(context),
                child: const Text("Log in with Google"),
              ),
              ElevatedButton(
                onPressed: () => _signInWithApple(context),
                child: const Text("Log in with Apple"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loginWithEmailPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home')));
    } catch (e) {
      // Handle error, e.g., show a toast or a dialog
      Fluttertoast.showToast(msg: "Login Failed: ${e.toString()}");
    }
  }

  void _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home')));
      }
    } catch (e) {
      // Handle error
      Fluttertoast.showToast(msg: "Login Failed: ${e.toString()}");
    }
  }

  void _signInWithApple(BuildContext context) async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an OAuthCredential for Firebase. Here, `appleCredential.identityToken`
      // and `appleCredential.authorizationCode` are needed.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in the user with Firebase
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      // Navigate to the home page
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home')));

    } catch (e) {
      // Handle errors here
      // Example: Fluttertoast.showToast(msg: "Apple Login Failed: ${e.toString()}");
    }
  }
}

class CustomUser {
  String email;
  String registrationType;
  String uid;

  CustomUser({required this.email, required this.registrationType, required this.uid});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'registrationType': registrationType,
      'uid': uid,
    };
  }
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

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              // Navigate to profile page or handle profile actions
            },
            child: const Text('Profile'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Optionally navigate to the login screen after logout
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: const Text('Logout'),
          ),
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

  Venue({required this.imagePath, required this.title, required this.location, required this.ageRequirement});

  factory Venue.fromMap(Map<String, dynamic> map) {
  
    return Venue(
      imagePath: map['imagePath'] as String,
      title: map['title'] as String,
      location: map['location'] as String,
      ageRequirement: map["ageRequirement"] 
    );
  }
}
class Event {
  String imagePath;
  String title;
  String location;
  DateTime date;

  Event({required this.imagePath, required this.title, required this.location, required this.date});

  factory Event.fromMap(Map<String, dynamic> map) {
    // Assuming 'date' in your Firestore is a Timestamp object
    Timestamp timestamp = map['date'] as Timestamp;
    DateTime date = timestamp.toDate();

    return Event(
      imagePath: map['imagePath'] as String,
      title: map['title'] as String,
      location: map['location'] as String,
      date: date, // Now using the converted DateTime object
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glare Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              // User not logged in, show LoginScreen
              return LoginScreen();
            } else {
              // User is logged in, show MyHomePage
              return MyHomePage(title: 'Glare Testing');
            }
          } else {
            // Waiting for authentication result
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
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
            Image.network(venue.imagePath, fit: BoxFit.cover),
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
            Image.network(event.imagePath, fit: BoxFit.cover),
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
    const SettingsPage(), // Placeholder for the Settings page
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
  List<Venue> venues = [];
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    fetchVenuesFromFirestore().then((_) {
      fetchEventsFromFirestore().then((_) {
        setState(() {}); // Rebuild the widget after fetching data
      });
    });
  }

  Future<void> fetchVenuesFromFirestore() async {
    try {
      QuerySnapshot venueSnapshot = await FirebaseFirestore.instance.collection('Venues').get();
      venues = venueSnapshot.docs.map((doc) => Venue.fromMap(doc.data() as Map<String, dynamic>)).toList();
      venues.sort((a, b) => a.title.compareTo(b.title));
    } catch (e) {
      print("Error fetching venues: $e");
    }
  }

Future<void> fetchEventsFromFirestore() async {
  try {
    QuerySnapshot eventSnapshot = await FirebaseFirestore.instance.collection('Events').get();
    events = eventSnapshot.docs.map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>)).toList();
    // Sort events by date, earliest first
    events.sort((a, b) => a.date.compareTo(b.date));
  } catch (e) {
    print("Error fetching events: $e");
  }
}


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
            child: Image.network(
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
        leading: Image.network(event.imagePath, width: 50, height: 50), // Adjust size as needed
        title: Text(event.title),
        subtitle: Text('${event.location}, ${event.date}'),
        // Add more event details here
      ),
    );
  }
}

