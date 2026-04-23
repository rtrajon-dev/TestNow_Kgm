import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testnow_mobile_app/features/auth/domain/address.dart';
import 'package:testnow_mobile_app/features/auth/domain/validators.dart';

const int kMaxPreviousAddresses = 5;

class PreviousAddressEntry {
  final Address address;
  final bool isLoadingLocation;

  const PreviousAddressEntry({
    this.address = const Address(),
    this.isLoadingLocation = false,
  });

  PreviousAddressEntry copyWith({
    Address? address,
    bool? isLoadingLocation,
  }) {
    return PreviousAddressEntry(
      address: address ?? this.address,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
    );
  }

  String? get houseNumberError => AuthValidators.houseNumber(address.houseNumber);
  String? get streetError => AuthValidators.street(address.street);
  String? get townError => AuthValidators.town(address.town);
  String? get postcodeError => AuthValidators.postcode(address.postcode);

  bool get isValid {
    return address.houseNumber.trim().isNotEmpty &&
        houseNumberError == null &&
        address.street.trim().isNotEmpty &&
        streetError == null &&
        address.town.trim().isNotEmpty &&
        townError == null &&
        address.postcode.trim().isNotEmpty &&
        postcodeError == null;
  }
}

class PreviousAddressController extends Notifier<List<PreviousAddressEntry>> {
  @override
  List<PreviousAddressEntry> build() => [const PreviousAddressEntry()];

  void addEntry() {
    if (state.length >= kMaxPreviousAddresses) return;
    state = [...state, const PreviousAddressEntry()];
  }

  void removeEntry(int index) {
    if (state.length <= 1) return;
    state = [
      for (var i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
  }

  void updateField(
    int index, {
    String? houseNumber,
    String? street,
    String? town,
    String? postcode,
  }) {
    final current = state[index];
    final next = current.copyWith(
      address: current.address.copyWith(
        houseNumber: houseNumber,
        street: street,
        town: town,
        postcode: postcode?.toUpperCase(),
      ),
    );
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) next else state[i],
    ];
  }

  Future<void> useCurrentLocation(int index) async {
    _setLoading(index, true);
    await Future.delayed(const Duration(milliseconds: 800));
    final current = state[index];
    final next = current.copyWith(
      address: const Address(
        houseNumber: '12',
        street: 'Lynton Rd',
        town: 'London',
        postcode: 'SE11 8AB',
      ),
      isLoadingLocation: false,
    );
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) next else state[i],
    ];
  }

  void _setLoading(int index, bool value) {
    final current = state[index];
    final next = current.copyWith(isLoadingLocation: value);
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) next else state[i],
    ];
  }

  bool get allValid => state.every((e) => e.isValid);
}

final previousAddressControllerProvider =
    NotifierProvider<PreviousAddressController, List<PreviousAddressEntry>>(
  PreviousAddressController.new,
);
