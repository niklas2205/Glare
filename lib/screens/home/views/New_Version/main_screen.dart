import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/screens/home/views/New_Version/explore_screen/explore_screen.dart';

import 'package:glare/screens/home/views/New_Version/home_screen.dart';
import '../../blocs/bottom_navigation_bloc/bottom_navigation_bloc.dart';



import 'settings_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavigationBloc(),
      child: Scaffold(
        body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            return IndexedStack(
              index: state.selectedIndex,
              children: const [
                HomeScreen(),
                ExploreScreen(),
                SettingsScreen(),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            return BottomNavigationBar(
              currentIndex: state.selectedIndex,
              onTap: (index) {
                context.read<BottomNavigationBloc>().add(NavigateTo(index));
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.event),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
