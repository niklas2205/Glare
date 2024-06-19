part of 'bottom_navigation_bloc.dart';

class BottomNavigationState extends Equatable {
  final int selectedIndex;

  const BottomNavigationState({required this.selectedIndex});

  factory BottomNavigationState.initial() {
    return const BottomNavigationState(selectedIndex: 0);
  }

  BottomNavigationState copyWith({int? selectedIndex}) {
    return BottomNavigationState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  @override
  List<Object> get props => [selectedIndex];
}
