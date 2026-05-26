// ignore_for_file: depend_on_referenced_packages

import 'package:biztidy_mobile_app/tidytech_app.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/data/page_index_class.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:provider/provider.dart';

class CustomNavBar extends StatefulWidget {
  final int currentPageIndx;
  const CustomNavBar({super.key, required this.currentPageIndx});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  void goPopUntil(BuildContext context, String routeName) {
    final router = GoRouter.of(context);
    while (router
            .routerDelegate.currentConfiguration.matches.last.matchedLocation !=
        "/$routeName") {
      if (!context.canPop()) {
        return;
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: context.navBarBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          /// Home
          GestureDetector(
            onTap: () {
              logger.i('Home selected');
              Provider.of<CurrentPage>(context, listen: false)
                  .setCurrentPageIndex(0);
              context.canPop()
                  ? goPopUntil(context, "homepageView")
                  : context.go("/homepageView");
            },
            child: _buildNavItem(
              barIndex: 0,
              label: AppStrings.home,
              activeIcon: Iconsax.home_25,
              inactiveIcon: Iconsax.home_24,
            ),
          ),

          /// Bookings
          GestureDetector(
            onTap: () {
              logger.i('Bookings selected');
              final bool fromHome =
                  Provider.of<CurrentPage>(context, listen: false)
                          .currentPageIndex ==
                      0;
              Provider.of<CurrentPage>(context, listen: false)
                  .setCurrentPageIndex(1);
              fromHome
                  ? context.push('/bookingsPage')
                  : context.replace('/bookingsPage');
            },
            child: _buildNavItem(
              barIndex: 1,
              label: AppStrings.bookings,
              activeIcon: Iconsax.calendar5,
              inactiveIcon: Iconsax.calendar_1,
            ),
          ),

          /// Appointments
          GestureDetector(
            onTap: () {
              logger.i('Appointments selected');
              final bool fromHome =
                  Provider.of<CurrentPage>(context, listen: false)
                          .currentPageIndex ==
                      0;
              Provider.of<CurrentPage>(context, listen: false)
                  .setCurrentPageIndex(2);
              fromHome
                  ? context.push('/bookingsListScreen')
                  : context.replace('/bookingsListScreen');
            },
            child: _buildNavItem(
              barIndex: 2,
              label: AppStrings.appointments,
              activeIcon: IconsaxPlusBold.archive_book,
              inactiveIcon: IconsaxPlusLinear.archive_book,
            ),
          ),

          /// Profile
          GestureDetector(
            onTap: () {
              logger.i('Profile selected');
              final bool fromHome =
                  Provider.of<CurrentPage>(context, listen: false)
                          .currentPageIndex ==
                      0;
              Provider.of<CurrentPage>(context, listen: false)
                  .setCurrentPageIndex(3);
              fromHome
                  ? context.push('/profileView')
                  : context.replace('/profileView');
            },
            child: _buildNavItem(
              barIndex: 3,
              label: AppStrings.profile,
              activeIcon: IconsaxPlusBold.profile,
              inactiveIcon: IconsaxPlusLinear.profile,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int barIndex,
    required String label,
    required IconData activeIcon,
    required IconData inactiveIcon,
  }) {
    final bool isActive = widget.currentPageIndx == barIndex;
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Active dot indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: isActive ? 4 : 0,
            height: isActive ? 4 : 0,
            margin: EdgeInsets.only(bottom: isActive ? 4 : 0),
            decoration: BoxDecoration(
              color: AppColors.primaryThemeColor,
              shape: BoxShape.circle,
            ),
          ),
          Icon(
            isActive ? activeIcon : inactiveIcon,
            color: isActive
                ? AppColors.primaryThemeColor
                : AppColors.darkGray,
            size: 24,
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: AppStyles.subStringStyle(
                10,
                isActive ? AppColors.primaryThemeColor : AppColors.darkGray,
              ).copyWith(
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
