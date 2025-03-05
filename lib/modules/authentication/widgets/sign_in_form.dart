import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_o/utils/k_images.dart';
import 'package:shop_o/widgets/custom_image.dart';
import 'package:shop_o/widgets/custom_text.dart';
import 'package:shop_o/widgets/loading_widget.dart';

import '../../../widgets/translate_form_text.dart';
import '/modules/authentication/widgets/sign_up_form.dart';
import '/widgets/capitalized_word.dart';
import '../../../core/router_name.dart';
import '../../../utils/constants.dart';
import '../../../utils/language_string.dart';
import '../../../utils/utils.dart';
import '../../../widgets/primary_button.dart';
import '../controller/login/login_bloc.dart';
import 'guest_button.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: loginBloc.formKey,
        child: Column(
          children: [
            const SizedBox(height: 12),
            BlocBuilder<LoginBloc, LoginModelState>(
              builder: (context, state) {
                final login = state.state;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TranslateWidget(
                      future: Utils.hintText(context, Language.email),
                      hintText: Language.email,
                      builder: (context, snap) {
                        return TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          initialValue: state.text,
                          onChanged: (value) =>
                              loginBloc.add(LoginEvenEmailOrPhone(value)),
                          decoration: InputDecoration(
                            hintText: snap,
                          ),
                        );
                      },
                    ),
                    if (login is LoginStateFormInvalid) ...[
                      if (login.error.email.isNotEmpty)
                        ErrorText(text: login.error.email.first)
                    ]
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<LoginBloc, LoginModelState>(
              builder: (context, state) {
                final login = state.state;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    TranslateWidget(
                      future: Utils.hintText(context, Language.password),
                      hintText: Language.password,
                      builder: (context, snap) {
                        return TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          initialValue: state.password,
                          onChanged: (value) =>
                              loginBloc.add(LoginEventPassword(value)),
                          obscureText: state.showPassword,
                          decoration: InputDecoration(
                            hintText: snap,
                            suffixIcon: IconButton(
                              icon: Icon(
                                state.showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: grayColor,
                              ),
                              onPressed: () => loginBloc
                                  .add(ShowPasswordEvent(state.showPassword)),
                            ),
                          ),
                        );
                      },
                    ),


                    if (state.text != '')
                      if (login is LoginStateFormInvalid) ...[
                        if (login.error.password.isNotEmpty)
                          ErrorText(text: login.error.password.first)
                      ]
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            _buildRememberMe(),
            const SizedBox(height: 25),
            BlocBuilder<LoginBloc, LoginModelState>(
              buildWhen: (previous, current) => previous.state != current.state,
              builder: (context, state) {
                if (state.state is LoginStateLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return PrimaryButton(
                  text: Language.login.capitalizeByWord(),
                  onPressed: () {
                    Utils.closeKeyBoard(context);
                    loginBloc.add(const LoginEventSubmit());
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    color: borderColor,
                    width: double.infinity,
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                const CustomText(text:
                  "OR",
                    color: textGreyColor,
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w500
                ),
                Expanded(
                  child: Container(
                    color: borderColor,
                    width: double.infinity,
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            BlocBuilder<LoginBloc, LoginModelState>(
              buildWhen: (previous, current) => previous.state != current.state,
              builder: (context, state) {
                if (state.state is GoogleStateLoading) {
                  return const LoadingWidget();
                }
                return GestureDetector(
                  onTap: () {
                    Utils.closeKeyBoard(context);
                    loginBloc.add(const GoogleSignInEvent());
                  },
                  child: Container(
                    padding: Utils.symmetric(v: 14.0),
                    decoration: BoxDecoration(
                      borderRadius: Utils.borderRadius(r: 10.0),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 25.0,
                            width: 25.0,
                            margin: Utils.only(right: 14.0),
                            child: const CustomImage(path: Kimages.google)),
                        const CustomText(
                            text: 'Continue with Google',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                            color: blackColor)
                      ],
                    ),
                  ),
                );
                // return SocialLoginButton(
                //   borderRadius: 10.0,
                //     fontSize:  14.0,
                //     buttonType: SocialLoginButtonType.google,
                //     onPressed: () {
                //       Utils.closeKeyBoard(context);
                //       loginBloc.add(const GoogleSignInEvent());
                //     });
                // return SocialButton(
                //   text: "Continue with Google",
                //   bgColor: Colors.white,
                //   textColor: Colors.black,
                //   icon: Kimages.google,
                //   onPressed: () {
                //     Utils.closeKeyBoard(context);
                //     loginBloc.add(const GoogleSignInEvent());
                //   },
                // );
              },
            ),
            const SizedBox(height: 25),
            // BlocBuilder<LoginBloc, LoginModelState>(
            //   buildWhen: (previous, current) => previous.state != current.state,
            //   builder: (context, state) {
            //     if (state.state is FacebookStateLoading) {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //     return SocialLoginButton(
            //         buttonType: SocialLoginButtonType.facebook,
            //         onPressed: () {
            //           Utils.closeKeyBoard(context);
            //           loginBloc.add(const FacebookSignInEvent());
            //         });
            //     // return SocialButton(
            //     //   text: "Continue with Facebook",
            //     //   bgColor: Colors.blueAccent,
            //     //   textColor: Colors.white,
            //     //   icon: Kimages.facebook,
            //     //   onPressed: () {
            //     //     // Utils.closeKeyBoard(context);
            //     //     // loginBloc.add(const FacebookSignInEvent());
            //     //     Utils.showSnackBar(
            //     //         context, "Facebook login need further configuration");
            //     //   },
            //     // );
            //   },
            // ),
            //const SizedBox(height: 28),
            const GuestButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRememberMe() {
    final loginBloc = context.read<LoginBloc>();
    return BlocBuilder<LoginBloc, LoginModelState>(
      builder: (context, state) {
        return Padding(
          padding: Utils.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: Utils.vSize(24.0),
                    width: Utils.vSize(24.0),
                    margin: Utils.only(right: 10.0),
                    child: Checkbox(
                      value: state.rememberMe,
                      checkColor: whiteColor,
                      activeColor: blackColor,
                      // activeColor: Utils.dynamicPrimaryColor(context),
                      onChanged: (val) {
                        loginBloc.add(RememberMeEvent(state.rememberMe));
                      },
                    ),
                  ),
                  CustomText(text:
                    Language.rememberMe.capitalizeByWord(),
                     color:  blackColor.withOpacity(.5), fontSize: 15.0
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.forgotScreen);
                },
                child: CustomText(text:
                  '${Language.forgotPassword.capitalizeByWord()}?',
                    color: redColor, fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
