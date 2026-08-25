import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/app_images.dart';
import '../../utils/firebase_functions.dart';
import '../../providers/my_provider.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../register/register_screen.dart';
import 'forget_password/forget_password_screen.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ThemeProvider>(context);
    var userProvider = Provider.of<MyProvider>(context);
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
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    eventlyLogo,
                    height: 50,
                  ),
                ),
                const SizedBox(height: 48),

                Text(
                  "login_title".tr(),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                ),
                const SizedBox(height: 24),

                CustomTextField(
                  controller: _emailController,
                  hintText: "login_email_hint".tr(),
                  prefixImageAsset: AppImagesWhiteMode.smsIcon,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _passwordController,
                  hintText: "login_password_hint".tr(),
                  prefixImageAsset: AppImagesWhiteMode.lockIcon,
                  isPassword: true,
                ),
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, ForgetPasswordScreen.routeName);
                    },
                    child: Text(
                      "forget_password_question".tr(),
                      style: GoogleFonts.poppins(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 47),

                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        FirebaseFunctions.login(
                          _emailController.text.trim(),
                          _passwordController.text,
                              () async {
                            await userProvider.initUser();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              HomeScreen.routeName,
                                  (r) => false,
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
                      "login_button".tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${"no_account_text".tr()} ",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 14,
                        color: isDark ? Colors.white:Color(0xff686868) ,
                          ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterScreen.routeName);
                      },
                      child: Text(
                        "signup_link".tr(),
                        style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
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
                        try {
                          await FirebaseFunctions().signInWithGoogle();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
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
                          "login_with_google".tr(),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
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
