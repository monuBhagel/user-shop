import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/k_images.dart';
import '../../../widgets/confirm_dialog.dart';
import '../../../widgets/custom_text.dart';

import '../../../core/remote_urls.dart';
import '../../../core/router_name.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_image.dart';
import '../../animated_splash_screen/controller/app_setting_cubit/app_setting_cubit.dart';
import '../controllers/cart/cart_cubit.dart';
import '../model/cart_product_model.dart';

class AddToCartComponent extends StatefulWidget {
  const AddToCartComponent(
      {super.key,
      required this.product,
      required this.onChange,
      required this.appSetting});

  final CartProductModel product;
  final ValueChanged<int> onChange;
  final AppSettingCubit appSetting;

  @override
  State<AddToCartComponent> createState() => _AddToCartComponentState();
}

class _AddToCartComponentState extends State<AddToCartComponent> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 40;
    const double height = 120;
    int value = widget.product.qty;
    return Container(
      height: height,
      margin: Utils.symmetric(v: 6.0, h: 15.0),
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: Utils.borderRadius(r: 12.0),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0.0, 0.0),
                spreadRadius: 0.0,
                blurRadius: 0.0,
                // color: whiteColor
                color: const Color(0xFF000000).withOpacity(0.4)),
          ]),
      child: Row(
        children: [
          SizedBox(
            height: height - 2,
            width: width / 2.7,
            child: ClipRRect(
              borderRadius: Utils.borderRadius(r: 6.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.productDetailsScreen,
                      arguments: widget.product.product.slug);
                },
                child: CustomImage(
                  path: RemoteUrls.imageUrl(widget.product.product.thumbImage),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: widget.product.product.name,
                        textAlign: TextAlign.left,
                        maxLine: 2,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        return await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => ConfirmDialog(
                            icon: Kimages.deleteIcon2,
                            message: 'Do you want to Remove\nthis Product?',
                            confirmText: 'Yes, Remove',
                            cancelText: 'No',
                            onTap: () async {
                              final result = await context
                                  .read<CartCubit>()
                                  .removerCartItem(
                                      widget.product.id.toString());
                              widget.product;
                              result.fold(
                                (failure) {
                                  // setState(() {});
                                  Utils.errorSnackBar(context, failure.message);
                                },
                                (success) {
                                  widget.onChange(widget.product.id);
                                  Utils.showSnackBar(context, success);
                                },
                              );
                              Navigator.of(context).pop(true);
                            },
                          ),
                        );
                      },
                      child: Padding(
                        padding: Utils.only(right: 10.0),
                        child: const Icon(Icons.clear_sharp,
                            size: 20.0, color: redColor),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomText(
                      text: Utils.formatPrice(
                          Utils.cartProductPrice(context, widget.product),
                          context),
                      color: redColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: widget.product.qty > 1
                          ? () async {
                              final result = await context
                                  .read<CartCubit>()
                                  .decrementQuantity(
                                      widget.product.id.toString());

                              result.fold(
                                (failure) {
                                  // setState(() {});
                                  Utils.errorSnackBar(context, failure.message);
                                },
                                (success) {
                                  // widget.onChange(widget.product.id);
                                  // Utils.showSnackBar(context, success);
                                  Future.microtask(() => context
                                      .read<CartCubit>()
                                      .getCartProducts());
                                  // value--;
                                  // setState(() {
                                  //
                                  // });
                                },
                              );
                            }
                          : null,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Utils.dynamicPrimaryColor(context),
                        child: const Icon(Icons.remove, color: blackColor),
                      ),
                      // child: Icon(Icons.remove_circle, color: Utils.dynamicPrimaryColor(context)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 5),
                      child: CustomText(
                          text: value.toString(),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    InkWell(
                      splashColor: transparent,
                      splashFactory: NoSplash.splashFactory,
                      onTap: () async {
                        final result = await context
                            .read<CartCubit>()
                            .incrementQuantity(widget.product.id.toString());

                        result.fold(
                          (failure) {
                            // setState(() {});
                            Utils.errorSnackBar(context, failure.message);
                          },
                          (success) {
                            // widget.onChange(widget.product.id);
                            // Utils.showSnackBar(context, success);
                            Future.microtask(() =>
                                context.read<CartCubit>().getCartProducts());
                            // value++;
                            // setState(() {

                            // });
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Utils.dynamicPrimaryColor(context),
                        child: const Icon(Icons.add, color: blackColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
