import 'package:flutter/material.dart';
import 'package:giachero_gaia_yologo/screens/auth/login_screen.dart';
import 'package:giachero_gaia_yologo/theme/app_colors.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/utils/helpers.dart';
import 'package:giachero_gaia_yologo/widgets/app_button.dart';
import 'package:giachero_gaia_yologo/widgets/profile_header.dart';
import 'package:giachero_gaia_yologo/widgets/text_field.dart';

class SettingsScreen extends StatefulWidget {
  final String nomeUtente;
  final String? bioUtente;

  const SettingsScreen({required this.nomeUtente, this.bioUtente, super.key});

  @override
  State<SettingsScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.nomeUtente);
    _bioController = TextEditingController(text: widget.bioUtente ?? '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

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
                      onPressed: () => Navigator.pop(context),
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
                ),
                SizedBox(height: AppSizes.gapSettings),
                Divider(),
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
                    Switch(value: false, onChanged: null),
                  ],
                ),
                SizedBox(height: AppSizes.gapSettings),
                Divider(),
                SizedBox(height: AppSizes.gapSettings),
                AppButton(labelButton: AppStrings.saveSettings, onTap: () {}),
                SizedBox(height: AppSizes.gapButton),
                AppButton(
                  labelButton: AppStrings.cancelButton,
                  variant: AppButtonVariant.secondary,
                  onTap: () {},
                ),
                SizedBox(height: AppSizes.gapSettings),
                Divider(),
                SizedBox(height: AppSizes.gapSettings),
                AppButton(
                  icon: Icons.logout,
                  labelButton: AppStrings.logoutButton,
                  variant: AppButtonVariant.secondary,
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
