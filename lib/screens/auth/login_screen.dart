import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/services/auth_service.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/screens/main_shell_screen.dart';
import 'package:giachero_gaia_yologo/utils/validators.dart';
import 'package:giachero_gaia_yologo/widgets/app_button.dart';
import 'package:giachero_gaia_yologo/widgets/text_field.dart';

import '../../utils/helpers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  String? errorMessage;
  bool _isLoading = false;

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = AppStrings.emptyField);
      return;
    }

    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    final result = await AuthService.signIn(email, password);

    if (!mounted) return;

    switch (result.status) {
      case AuthStatus.success:
        final userResult = result.user;
        if (userResult != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  MainShellScreen(user: userResult),
            ),
          );
        } else {
          setState(() {
            _isLoading = false;
            errorMessage = AppStrings.detailError;
          });
        }
      case AuthStatus.invalidCredentials:
        setState(() {
          errorMessage = AppStrings.loginError;
          _isLoading = false;
        });
      case AuthStatus.error:
        setState(() {
          errorMessage = AppStrings.detailError;
          _isLoading = false;
        });
    }
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = errorMessage;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_yologo.webp',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black.withValues(
                alpha: 0.4,
              ), 
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingHorizontal,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.title,
                            style: AppTextStyles.brandTitle.copyWith(
                              color: AppColors.of(context).textLogin,
                            ),
                          ),
                          Text(
                            AppStrings.intestation,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.of(context).textLogin,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.gapTitleCard),
                      SingleChildScrollView(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusBox,
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              color: AppColors.of(context).background
                                  .withValues(
                                    alpha: 0.5,
                                  ), // fill semitrasparente
                              child: SizedBox(
                                width: AppSizes.widthBox,
                                height: AppSizes.heightBox,
                                // child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    AppSizes.paddingBox,
                                    AppSizes.paddingBox,
                                    AppSizes.paddingBox,
                                    AppSizes.paddingBottomBox,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppStrings.titleLogin,
                                        style: AppTextStyles.h4.copyWith(
                                          color: AppColors.of(context)
                                              .textPrimary,
                                        ),
                                      ),
                                      Text(
                                        AppStrings.intestationLogin,
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          color: AppColors.of(context)
                                              .textPrimary,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: AppSizes.gapTextBox,
                                      ),
                                      AppTextField(
                                        labelText: AppStrings.hintLabelEmail,
                                        hintText: AppStrings.hintLabelEmail,
                                        controller: emailController,
                                        validator: Validators.email,
                                      ),
                                      const SizedBox(
                                        height: AppSizes.gapFieldBox,
                                      ),
                                      AppTextField(
                                        labelText: AppStrings.hintLabelPassword,
                                        hintText: AppStrings.hintLabelPassword,
                                        isPassword: true,
                                        controller: passwordController,
                                        validator: Validators.password,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          child: Text(
                                            AppStrings.forgotPassword,
                                            style: AppTextStyles.body.copyWith(
                                              color: AppColors.of(context)
                                                  .primary,
                                            ),
                                          ),
                                          onTap: () {
                                            _mostraBottomSheet(context);
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: AppSizes.gapTextBox,
                                      ),
                                      if (error != null)
                                        Text(
                                          error,
                                          style: AppTextStyles.body.copyWith(
                                            color: AppColors.of(context).error,
                                          ),
                                        ),
                                      const SizedBox(
                                        height: AppSizes.gapTextBox,
                                      ),
                                      AppButton(
                                        labelButton: AppStrings.loginButton,
                                        isLoading: _isLoading,
                                        onTap: _login,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _mostraBottomSheet(BuildContext context) {
  bool sent = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => StatefulBuilder(
      builder: (context, setSheetState) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSizes.horizontalPadding,
            AppSizes.verticalPadding,
            AppSizes.horizontalPadding,
            AppSizes.verticalPadding + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.requestButton,
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.of(context).textPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.cancel_outlined),
                      color: AppColors.of(context).textPrimary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.gapSheet),
              sent == true
                  ? Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(AppStrings.confirmMessage),
                        ),
                        const SizedBox(height: AppSizes.gapSheet),
                        AppButton(
                          labelButton: AppStrings.requestSend,
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AppTextField(
                            labelText: AppStrings.hintLabelEmail,
                            hintText: AppStrings.hintLabelEmail,
                          ),
                        ),
                        const SizedBox(height: AppSizes.gapSheet),
                        AppButton(
                          labelButton: AppStrings.requestButton,
                          onTap: () => setSheetState(() => sent = true),
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
    ),
  );
}
