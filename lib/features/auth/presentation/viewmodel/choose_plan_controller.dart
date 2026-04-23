import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlanFeature {
  final String text;
  final bool isIncluded;
  final bool isYellow;

  const PlanFeature({
    required this.text,
    this.isIncluded = true,
    this.isYellow = false,
  });
}

class Plan {
  final String title;
  final String price;
  final String subtitle;
  final String buttonText;
  final List<PlanFeature> features;

  const Plan({
    required this.title,
    required this.price,
    required this.subtitle,
    required this.buttonText,
    required this.features,
  });
}

class ChoosePlanState {
  final int selectedIndex;
  final String? selectedPaymentMethod;

  const ChoosePlanState({
    this.selectedIndex = 0,
    this.selectedPaymentMethod,
  });

  Plan get currentPlan => plans[selectedIndex];

  ChoosePlanState copyWith({int? selectedIndex, String? selectedPaymentMethod}) {
    return ChoosePlanState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
    );
  }
}

const List<Plan> plans = [
  Plan(
    title: 'Free',
    price: 'Free',
    subtitle: '',
    buttonText: 'Continue with Free',
    features: [
      PlanFeature(text: 'Basic test swapping'),
      PlanFeature(text: 'Instant DVSA notifications', isIncluded: false),
      PlanFeature(text: 'Priority swap matching', isIncluded: false),
    ],
  ),
  Plan(
    title: 'Plus',
    price: '\u00a34.99',
    subtitle: 'per month',
    buttonText: 'Get Plus',
    features: [
      PlanFeature(text: 'Basic test swapping'),
      PlanFeature(text: 'Instant DVSA notifications', isYellow: true),
      PlanFeature(text: 'Priority swap matching', isIncluded: false),
    ],
  ),
  Plan(
    title: 'Premium',
    price: '\u00a39.99',
    subtitle: 'per month',
    buttonText: 'Get Premium',
    features: [
      PlanFeature(text: 'Basic test swapping'),
      PlanFeature(text: 'Instant DVSA notifications', isYellow: true),
      PlanFeature(text: 'Priority swap matching'),
    ],
  ),
];

class ChoosePlanController extends Notifier<ChoosePlanState> {
  @override
  ChoosePlanState build() => const ChoosePlanState();

  void selectPlan(int index) {
    state = state.copyWith(selectedIndex: index);
  }

  void selectPaymentMethod(String method) {
    state = state.copyWith(selectedPaymentMethod: method);
  }
}

final choosePlanControllerProvider =
    NotifierProvider<ChoosePlanController, ChoosePlanState>(
  ChoosePlanController.new,
);
