import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomVenueSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterPressed;

  const CustomVenueSearchBar({Key? key, required this.onChanged, required this.onFilterPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth = screenWidth * 0.82;
    final double searchWidth = screenWidth * 0.713;

    return SizedBox(
      width: containerWidth,
      height: 56,
      child: Row(
        children: [
          Container(
            width: searchWidth,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF8FFA58)),
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xFF1A1A1A),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 14),
                  width: 17,
                  height: 17.1,
                  child: Image.asset(
                    'assets/icons/Search_lens.png',
                    width: 17,
                    height: 17.1,
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.5,
                        color: const Color(0xFFBDBDBD),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 1.5,
                      color: const Color(0xFFBDBDBD),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: onFilterPressed,
            child: SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                'assets/icons/setting-5.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class FilterModal extends StatefulWidget {
  final Function(List<String>, bool) onFilterApply;

  const FilterModal({Key? key, required this.onFilterApply}) : super(key: key);

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  List<String> selectedGenres = [];
  bool filterLikedVenues = false;

  final List<String> genres = [
    'Charts', 'Hip Hop', 'House', 'Techno', 'Pop', 'Electronic', 'R&B', 'Soul',
    'Disco', 'Trap', 'Live Music', 'Indie Rock', '80s', 'Alternative'
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
            title: Text('Liked Venues'),
            value: filterLikedVenues,
            onChanged: (bool? value) {
              setState(() {
                filterLikedVenues = value!;
              });
            },
          ),
          Expanded(
            child: ListView(
              children: genres.map((genre) {
                return CheckboxListTile(
                  title: Text(genre),
                  value: selectedGenres.contains(genre),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        selectedGenres.add(genre);
                      } else {
                        selectedGenres.remove(genre);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onFilterApply(selectedGenres, filterLikedVenues);
              Navigator.of(context).pop();
            },
            child: Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}

