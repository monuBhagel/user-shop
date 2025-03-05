
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_o/widgets/custom_text.dart';
import 'package:shop_o/widgets/fetch_error_text.dart';
import 'package:shop_o/widgets/loading_widget.dart';

import '/modules/animated_splash_screen/controller/currency/currency_cubit.dart';
import '/modules/cart/controllers/delivery_charges/delivery_charges_cubit.dart';
import '/modules/profile/controllers/address/address_cubit.dart';
import '/widgets/capitalized_word.dart';
import '../../core/router_name.dart';
import '../../dummy_data/all_dummy_data.dart';
import '../../utils/constants.dart';
import '../../utils/language_string.dart';
import '../../utils/utils.dart';
import '../../widgets/page_refresh.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/rounded_app_bar.dart';
import '../animated_splash_screen/controller/app_setting_cubit/app_setting_cubit.dart';
import '../profile/model/address_model.dart';
import 'component/address_card_component.dart';
import 'component/checkout_single_item.dart';
import 'component/shiping_method_list.dart';
import 'controllers/cart/cart_cubit.dart';
import 'controllers/checkout/checkout_cubit.dart';
import 'model/cart_calculation_model.dart';
import 'model/checkout_response_model.dart';
import 'model/shipping_response_model.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  CartCalculation? cartCalculation;
  late CheckoutCubit checkCubit;

  @override
  void initState() {
    super.initState();
    checkCubit = context.read<CheckoutCubit>();
    Future.microtask(() {
      if (context.read<CartCubit>().couponResponseModel != null) {
        checkCubit.getCheckOutData(
            context.read<CartCubit>().couponResponseModel!.code);
      } else {
        checkCubit.getCheckOutData("");
      }
      context.read<AddressCubit>().getAddress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(titleText: Language.checkout.capitalizeByWord()),
      body: PageRefresh(
        onRefresh: () async {
          if (context.read<CartCubit>().couponResponseModel != null) {
            context.read<CheckoutCubit>().getCheckOutData(
                context.read<CartCubit>().couponResponseModel!.code);
          } else {
            context.read<CheckoutCubit>().getCheckOutData("");
          }
          context.read<AddressCubit>().getAddress();
        },
        child: BlocConsumer<CheckoutCubit, CheckoutState>(
          listener: (_, state) {
            if (state is CheckoutStateError) {
              if (state.statusCode == 503 ||
                  checkCubit.checkoutResponseModel == null) {
                if (context.read<CartCubit>().couponResponseModel != null) {
                  checkCubit.getCheckOutData(
                      context.read<CartCubit>().couponResponseModel!.code);
                } else {
                  checkCubit.getCheckOutData("");
                }
              }
            }
          },
          builder: (context, state) {
            if (state is CheckoutStateLoading) {
              return const LoadingWidget();
            } else if (state is CheckoutStateError) {
              if (state.statusCode == 503 ||
                  checkCubit.checkoutResponseModel != null) {
                return const _LoadedWidget();
              } else {
                return FetchErrorText(text: state.message);
              }
            }else if(state is CheckoutStateLoaded){
              return const _LoadedWidget();
            }
            if(checkCubit.checkoutResponseModel != null){
              return const _LoadedWidget();
            }else{
              return const FetchErrorText(text: 'Something went wrong');
            }

          },
        ),
      ),
    );
  }
}

class _LoadedWidget extends StatefulWidget {
  const _LoadedWidget();

  @override
  State<_LoadedWidget> createState() => _LoadedWidgetState();
}

class _LoadedWidgetState extends State<_LoadedWidget> {
  late CheckoutCubit checkCubit;
  late DeliveryChargesCubit deliveryCubit;
  late CurrencyCubit cCubit;
  final double height = 140;
  String addressTypeSelect = "Billing Address";

  late CheckoutResponseModel? response;
  CartCalculation? cartCalculation;
  PageController pageController =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  final body = <String, dynamic>{};
  final shippingMethodList = <ShippingResponseModel>[];

