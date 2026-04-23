import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestDetailsState {
  final String theoryTestNumber;
  final String drivingLicenceNumber;

  const TestDetailsState({
    this.theoryTestNumber = '',
    this.drivingLicenceNumber = '',
  });

  TestDetailsState copyWith({
    String? theoryTestNumber,
    String? drivingLicenceNumber,
  }) {
    return TestDetailsState(
      theoryTestNumber: theoryTestNumber ?? this.theoryTestNumber,
      drivingLicenceNumber: drivingLicenceNumber ?? this.drivingLicenceNumber,
    );
  }

  String? get theoryError {
    final v = theoryTestNumber.trim();
    if (v.isEmpty) return null;
    if (!RegExp(r'^\d{9}$').hasMatch(v)) {
      return 'Theory test number must be 9 digits';
    }
    return null;
  }

  String? get licenceError {
    final v = drivingLicenceNumber.trim().toUpperCase();
    if (v.isEmpty) return null;
    if (v.length != 16) return 'Licence must be 16 characters';
    if (!RegExp(r'^[A-Z]{5}\d{6}[A-Z0-9]{5}$').hasMatch(v)) {
      return 'Enter a valid DVSA-format licence number';
    }
    return null;
  }

  bool get isValid {
    return theoryTestNumber.trim().isNotEmpty &&
        theoryError == null &&
        drivingLicenceNumber.trim().isNotEmpty &&
        licenceError == null;
  }
}

class TestDetailsController extends Notifier<TestDetailsState> {
  @override
  TestDetailsState build() => const TestDetailsState();

  void setTheory(String v) => state = state.copyWith(theoryTestNumber: v);
  void setLicence(String v) =>
      state = state.copyWith(drivingLicenceNumber: v.toUpperCase());
}

final testDetailsControllerProvider =
    NotifierProvider<TestDetailsController, TestDetailsState>(
  TestDetailsController.new,
);
