enum BookingType { dvsa, swap }

enum BookingStatus { available, pending, approved }

class Booking {
  final String id;
  final BookingType type;
  final BookingStatus status;
  final DateTime dateTime;
  final String location;

  const Booking({
    required this.id,
    required this.type,
    required this.status,
    required this.dateTime,
    required this.location,
  });

  String get typeLabel => type == BookingType.dvsa ? 'DVSA Test' : 'Swap Test';

  String get buttonLabel => type == BookingType.dvsa ? 'Select' : 'Request';

  String get pendingBadgeLabel =>
      type == BookingType.dvsa ? 'DVSA Notified' : 'Swap Requested';

  String get approvedBadgeLabel =>
      type == BookingType.dvsa ? 'DVSA Booked' : 'Swap Approved';
}
