import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/custom_text.dart';
import '/utils/language_string.dart';
import '/widgets/capitalized_word.dart';
import '../../../core/router_name.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../controllers/order/order_cubit.dart';
import '../model/order_model.dart';

class OrderedListComponent extends StatelessWidget {
  const OrderedListComponent({super.key, required this.orderedItem});

  final OrderModel orderedItem;

  @override
  Widget build(BuildContext context) {
    final oCubit = context.read<OrderCubit>();
    return Container(
      padding: Utils.symmetric(v: 20.0),

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

      margin: Utils.symmetric(v: 5.0, h: 10.0),
      // decoration: const BoxDecoration(color: cardBgGreyColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _totalItem(context),
          const SizedBox(height: 10),
          _buildTrackingNumber(),
          const SizedBox(height: 10),
          // ...orderedItem.orderProducts.map((e) => SingleOrderDetailsComponent(
          //     orderItem: e, isOrdered: orderedItem.orderStatus == '3')),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Utils.dynamicPrimaryColor(context),
                      backgroundColor: Colors.white,
                      side:
                          BorderSide(color: Utils.dynamicPrimaryColor(context)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      )),
                  onPressed: () {
                    if (oCubit.state is! OrderStateInitial) {
                      // print('oCubit.state ${oCubit.state}');
                      oCubit.initPage(isPaginate: false);
                    }
                    Navigator.pushNamed(context, RouteNames.singleOrderScreen,
                        arguments: orderedItem.orderId);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: CustomText(
                      text: Language.viewDetails.capitalizeByWord(),
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              // TextButton(
              //     onPressed: () {
              //       print(orderedItem.orderId);
              //       context
              //           .read<OrderTrackingCubit>()
              //           .trackingOrderResponse('16529475760');
              //     },
              //     child: const Text('Tracking')),
              CustomText(
                  text: Utils.orderStatus("${orderedItem.orderStatus}"),
                  fontWeight: FontWeight.w600,
                  color: "${orderedItem.orderStatus}" == '4'
                      ? redColor
                      : greenColor)
            ],
          ),
        ],
      ),
    );
  }

  Widget _totalItem(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OrderItem(
                title: "${Language.quantity.capitalizeByWord()}: ",
                value: "${orderedItem.productQty}"),
            CustomText(
              text: Utils.formatDate(orderedItem.createdAt),
              color: const Color(0xff85959E),
              isTranslate: false,
            )
          ],
        ),
        const SizedBox(height: 8),
        OrderItem(
          title: "${Language.totalAmount.capitalizeByWord()}: ",
          value: Utils.formatPrice(orderedItem.totalAmount, context),
          isTranslate: false,
        ),
      ],
    );
  }

  Widget _buildTrackingNumber() {
    return OrderItem(
        title: "Order tracking number:",
        value: ' ${orderedItem.orderId}');
  }
}

class OrderItem extends StatelessWidget {
  const OrderItem(
      {super.key,
      required this.title,
      required this.value,
      this.isTranslate = true});

  final String title;
  final String value;
  final bool isTranslate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomText(text: title, fontSize: 16.0, fontWeight: FontWeight.w500),
        Utils.horizontalSpace(6.0),
        CustomText(
            text: value,
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
            isTranslate: isTranslate),
      ],
    );
  }
}
