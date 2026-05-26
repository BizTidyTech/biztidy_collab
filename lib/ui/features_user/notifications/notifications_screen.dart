import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            context.isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: context.navBarBg,
      ),
      child: Scaffold(
        backgroundColor: context.bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: context.cardBg,
          surfaceTintColor: context.cardBg,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.surfaceBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: context.textPrimary,
                size: 18,
              ),
            ),
          ),
          title: Text(
            'Notifications',
            style: AppStyles.keyStringStyle(18, context.textPrimary),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryThemeColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 40,
                  color: AppColors.primaryThemeColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No notifications yet',
                style: AppStyles.keyStringStyle(16, context.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                "You'll see updates about your bookings\nand services here.",
                textAlign: TextAlign.center,
                style: AppStyles.subStringStyle(13, context.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
