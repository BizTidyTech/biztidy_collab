import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterView extends StatelessWidget {
  const HelpCenterView({super.key});

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'tidy1tech@gmail.com',
      query: 'subject=Help Needed&body=Describe your issue here',
    );
    try {
      await launchUrl(emailUri);
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not launch email");
    }
  }

  void _launchWhatsApp() async {
    const String whatsappNumber = companyPhoneNumber;
    const String message = "Hello, I need help with . . .";
    final Uri whatsappUri =
        Uri.parse("https://wa.me/$whatsappNumber?text=$message");
    try {
      await launchUrl(whatsappUri);
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not launch WhatsApp");
    }
  }

  void _launchPhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: companyPhoneNumber);
    try {
      await launchUrl(phoneUri);
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not launch phone call");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF6F7F9);
    final textPrimary = isDark ? Colors.white : AppColors.deepBlue;
    final textSecondary = isDark ? Colors.white60 : const Color(0xFF6B7280);
    final divider = isDark ? Colors.white12 : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surface,
        surfaceTintColor: surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: textPrimary),
        ),
        title: Text(
          'Help Center',
          style: AppStyles.keyStringStyle(17, textPrimary),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: divider),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Hero icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryThemeColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.support_agent_rounded,
                size: 36,
                color: AppColors.primaryThemeColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'How can we help you?',
              style: AppStyles.keyStringStyle(22, textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Our support team is available to assist you.\nChoose a channel below to get in touch.',
              style: AppStyles.normalStringStyle(14, textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Contact cards
            _ContactCard(
              iconWidget: const Icon(Icons.mail_outline_rounded,
                  color: Color(0xFF3B82F6), size: 22),
              iconBg: const Color(0xFFEFF6FF),
              title: 'Email Support',
              subtitle: 'tidy1tech@gmail.com',
              onTap: _launchEmail,
              surface: surface,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              divider: divider,
            ),
            const SizedBox(height: 12),
            _ContactCard(
              iconWidget: const FaIcon(FontAwesomeIcons.whatsapp,
                  color: Color(0xFF25D366), size: 20),
              iconBg: const Color(0xFFECFDF5),
              title: 'WhatsApp',
              subtitle: 'Chat with us instantly',
              badge: 'Recommended',
              onTap: _launchWhatsApp,
              surface: surface,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              divider: divider,
            ),
            const SizedBox(height: 12),
            _ContactCard(
              iconWidget: Icon(Icons.phone_outlined,
                  color: AppColors.primaryThemeColor, size: 22),
              iconBg: AppColors.primaryThemeColor.withOpacity(0.1),
              title: 'Call Us',
              subtitle: companyPhoneNumber,
              onTap: _launchPhoneCall,
              surface: surface,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              divider: divider,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time_rounded, size: 14, color: textSecondary),
                const SizedBox(width: 6),
                Text(
                  'Available Mon – Fri, 9 AM – 6 PM',
                  style: AppStyles.normalStringStyle(12, textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final Widget iconWidget;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String? badge;
  final VoidCallback onTap;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;

  const _ContactCard({
    required this.iconWidget,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.onTap,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: iconWidget),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(title,
                            style: AppStyles.regularStringStyle(15, textPrimary)),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryThemeColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              badge!,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryThemeColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: AppStyles.normalStringStyle(12, textSecondary)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: textSecondary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}