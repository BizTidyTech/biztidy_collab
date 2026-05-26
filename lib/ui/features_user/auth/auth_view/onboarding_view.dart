import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/globals.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
import 'package:biztidy_mobile_app/utils/extension_and_methods/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardSlide> _slides = const [
    _OnboardSlide(
      image: 'assets/casual-life-cleaning.png',
      title: 'Professional Cleaning\nAt Your Doorstep',
      subtitle: 'We provide professional service at a friendly price',
    ),
    _OnboardSlide(
      image: 'assets/residential.png',
      title: 'Your Satisfaction Is\nOur Top Priority',
      subtitle:
          'The best results and your satisfaction is what drives us every day',
    ),
    _OnboardSlide(
      image: 'assets/specialty.png',
      title: "Let's Make Awesome\nChanges To Your Home",
      subtitle:
          'Book a cleaning service in minutes and enjoy a spotless space',
    ),
  ];

  @override
  void initState() {
    super.initState();
    Globals.isLoggedIn = false;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPage == _slides.length - 1;

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: AppColors.plainWhite,
        body: Column(
          children: [
            // ── Slide area ──
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) =>
                    _SlideWidget(slide: _slides[index]),
              ),
            ),

            // ── Bottom section ──
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
              color: AppColors.plainWhite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? AppColors.primaryThemeColor
                              : AppColors.primaryThemeColor.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  if (!isLastPage) ...[
                    // Next button
                    CustomButton(
                      buttonText: 'Next',
                      onPressed: _nextPage,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context.push('/createAccountView'),
                      child: Text(
                        'Skip',
                        style: AppStyles.normalStringStyle(
                            15, AppColors.darkGray),
                      ),
                    ),
                  ] else ...[
                    // Sign Up
                    CustomButton(
                      buttonText: AppStrings.signUp,
                      onPressed: () => context.push('/createAccountView'),
                    ),
                    const SizedBox(height: 12),
                    // Login outlined
                    CustomButton(
                      buttonText: AppStrings.login,
                      outlined: true,
                      color: AppColors.plainWhite,
                      borderColor: AppColors.deepBlue,
                      textcolor: AppColors.deepBlue,
                      onPressed: () => context.push('/signInUserView'),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => context.go('/homepageView'),
                      child: Text(
                        'Continue as a guest',
                        style: AppStyles.normalStringStyle(
                          15,
                          AppColors.darkGray,
                        ).copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardSlide {
  final String image;
  final String title;
  final String subtitle;
  const _OnboardSlide(
      {required this.image, required this.title, required this.subtitle});
}

class _SlideWidget extends StatelessWidget {
  final _OnboardSlide slide;
  const _SlideWidget({required this.slide});

  @override
  Widget build(BuildContext context) {
    final double circleSize = screenWidth(context) * 0.72;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).viewPadding.top + 40),
          // Image with teal circle background + floating dots
          SizedBox(
            height: screenHeight(context) * 0.40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Floating decoration dots
                Positioned(
                  top: 10,
                  left: 20,
                  child: _Dot(size: 14, opacity: 0.35),
                ),
                Positioned(
                  top: 30,
                  right: 40,
                  child: _Dot(size: 8, opacity: 0.2),
                ),
                Positioned(
                  bottom: 30,
                  left: 10,
                  child: _Dot(size: 10, opacity: 0.25),
                ),
                Positioned(
                  top: 60,
                  right: 15,
                  child: _Dot(size: 28, opacity: 0.45),
                ),
                Positioned(
                  bottom: 50,
                  right: 20,
                  child: _Dot(size: 16, opacity: 0.3),
                ),
                // Teal circle background
                Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryThemeColor.withOpacity(0.9),
                  ),
                ),
                // Hero image
                SizedBox(
                  width: circleSize * 1.05,
                  height: circleSize * 1.05,
                  child: Image.asset(
                    slide.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Title
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: AppStyles.keyStringStyle(26, AppColors.fullBlack),
          ),
          const SizedBox(height: 12),
          // Subtitle
          Text(
            slide.subtitle,
            textAlign: TextAlign.center,
            style: AppStyles.subStringStyle(15, AppColors.darkGray),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final double size;
  final double opacity;
  const _Dot({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryThemeColor.withOpacity(opacity),
      ),
    );
  }
}
