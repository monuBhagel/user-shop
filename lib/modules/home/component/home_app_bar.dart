import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop_o/modules/home/controller/cubit/home_controller_cubit.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_text.dart';
import '../../animated_splash_screen/controller/currency/currency_cubit.dart';
import '../../animated_splash_screen/controller/currency/currency_state_model.dart';
import '../../animated_splash_screen/controller/translate_cubit/translate_cubit.dart';
import '../../authentication/controller/login/login_bloc.dart';
import '../../setting/model/language_model.dart';
import '/modules/animated_splash_screen/controller/app_setting_cubit/app_setting_cubit.dart';
import '/widgets/capitalized_word.dart';
import '../../../core/router_name.dart';
import '../../../dummy_data/all_dummy_data.dart';
import '../../../utils/k_images.dart';
import '../../../utils/language_string.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_image.dart';
import '../../cart/controllers/cart/cart_cubit.dart';
import '../../setting/model/currencies_model.dart';
import 'search_field.dart';

class HomeAppBar extends StatelessWidget {
  final double height;

  const HomeAppBar({super.key, this.height = 100});

  @override
  Widget build(BuildContext context) {
    final logo = context.read<AppSettingCubit>().settingModel!.setting.logo;
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: Utils.vSize(140.0),
          width: double.infinity,
          // margin: Utils.symmetric(),
          color: blackColor,
          child: Padding(
            padding: Utils.symmetric(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                // const LocationSelector(),
                // CustomImage(
                //     path: RemoteUrls.imageUrl(logo),
                //     color: whiteColor,
                //     height: 24),
                // const Spacer(),
                // const SizedBox(width: 20),
                const CurrenciesWidget(),
                // const Spacer(),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.cartScreen);
                  },
                  child: BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      return CartBadge(
                        iconColor: whiteColor,
                        count: context.read<CartCubit>().cartCount.toString(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
        const Positioned(
            bottom: -30.0, left: 0.0, right: 0.0, child: SearchField()),
      ],
    );
  }
}

class CartBadge extends StatelessWidget {
  const CartBadge({super.key, required this.count, required this.iconColor});

  final String? count;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      badgeStyle: badges.BadgeStyle(
        badgeColor: Utils.dynamicPrimaryColor(context),
      ),
      badgeContent: CustomText(
          isTranslate: false,
          text: count?.isNotEmpty ?? false ? count! : '0',
          fontSize: 10,
          color: blackColor),
      child: CustomImage(path: Kimages.shoppingIcon, color: iconColor),
    );
  }
}

class LocationSelector extends StatefulWidget {
  const LocationSelector({super.key});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  String selectCity = Language.location.capitalizeByWord();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomImage(path: Kimages.locationIcon),
        const SizedBox(width: 8),
        DropdownButton<String>(
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: SvgPicture.asset(Kimages.expandIcon, height: 8),
            ),
            underline: const SizedBox(),
            hint: Text(
              selectCity,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            items: dropDownItem
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (v) {
              setState(() {
                selectCity = v!;
              });
            }),
      ],
    );
  }
}

class CurrenciesWidget extends StatefulWidget {
  const CurrenciesWidget({super.key});

  @override
  State<CurrenciesWidget> createState() => _CurrenciesWidgetState();
}

class _CurrenciesWidgetState extends State<CurrenciesWidget> {
  CurrenciesModel? _currencies;
  LanguageModel? _language;
  late CurrencyCubit cCubit;
  late AppSettingCubit appSetting;
  late LoginBloc loginBloc;
  late TranslateCubit tCubit;

  @override
  void initState() {
    _initCurrencies();
    super.initState();
  }

