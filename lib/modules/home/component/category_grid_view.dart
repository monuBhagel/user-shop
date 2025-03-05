import 'package:flutter/material.dart';
import 'package:shop_o/utils/constants.dart';
import 'package:shop_o/utils/utils.dart';
import '../../../core/router_name.dart';
import '../../category/component/single_circuler_card.dart';
import '../model/home_model.dart';
import 'section_header.dart';
import 'sponsor_component.dart';

class CategoryGridView extends StatelessWidget {
  const CategoryGridView({super.key, required this.model});
  final HomeModel model;

  @override
  Widget build(BuildContext context) {
    //if (categoryList.isEmpty) return const SliverToBoxAdapter();
    return SliverToBoxAdapter(
      child: Container(
        color: whiteColor,
        padding: Utils.symmetric(h: 0.0, v: 14.0),
        width: Utils.mediaQuery(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              headerText: '${model.sectionTitle[0].custom ?? model.sectionTitle[0].dDefault}',
              onTap: () {
                Navigator.pushNamed(context, RouteNames.allCategoryListScreen);
              },
            ),
            Utils.verticalSpace(14.0),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                    model.homePageCategory.length > 6 ? 6 : model.homePageCategory.length,
                    (index) => Container(
                      color: whiteColor,
                      padding: const EdgeInsets.only(right: 24),
                      child: CategoryCircleCard(
                          categoriesModel: model.homePageCategory[index]),
                    ),
                  )
                ],
              ),
            ),
            Utils.verticalSpace(14.0),
            SponsorComponent(brands: model.brands),
          ],
        ),
      ),
    );
  }

}
