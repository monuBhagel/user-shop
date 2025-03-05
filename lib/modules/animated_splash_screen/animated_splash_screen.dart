import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/router_name.dart';
import '../../utils/my_theme.dart';
import '../../utils/utils.dart';
import '../authentication/controller/login/login_bloc.dart';
import 'controller/app_setting_cubit/app_setting_cubit.dart';
import 'controller/currency/currency_cubit.dart';
import 'controller/internet_status/internet_status_bloc.dart';
import 'controller/translate_cubit/translate_cubit.dart';
import 'widgets/animation_splash_widget.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  late LoginBloc loginBloc;
  late AppSettingCubit sCubit;
  late CurrencyCubit cCubit;
  late TranslateCubit tCubit;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loginBloc = context.read<LoginBloc>();
    sCubit = context.read<AppSettingCubit>();
    cCubit = context.read<CurrencyCubit>();
    tCubit = context.read<TranslateCubit>();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() {
      if (mounted) setState(() {});
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<InternetStatusBloc, InternetStatusState>(
            listener: (context, state) {
              if (state is InternetStatusBackState) {
                // Utils.showSnackBar(context, state.message);
                sCubit.loadWebSetting();
              } else if (state is InternetStatusLostState) {
                debugPrint('no internet');
                Utils.showSnackBar(context, state.message);
              }
            },
          ),
          BlocListener<AppSettingCubit, AppSettingState>(
            listener: (context, state) {
              // log("listener $state", name: _className);
              if (state is AppSettingStateLoaded) {
                MyTheme.dynamicColor = Utils.dynamicPrimaryColor(context);

                cCubit.resetList(false);

                ///add default currency into the state
                if (sCubit.settingModel?.currencies?.isNotEmpty ?? false) {
                  final currency = sCubit.settingModel?.currencies;
                  for (int i = 0; i < currency!.length; i++) {
                    if (currency[i].isDefault.toLowerCase() == 'yes' && currency[i].status == 1) {
                      cCubit.addNewCurrency(currency[i]);
                    }
                  }
                }

                ///add default language into the state
                if (sCubit.settingModel?.languages?.isNotEmpty ?? false) {
                  final language = sCubit.settingModel?.languages;
                  for (int i = 0; i < language!.length; i++) {
                    if (language[i].isDefault.toLowerCase() == 'yes' && language[i].status == 1) {
                      loginBloc.add(LoginEventLanguageCode(language[i].langCode));
                      cCubit.addNewLanguage(language[i]);
                      tCubit.translateNavText(language[i].langCode);
                    }
                  }
                }
                if (state.settingModel.maintainTextModel!.status == 0) {
                  // debugPrint('loaded-1');
                  if (loginBloc.isLogedIn) {
                    // debugPrint('loaded-2');
                    Navigator.pushReplacementNamed(context, RouteNames.mainPage);
                  } else if (sCubit.isOnBoardingShown) {
                    // debugPrint('loaded-3');
                    Navigator.pushReplacementNamed(context, RouteNames.authenticationScreen);
                  } else {
                    // debugPrint('loaded-4');
                    Navigator.pushReplacementNamed(context, RouteNames.onBoardingScreen);
                  }
                } else {
                  // debugPrint('loaded-5');
                  Navigator.pushReplacementNamed(context, RouteNames.maintainScreen);
                }
              }
            },
          ),
        ],
        child: AnimationSplashWidget(animation: animation),
      ),
    );
  }
}

// class SplashWidget extends StatelessWidget {
//   const SplashWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);
//     const image = 'assets/celove_splash.png';
//     return SizedBox(
//       height: size.height,
//       width: size.width,
//       child: const CustomImage(path: image),
//     );
//   }
// }
