import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testnow_mobile_app/features/auth/domain/user_role.dart';
import 'package:testnow_mobile_app/features/auth/domain/validators.dart';

class AboutFormState {
  final String fullName;
  final String houseNumber;
  final String street;
  final String town;
  final String postcode;
  final String drivingLicence;
  final String prn;
  final bool isLoadingLocation;

  const AboutFormState({
    this.fullName = '',
    this.houseNumber = '',
    this.street = '',
    this.town = '',
    this.postcode = '',
    this.drivingLicence = '',
    this.prn = '',
    this.isLoadingLocation = false,
  });

  AboutFormState copyWith({
    String? fullName,
    String? houseNumber,
    String? street,
    String? town,
    String? postcode,
    String? drivingLicence,
    String? prn,
    bool? isLoadingLocation,
  }) {
    return AboutFormState(
      fullName: fullName ?? this.fullName,
      houseNumber: houseNumber ?? this.houseNumber,
      street: street ?? this.street,
      town: town ?? this.town,
      postcode: postcode ?? this.postcode,
      drivingLicence: drivingLicence ?? this.drivingLicence,
      prn: prn ?? this.prn,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
    );
  }

  String? get fullNameError => AuthValidators.fullName(fullName);
  String? get houseNumberError => AuthValidators.houseNumber(houseNumber);
  String? get streetError => AuthValidators.street(street);
  String? get townError => AuthValidators.town(town);
  String? get postcodeError => AuthValidators.postcode(postcode);
  String? get drivingLicenceError => AuthValidators.drivingLicence(drivingLicence);
  String? get prnError => AuthValidators.prn(prn);

  bool isValid(UserRole role) {
    if (fullName.trim().isEmpty || fullNameError != null) return false;
    if (role == UserRole.student) {
      return houseNumber.trim().isNotEmpty &&
          houseNumberError == null &&
          street.trim().isNotEmpty &&
          streetError == null &&
          town.trim().isNotEmpty &&
          townError == null &&
          postcode.trim().isNotEmpty &&
          postcodeError == null;
    }
    return drivingLicence.trim().isNotEmpty &&
        drivingLicenceError == null &&
        prn.trim().isNotEmpty &&
        prnError == null;
  }
}

class AboutController extends Notifier<AboutFormState> {
  @override
  AboutFormState build() => const AboutFormState();

  void setFullName(String v) => state = state.copyWith(fullName: v);
  void setHouseNumber(String v) => state = state.copyWith(houseNumber: v);
  void setStreet(String v) => state = state.copyWith(street: v);
  void setTown(String v) => state = state.copyWith(town: v);
  void setPostcode(String v) =>
      state = state.copyWith(postcode: v.toUpperCase());
  void setDrivingLicence(String v) =>
      state = state.copyWith(drivingLicence: v.toUpperCase());
  void setPrn(String v) => state = state.copyWith(prn: v);

  Future<void> useCurrentLocation() async {
    state = state.copyWith(isLoadingLocation: true);
    await Future.delayed(const Duration(milliseconds: 800));
    state = state.copyWith(
      houseNumber: '12',
      street: 'Lynton Rd',
      town: 'London',
      postcode: 'SE11 8AB',
      isLoadingLocation: false,
    );
  }
}

final aboutControllerProvider =
    NotifierProvider<AboutController, AboutFormState>(AboutController.new);
