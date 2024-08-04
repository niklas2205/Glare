import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:event_repository/event_repository.dart';


part 'get_event_event.dart';
part 'get_event_state.dart';

class GetEventBloc extends Bloc<GetEventEvent, GetEventState> {
  final EventRepo _eventRepo;

  GetEventBloc(this._eventRepo) : super(GetEventInitial()) {
    on<GetEventEvent>((event, emit) async {
      if (event is LoadEvents) {
        emit(GetEventLoading());
        try {
          List<Event> events = await _eventRepo.getFutureEvents();
          emit(GetEventSuccess(events));
        } catch (e) {
          emit(GetEventFailure());
        }
      }
    });

    // Load initial events when the bloc is created
    add(LoadEvents());
  }
}


