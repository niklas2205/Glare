import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
//import 'package:glare/main.dart';
import 'package:venue_repository/venue_repository.dart';


part 'get_venue_event.dart';
part 'get_venue_state.dart';

class GetVenueBloc extends Bloc<GetVenueEvent, GetVenueState> {
  final VenueRepo venueRepo;

  GetVenueBloc(this.venueRepo) : super(GetVenueInitial()) {
    on<GetVenue>(_onGetVenue);
  }

  Future<void> _onGetVenue(GetVenue event, Emitter<GetVenueState> emit) async {
    emit(GetVenueLoading());
    try {
      final venues = await venueRepo.getVenues();
      emit(GetVenueSuccess(venues));
    } catch (e) {
      emit(GetVenueFailure());
    }
  }
}

