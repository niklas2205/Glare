import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glare/screens/home/blocs/user_bloc/user_bloc.dart';
import 'package:glare/screens/home/views/New_Version/Profile_screen/Profile_main.dart';
import 'package:glare/screens/home/views/New_Version/Profile_screen/change_genre.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_repository/user_repository.dart';

import '../../../../background_screen/background_screen.dart';
import 'Personal_details.dart';

class MyAccount extends StatelessWidget {
  final String title;

  const MyAccount({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          final user = state.user;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                BackgroundScreen(),
                Column(
                  children: [
                    const SizedBox(height: 60), // Space for the status bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Transform.rotate(
                              angle: 3.14159, // 180 degrees in radians
                              child: SvgPicture.asset(
                                'assets/icons/Profile_screen/ic_expand_more.svg',
                                width: 24,
                                height: 24,
                                color: const Color(0xFF8FFA58),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            title,
                            style: const TextStyle(
                              color: Color(0xFF8FFA58),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20), // Add some space below the title
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Display user information here if needed
                            // Text(
                            //   'Hello, ${user.name ?? 'User'}',
                            //   style: TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 20,
                            //   ),
                            // ),
                            const SizedBox(height: 10),
                            _buildCategoryBox(
                              context,
                              options: [
                                _buildSettingsOption(
                                  context,
                                  icon: 'assets/icons/Profile_screen/user.svg',
                                  text: 'Personal Details',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const PersonalDetails(),
                                      ),
                                    );
                                  },
                                ),
                                // _buildSettingsOption(
                                //   context,
                                //   icon: 'assets/icons/Profile_screen/security-safe.svg',
                                //   text: 'Security Settings',
                                //   onTap: () {},
                                // ),
                                _buildSettingsOption(
                                  context,
                                  icon: 'assets/icons/Profile_screen/music.svg',
                                  text: 'My Favorite Genres',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ChangeGenreScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const DeleteAccountButton(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (state is UserLoading) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is UserError) {
          return Scaffold(
            body: Center(child: Text('Error: ${state.message}')),
          );
        } else {
          // Initial or unknown state
          return Scaffold(
            body: Center(child: Text('Please log in.')),
          );
        }
      },
    );
  }

  Widget _buildCategoryBox(BuildContext context, {required List<Widget> options}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.82,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.symmetric(vertical: 2.0), // Add some padding inside the box
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF8FFA58),
          width: 2, // Increase the border thickness to 2 pixels
        ),
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF282828),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(4, 4),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: options,
      ),
    );
  }

  Widget _buildSettingsOption(BuildContext context, {required String icon, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
        ),
        padding: const EdgeInsets.fromLTRB(8, 10, 16.4, 10), // Decrease the padding to reduce the height
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(icon),
                ),
                Text(
                  text,
                  style: GoogleFonts.getFont(
                    'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.5,
                    letterSpacing: 0.1,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ],
            ),
            SvgPicture.asset(
              'assets/icons/Profile_screen/ic_expand_more.svg',
              width: 20, // Increased the size
              height: 20, // Increased the size
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.82,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 0.0),
      decoration: BoxDecoration(
        color: Colors.transparent, // Transparent background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.red, // Red border color
          width: 2,
        ),
      ),
      child: TextButton(
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text(
                  'Are you sure you want to delete your account? This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );

          if (confirm == true) {
            try {
              final userRepository =
                  RepositoryProvider.of<UserRepository>(context);
              await userRepository.deleteAccount();

              // Optionally, you can dispatch a logout event if using Bloc
              // context.read<AuthenticationBloc>().add(LoggedOut());

              // Navigate to the welcome screen
              Navigator.pushNamedAndRemoveUntil(
                  context, '/welcome', (route) => false);
            } on FirebaseAuthException catch (e) {
              // Since we're not handling re-authentication, just show the error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.message}'),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error deleting account: ${e.toString()}'),
                ),
              );
            }
          }
        },
        child: const Text(
          'Delete Account',
          style: TextStyle(
            color: Colors.red, // Red text color
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}