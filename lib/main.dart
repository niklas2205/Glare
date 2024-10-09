import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/app.dart';
import 'package:glare/screens/home/views/LifecycleObserver.dart';
import 'package:glare/simple_bloc_observer.dart';

import 'package:user_repository/user_repository.dart';


//import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart'; // Adjust the import path if necessary


import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp();

  LifecycleObserver().startObserving();

  // Set preferred orientations to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Bloc.observer = const SimpleBlocObserver();
  final userRepository = FirebaseUserRepo();
  runApp(MainApp(userRepository));
}

