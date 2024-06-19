import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/get_venue_bloc/get_venue_bloc.dart';
import '../../Venue_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VenueListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Venue List Screen", style: TextStyle(fontSize: 24, color: Colors.black)),
        Expanded(
          child: BlocBuilder<GetVenueBloc, GetVenueState>(
            builder: (context, venueState) {
              if (venueState is GetVenueSuccess) {
                return VenueListWidget(state: venueState);
              }
              return const Center(child: CircularProgressIndicator(color: Color(0xFF13B8A8)));
            },
          ),
        ),
      ],
    );
  }
}
