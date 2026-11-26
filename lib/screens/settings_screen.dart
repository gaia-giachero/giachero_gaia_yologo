import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/models/user.dart';
import 'package:giachero_gaia_yologo/screens/auth/login_screen.dart';
import 'package:giachero_gaia_yologo/services/auth_service.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/theme/app_theme.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/widgets/app_button.dart';
import 'package:giachero_gaia_yologo/widgets/profile_header.dart';
import 'package:giachero_gaia_yologo/widgets/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final User user;

  const SettingsScreen({required this.user, super.key});

  @override
  State<SettingsScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late ThemeMode _initialTheme;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _bioController = TextEditingController(text: widget.user.bio ?? '');
    _initialTheme = themeNotifier.value;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _cancelAndPop() {
    themeNotifier.value = _initialTheme;
    Navigator.pop(context);
  }

  bool get _hasChanges {
    final currentUsername = _usernameController.text.trim();
    final currentBio = _bioController.text.trim();
    final initialBio = (widget.user.bio ?? '').trim();

    return currentUsername != widget.user.username ||
        currentBio != initialBio ||
        themeNotifier.value != _initialTheme;
  }

  bool get _canSave =>
      _hasChanges && _usernameController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final username = _usernameController.text;
    final bio = _bioController.text;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.paddingHorizontalPage,
            AppSizes.paddingTopPage,
            AppSizes.paddingHorizontalPage,
            AppSizes.paddingBottomPage,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _cancelAndPop,
                      icon: const Icon(Icons.arrow_back_ios),
                      color: AppColors.of(context).textPrimary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    SizedBox(width: AppSizes.gapBackButton),
                    Text(
                      AppStrings.profile,
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.of(context).textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.gapSettings),
                Center(child: ProfileHeader(username: username)),
                SizedBox(height: AppSizes.gapSettings),
                Text(
                  AppStrings.modify,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.of(context).textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.gapSettings),
                AppTextField(
                  controller: _usernameController,
                  labelText: username,
                  hintText: username,
                  showLabel: false,
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: AppSizes.gapSettings),
                AppTextField(
                  controller: _bioController,
                  labelText: bio,
                  hintText: bio,
                  showLabel: false,
                  maxLines: 4,
                  onChanged: (_) => setState(() {})
                ),
                SizedBox(height: AppSizes.gapSettings),
                const Divider(),
                SizedBox(height: AppSizes.gapSettings),
                Text(
                  AppStrings.theme,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.of(context).textPrimary,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.themeDark),
                    Switch(
                      value: themeNotifier.value == ThemeMode.dark,
                      onChanged: (isDark) {
                        setState(() {
                          themeNotifier.value = isDark
                              ? ThemeMode.dark
                              : ThemeMode.light;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.gapSettings),
                const Divider(),
                SizedBox(height: AppSizes.gapSettings),
                AppButton(
                  labelButton: AppStrings.saveSettings,
                  onTap: _canSave ? () async {
                    final newUsername = _usernameController.text.trim();
                    final newBio = _bioController.text.trim();

                    final ok = await AuthService.updateProfile(
                      widget.user.id,
                      newUsername,
                      newBio.isEmpty ? null : newBio,
                    );

                    if (!context.mounted) return;

                    if (ok) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool(
                        'isDarkMode',
                        themeNotifier.value == ThemeMode.dark,
                      );

                      final updatedUser = widget.user.copyWith(
                        username: newUsername,
                        bio: newBio.isEmpty ? null : newBio,
                      );
                      if (!context.mounted) return;
                      Navigator.pop(context, updatedUser);
                    }
                  } : null,
                ),
                SizedBox(height: AppSizes.gapButton),
                if (_hasChanges) ...[
                  SizedBox(height: AppSizes.gapButton),
                  AppButton(
                    labelButton: AppStrings.cancelButton,
                    variant: AppButtonVariant.secondary,
                    onTap: _cancelAndPop,
                  ),
                ],
                SizedBox(height: AppSizes.gapSettings),
                const Divider(),
                SizedBox(height: AppSizes.gapSettings),
                AppButton(
                  icon: Icons.logout,
                  labelButton: AppStrings.logoutButton,
                  variant: AppButtonVariant.secondary,
                  onTap: () async {
                    await AuthService.signOut();
                    if (!context.mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