  _initCurrencies() {
    loginBloc = context.read<LoginBloc>();

    appSetting = context.read<AppSettingCubit>();

    cCubit = context.read<CurrencyCubit>();

    tCubit = context.read<TranslateCubit>();

    if (appSetting.settingModel?.currencies?.isNotEmpty ?? false) {
      for (int i = 0; i < appSetting.settingModel!.currencies!.length; i++) {
        final item = appSetting.settingModel!.currencies![i];

        if (item.isDefault.toLowerCase() == 'yes' && item.status == 1) {
          _currencies = item;
          cCubit.addNewCurrency(item);
        }
      }
    }

    if (appSetting.settingModel?.languages?.isNotEmpty ?? false) {
      for (int i = 0; i < appSetting.settingModel!.languages!.length; i++) {
        final item = appSetting.settingModel!.languages![i];

        if (item.isDefault.toLowerCase() == 'yes' && item.status == 1) {
          _language = item;
          cCubit.addNewLanguage(item);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyCubit, CurrencyStateModel>(
      builder: (context, state) {
        if (state.currencies.isNotEmpty) {
          _currencies = state.currencies.first;
        }
        if (state.languages.isNotEmpty) {
          _language = state.languages.first;
        }
        return Expanded(
          child: Row(
            children: [
              if (appSetting.settingModel?.currencies?.isNotEmpty ?? false) ...[
                Expanded(
                  child: Padding(
                    padding: Utils.symmetric(h: 0.0),
                    child: DropdownButtonFormField<CurrenciesModel>(
                      value: _currencies,
                      hint: const CustomText(
                          text: 'Currencies', color: whiteColor),
                      padding: EdgeInsets.zero,
                      focusColor: blackColor,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: whiteColor),
                      decoration: InputDecoration(
                        contentPadding: Utils.symmetric(h: 10.0, v: 10.0),
                        isDense: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: whiteColor),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: whiteColor),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: whiteColor),
                        ),
                        filled: true,
                        fillColor: blackColor,
                      ),
                      dropdownColor: blackColor,
                      onTap: () async {
                        Utils.closeKeyBoard(context);
                      },
                      onChanged: (value) {
                        if (value == null) return;
                        cCubit.state.currencies.clear();
                        cCubit.addNewCurrency(value);
                        // debugPrint('values $value');
                      },
                      isDense: true,
                      isExpanded: true,
                      items: appSetting.settingModel?.currencies?.isNotEmpty ??
                              false
                          ? appSetting.settingModel?.currencies!
                              .map<DropdownMenuItem<CurrenciesModel>>(
                                  (CurrenciesModel value) {
                              return DropdownMenuItem<CurrenciesModel>(
                                value: value,
                                child: Text(
                                  value.currencyName,
                                  style: const TextStyle(color: whiteColor),
                                ),
                              );
                            }).toList()
                          : [],
                    ),
                  ),
                )
              ],
              Utils.horizontalSpace(10.0),
              if (appSetting.settingModel?.languages?.isNotEmpty ?? false) ...[
                Expanded(
                  child: Padding(
                    padding: Utils.symmetric(h: 0.0),
                    child: DropdownButtonFormField<LanguageModel>(
                      value: _language,
                      hint:
                          const CustomText(text: 'Language', color: whiteColor),
                      padding: EdgeInsets.zero,
                      focusColor: blackColor,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: whiteColor),
                      decoration: InputDecoration(
                        contentPadding: Utils.symmetric(h: 10.0, v: 10.0),
                        isDense: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: whiteColor),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: whiteColor),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: whiteColor),
                        ),
                        filled: true,
                        fillColor: blackColor,
                      ),
                      dropdownColor: blackColor,
                      onTap: () async {
                        Utils.closeKeyBoard(context);
                      },
                      onChanged: (value) {
                        if (value == null) return;
                        if (loginBloc.state.langCode != value.langCode) {
                          Utils.clearCachedText();
                          cCubit.resetList(true);
                          cCubit.addNewLanguage(value);
                          final code = cCubit.state.languages.first.langCode;
                          tCubit.translateNavText(code);
                          loginBloc.add(LoginEventLanguageCode(code));
                          // debugPrint('values $value');
                          context.read<HomeControllerCubit>().getHomeData();
                        }
                      },
                      isDense: true,
                      isExpanded: true,
                      items: appSetting.settingModel?.languages?.isNotEmpty ??
                              false
                          ? appSetting.settingModel?.languages!
                              .map<DropdownMenuItem<LanguageModel>>(
                                  (LanguageModel value) {
                              return DropdownMenuItem<LanguageModel>(
                                value: value,
                                child: Text(
                                  value.langName,
                                  style: const TextStyle(color: whiteColor),
                                ),
                              );
                            }).toList()
                          : [],
                    ),
                  ),
                )
              ],
              Utils.horizontalSpace(10.0),
            ],
          ),
        );
      },
    );
  }
}
