import 'package:flutter/material.dart';
import 'package:shop_o/utils/constants.dart';
import '../../../widgets/custom_text.dart';
import '/widgets/capitalized_word.dart';

import '../../../utils/language_string.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    this.color,
    this.onTap,
    required this.headerText,
    this.isSeeAllShow = true,
  });

  final Color? color;
  final String headerText;
  final VoidCallback? onTap;
  final bool isSeeAllShow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
              text: headerText,
              fontSize: 18,
              color: color ?? blackColor,
              height: 1.5,
              fontWeight: FontWeight.w600),
          isSeeAllShow
              ? InkWell(
                  onTap: onTap,
                  child: Container(
                    // color: iconGreyColor,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CustomText(
                      text: Language.seeAll.capitalizeByWord(),
                      fontSize: 16,
                      color: textGreyColor,
                      height: 1.6,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
