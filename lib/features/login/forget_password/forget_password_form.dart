import 'package:easy_localization/easy_localization.dart';
import 'package:evently_app/features/login/login.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_images.dart';
import '../../../utils/widgets/custom_text_field.dart';

class ForgetPasswordForm extends StatefulWidget {
  static const String routeName = "forget_password_form";
  const ForgetPasswordForm({super.key});

  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _passwordController,
            hintText: "register_password_hint".tr(),
            prefixImageAsset: AppImagesWhiteMode.lockIcon,
            isPassword: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "register_password_hint".tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Confirm Password Field
          CustomTextField(
            controller: _confirmPasswordController,
            hintText: "register_confirm_password_hint".tr(),
            prefixImageAsset: AppImagesWhiteMode.lockIcon,
            isPassword: true,
            validator: (value) {
              if (value != _passwordController.text) {
                return 'password_not_matched'.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Reset Password Button
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('password_reset_success'.tr()),
                      backgroundColor: primaryColor,
                    ),
                  );
                  Navigator.pushNamed(context, LoginScreen.routeName);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                "reset_password_button".tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
