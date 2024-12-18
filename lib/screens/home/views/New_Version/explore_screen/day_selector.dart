import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../blocs/day_selector_bloc/day_selector_bloc.dart'; // Add this import for DateFormat

class DaySelector extends StatelessWidget {
  final Function(DateTime) onDaySelected;
  final ScrollController scrollController = ScrollController(); // for horizontal scrolling

  DaySelector({Key? key, required this.onDaySelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DateTime> days = List.generate(30, (i) => DateTime.now().add(Duration(days: i)));

    return BlocBuilder<DaySelectorBloc, DaySelectorState>(
      builder: (context, state) {
        DateTime? selectedDate;
        if (state is DaySelected) {
          selectedDate = state.selectedDate;
          // Auto scroll the horizontal list to the selected date
          Future.microtask(() {
            final index = days.indexWhere((d) => _isSameDate(d, selectedDate!));
            if (index != -1 && scrollController.hasClients) {
              // Center the selected date
              // Each item has width approx: let's assume a fixed width for each date container
              // For a more dynamic approach, measure the item width or use a fixed width.
              // Let's assume each item has width of about 100 including margins.
              double itemWidth = 100.0;
              double offset = index * itemWidth - (MediaQuery.of(context).size.width / 2) + (itemWidth / 2);
              offset = offset < 0 ? 0 : offset;
              scrollController.animateTo(offset, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
            }
          });
        }

        return Container(
          height: 60,
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = selectedDate != null && _isSameDate(selectedDate, day);
              final dayText = DateFormat('dd.MM').format(day);
              final weekdayText = DateFormat('EEE').format(day);

              return GestureDetector(
                onTap: () {
                  context.read<DaySelectorBloc>().add(SelectDay(day));
                  onDaySelected(day);
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF8FFA58)),
                    borderRadius: BorderRadius.circular(10),
                    color: isSelected ? const Color(0xFF8FFA58) : const Color(0xFF1A1A1A),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayText,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        weekdayText,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}