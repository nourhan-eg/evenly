import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/app_images.dart';
import '../../utils/firebase_functions.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../home/home_screen.dart';
import '../login/login.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "register";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final eventlyLogo = isDark
        ? AppImagesDarkMode.eventlyTop
        : AppImagesWhiteMode.eventlyTop;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Image.asset(
                    eventlyLogo,
                    height: 50,
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  "register_title".tr(),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                ),
                const SizedBox(height: 24),

                CustomTextField(
                  controller: _nameController,
                  hintText: "register_name_hint".tr(),
                  prefixIconData: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _emailController,
                  hintText: "register_email_hint".tr(),
                  prefixImageAsset: AppImagesWhiteMode.smsIcon,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _passwordController,
                  hintText: "register_password_hint".tr(),
                  prefixImageAsset: AppImagesWhiteMode.lockIcon,
                  isPassword: true,
                ),
                const SizedBox(height: 16),

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
                const SizedBox(height: 64),

                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        FirebaseFunctions.register(
                          _nameController.text.trim(),
                          _emailController.text.trim(),
                          _passwordController.text,
                              () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              LoginScreen.routeName,
                                  (_) => false,
                            );
                          },
                              (message) {
                            Fluttertoast.showToast(
                              msg: message,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          },
                        );
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "signup_button".tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${"have_account_text".tr()} ",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 15,
                            color: isDark ? Colors.white:Color(0xff686868) ,
                          ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        }
                      },
                      child: Text(
                        "login_link".tr(),
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Center(
                  child: Text(
                      "or_text".tr(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: primaryColor)
                  ),
                ),
                const SizedBox(height: 24),


                SizedBox(
                  height: 54,
                  child: OutlinedButton(
                    onPressed: () async {
                      final userCredential =
                      await FirebaseFunctions().signUpWithGoogle();

                      if (userCredential != null) {
                        print("User: ${userCredential.user?.email}");

                        // Navigate to Home
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                      side: BorderSide(
                        color: primaryColor,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImagesWhiteMode.google,
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "signup_with_google".tr(),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
