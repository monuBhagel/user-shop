import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/k_images.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_image.dart';
import '../../category/component/product_card.dart';
import '../model/product_model.dart';
import 'section_header.dart';

class NewArrivalComponent extends StatelessWidget {
  const NewArrivalComponent({
    super.key,
    required this.productList,
    required this.sectionTitle,
    this.onTap,
  });

  final List<ProductModel> productList;
  final String sectionTitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: scaBgColor,
        padding: Utils.symmetric(v: 20.0,h: 0.0).copyWith(bottom: 40.0),
        // margin: Utils.only(top: 20.0),
        child: Column(
          children: [
            SectionHeader(headerText: sectionTitle, onTap: onTap),
            Utils.verticalSpace(14.0),
            GridView.builder(
              shrinkWrap: true,
              padding: Utils.symmetric(),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                mainAxisExtent: cardSize,
              ),
              itemBuilder: (context, index) =>  ProductCard(productModel: productList[index]),
              itemCount: productList.length > 6 ? 6 : productList.length,
            ),
          ],
        ),
      ),
    );
  }
}

class _NewArrivalHeader extends StatefulWidget {
  const _NewArrivalHeader({
    required this.title,
  });

  final String title;

  @override
  State<_NewArrivalHeader> createState() => _NewArrivalHeaderState();
}

class _NewArrivalHeaderState extends State<_NewArrivalHeader> {
  final _controller = CustomPopupMenuController();

  final List<String> list = <String>[
    'New Arrival',
    'Top Products',
    'Best Sellings',
    'Discount Products',
    'Height Price',
    'Low Price',
    'Free Delivery'
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
              fontSize: 18, height: 1.5, fontWeight: FontWeight.w600),
        ),
        CustomPopupMenu(
          pressType: PressType.singleClick,
          position: PreferredPosition.bottom,
          showArrow: false,
          verticalMargin: 4,
          controller: _controller,
          child: const SizedBox(
            height: 24,
            width: 24,
            child: Center(child: CustomImage(path: Kimages.menuIcon)),
          ),
          menuBuilder: () =>
              MenuItemListComponent(list: list, controller: _controller),
        ),
      ],
    );
  }
}

class MenuItemListComponent extends StatelessWidget {
  const MenuItemListComponent({
    super.key,
    required this.controller,
    required this.list,
  });

  final List<String> list;
  final CustomPopupMenuController controller;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: Colors.white,
        width: 175,
        height: 280,
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(left: 12),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: list
              .map(
                (e) => InkWell(
                  onTap: () {
                    controller.hideMenu();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      e,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
