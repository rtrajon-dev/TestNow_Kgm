import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:testnow_mobile_app/features/auth/domain/user_role.dart';
import 'package:testnow_mobile_app/features/auth/presentation/view/about_page.dart';
import 'package:testnow_mobile_app/features/auth/presentation/view/account_under_review_page.dart';
import 'package:testnow_mobile_app/features/auth/presentation/view/address_page.dart';
import 'package:testnow_mobile_app/features/auth/presentation/view/choose_plan_page.dart';
import 'package:testnow_mobile_app/features/auth/presentation/view/login_page.dart';
import 'package:testnow_mobile_app/features/auth/presentation/view/previous_address_page.dart';
import 'package:testnow_mobile_app/features/auth/presentation/view/role_selection_page.dart';
import 'package:testnow_mobile_app/features/auth/presentation/view/splash_page.dart';
import 'package:testnow_mobile_app/features/auth/presentation/view/status_page.dart';
import 'package:testnow_mobile_app/features/auth/presentation/view/test_details_page.dart';
import 'package:testnow_mobile_app/features/auth/presentation/view/type_of_instructor_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String about = '/about';
  static const String testDetails = '/test-details';
  static const String address = '/address';
  static const String previousAddress = '/previous-address';
  static const String typeOfInstructor = '/type-of-instructor';
  static const String accountReview = '/account-review';
  static const String status = '/status';
  static const String choosePlan = '/choose-plan';
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        builder: (context, state) => const RoleSelectionPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => LoginPage(
          role: _roleFromQuery(state.uri.queryParameters['role']),
        ),
      ),
      GoRoute(
        path: AppRoutes.about,
        builder: (context, state) => AboutPage(
          role: _roleFromQuery(state.uri.queryParameters['role']),
        ),
      ),
      GoRoute(
        path: AppRoutes.testDetails,
        builder: (context, state) => TestDetailsPage(
          role: _roleFromQuery(state.uri.queryParameters['role']),
        ),
      ),
      GoRoute(
        path: AppRoutes.typeOfInstructor,
        builder: (context, state) => const TypeOfInstructorPage(),
      ),
      GoRoute(
        path: AppRoutes.address,
        builder: (context, state) => AddressPage(
          role: _roleFromQuery(state.uri.queryParameters['role']),
        ),
      ),
      GoRoute(
        path: AppRoutes.previousAddress,
        builder: (context, state) => const PreviousAddressPage(),
      ),
      GoRoute(
        path: AppRoutes.accountReview,
        builder: (context, state) => AccountUnderReviewPage(
          role: _roleFromQuery(state.uri.queryParameters['role']),
        ),
      ),
      GoRoute(
        path: AppRoutes.status,
        builder: (context, state) => StatusPage(
          role: _roleFromQuery(state.uri.queryParameters['role']),
        ),
      ),
      GoRoute(
        path: AppRoutes.choosePlan,
        builder: (context, state) => const ChoosePlanPage(),
      ),
    ],
  );
});

UserRole _roleFromQuery(String? raw) {
  return UserRole.values.firstWhere(
    (r) => r.name == raw,
    orElse: () => UserRole.student,
  );
}