  @override
  void initState() {
    super.initState();
    deliveryCubit = context.read<DeliveryChargesCubit>();
    cCubit = context.read<CurrencyCubit>();
    deliveryCubit.resetDistance();
    load();
    if (context.read<CartCubit>().couponResponseModel != null) {
      body['coupon'] = context.read<CartCubit>().couponResponseModel!.code;
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  load() {
    checkCubit = context.read<CheckoutCubit>();
    response = checkCubit.checkoutResponseModel;
    cartCalculation = context.read<CartCubit>().getCartCalculation();

    previousPrice = cartCalculation!.total;
    deliveryCubit.addDeliveryCharges(previousPrice);

    if (Utils.isMapEnable(context) &&
        response != null &&
        response!.addresses.isNotEmpty) {
      deliveryCubit.addDistancePerKM(response!.addresses.first.distance,
          response!.addresses.first.priceRange);

      billingAddressId = response!.addresses.first.id;
      shippingAddressId = response!.addresses.first.id;

      // debugPrint('initial-dis-km ${checkoutResponseModel!.addresses.first.distance} | ${checkoutResponseModel!.addresses.first.priceRange}');
    }
  }

  int shippingMethod = 0;
  int agreeTermsCondition = 0;
  int billingAddressId = 0;
  int shippingAddressId = 0;
  double previousPrice = 0.0;
  double totalPrice = 0.0;
  String basedOnWeight = 'base_on_weight';
  String basedOnPrice = 'base_on_price';
  String basedOnQty = 'base_on_qty';
  double totalWeight = 0.0;
  double perUnit = 300.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildProductNumber()),
              _buildProductList(),
              SliverToBoxAdapter(child: _buildLocation()),
              if (shippingMethodList.isNotEmpty)
                SliverToBoxAdapter(
                  child: ShippingMethodList(
                    shippingMethods: shippingMethodList,
                    onChange: (int id) {
                      shippingMethod = id;
                      for (var i in shippingMethodList) {
                        if (i.id == id) {
                          totalPrice = previousPrice + i.shippingFee;
                          context
                              .read<DeliveryChargesCubit>()
                              .addDeliveryCharges(totalPrice);
                        }
                      }
                    },
                  ),
                ),
              // SliverToBoxAdapter(child: _buildPaymentList(context)),
              if (Utils.isMapEnable(context)) ...[
                SliverToBoxAdapter(child: _locationWiseCharge()),
              ],

              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: agreeTermsCondition == 1 ? true : false,
                      activeColor: blackColor,
                      checkColor: whiteColor,
                      onChanged: (v) {
                        if (v != null) {
                          agreeTermsCondition =
                              agreeTermsCondition == 1 ? 0 : 1;
                          setState(() {});
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: CustomText(
                          text: Language.agreeTermAndCondition.capitalizeByWord(),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: textGreyColor),
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
            ],
          ),
        ),
        _bottomBtn(),
      ],
    );
  }

  Widget _bottomBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<DeliveryChargesCubit, ShippingResponseModel>(
                  builder: (context, state) {
                    final price = state.initialPrice + state.distancePrice;
                    return Row(
                      children: [
                        CustomText(
                          text: '${Language.total.capitalizeByWord()}: ',
                          color: redColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                        ),
                        CustomText(
                          text: Utils.formatPrice(price, context),
                          isTranslate: false,
                          color: redColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    );
                  },
                ),
                CustomText(
                    text: "+${Language.shippingCost.capitalizeByWord()}",
                    fontSize: 12.0),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Flexible(
            child: PrimaryButton(
              text: Language.placeOrderNow.capitalizeByWord(),
              onPressed: () {
                if (agreeTermsCondition != 1) {
                  Utils.errorSnackBar(context, Language.termAndCondition);
                  return;
                } else {
                  if (Utils.isMapEnable(context)) {
                    body['shipping_address_id'] = shippingAddressId.toString();
                    body['billing_address_id'] = billingAddressId.toString();
                    body['shipping_method_id'] = shippingMethod.toString();
                    debugPrint(body.toString());
                    Navigator.pushNamed(context, RouteNames.placeOrderScreen,
                        arguments: {'body': body, 'payment_status': response});
                  } else {
                    if (shippingAddressId < 1 ||
                        billingAddressId < 1 ||
                        shippingMethod < 1) {
                      Utils.errorSnackBar(context, Language.selectLocation);
                    } else {
                      body['shipping_address_id'] =
                          shippingAddressId.toString();
                      body['billing_address_id'] = billingAddressId.toString();
                      body['shipping_method_id'] = shippingMethod.toString();
                      debugPrint(body.toString());
                      Navigator.pushNamed(context, RouteNames.placeOrderScreen,
                          arguments: {
                            'body': body,
                            'payment_status': response
                          });
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    final addressCubit = context.read<AddressCubit>();
    return Column(
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                  text: Language.deliveryLocation.capitalizeByWord(),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.addressScreen);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 22,
                  decoration: BoxDecoration(
                    color: Utils.dynamicPrimaryColor(context),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: CustomText(
                        text: Language.add.capitalizeByWord(),
                        fontSize: 12.0,
                        color: blackColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 9),
        if (Utils.isMapEnable(context)) ...[
          _scrollingAddress(context, response!.addresses),
        ] else ...[
          BlocConsumer<AddressCubit, AddressState>(
            listener: (context, state) {
              if (state is AddressStateError) {
                if (state.statusCode == 503) {
                  addressCubit.getAddress();
                }
              }
            },
            builder: (context, state) {
              if (state is AddressStateLoading) {
                return CustomText(text: Language.loading.capitalizeByWord());
              } else if (state is AddressStateError) {
                if (state.statusCode == 503 || addressCubit.address != null) {
                  return _scrollingAddress(
                      context, addressCubit.address!.addresses);
                }
                return FetchErrorText(text: state.message);
              } else if (state is AddressStateLoaded) {
                if (state.address.addresses.isEmpty) {
                  return CustomText(
                      text: Language.noAddress.capitalizeByWord());
                } else {
                  return _scrollingAddress(context, state.address.addresses);
                }
              }
              if (addressCubit.address != null) {
                return _scrollingAddress(
                    context, addressCubit.address!.addresses);
              } else {
                return FetchErrorText(text: Language.somethingWentWrong);
              }
            },
          )
        ],
      ],
    );
  }

  Widget _scrollingAddress(BuildContext context, List<AddressModel> addresses) {
    if (addresses.isNotEmpty &&
        billingAddressId == 0 &&
        shippingAddressId == 0) {
      billingAddressId = addresses.first.id;
      shippingAddressId = addresses.first.id;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // BlocBuilder<CheckoutInfoCubit, CheckoutInfoStateModel>(
        //   builder: (context, state) {
        //     return Row(
        //       children: List.generate(addressType.length, (index) {
        //         final value = addressType[index];
        //         return AnimatedContainer(
        //           duration: const Duration(microseconds: 300),
        //           curve: Curves.ease,
        //           decoration: BoxDecoration(
        //               border: Border(
        //                   bottom: BorderSide(
        //             color: addressTypeSelect == value
        //                 ? Utils.dynamicPrimaryColor(context)
        //                 : Colors.transparent,
        //           ))),
        //           margin:
        //               const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //           padding: const EdgeInsets.only(bottom: 6),
        //           child: Text(
        //             value,
        //             style: TextStyle(
        //               color: addressTypeSelect == value
        //                   ? Utils.dynamicPrimaryColor(context)
        //                   : blackColor,
        //             ),
        //           ),
        //         );
        //       }),
        //     );
        //   },
        // ),
        Container(
          padding: Utils.symmetric(h: 8.0, v: 6.0),
          margin: Utils.symmetric(h: 20.0, v: 6.0),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: Utils.borderRadius(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...addressType.asMap().entries.map(
                    (e) => InkWell(
                      onTap: () {
                        setState(
                          () {
                            addressTypeSelect = e.value;
                            pageController.animateToPage(e.key,
                                duration: const Duration(microseconds: 500),
                                curve: Curves.ease);
                          },
                        );
                      },
                      child: AnimatedContainer(
                        // width: Utils.mediaQuery(context).width / 2.6,

                        duration: const Duration(microseconds: 300),
                        curve: Curves.ease,
                        decoration: BoxDecoration(
                          color: addressTypeSelect == e.value
                              ? tabBgColor
                              : transparent,
                          borderRadius: Utils.borderRadius(r: 6.0),
                        ),
                        padding: Utils.symmetric(h: 22.0, v: 12.0),
                        child: CustomText(
                          text: e.value,
                          color: blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
        // height: MediaQuery.of(context).size.height * 0.25,

        SizedBox(
          height: Utils.mediaQuery(context).height * 0.22,
          child: PageView.builder(
              itemCount: addressType.length,
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                //print('address-length ${addresses.length}');
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 20),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(addresses.length,
                          (index) => shippingCharges(addresses, index)),
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }

  Widget shippingCharges(List<AddressModel> addresses, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 10.0),
      child: InkWell(
        borderRadius: Utils.borderRadius(r: 12.0),
        onTap: () {
          if (addressTypeSelect == 'Billing Address') {
            billingAddressId = addresses[index].id;
          } else {
            if (Utils.isMapEnable(context)) {
              deliveryCubit.addDistancePerKM(
                  addresses[index].distance, addresses[index].priceRange);
              debugPrint(
                  'dis-km ${addresses[index].distance} | ${addresses[index].priceRange}');
            } else {
              shippingMethodList.clear();
              for (var shipping in response!.shippings) {
                if (shipping.type == basedOnPrice) {
                  if (shipping.conditionFrom <= previousPrice &&
                      shipping.conditionTo >= previousPrice) {
                    debugPrint('addressId $shippingAddressId');
                    debugPrint('shippingId ${shipping.id}');
                    if (shippingAddressId != shipping.id) {
                      shippingMethodList.add(shipping);
                    }
                  }
                }

                if (shipping.type == basedOnWeight) {
                  if (shipping.conditionFrom <= previousPrice &&
                      shipping.conditionTo >= previousPrice) {
                    shippingMethodList.add(shipping);
                    // if (shippingAddressId != shipping.id) {
                    //   shippingMethodList.add(shipping);
                    // }
                  }
                }

                if (shipping.type == basedOnQty) {
                  if (shipping.conditionFrom <= previousPrice &&
                      shipping.conditionTo >= previousPrice) {
                    shippingMethodList.add(shipping);
                  }
                }

                // shippingAddressId = addresses[index].id;
                // setState(() {});
              }
            }
            shippingAddressId = addresses[index].id;
            setState(() {});
          }
          setState(() {});
        },
        child: AddressCardComponent(
            isEditButtonShow: false,
            selectAddress: addressTypeSelect == 'Billing Address'
                ? billingAddressId
                : shippingAddressId,
            addressModel: addresses[index],
            type: addresses[index].type),
      ),
    );
  }

  Widget _buildProductList() {
    final appSetting = context.read<AppSettingCubit>();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return CheckoutSingleItem(
                appSetting: appSetting, product: response!.cartProducts[index]);
          },
          childCount: response!.cartProducts.length,
          addAutomaticKeepAlives: true,
        ),
      ),
    );
  }

  Widget _buildProductNumber() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
      child: Row(
        children: [
          const Icon(Icons.shopping_cart_rounded, color: redColor),
          const SizedBox(width: 10),
         CustomText(text:
            "${response!.cartProducts.length} ${Language.products.capitalizeByWord()}",
           fontSize: 16.0,
           fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _locationWiseCharge() {
    String convertPrice(String price) {
      if (cCubit.state.currencies.isNotEmpty) {
        return Utils.convertMulCurrency(
            price, context, cCubit.state.currencies.first);
      } else {
        return Utils.formatPrice(price, context);
      }
    }

    return BlocBuilder<DeliveryChargesCubit, ShippingResponseModel>(
      builder: (context, state) {
        if (state.distancePrice != 0.0) {
          return Container(
            margin: Utils.symmetric(v: 12.0),
            decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: Utils.borderRadius(r: 12.0),
                border: Border.all(color: greenColor),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0.0, 0.0),
                    spreadRadius: 0.0,
                    blurRadius: 0.0,
                    // color: whiteColor
                    color: const Color(0xFF000000).withOpacity(0.4),
                  ),
                ]),
            child: ListTile(
              horizontalTitleGap: 0,
              title: CustomText(
                  text:
                      'Fee: ${convertPrice(state.distancePrice.toStringAsFixed(2))}'),
              //subtitle: Text(e.shippingRule),
              subtitle: const CustomText(
                text: 'Delivery Charge',
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
