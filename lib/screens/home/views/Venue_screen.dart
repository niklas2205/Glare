import 'package:flutter/material.dart';

class VenueDetail extends StatelessWidget {
  final String name;
  final String address;
  final String description;
  final String pictureUrl;
  final String instagram;  // Added 'instagram' field
  final String website;    // Added 'website' field

  const VenueDetail({
    required this.name,
    required this.address,
    required this.description,
    required this.pictureUrl,
    required this.instagram,  // Initialize 'instagram'
    required this.website,    // Initialize 'website'
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width - (40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  image: NetworkImage(pictureUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start, 
                    children: [
                      Text(
                        name,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        address,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        description,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Adds space between elements
            Text(
              instagram, // Displays the Instagram information
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blue, // Style it as needed
              ),
            ),
            const SizedBox(height: 10), // Adds space between elements
            Text(
              website, // Displays the Website information
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blue, // Style it as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
