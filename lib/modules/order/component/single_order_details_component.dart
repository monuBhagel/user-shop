import 'package:flutter/material.dart';

import '../../../core/router_name.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_text.dart';
import '../model/product_order_model.dart';

class SingleOrderDetailsComponent extends StatelessWidget {
  const SingleOrderDetailsComponent(
      {super.key, required this.orderItem, this.isOrdered = false});

  final bool isOrdered;

  final OrderedProductModel orderItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 14, left: 14),
      child: InkWell(
        onTap: () {
          // Navigator.pushNamed(context, RouteNames.productDetailsScreen,
          //     arguments: orderItem.slug);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CustomImage(
            //   path: RemoteUrls.imageUrl(orderItem.thumbImage),
            //   height: 70,
            //   width: 70,
            //   fit: BoxFit.cover,
            // ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      text: orderItem.productName,
                      maxLine: 2,
                      overflow: TextOverflow.ellipsis,
                      height: 1.4,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  CustomText(
                      text: 'X ${orderItem.qty}',
                      color: blackColor.withOpacity(0.6)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: Utils.formatPrice(orderItem.unitPrice, context),
                        isTranslate: false,
                      ),
                      if (isOrdered)
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteNames.submitFeedBackScreen,
                                arguments: orderItem);
                          },
                          child: const CustomText(
                            text: 'Write Review',
                            color: blackColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
