import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/utils.dart';
import '/utils/language_string.dart';
import '/widgets/capitalized_word.dart';
import '../../core/router_name.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/primary_button.dart';
import '../animated_splash_screen/controller/app_setting_cubit/app_setting_cubit.dart';
import 'model/onbording_data.dart';
import 'widgets/dot_indicator_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  late int _numPages;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _numPages = onBoardingList.length;
    _pageController = PageController(initialPage: _currentPage);
  }

  Widget getContent() {
    final item = onBoardingList[_currentPage];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      key: ValueKey('$_currentPage'),
      children: [
        CustomText(
            text: item.title, fontSize: 26.0, fontWeight: FontWeight.w700),
        const SizedBox(height: 10.0),
        CustomText(
          text: item.paragraph,
          fontSize: 16.0,
          color: blackColor.withOpacity(0.5),
        ),
      ],
    );
  }

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    // Utils.dynamicPrimaryColor(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildImagesSlider(),
              _buildBottomContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: kDuration,
            transitionBuilder: (Widget child, Animation<double> anim) {
              return FadeTransition(opacity: anim, child: child);
            },
            child: getContent(),
          ),
          const SizedBox(height: 10.0),
          if (_currentPage == _numPages - 1) ...[
            const SizedBox(height: 26.0),
            PrimaryButton(
              text: Language.enabledLocation.capitalizeByWord(),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteNames.authenticationScreen, (route) => false);
              },
            ),
            TextButton(
              onPressed: () {
                context.read<AppSettingCubit>().cachOnBoarding();
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteNames.authenticationScreen, (route) => false);
              },
              child: CustomText(text:
                Language.notNow.capitalizeByWord(),
                color: const Color(0xff797979),
                fontWeight: FontWeight.w700,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 30),
          ] else ...[
            _buildBottomButtonIndicator(),
          ]
        ],
      ),
    );
  }

  Widget _buildBottomButtonIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: Utils.symmetric(h: 0.0),
          child: DotIndicatorWidget(
            currentIndex: _currentPage,
            dotNumber: _numPages,
          ),
        ),
        PrimaryButton(
            text: Language.next.capitalizeByWord(),
            onPressed: () {
              if (_currentPage == _numPages - 1) {
                context.read<AppSettingCubit>().cachOnBoarding();
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteNames.authenticationScreen, (route) => false);
                return;
              }
              _pageController.nextPage(
                  duration: kDuration, curve: Curves.easeInOut);
            }),
      ],
    );
  }

  Widget _buildImagesSlider() {
    return SizedBox(
      height: size.height / 3,
      child: PageView(
        physics: const ClampingScrollPhysics(),
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children:
            onBoardingList.map((e) => CustomImage(path: e.image)).toList(),
      ),
    );
  }
}
