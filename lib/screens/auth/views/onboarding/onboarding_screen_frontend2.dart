import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/onboarding_bloc/onboarding_bloc.dart';

class AdditionalDetailsScreen extends StatelessWidget {
  final Function onBack;

  const AdditionalDetailsScreen({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double verticalSpacing = screenHeight * 0.02;

    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        List<String> selectedGenres = state is GenresUpdated ? state.genres : [];

        return Container(
          margin: const EdgeInsets.fromLTRB(0, 55, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildTitle(context),
              buildTellUs(),
              buildGenreGrid(context, selectedGenres),
              SizedBox(height: verticalSpacing),
              buildNextButton(context),
              buildBackButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget buildGenreGrid(BuildContext context, List<String> selectedGenres) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3,
        physics: const NeverScrollableScrollPhysics(),
        children: ['EDM','Techno','House','Disco','Hip-Hop/Rap','Afrobeats','Charts','Latin']
            .map((genre) => genreButton(context, genre, selectedGenres.contains(genre)))
            .toList(),
      ),
    );
  }

  Widget genreButton(BuildContext context, String genre, bool isSelected) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<OnboardingBloc>(context).add(GenreSelected(genre));
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF8FFA58) : Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Color(0xFF8FFA58)),
        ),
        child: Center(
          child: Text(
            genre,
            style: TextStyle(
              color: isSelected ? Color(0xFF1A1A1A) : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(33, 0, 0, 30.5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Glare',
          style: GoogleFonts.majorMonoDisplay(
            fontWeight: FontWeight.w400,
            fontSize: 30,
            color: const Color(0xFF8FFA58),
          ),
        ),
      ),
    );
  }

  Widget buildTellUs() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      width: 326,
      height: 64,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Choose Your Favorite Genres!',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            height: 1.1,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildNextButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      width: 322,
      height: 48,
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
          BlocProvider.of<OnboardingBloc>(context).add(OnboardingCompleted());
        },
        child: Text("Next", style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: const Color(0xFF1A1A1A),
        )),
      ),
    );
  }

  Widget buildBackButton(BuildContext context) {
    return SizedBox(
      width: 322,
      height: 48,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFF1A1A1A)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: const BorderSide(color: Color(0xFF8FFA58)),
          )),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        onPressed: () => onBack(),
        child: Text("Back", style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: const Color(0xFF8FFA58)),
        )
      ),
    );
  }
}

