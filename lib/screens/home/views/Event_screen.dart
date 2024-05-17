import 'package:flutter/material.dart';

class EventDetail extends StatelessWidget {
  final String name;
  final String venue;
  final String description;
  final String pictureUrl;

  const EventDetail({
    required this.name,
    required this.venue,
    required this.description,
    required this.pictureUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Changed to black for futuristic theme
      appBar: AppBar(
        backgroundColor: Colors.black, // Changed to black for futuristic theme
        title: const Text(
          'Event Details',
          style: TextStyle(
            color: Color(0xFF13B8A8), // Neon green color for the title
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width - (40),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0), // Slight grey tone for the image container
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  image: NetworkImage(pictureUrl), // Use NetworkImage for the picture URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20), // Add space between the image and the text
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0), // Slight grey tone for the details container
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start, 
                    children: [
                      Text(
                        name, // Use provided name for the event name
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF13B8A8), // Changed to neon green for futuristic theme
                        ),
                      ),
                      const SizedBox(height: 10), // Add space between the name and the venue
                      Text(
                        venue, // Use provided venue for the event venue
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF13B8A8), // Changed to neon green for futuristic theme
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Add space between the details container and the description
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        description, // Use provided description for the event description
                        style: const TextStyle(
                          color: Colors.white, // Changed to white for better readability on black background
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}