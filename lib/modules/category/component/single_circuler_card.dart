import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_font_awesome_web_names/flutter_font_awesome.dart';

import '../../../core/remote_urls.dart';
import '../../../core/router_name.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_image.dart';

import '../../../widgets/custom_text.dart';
import '../../home/model/home_category_model.dart';
import '../controller/cubit/category_cubit.dart';

class CategoryCircleCard extends StatelessWidget {
  const CategoryCircleCard({super.key, required this.categoriesModel});

  // final CategoriesModel categoriesModel;
  final HomePageCategoriesModel categoriesModel;

  @override
  Widget build(BuildContext context) {
    final cCubit = context.read<CategoryCubit>();
    return InkWell(
      onTap: () {
        if (cCubit.state.initialPage > 1) {
          cCubit.initPage();
        }
        cCubit..changeTitle(categoriesModel.name)..clearFilterData();

        Navigator.pushNamed(
          context,
          RouteNames.singleCategoryProductScreen,
          arguments: categoriesModel.slug,
        );
      },
      child: Column(
        children: [
          Container(
            height: 70.0,
            width: 70.0,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffeef1f1),
              // color: Color(0xffFFF7E7),
            ),
            // child: Center(
            //   child: FaIcon(categoriesModel.icon, color: blackColor),
            // ),
            child: Center(
              child: categoriesModel.image.isNotEmpty
                  ? CustomImage(
                      path: RemoteUrls.imageUrl(categoriesModel.image),
                      height: 40.0,
                      width: 40.0,
                    )
                  : FaIcon(categoriesModel.icon, color: blackColor),
              // child: FaIcon(categoriesModel., color: blackColor),
            ),
          ),
          Utils.verticalSpace(4.0),
          CustomText(
            text: categoriesModel.name,
            maxLine: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
