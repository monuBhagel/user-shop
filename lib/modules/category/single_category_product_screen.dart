import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../utils/k_images.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/custom_text.dart';
import '/core/router_name.dart';
import '/modules/category/component/drawer_filter.dart';
import '/utils/constants.dart';
import '/utils/language_string.dart';
import '/widgets/capitalized_word.dart';
import '../../utils/utils.dart';
import '../../widgets/fetch_error_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/page_refresh.dart';
import '../../widgets/rounded_app_bar.dart';
import '../home/controller/cubit/product/product_state_model.dart';
import '../home/model/product_model.dart';
import 'component/product_card.dart';
import 'controller/cubit/category_cubit.dart';

class SingleCategoryProductScreen extends StatefulWidget {
  const SingleCategoryProductScreen({super.key, required this.slug});

  final String slug;

  @override
  State<SingleCategoryProductScreen> createState() =>
      _SingleCategoryProductScreenState();
}

class _SingleCategoryProductScreenState
    extends State<SingleCategoryProductScreen> {
  late CategoryCubit categoryCubit;

  @override
  void initState() {
    _initState();
    super.initState();
  }

  final _scrollController = ScrollController();

  @override
  void dispose() {
    // if (categoryCubit.state.initialPage > 1) {
    //   categoryCubit.initPage();
    // }
    _scrollController.dispose();
    super.dispose();
  }

  _initState() {
    categoryCubit = context.read<CategoryCubit>();
    Future.microtask(() {
      categoryCubit.getCategoryProduct(widget.slug);
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0.0) {
        if (categoryCubit.state.isListEmpty == false) {
          categoryCubit.getCategoryProduct(widget.slug);
        }
      }
    }
  }

  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // print('categoryCubit.state.title ${categoryCubit.state.title}');
    return Scaffold(
      key: _key,
      endDrawer: const DrawerFilter(),
      appBar: RoundedAppBar(
        titleText: categoryCubit.state.title.capitalizeByWord(),
        options: [
          BlocBuilder<CategoryCubit, ProductStateModel>(
            builder: (context, state) {
              if (categoryCubit.productCategoriesModel != null){
                return GestureDetector(
                  onTap: () {
                    // context.read<CategoryCubit>().clearFilterData();
                    _key.currentState?.openEndDrawer();
                    // Scaffold.of(context).openEndDrawer();
                  },
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Utils.dynamicPrimaryColor(context),
                          borderRadius: Utils.borderRadius(r: 4.0)),
                      padding: Utils.symmetric(h: 10.0),
                      margin: Utils.symmetric(v: 10.0),
                      child: Row(
                        children: [
                          const CustomImage(path: Kimages.filterProductIcon),
                          Utils.horizontalSpace(10.0),
                        CustomText(text:
                            Language.filter.capitalizeByWord(),
                            color: blackColor, fontWeight: FontWeight.w700
                          ),
                        ],
                      )),
                );
              }else{
                return const SizedBox.shrink();
              }

            },
          ),
        ],
        onTap: () {
          Navigator.popAndPushNamed(context, RouteNames.allCategoryListScreen);
        },
      ),
      body: PageRefresh(
        onRefresh: () async {
          if (categoryCubit.state.initialPage > 1) {
            categoryCubit.initPage();
          }
          categoryCubit.getCategoryProduct(widget.slug);
        },
        child: BlocConsumer<CategoryCubit, ProductStateModel>(
          listener: (context, productState) {
            final state = productState.catState;
            if (state is CategoryErrorState) {
              if (state.statusCode == 503) {
                categoryCubit.getCategoryProduct(widget.slug);
              }
            }
            if (state is CategoryLoadingState &&
                categoryCubit.state.initialPage != 1) {
              Utils.loadingDialog(context);
            } else if (state is CategoryMoreLoadedState) {
              Utils.closeDialog(context);
            }
          },
          listenWhen: (p, c) => p == c,
          builder: (context, productState) {
            final state = productState.catState;
            if (state is CategoryLoadingState &&
                categoryCubit.state.initialPage == 1) {
              return const LoadingWidget(color: greenColor);
            } else if (state is CategoryErrorState) {
              if (state.statusCode == 503 ||
                  categoryCubit.productCategoriesModel == null) {
                return CategoryLoad(
                    catProducts: categoryCubit.catProducts,
                    controller: _scrollController);
              } else {
                return FetchErrorText(text: state.message);
              }
            } else if (state is CategoryLoadedState) {
              return CategoryLoad(
                  catProducts: state.categoryProducts,
                  controller: _scrollController);
            } else if (state is CategoryMoreLoadedState) {
              return CategoryLoad(
                  catProducts: state.categoryProducts,
                  controller: _scrollController);
            }
            if (categoryCubit.catProducts.isNotEmpty ||
                categoryCubit.productCategoriesModel != null) {
              return CategoryLoad(
                  catProducts: categoryCubit.catProducts,
                  controller: _scrollController);
            } else {
              //if (categoryCubit.catProducts.isEmpty) {
              //return const LoadingWidget(color: greenColor);
              //} else {
              return const FetchErrorText(text: 'Something went wrong');
              //}
            }
          },
        ),
      ),
    );
  }
}

class CategoryLoad extends StatelessWidget {
  const CategoryLoad(
      {super.key, required this.catProducts, required this.controller});

  final List<ProductModel> catProducts;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final cCubit = context.read<CategoryCubit>();
    return CustomScrollView(
      controller: controller,
      slivers: [
        // SliverToBoxAdapter(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       const SizedBox(),
        //       BlocBuilder<CategoryCubit, ProductStateModel>(
        //         builder: (context, state) {
        //           if (cCubit.productCategoriesModel != null) {
        //             return GestureDetector(
        //               onTap: () {
        //                 context.read<CategoryCubit>().clearFilterData();
        //                 Scaffold.of(context).openEndDrawer();
        //               },
        //               child: Container(
        //                   alignment: Alignment.center,
        //                   decoration: BoxDecoration(
        //                       color: Utils.dynamicPrimaryColor(context)),
        //                   padding: Utils.symmetric(h: 6.0),
        //                   margin: Utils.symmetric(v: 10.0),
        //                   child: Padding(
        //                     padding: Utils.only(bottom: 4.0),
        //                     child: Text(
        //                       Language.filter.capitalizeByWord(),
        //                       style: const TextStyle(color: whiteColor),
        //                     ),
        //                   )),
        //             );
        //           } else {
        //             return const SizedBox();
        //           }
        //         },
        //       ),
        //     ],
        //   ),
        // ),
        SliverPadding(
          padding: Utils.symmetric(v: 30.0).copyWith(top: 20.0),
          sliver: catProducts.isNotEmpty
              ? SliverGrid.builder(
                  itemCount: catProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: cardSize,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ProductCard(productModel: catProducts[index]);
                  },
                )
              : SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.8,
                    child: const FetchErrorText(
                        text: 'No Product found!', color: blackColor),
                  ),
                ),
        )
      ],
    );
  }

  ListView buildListView(BuildContext context) {
    return ListView(
      controller: controller,
      padding: Utils.symmetric(),
      children: [
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: GridView.builder(
            itemCount: catProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: cardSize,
            ),
            itemBuilder: (BuildContext context, int index) {
              return ProductCard(productModel: catProducts[index]);
            },

            // delegate: SliverChildBuilderDelegate(
            //       (BuildContext context, int index) {
            //     return ;
            //   },
            //   childCount: categoryProduct.length,
            // ),
          ),
        ),
      ],
    );
  }
}
