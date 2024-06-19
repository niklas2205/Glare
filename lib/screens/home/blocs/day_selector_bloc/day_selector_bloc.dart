import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'day_selector_event.dart';
part 'day_selector_state.dart';

class DaySelectorBloc extends Bloc<DaySelectorEvent, DaySelectorState> {
  DaySelectorBloc() : super(DaySelectorInitial()) {
    on<SelectDay>((event, emit) {
      emit(DaySelected(event.selectedDate));
    });
  }
}