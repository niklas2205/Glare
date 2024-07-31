import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/screens/background_screen/background_screen.dart';
import 'package:glare/screens/home/blocs/friends_bloc/friends_bloc.dart';
import 'package:glare/screens/home/views/New_Version/Profile_screen/User_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user_repository/user_repository.dart';

import '../../../blocs/friends_bloc/friends_state.dart';



class AddFriends extends StatefulWidget {
  const AddFriends({Key? key}) : super(key: key);

  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  final TextEditingController _searchController = TextEditingController();

  void _searchUsers() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      context.read<FriendsBloc>().add(SearchUsers(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Add Friends',
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
                          buildSearchField(),
                          BlocBuilder<FriendsBloc, FriendsState>(
                            builder: (context, state) {
                              if (state is FriendsLoadInProgress) {
                                return const CircularProgressIndicator();
                              } else if (state is SearchUsersSuccess) {
                                return buildUserList(state.users);
                              } else if (state is FriendsLoadFailure) {
                                return Text(state.message, style: const TextStyle(color: Colors.red));
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
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

  Widget buildSearchField() {
    return Container(
      width: 322,
      height: 82,
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search for friends',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF8FFA58)),
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xFF1A1A1A),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter name',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 16,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: _searchUsers,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserList(List<MyUser> users) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return UserCard(
          user: user,
          onAddFriend: () {
            context.read<FriendsBloc>().add(SendFriendRequest(user.userId));
          },
        );
      },
    );
  }
}
