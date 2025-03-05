import 'package:flutter/material.dart';
import 'package:shop_o/utils/constants.dart';

import '../../../core/remote_urls.dart';
import '../../../core/router_name.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_image.dart';
import '../model/brand_model.dart';

class SponsorComponent extends StatelessWidget {
  const SponsorComponent({super.key, required this.brands});

  final List<BrandModel> brands;

  @override
  Widget build(BuildContext context) {
    if (brands.isEmpty) return const SizedBox();
    return Container(
      padding: Utils.symmetric(h: 10.0),
      margin: Utils.symmetric(h: 0.0, v: 15.0),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: grayColor.withOpacity(0.2)))),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(brands.length, (index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteNames.brandProductScreen,
                    arguments: brands[index].slug);
              },
              child: Padding(
                padding: Utils.only(right: 24.0),
                child: CustomImage(
                  path: RemoteUrls.imageUrl(brands[index].logo),
                  height: 56.0,
                  width: 68.0,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Container buildContainer() {
    return Container(
      height: 70.0,
      padding: Utils.symmetric(h: 10.0),
      margin: Utils.symmetric(h: 0.0, v: 15.0),
      decoration: BoxDecoration(
          color: scaBgColor,
          border: Border(top: BorderSide(color: grayColor.withOpacity(0.1)))),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteNames.brandProductScreen,
                arguments: brands[index].slug);
          },
          child: Padding(
            padding: Utils.only(right: 24.0),
            child: CustomImage(
              path: RemoteUrls.imageUrl(brands[index].logo),
              height: 56.0,
              width: 68.0,
            ),
          ),
        ),
        separatorBuilder: (_, index) => const SizedBox(width: 10),
        itemCount: brands.length,
      ),
    );
  }
}
