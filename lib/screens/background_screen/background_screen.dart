

import 'package:flutter/material.dart';

class BackgroundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Style_img/kajetan-sumila-EUAzJnKSNQg-unsplash_1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
        ],
      ),
    );
  }
}