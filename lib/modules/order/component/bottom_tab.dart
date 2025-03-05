import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_o/widgets/capitalized_word.dart';

import '../../../utils/constants.dart';
import '../../../utils/language_string.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_text.dart';
import '../../home/controller/cubit/product/product_state_model.dart';
import '../controllers/order/order_cubit.dart';

class BottomTab extends StatefulWidget implements PreferredSizeWidget {
  const BottomTab({super.key});

  @override
  State<BottomTab> createState() => _BottomTabState();

  @override
  Size get preferredSize => Size.fromHeight(Utils.vSize(50.0));
}

class _BottomTabState extends State<BottomTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final bCubit = context.read<OrderCubit>();

    return BlocBuilder<OrderCubit, ProductStateModel>(
      builder: (context, state) {
        final tabs = [
          'All Orders',
          (Language.pending.capitalizeByWord()),
          (Language.progress.capitalizeByWord()),
          (Language.delivered.capitalizeByWord()),
          (Language.completed.capitalizeByWord()),
          (Language.declined.capitalizeByWord()),
        ];
        final count = [
          '${bCubit.orderList.length}',
          '${bCubit.pending.length}',
          '${bCubit.progress.length}',
          '${bCubit.delivered.length}',
          '${bCubit.completed.length}',
          '${bCubit.declined.length}',
        ];
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: Utils.symmetric(h: 10.0, v: 5.0),
          padding: Utils.symmetric(v: 10.0, h: 10.0),
          color: whiteColor,
          // decoration: BoxDecoration(
          //   color: whiteColor,
          //   borderRadius: Utils.borderRadius(),
          // ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                tabs.length,
                (index) {
                  final active = state.currentIndex == index;
                  // final active = currentIndex == index;
                  return GestureDetector(
                    onTap: () {
                      bCubit.changeCurrentIndex(index);
                      _scrollToIndex(index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      padding: Utils.symmetric(v: 6.0, h: 16.0),
                      margin: Utils.only(right: 6.0),
                      // margin: Utils.only(
                      //     right: index == tabs.length - 1 ? 20.0 : 12.0,
                      //     left: index == 0 ? 20.0 : 0.0),

                      decoration: BoxDecoration(
                        color: active ? blackColor : transparent,
                        borderRadius: Utils.borderRadius(r: 6.0),
                      ),

                      // decoration: BoxDecoration(
                      //   color: active
                      //       ? Utils.dynamicPrimaryColor(context)
                      //       : Colors.white,
                      //   //borderRadius: BorderRadius.circular(2),
                      // ),
                      child: Row(
                        children: [
                          CustomText(
                            text: tabs[index],
                            fontSize: 16.0,
                            color: !active ? textGreyColor : whiteColor,
                          ),
                          CustomText(
                            text: '(${count[index]})',
                            isTranslate: false,
                            fontSize: 16.0,
                            color: !active ? textGreyColor : whiteColor,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _scrollToIndex(int index) {
    const itemWidth = 160.0;
    final screenWidth = MediaQuery.of(context).size.width;

    final offset = index * itemWidth - (screenWidth - itemWidth) / 2;

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
