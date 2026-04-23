import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginFormState {
  final bool isPasswordVisible;
  final bool isLoading;

  const LoginFormState({
    this.isPasswordVisible = false,
    this.isLoading = false,
  });

  LoginFormState copyWith({bool? isPasswordVisible, bool? isLoading}) {
    return LoginFormState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LoginController extends Notifier<LoginFormState> {
  @override
  LoginFormState build() => const LoginFormState();

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }
}

final loginControllerProvider =
    NotifierProvider<LoginController, LoginFormState>(LoginController.new);
