import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_repository/user_repository.dart';


class UserCard extends StatelessWidget {
  final MyUser user;
  final VoidCallback onAddFriend;

  const UserCard({
    Key? key,
    required this.user,
    required this.onAddFriend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8FFA58)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            user.name ?? 'Unknown',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF8FFA58)),
            onPressed: onAddFriend,
          ),
        ],
      ),
    );
  }
}
