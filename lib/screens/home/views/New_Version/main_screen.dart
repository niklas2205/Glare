import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glare/screens/home/views/New_Version/explore_screen/explore_screen.dart';

import 'package:glare/screens/home/views/New_Version/home_screen.dart';
import '../../blocs/bottom_navigation_bloc/bottom_navigation_bloc.dart';



import 'Profile_screen/Profile_main.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                ProfileMain(),
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
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/Navbar/house-2.svg',
                    colorFilter: ColorFilter.mode(
                      state.selectedIndex == 0 ? Color(0xFF8FFA58) : Colors.grey[700]!,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/Navbar/search-status.svg',
                    colorFilter: ColorFilter.mode(
                      state.selectedIndex == 1 ? Color(0xFF8FFA58) : Colors.grey[700]!,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                   icon: SvgPicture.asset(
                    'assets/icons/Navbar/user.svg',
                    colorFilter: ColorFilter.mode(
                      state.selectedIndex == 2 ? Color(0xFF8FFA58) : Colors.grey[700]!,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Profile',
                ),
              ],
              selectedItemColor: Color(0xFF8FFA58),
              unselectedItemColor: Colors.grey[700],
            );
          },
        ),
      ),
    );
  }
}
