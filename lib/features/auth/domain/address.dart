class Address {
  final String houseNumber;
  final String street;
  final String town;
  final String postcode;

  const Address({
    this.houseNumber = '',
    this.street = '',
    this.town = '',
    this.postcode = '',
  });

  Address copyWith({
    String? houseNumber,
    String? street,
    String? town,
    String? postcode,
  }) {
    return Address(
      houseNumber: houseNumber ?? this.houseNumber,
      street: street ?? this.street,
      town: town ?? this.town,
      postcode: postcode ?? this.postcode,
    );
  }

  bool get isEmpty =>
      houseNumber.isEmpty && street.isEmpty && town.isEmpty && postcode.isEmpty;
}
