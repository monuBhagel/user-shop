import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:shop_o/utils/constants.dart';

import '../../../widgets/custom_text.dart';
import '/modules/home/component/implemented_count_down.dart';
import '/utils/language_string.dart';
import '/widgets/capitalized_word.dart';
import '../../../core/remote_urls.dart';
import '../../../core/router_name.dart';
import '../../../utils/utils.dart';
import '../model/flash_sale_model.dart';

class FlashSaleComponent extends StatelessWidget {
  const FlashSaleComponent({super.key, required this.flashSale});

  final FlashSaleModel flashSale;

  @override
  Widget build(BuildContext context) {
    int endTime =
        DateTime.parse(flashSale.endTime).millisecondsSinceEpoch + 1000 * 30;
    // DateTime.now().millisecondsSinceEpoch + 1000 * 30;
    if (endTime > 0) {
      return SliverToBoxAdapter(
        child: Container(
          height: 275,
          padding: Utils.symmetric(h: 10.0),
          margin: Utils.only(bottom: 20.0, top: 15),
          decoration: BoxDecoration(
            image: DecorationImage(
                image:
                    NetworkImage(RemoteUrls.imageUrl(flashSale.homepageImage)),
                fit: BoxFit.cover),
            color: Utils.dynamicPrimaryColor(context).withOpacity(0.05),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            // alignment: Alignment.center,
            children: [
              Expanded(
                child: CountdownTimer(
                  endTime: endTime,
                  widgetBuilder: (_, time) {
                    if (time == null) {
                      // return const CustomText(text: '');
                      return const SizedBox.shrink();
                    }
                    return ImplementedCountDown(time: time);

                    // Text(
                    //   'days: [ ${time.days} ], hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: Utils.symmetric(h: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "WOO!\n",
                              fontSize: 30.0,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              color: blackColor,
                            ),
                            Utils.verticalSpace(2.0),
                            CustomText(
                              text: flashSale.title.replaceAll('WOO!', ''),
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                              color: blackColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteNames.flashScreen);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomText(
                                text: Language.shopNow.capitalizeByWord(),
                                fontWeight: FontWeight.w600,
                                height: 1,
                                color: blackColor,
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }
}
