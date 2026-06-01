import 'package:biztidy_mobile_app/ui/shared/custom_button.dart';
import 'package:biztidy_mobile_app/ui/shared/globals.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_colors.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_styles.dart';
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
      image: 'assets/clean-1.png',
      title: 'Professional Cleaning\nAt Your Doorstep',
      subtitle: 'We provide professional service at a friendly price',
    ),
    _OnboardSlide(
      image: 'assets/clean-2.png',
      title: 'Your Satisfaction Is\nOur Top Priority',
      subtitle:
          'The best results and your satisfaction is what drives us every day',
    ),
    _OnboardSlide(
      image: 'assets/clean-3.png',
      title: "Let's Make Awesome\nChanges To Your Home",
      subtitle:
          'Book a cleaning service in minutes and enjoy a spotless space',
    ),
    _OnboardSlide(
      image: 'assets/clean-4.png',
      title: 'Trusted Cleaners,\nSpotless Results',
      subtitle:
          'Our vetted professionals deliver quality you can rely on every time',
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
                      onPressed: () => context.push('/signInUserView'),
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
    return Column(
      children: [
        // Full-bleed image
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  slide.image,
                  fit: BoxFit.cover,
                ),
                // Subtle gradient at bottom for readability
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Text(
                slide.title,
                textAlign: TextAlign.center,
                style: AppStyles.keyStringStyle(26, AppColors.fullBlack),
              ),
              const SizedBox(height: 12),
              Text(
                slide.subtitle,
                textAlign: TextAlign.center,
                style: AppStyles.subStringStyle(15, AppColors.darkGray),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
