import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfessionalDetailsState {
  final String? badgeImagePath;
  final DateTime? expiryDate;

  const ProfessionalDetailsState({
    this.badgeImagePath,
    this.expiryDate,
  });

  ProfessionalDetailsState copyWith({
    String? badgeImagePath,
    DateTime? expiryDate,
    bool clearBadge = false,
    bool clearExpiry = false,
  }) {
    return ProfessionalDetailsState(
      badgeImagePath:
          clearBadge ? null : (badgeImagePath ?? this.badgeImagePath),
      expiryDate: clearExpiry ? null : (expiryDate ?? this.expiryDate),
    );
  }

  bool get isValid => badgeImagePath != null && expiryDate != null;
}

class ProfessionalDetailsController
    extends Notifier<ProfessionalDetailsState> {
  @override
  ProfessionalDetailsState build() => const ProfessionalDetailsState();

  void setBadgeImage(String path) =>
      state = state.copyWith(badgeImagePath: path);

  void setExpiryDate(DateTime date) =>
      state = state.copyWith(expiryDate: date);
}

final professionalDetailsControllerProvider = NotifierProvider<
    ProfessionalDetailsController,
    ProfessionalDetailsState>(ProfessionalDetailsController.new);
