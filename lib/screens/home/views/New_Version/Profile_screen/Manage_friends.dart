import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/screens/background_screen/background_screen.dart';
import 'package:glare/screens/home/blocs/friends_bloc/friends_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../../../blocs/friends_bloc/friends_state.dart';

class ManageFriends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          BackgroundScreen(),
          Column(
            children: [
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Transform.rotate(
                        angle: 3.14159,
                        child: SvgPicture.asset(
                          'assets/icons/Profile_screen/ic_expand_more.svg',
                          width: 24,
                          height: 24,
                          color: const Color(0xFF8FFA58),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Manage Friends',
                      style: TextStyle(
                        color: Color(0xFF8FFA58),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildFriendsList(context),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/add_friends'),
                            child: const Text('Add Friends'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFriendsList(BuildContext context) {
    return BlocBuilder<FriendsBloc, FriendsState>(
      builder: (context, state) {
        if (state is FriendsLoadInProgress) {
          return const CircularProgressIndicator();
        } else if (state is FriendsLoadSuccess) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.friends.length,
            itemBuilder: (context, index) {
              final friend = state.friends[index];
              return ListTile(
                title: Text(friend.name ?? 'Unknown'),
                subtitle: Text(friend.email),
              );
            },
          );
        } else if (state is FriendsLoadFailure) {
          return Text(state.message, style: const TextStyle(color: Colors.red));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
