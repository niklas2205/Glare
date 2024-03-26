import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
//import 'package:glare/main.dart';
import 'package:venue_repository/venue_repository.dart';


part 'get_venue_event.dart';
part 'get_venue_state.dart';

class GetVenueBloc extends Bloc<GetVenueEvent, GetVenueState> {
  final VenueRepo _venueRepo;

  GetVenueBloc(this._venueRepo) : super(GetVenueInitial()) {
    on<GetVenueEvent>((event, emit) async{
      emit(GetVenueLoading());
      try{
        List<Venue> events = await _venueRepo.getVenue();
        emit(GetVenueSuccess(events));

      } catch(e) {
        emit(GetVenueFailure());

      }
      
    
    }
    );

  }
}
