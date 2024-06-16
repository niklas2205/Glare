import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/app.dart';
import 'package:glare/simple_bloc_observer.dart';

import 'package:user_repository/user_repository.dart';


//import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart'; // Adjust the import path if necessary


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp();
  Bloc.observer = const SimpleBlocObserver();

  final userRepository = FirebaseUserRepo();
  runApp(MainApp(userRepository));
}

