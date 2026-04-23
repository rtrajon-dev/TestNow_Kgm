class AuthValidators {
  AuthValidators._();

  static final RegExp _ukPostcode = RegExp(
    r'^[A-Z]{1,2}[0-9][A-Z0-9]? ?[0-9][A-Z]{2}$',
    caseSensitive: false,
  );

  static final RegExp _lettersAndSpaces = RegExp(r'^[a-zA-Z\s]+$');
  static final RegExp _alphanumericUpper = RegExp(r'^[A-Z0-9]+$');
  static final RegExp _gbLicence = RegExp(r'^[A-Z]{5}\d{6}[A-Z0-9]{5}$');
  static final RegExp _niLicence = RegExp(r'^\d{8}$');

  static String? fullName(String raw) {
    final name = raw.trim();
    if (name.isEmpty) return null;
    if (name.length < 2) return 'Name must be at least 2 characters';
    if (!_lettersAndSpaces.hasMatch(name)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  static String? houseNumber(String raw) {
    if (raw.trim().isEmpty) return null;
    return null;
  }

  static String? street(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return null;
    if (s.length < 3) return 'Street name must be at least 3 characters';
    return null;
  }

  static String? town(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return null;
    if (t.length < 2) return 'Town name must be at least 2 characters';
    if (!_lettersAndSpaces.hasMatch(t)) {
      return 'Town can only contain letters and spaces';
    }
    return null;
  }

  static String? postcode(String raw) {
    final p = raw.trim().toUpperCase();
    if (p.isEmpty) return null;
    if (!_ukPostcode.hasMatch(p)) return 'Please enter a valid UK postcode';
    return null;
  }

  static String? drivingLicence(String raw) {
    final lic = raw.trim().toUpperCase();
    if (lic.isEmpty) return null;
    if (!_alphanumericUpper.hasMatch(lic)) {
      return 'Please enter a valid driving licence number based on DVSA format.';
    }
    if (_niLicence.hasMatch(lic)) return null;
    if (lic.length == 16 && _gbLicence.hasMatch(lic)) return null;
    return 'Please enter a valid driving licence number based on DVSA format.';
  }

  static String? prn(String raw) {
    final p = raw.trim();
    if (p.isEmpty) return null;
    if (p.length != 6) return 'PRN must be exactly 6 digits';
    return null;
  }
}
