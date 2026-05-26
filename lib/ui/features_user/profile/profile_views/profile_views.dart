import 'package:biztidy_mobile_app/ui/features_user/nav_bar/data/page_index_class.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/views/custom_navbar.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_controller/profile_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/change_password_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/edit_profile_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/help_center_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/web_data_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/widgets/guest_user_prompt_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/profile/profile_views/widgets/image_full_screen_view.dart';
import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/globals.dart';
import 'package:biztidy_mobile_app/ui/shared/loading_widget.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:biztidy_mobile_app/utils/app_constants/constants.dart';
import 'package:biztidy_mobile_app/utils/app_constants/theme_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
      onWillPop: () => Provider.of<CurrentPage>(context, listen: false)
          .checkCurrentPageIndex(context),
      shouldAddCallback: true,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              context.isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarIconBrightness:
              context.isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: context.navBarBg,
        ),
        child: GetBuilder<ProfileController>(
          init: ProfileController(),
          initState: (state) {
            controller.getUserProfileData();
          },
          builder: (_) {
            return Scaffold(
              backgroundColor: context.bgColor,
              bottomNavigationBar: const CustomNavBar(currentPageIndx: 3),
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                centerTitle: true,
                surfaceTintColor: context.cardBg,
                backgroundColor: context.cardBg,
                title: Text(
                  AppStrings.profile,
                  style: AppStyles.keyStringStyle(20, context.textPrimary),
                ),
              ),
              body: Globals.isLoggedIn == true
                  ? _loggedInUserProfileView(context)
                  : guestUserPromptView(context, "profile"),
            );
          },
        ),
      ),
    );
  }

  Widget _loggedInUserProfileView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          verticalSpacer(20),
          _profileDetailsCard(),
          verticalSpacer(20),
          // Account settings group
          _menuGroupWithExtras(
            context: context,
            title: 'Account',
            items: [
              _MenuItem(
                icon: IconsaxPlusLinear.user,
                label: 'Personal Details',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const EditProfileView()),
                ),
              ),
              _MenuItem(
                icon: IconsaxPlusLinear.security_safe,
                label: 'Change Password',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ChangePasswordView()),
                ),
              ),
            ],
            extras: [_darkModeToggle(context)],
          ),
          verticalSpacer(12),
          // Support group
          _menuGroup(
            title: 'Support',
            items: [
              _MenuItem(
                icon: Icons.perm_contact_calendar_outlined,
                label: 'Help Center',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const HelpCenterView()),
                ),
              ),
              _MenuItem(
                icon: CupertinoIcons.question_circle,
                label: 'About',
                onTap: () => goToWebViewPage(context,
                    title: "About us", url: aboutUsUrl),
              ),
            ],
          ),
          verticalSpacer(12),
          // Legal group
          _menuGroup(
            title: 'Legal',
            items: [
              _MenuItem(
                icon: CupertinoIcons.doc_append,
                label: 'Terms of Use',
                onTap: () => goToWebViewPage(context,
                    title: "Terms of Use", url: termsOfUseUrl),
              ),
              _MenuItem(
                icon: CupertinoIcons.info_circle,
                label: 'Disclaimer',
                onTap: () => goToWebViewPage(context,
                    title: "Disclaimer", url: disclaimerUrl),
              ),
              _MenuItem(
                icon: CupertinoIcons.person_2_square_stack,
                label: 'Privacy Policy',
                onTap: () => goToWebViewPage(context,
                    title: "Privacy Policy", url: privacyPolicyUrl),
              ),
            ],
          ),
          verticalSpacer(12),
          // Danger group
          _menuGroup(
            items: [
              _MenuItem(
                icon: IconsaxPlusLinear.logout_1,
                label: 'Logout',
                color: AppColors.primaryThemeColor,
                showArrow: false,
                onTap: () => _showLogoutSheet(context),
              ),
              _MenuItem(
                icon: IconsaxPlusLinear.user_remove,
                label: 'Delete Account',
                color: AppColors.coolRed,
                showArrow: false,
                onTap: () => _showDeleteSheet(context),
              ),
            ],
          ),
          verticalSpacer(32),
        ],
      ),
    );
  }

  // ── Dark mode toggle row ─────────────────────────────────────────────────
  Widget _darkModeToggle(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryThemeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              themeNotifier.isDark
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              color: AppColors.primaryThemeColor,
              size: 18,
            ),
          ),
          horizontalSpacer(12),
          Expanded(
            child: Text(
              'Dark Mode',
              style: AppStyles.normalStringStyle(15, context.textPrimary),
            ),
          ),
          Switch.adaptive(
            value: themeNotifier.isDark,
            activeColor: AppColors.primaryThemeColor,
            onChanged: (_) => themeNotifier.toggle(),
          ),
        ],
      ),
    );
  }

  // ── Menu group with optional extra widgets appended ──────────────────────
  Widget _menuGroupWithExtras({
    required BuildContext context,
    String? title,
    required List<_MenuItem> items,
    List<Widget> extras = const [],
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                title,
                style: AppStyles.subStringStyle(12, context.textSecondary)
                    .copyWith(letterSpacing: 0.5),
              ),
            ),
          ...List.generate(items.length, (i) {
            final item = items[i];
            return Column(
              children: [
                InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.vertical(
                    top: i == 0 ? const Radius.circular(16) : Radius.zero,
                    bottom: Radius.zero,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primaryThemeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(item.icon,
                              color: AppColors.primaryThemeColor, size: 18),
                        ),
                        horizontalSpacer(12),
                        Expanded(
                          child: Text(item.label,
                              style: AppStyles.normalStringStyle(
                                  15, context.textPrimary)),
                        ),
                        if (item.showArrow)
                          Icon(Icons.arrow_forward_ios_rounded,
                              color: context.textSecondary, size: 14),
                      ],
                    ),
                  ),
                ),
                Divider(height: 1, indent: 64, color: context.dividerColor),
              ],
            );
          }),
          // Extra widgets (e.g. dark mode toggle)
          ...extras,
        ],
      ),
    );
  }

  Widget _profileDetailsCard() {
    if (controller.showLoading == true) return loadingWidget();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDark ? 0.3 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              InkWell(
                onTap: () {
                  if (controller.myProfileData != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ImageFullScreen(
                            userData: controller.myProfileData!),
                      ),
                    );
                  }
                },
                child: CircleAvatar(
                  radius: 38,
                  backgroundColor:
                      AppColors.primaryThemeColor.withOpacity(0.2),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundImage: CachedNetworkImageProvider(
                      controller.myProfileData?.photoUrl ?? dummyImageUrl,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => controller.changeProfileImage(),
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: AppColors.primaryThemeColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: context.cardBg, width: 2),
                  ),
                  child: const Icon(
                    IconsaxPlusLinear.gallery_edit,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          horizontalSpacer(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.myProfileData?.name ?? '',
                  style: AppStyles.regularStringStyle(
                      17, context.textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                verticalSpacer(3),
                Text(
                  controller.myProfileData?.email ?? '',
                  style: AppStyles.subStringStyle(
                      13, context.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuGroup({
    String? title,
    required List<_MenuItem> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                title,
                style: AppStyles.subStringStyle(12, context.textSecondary)
                    .copyWith(letterSpacing: 0.5),
              ),
            ),
          ...List.generate(items.length, (i) {
            final item = items[i];
            return Column(
              children: [
                InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.vertical(
                    top: i == 0
                        ? const Radius.circular(16)
                        : Radius.zero,
                    bottom: i == items.length - 1
                        ? const Radius.circular(16)
                        : Radius.zero,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: (item.color ?? AppColors.primaryThemeColor)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item.icon,
                            color: item.color ?? AppColors.primaryThemeColor,
                            size: 18,
                          ),
                        ),
                        horizontalSpacer(12),
                        Expanded(
                          child: Text(
                            item.label,
                            style: AppStyles.normalStringStyle(
                                15, item.color ?? context.textPrimary),
                          ),
                        ),
                        if (item.showArrow)
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: context.textSecondary,
                            size: 14,
                          ),
                      ],
                    ),
                  ),
                ),
                if (i < items.length - 1)
                  Divider(
                    height: 1,
                    indent: 64,
                    color: context.dividerColor,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  void _showLogoutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _confirmSheet(
        context: context,
        title: 'Log out?',
        message: 'Confirm you want to log out from this account',
        titleColor: AppColors.deepBlue,
        confirmLabel: 'Logout',
        confirmColor: AppColors.deepBlue,
        onConfirm: () {
          controller.logout(context);
          context.go('/onboardingScreen');
        },
      ),
    );
  }

  void _showDeleteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _confirmSheet(
        context: context,
        title: 'Delete Account?',
        message: 'Confirm you want to permanently delete this account',
        titleColor: AppColors.coolRed,
        confirmLabel: 'Delete',
        confirmColor: AppColors.coolRed,
        onConfirm: () async {
          await controller.deleteAccount(context);
        },
      ),
    );
  }

  Widget _confirmSheet({
    required BuildContext context,
    required String title,
    required String message,
    required Color titleColor,
    required String confirmLabel,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            verticalSpacer(20),
            Text(title,
                style: AppStyles.keyStringStyle(18, titleColor)),
            verticalSpacer(8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.subStringStyle(14, context.textSecondary),
            ),
            verticalSpacer(24),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonText: 'Cancel',
                    color: const Color(0xFFF0F0F0),
                    textcolor: AppColors.fullBlack,
                    height: 48,
                    onPressed: () => context.pop(),
                  ),
                ),
                horizontalSpacer(12),
                Expanded(
                  child: CustomButton(
                    buttonText: confirmLabel,
                    color: confirmColor,
                    textcolor: AppColors.plainWhite,
                    height: 48,
                    onPressed: onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color? color;
  final bool showArrow;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.color,
    this.showArrow = true,
    required this.onTap,
  });
}
