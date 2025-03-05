import 'package:flutter/material.dart';
import 'package:shop_o/utils/utils.dart';

import '../../../utils/constants.dart';
import '../../category/component/product_card.dart';
import '../model/product_model.dart';
import 'section_header.dart';

class HorizontalProductComponent extends StatelessWidget {
  const HorizontalProductComponent(
      {super.key,
      required this.productList,
      required this.category,
      this.bgColor,
      this.onTap});

  final List<ProductModel> productList;
  final String category;
  final Color? bgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (productList.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    } else {
      return SliverToBoxAdapter(
        child: Container(
          // color: scaBgColor,
          color: bgColor,
          padding: Utils.symmetric(v: 10.0, h: 0.0),
          child: Column(
            children: [
              // const SizedBox(height: 10),
              SectionHeader(headerText: category, onTap: onTap),
              Container(
                height: cardSize,
                margin: Utils.only(top: 14.0),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: Utils.symmetric(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      ProductCard(productModel: productList[index], width: 180),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                  itemCount: productList.length > 5 ? 5 : productList.length,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
