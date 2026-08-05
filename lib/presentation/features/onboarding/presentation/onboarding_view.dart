import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmcsms/core/extensions/build_context_extension.dart';
import 'package:pmcsms/core/extensions/text_theme_extension.dart';
import 'package:pmcsms/core/theme/app_colors.dart';
import 'package:pmcsms/presentation/features/login/presentation/view/login_view.dart';
import 'package:pmcsms/presentation/features/onboarding/model/onboarding_model.dart';
import 'package:pmcsms/presentation/features/sign_up/presentation/view/sign_up_view.dart';
import 'package:pmcsms/presentation/general_widgets/app_send_button.dart';
import 'package:pmcsms/presentation/general_widgets/spacing.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});
  static const routeName = '/onboarding_view';

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const VerticalSpacing(31),
                Center(
                  child: SizedBox(
                      height: 21.h,
                      width: 99.w,
                      child: Image.asset('assets/logo/pmcsms_logo.png')),
                ),
                const VerticalSpacing(62),
                SizedBox(
                  height: height * 0.5,
                  child: PageView(
                    controller: _pageController,
                    children: List.generate(
                      onboardingData.length,
                      (index) {
                        final data = onboardingData[index];
                        return Column(
                          children: [
                            SizedBox(
                              height: 240.h,
                              child: Image.asset(data.image),
                            ),
                            const VerticalSpacing(40),
                            Text(
                              data.title,
                              style: context.textTheme.s20w600.copyWith(
                                color: AppColors.primary141414,
                              ),
                            ),
                            const VerticalSpacing(12),
                            Text(
                              data.description,
                              style: context.textTheme.s12w400.copyWith(
                                color: AppColors.primary676767,
                              ),
                            ),
                            const VerticalSpacing(24),
                            SmoothPageIndicator(
                              controller: _pageController,
                              count: onboardingData.length,
                              effect: const ExpandingDotsEffect(
                                  dotHeight: 10,
                                  dotWidth: 10,
                                  radius: 5,
                                  activeDotColor: AppColors.primary1C1C1C,
                                  dotColor: AppColors.primaryD9D9D9),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const VerticalSpacing(30),
                AppSendButton(
                    onTap: () =>
                        context.pushReplacementNamed(SignUpView.routeName),
                    title: 'Sign up'),
                const VerticalSpacing(10),
                AppSendButton(
                  backgroundColor: AppColors.white,
                  onTap: () {
                    context.pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const LoginView()),
                    );
                  },
                  title: 'Log in',
                  textColor: AppColors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
