import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glare/screens/background_screen/background_screen.dart';
import 'package:glare/screens/home/blocs/change_genre_bloc/change_genre_bloc.dart';
import 'package:glare/screens/home/blocs/user_bloc/user_bloc.dart';
import 'package:glare/screens/home/blocs/user_update_bloc/user_update_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user_repository/user_repository.dart';




class ChangeGenreScreen extends StatelessWidget {
  const ChangeGenreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangeGenreBloc(userRepository: context.read<UserRepository>())
        ..add(LoadUserGenres()),
      child: Scaffold(
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
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Change Genre',
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
                            BlocBuilder<ChangeGenreBloc, ChangeGenreState>(
                              builder: (context, state) {
                                if (state is ChangeGenreLoading) {
                                  return const CircularProgressIndicator();
                                } else if (state is ChangeGenreLoaded) {
                                  return buildGenreGrid(context, state.selectedGenres);
                                } else if (state is ChangeGenreError) {
                                  return Text(state.error, style: const TextStyle(color: Colors.red));
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            buildUpdateButton(context),
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
      ),
    );
  }

  Widget buildGenreGrid(BuildContext context, List<String> selectedGenres) {
    final genres = ['Rock', 'Jazz', 'Pop', 'Classical', 'Electronic'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3,
        physics: const NeverScrollableScrollPhysics(),
        children: genres
            .map((genre) => genreButton(context, genre, selectedGenres.contains(genre)))
            .toList(),
      ),
    );
  }

  Widget genreButton(BuildContext context, String genre, bool isSelected) {
    return GestureDetector(
      onTap: () {
        context.read<ChangeGenreBloc>().add(GenreSelected(genre));
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8FFA58) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF8FFA58)),
        ),
        child: Center(
          child: Text(
            genre,
            style: TextStyle(
              color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUpdateButton(BuildContext context) {
    return Container(
      width: 322,
      height: 48,
      margin: const EdgeInsets.only(top: 24),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFF8FFA58)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: const BorderSide(color: Color(0xFF8FFA58)),
          )),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        onPressed: () {
          final state = context.read<ChangeGenreBloc>().state;
          if (state is ChangeGenreLoaded) {
            context.read<ChangeGenreBloc>().add(UpdateUserGenres(state.selectedGenres));
            Navigator.pop(context); // Navigate back to previous screen after update
          }
        },
        child: const Text(
          'Update',
          style: TextStyle(
            color: Colors.black, // Black text color
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}