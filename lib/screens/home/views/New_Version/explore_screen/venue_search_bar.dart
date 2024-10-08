import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomVenueSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const CustomVenueSearchBar({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth = screenWidth * 0.82;
    final double searchWidth = screenWidth * 0.82;

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
          // const SizedBox(width: 16),
          // SizedBox(
          //   width: 24,
          //   height: 24,
          //   child: Image.asset(
          //     'assets/icons/setting-5.png',
          //     width: 24,
          //     height: 24,
          //   ),
          // ),
        ],
      ),
    );
  }
}
