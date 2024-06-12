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
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        List<String> selectedGenres = state is GenresUpdated ? state.genres : [];
        List<String> genres = ['EDM', 'House', 'Techno', 'Trance', 'Hip-Hop', 'R&B', 'Rock', 'Jazz'];

        return Container(
          margin: const EdgeInsets.fromLTRB(0, 55, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              buildTitle(context),
              buildTellUs(),
              buildExplaination(),
              Wrap(
                spacing: 10, // Horizontal space between buttons
                runSpacing: 10, // Vertical space between lines
                children: genres
                    .map((genre) => genreButton(context, genre, selectedGenres.contains(genre)))
                    .toList(),
              ),
              buildNextButton(context),
              buildBackButton(context),
              buildSkipForNowButton(context)
            ],
          ),
        );
      },
    );
  }

  Widget genreButton(BuildContext context, String genre, bool isSelected) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<OnboardingBloc>(context).add(GenreSelected(genre));
      },
      child: Container(
        width: 152, // Width in pixels
        height: 48, // Height in pixels
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8FFA58) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF8FFA58)),
        ),
        alignment: Alignment.center,
        child: Text(
          genre,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
            fontWeight: FontWeight.bold,
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

  Widget buildExplaination(){
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      width: 326,
      height: 64,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'Please select your favourite genres. You will be able to change this later.',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );}

  Widget buildNextButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 8),
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
          BlocProvider.of<OnboardingBloc>(context).add(SubmitGenres());
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
          color: const Color(0xFF8FFA58),
        )),
      ),
    );
  }
  Widget buildSkipForNowButton(BuildContext context) {
    return Container(
      width: 322,
      height: 48,
      alignment: Alignment.center,  // Center the text within the container
      margin: const EdgeInsets.only(top: 2),  // Adjust margin as needed
      child: TextButton(
        onPressed: () {
          BlocProvider.of<OnboardingBloc>(context).add(SkipOnboarding());
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,  // Remove padding
          backgroundColor: Colors.transparent,  // Ensure background is transparent
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,  // Reduce tap target to the size of the text
        ),
        child: Text(
          "Skip for Now",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,  // Set text color
          ),
        ),
      ),
    );
  }
}
