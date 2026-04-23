import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:testnow_mobile_app/app/router/app_router.dart';
import 'package:testnow_mobile_app/app/theme/app_colors.dart';
import 'package:testnow_mobile_app/app/theme/app_text_styles.dart';
import 'package:testnow_mobile_app/app/theme/input_decorations.dart';
import 'package:testnow_mobile_app/app/utils/app_assets.dart';
import 'package:testnow_mobile_app/features/auth/domain/user_role.dart';
import 'package:testnow_mobile_app/features/auth/presentation/viewmodel/login_controller.dart';
import 'package:testnow_mobile_app/global_widgets/custom_app_bar.dart';
import 'package:testnow_mobile_app/global_widgets/custom_primary_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  final UserRole role;

  const LoginPage({super.key, required this.role});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  bool get _isInstructor => widget.role == UserRole.instructor;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.go(
      '${AppRoutes.accountReview}?role=${widget.role.name}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    final controller = ref.read(loginControllerProvider.notifier);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                120.verticalSpace,
                Image.asset(AppAssets.logo, scale: 4),
                10.verticalSpace,
                Text('TestNow', style: AppTextStyles.style25Bold),
                40.verticalSpace,
                _buildLabel(
                  _isInstructor ? 'PRN Number' : 'Driving License Number',
                ),
                _buildIdField(),
                20.verticalSpace,
                _buildLabel('Password'),
                _buildPasswordField(state.isPasswordVisible, controller),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot password?',
                      style: AppTextStyles.style16
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                ),
                40.verticalSpace,
                CustomPrimaryButton(
                  text: 'Login',
                  isLoading: state.isLoading,
                  onPressed: _submit,
                ),
                60.verticalSpace,
                GestureDetector(
                  onTap: () {
                    context.push('${AppRoutes.about}?role=${widget.role.name}');
                  },
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "I don't have an account? ",
                        style: AppTextStyles.style17_600.copyWith(
                          color: AppColors.greyBorder,
                        ),
                      ),
                      TextSpan(
                        text: 'SignUp',
                        style: AppTextStyles.style17_600,
                      ),
                    ]),
                  ),
                ),
                10.verticalSpace,
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: AppTextStyles.style17_600),
      ),
    );
  }

  Widget _buildIdField() {
    return TextFormField(
      controller: _idController,
      keyboardType: _isInstructor ? TextInputType.number : TextInputType.text,
      textCapitalization: _isInstructor
          ? TextCapitalization.none
          : TextCapitalization.characters,
      maxLength: _isInstructor ? 6 : 16,
      inputFormatters: _isInstructor
          ? [FilteringTextInputFormatter.digitsOnly]
          : [UpperCaseTextFormatter()],
      decoration: AppInputDecorations.authField(
        hintText: _isInstructor
            ? 'Enter 6 digit PRN'
            : 'Enter 16 character Driving License',
        counterText: '',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _isInstructor
              ? 'PRN is required'
              : 'Driving License is required';
        }
        if (_isInstructor && value.length != 6) {
          return 'PRN must be 6 digits';
        }
        if (!_isInstructor && value.length != 16) {
          return 'Driving License must be 16 characters';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(bool visible, LoginController controller) {
    return TextFormField(
      controller: _passwordController,
      obscureText: !visible,
      decoration: AppInputDecorations.authField(
        hintText: 'Created during sign up',
        suffixIcon: IconButton(
          icon: Icon(
            visible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: controller.togglePasswordVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        return null;
      },
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
