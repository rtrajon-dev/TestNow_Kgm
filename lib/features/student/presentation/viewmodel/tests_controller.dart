import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testnow_mobile_app/features/student/domain/booking.dart';

enum TestsFilterSort { location, time, date }

class TestsState {
  final BookingStatus selectedStatus;
  final TestsFilterSort filterSort;
  final bool filterMenuOpen;

  const TestsState({
    this.selectedStatus = BookingStatus.available,
    this.filterSort = TestsFilterSort.time,
    this.filterMenuOpen = false,
  });

  TestsState copyWith({
    BookingStatus? selectedStatus,
    TestsFilterSort? filterSort,
    bool? filterMenuOpen,
  }) {
    return TestsState(
      selectedStatus: selectedStatus ?? this.selectedStatus,
      filterSort: filterSort ?? this.filterSort,
      filterMenuOpen: filterMenuOpen ?? this.filterMenuOpen,
    );
  }
}

class TestsController extends Notifier<TestsState> {
  @override
  TestsState build() => const TestsState();

  void selectStatus(BookingStatus s) =>
      state = state.copyWith(selectedStatus: s);

  void toggleFilterMenu() =>
      state = state.copyWith(filterMenuOpen: !state.filterMenuOpen);

  void setSort(TestsFilterSort sort) =>
      state = state.copyWith(filterSort: sort, filterMenuOpen: false);
}

final testsControllerProvider =
    NotifierProvider<TestsController, TestsState>(TestsController.new);

final mockBookingsProvider = Provider<List<Booking>>((ref) {
  final now = DateTime.now();
  return [
    Booking(
      id: 'b1',
      type: BookingType.dvsa,
      status: BookingStatus.available,
      dateTime: DateTime(now.year, now.month, now.day + 3, 9, 30),
      location: 'Isleworth Test Centre, London',
    ),
    Booking(
      id: 'b2',
      type: BookingType.swap,
      status: BookingStatus.available,
      dateTime: DateTime(now.year, now.month, now.day + 5, 14, 15),
      location: 'Wood Green Test Centre, London',
    ),
    Booking(
      id: 'b3',
      type: BookingType.swap,
      status: BookingStatus.pending,
      dateTime: DateTime(now.year, now.month, now.day + 8, 11, 0),
      location: 'Hendon Test Centre, London',
    ),
    Booking(
      id: 'b4',
      type: BookingType.dvsa,
      status: BookingStatus.approved,
      dateTime: DateTime(now.year, now.month, now.day + 12, 10, 0),
      location: 'Barnet Test Centre, London',
    ),
  ];
});
