import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/custom_text.dart';
import '/utils/language_string.dart';
import '/widgets/capitalized_word.dart';
import '../../core/remote_urls.dart';
import '../../core/router_name.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_image.dart';
import '../animated_splash_screen/controller/app_setting_cubit/app_setting_cubit.dart';
import '../profile/controllers/delete_user/delete_user_cubit.dart';
import 'controller/login/login_bloc.dart';
import 'controller/sign_up/sign_up_bloc.dart';
import 'widgets/sign_in_form.dart';
import 'widgets/sign_up_form.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: _currentPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appSetting = context.read<AppSettingCubit>();
    // final loginBloc = context.read<LoginBloc>();
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginModelState>(
          listenWhen: (previous, current) => previous.state != current.state,
          listener: (context, state) {
            if (state.state is LoginStateError) {
              final status = state.state as LoginStateError;
              Utils.errorSnackBar(context, status.errorMsg);
            } else if (state.state is LoginStateLoaded) {
              Navigator.pushReplacementNamed(context, RouteNames.mainPage);
            } else if (state.state is SendAccountCodeSuccess) {
              final messageState = state.state as SendAccountCodeSuccess;
              Utils.showSnackBar(context, messageState.msg);
            } else if (state.state is AccountActivateSuccess) {
              final messageState = state.state as AccountActivateSuccess;
              Utils.showSnackBar(context, messageState.msg);
              Navigator.pop(context);
            } else if (state.state is LoginStateLogOut) {
              final logout = state.state as LoginStateLogOut;
              Utils.showSnackBar(context, logout.msg);
            }
          },
        ),
        BlocListener<SignUpBloc, SignUpModelState>(
          listenWhen: (previous, current) {
            return previous.state != current.state;
          },
          listener: (context, state) {
            if (state.state is SignUpStateFormValidationError) {
            } else if (state.state is SignUpStateFormError) {
              final status = state.state as SignUpStateFormError;
              Utils.errorSnackBar(context, status.errorMsg);
            } else if (state.state is SignUpStateLoaded) {
              final loadedData = state.state as SignUpStateLoaded;
              Navigator.pushNamed(context, RouteNames.verificationCodeScreen);
              Utils.showSnackBar(context, loadedData.msg);
            }
          },
        ),
        BlocListener<DeleteUserCubit, DeleteUserState>(
            listener: (context, state) {
          if (state is DeleteUserError) {
            Utils.errorSnackBar(context, state.message);
          } else if (state is DeleteUserLoaded) {
            Utils.showSnackBar(context, state.message);
          }
        }),
      ],
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    CustomImage(
                      path: RemoteUrls.imageUrl(
                          appSetting.settingModel!.setting.logo),
                      width: 188,
                      height: 47,
                      // height: 55,
                    ),
                    const SizedBox(height: 30),
                    _buildHeader(),
                    const SizedBox(height: 15),
                    _buildTabText(),
                    SizedBox(
                      height: 650,
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: const [SignInForm(), SignUpForm()],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.topLeft,
      duration: kDuration,
      child: CustomText(
        text: _currentPage == 0
            ? Language.welcomeToProfile.capitalizeByWord()
            : Language.createAccount.capitalizeByWord(),
        fontWeight: FontWeight.bold,
        fontSize: 26.0,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTabText() {
    const tabUnSelectedColor = Color(0xff797979);
    return Container(
      decoration: BoxDecoration(
        color: tabBgColor,
        borderRadius: Utils.borderRadius(),
      ),
      // padding: Utils.symmetric(v: 16.0),
      margin: Utils.symmetric(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              _pageController.animateToPage(0,
                  duration: kDuration, curve: Curves.bounceInOut);
            },
            child: Container(
              width: Utils.mediaQuery(context).width / 2.6,
              decoration: BoxDecoration(
                color: _currentPage == 0 ? whiteColor : transparent,
                borderRadius: Utils.borderRadius(),
              ),
              alignment: Alignment.center,
              padding: Utils.symmetric(v: 12.0, h: 10.0),
              margin: Utils.symmetric(h: 10.0, v: 5.0),
              child: CustomText(
                text: Language.login.capitalizeByWord(),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _currentPage == 0 ? blackColor : tabUnSelectedColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _pageController.animateToPage(1,
                  duration: kDuration, curve: Curves.bounceInOut);
            },
            child: Container(
              width: Utils.mediaQuery(context).width / 2.6,
              decoration: BoxDecoration(
                color: _currentPage == 1 ? whiteColor : transparent,
                borderRadius: Utils.borderRadius(),
              ),
              alignment: Alignment.center,
              padding: Utils.symmetric(v: 12.0, h: 10.0),
              margin: Utils.symmetric(h: 10.0, v: 5.0),
              child: CustomText(
                text: Language.singUp.capitalizeByWord(),
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: _currentPage == 0 ? blackColor : tabUnSelectedColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
