import 'package:biztidy_mobile_app/ui/features_user/booking/booking_controller/booking_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/home/data/services_data.dart';
import 'package:biztidy_mobile_app/ui/features_user/home/home_controller/home_controller.dart';
import 'package:biztidy_mobile_app/ui/features_user/home/home_model/services_model.dart';
import 'package:biztidy_mobile_app/ui/features_user/home/home_view/categories_services_view.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/data/page_index_class.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/views/custom_navbar.dart';
import 'package:biztidy_mobile_app/ui/shared/spacer.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/string_cap_extensions.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
  final controller = Get.put(HomeController());

  void _optInNotification() async {
    await OneSignal.User.pushSubscription.optIn();
  }

  @override
  void initState() {
    super.initState();
    controller.getUserData();
    _optInNotification();
  }

  // ── Category meta ─────────────────────────────────────────────────────────
  static const _categories = [
    _CategoryMeta(
      category: CleaningCategory.commercial,
      label: 'Commercial',
      icon: Icons.business_rounded,
      gradient: [Color(0xFF00BCD4), Color(0xFF0097A7)],
      image: 'assets/commercial.png',
    ),
    _CategoryMeta(
      category: CleaningCategory.residential,
      label: 'Residential',
      icon: Icons.home_rounded,
      gradient: [Color(0xFF4CAF50), Color(0xFF388E3C)],
      image: 'assets/residential.png',
    ),
    _CategoryMeta(
      category: CleaningCategory.industrial,
      label: 'Industrial',
      icon: Icons.factory_rounded,
      gradient: [Color(0xFFFF9800), Color(0xFFF57C00)],
      image: 'assets/industrial.png',
    ),
    _CategoryMeta(
      category: CleaningCategory.specialty,
      label: 'Specialty',
      icon: Icons.auto_fix_high_rounded,
      gradient: [Color(0xFFE91E63), Color(0xFFC2185B)],
      image: 'assets/specialty.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool dark = context.isDark;

    return ConditionalWillPopScope(
      onWillPop: () => Provider.of<CurrentPage>(context, listen: false)
          .checkCurrentPageIndex(context),
      shouldAddCallback: true,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              dark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: context.navBarBg,
        ),
        child: Scaffold(
          backgroundColor: context.bgColor,
          bottomNavigationBar: const CustomNavBar(currentPageIndx: 0),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildSearchBar()),
                SliverToBoxAdapter(child: _buildHeroBanner()),
                SliverToBoxAdapter(child: _buildCategorySection()),
                SliverToBoxAdapter(child: _buildPopularSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (_) {
        final name = controller.userData?.name;
        final first = name != null
            ? name.split(' ')[0].toSentenceCase
            : null;

        return Container(
          color: context.cardBg,
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryThemeColor.withOpacity(0.15),
                ),
                clipBehavior: Clip.hardEdge,
                child: controller.userData?.photoUrl != null
                    ? Image.network(
                        controller.userData!.photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                            Icons.person_rounded,
                            color: AppColors.primaryThemeColor,
                            size: 26),
                      )
                    : Icon(Icons.person_rounded,
                        color: AppColors.primaryThemeColor, size: 26),
              ),
              horizontalSpacer(12),
              // Greeting
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      first != null ? 'Good day, $first 👋' : 'Welcome 👋',
                      style: AppStyles.regularStringStyle(15, context.textPrimary),
                    ),
                    Text(
                      'What needs cleaning today?',
                      style: AppStyles.subStringStyle(13, context.textSecondary),
                    ),
                  ],
                ),
              ),
              // Notification icon
              _iconBtn(Iconsax.notification,
                  onTap: () => context.push('/notificationsScreen')),
            ],
          ),
        );
      },
    );
  }

  Widget _iconBtn(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: context.surfaceBg,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: context.textPrimary),
      ),
    );
  }

  // ── Search bar ────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      color: context.cardBg,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: context.surfaceBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(Icons.search_rounded, color: context.textSecondary, size: 22),
            const SizedBox(width: 8),
            Text(
              'Search services...',
              style: AppStyles.subStringStyle(14, context.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  // ── Hero Banner ───────────────────────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFF00B4B4), Color(0xFF007A7A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryThemeColor.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -25,
              left: -20,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: 60,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            // Text side
            Positioned(
              left: 22,
              top: 0,
              bottom: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'BizTidy',
                      style: AppStyles.subStringStyle(
                          11, Colors.white.withOpacity(0.9)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A Tidy Space\nStarts With\nSmart Choices',
                    style: AppStyles.keyStringStyle(18, Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Book a cleaner today →',
                      style: AppStyles.subStringStyle(
                          11, Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            // Cleaning character image
            Positioned(
              right: -10,
              bottom: 0,
              child: SizedBox(
                height: 170,
                width: 150,
                child: Image.asset(
                  'assets/casual-life-cleaning.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Category Cards (horizontal scroll) ───────────────────────────────────
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpacer(24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Services',
                style: AppStyles.keyStringStyle(17, context.textPrimary),
              ),
              Text(
                'See All',
                style: AppStyles.regularStringStyle(
                    13, AppColors.primaryThemeColor),
              ),
            ],
          ),
        ),
        verticalSpacer(14),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, i) {
              final meta = _categories[i];
              final services = _servicesFor(meta.category);
              return _categoryCard(meta, services);
            },
          ),
        ),
      ],
    );
  }

  List<ServiceModel> _servicesFor(CleaningCategory cat) {
    switch (cat) {
      case CleaningCategory.commercial:
        return commercialServices;
      case CleaningCategory.residential:
        return residentialServices;
      case CleaningCategory.industrial:
        return industrialServices;
      case CleaningCategory.specialty:
        return specialtyServices;
      default:
        return [];
    }
  }

  Widget _categoryCard(
      _CategoryMeta meta, List<ServiceModel> services) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryServicesView(
            cleaningCategory: meta.category,
            servicesList: services,
          ),
        ),
      ),
      child: Container(
        width: 110,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: meta.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: meta.gradient.first.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              // Faint circle decoration
              Positioned(
                top: -15,
                right: -15,
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(meta.icon,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      meta.label,
                      style: AppStyles.regularStringStyle(
                          12, Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${services.length} service${services.length == 1 ? '' : 's'}',
                      style: AppStyles.subStringStyle(
                          10, Colors.white.withOpacity(0.75)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Most Popular Services ─────────────────────────────────────────────────
  Widget _buildPopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpacer(24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.mostPopularService,
                style: AppStyles.keyStringStyle(17, context.textPrimary),
              ),
            ],
          ),
        ),
        verticalSpacer(14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: popularServices.length,
            itemBuilder: (context, index) =>
                _popularCard(popularServices[index]),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              mainAxisExtent: 185,
            ),
          ),
        ),
      ],
    );
  }

  Widget _popularCard(ServiceModel service) {
    return GestureDetector(
      onTap: () {
        Get.put(BookingsController()).changeSelectedService(service);
        Provider.of<CurrentPage>(context, listen: false)
            .setCurrentPageIndex(1);
        context.push('/bookingsPage');
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(context.isDark ? 0.3 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: SizedBox(
                height: 130,
                width: double.infinity,
                child: Image.asset(
                  service.imageUrl ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name ?? '',
                    style: AppStyles.normalStringStyle(
                        12, context.textPrimary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Category metadata ─────────────────────────────────────────────────────
class _CategoryMeta {
  final CleaningCategory category;
  final String label;
  final IconData icon;
  final List<Color> gradient;
  final String image;
  const _CategoryMeta({
    required this.category,
    required this.label,
    required this.icon,
    required this.gradient,
    required this.image,
  });
}

// ── getCategoriesMenuItems (unchanged — used by search/filter) ─────────────
List<QudsPopupMenuBase> getCategoriesMenuItems(HomeController controller) {
  return [
    QudsPopupMenuItem(
      title: Text(CleaningCategory.all.name.toSentenceCase,
          style: AppStyles.normalStringStyle(14, AppColors.fullBlack)),
      trailing:
          CleaningCategory.all == controller.selectedCleaningCategory
              ? const Icon(Icons.check_rounded)
              : null,
      onPressed: () =>
          controller.changeSearchFilterCategory(CleaningCategory.all),
    ),
    QudsPopupMenuDivider(height: 0.5, color: AppColors.lightGray),
    QudsPopupMenuItem(
      title: Text(CleaningCategory.commercial.name.toSentenceCase,
          style: AppStyles.normalStringStyle(14, AppColors.fullBlack)),
      trailing: CleaningCategory.commercial ==
              controller.selectedCleaningCategory
          ? const Icon(Icons.check_rounded)
          : null,
      onPressed: () =>
          controller.changeSearchFilterCategory(CleaningCategory.commercial),
    ),
    QudsPopupMenuDivider(height: 0.5, color: AppColors.lightGray),
    QudsPopupMenuItem(
      title: Text(CleaningCategory.residential.name.toSentenceCase,
          style: AppStyles.normalStringStyle(14, AppColors.fullBlack)),
      trailing: CleaningCategory.residential ==
              controller.selectedCleaningCategory
          ? const Icon(Icons.check_rounded)
          : null,
      onPressed: () =>
          controller.changeSearchFilterCategory(CleaningCategory.residential),
    ),
    QudsPopupMenuDivider(height: 0.5, color: AppColors.lightGray),
    QudsPopupMenuItem(
      title: Text(CleaningCategory.industrial.name.toSentenceCase,
          style: AppStyles.normalStringStyle(14, AppColors.fullBlack)),
      trailing: CleaningCategory.industrial ==
              controller.selectedCleaningCategory
          ? const Icon(Icons.check_rounded)
          : null,
      onPressed: () =>
          controller.changeSearchFilterCategory(CleaningCategory.industrial),
    ),
    QudsPopupMenuDivider(height: 0.5, color: AppColors.lightGray),
    QudsPopupMenuItem(
      title: Text(CleaningCategory.specialty.name.toSentenceCase,
          style: AppStyles.normalStringStyle(14, AppColors.fullBlack)),
      trailing: CleaningCategory.specialty ==
              controller.selectedCleaningCategory
          ? const Icon(Icons.check_rounded)
          : null,
      onPressed: () =>
          controller.changeSearchFilterCategory(CleaningCategory.specialty),
    ),
  ];
}
