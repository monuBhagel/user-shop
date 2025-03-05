import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_o/utils/constants.dart';
import 'package:shop_o/widgets/page_refresh.dart';

import '../../utils/utils.dart';
import '../../widgets/fetch_error_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/rounded_app_bar.dart';
import '../home/controller/cubit/product/product_state_model.dart';
import '../home/controller/cubit/product/products_cubit.dart';
import '../home/controller/cubit/product/products_state.dart';
import '../home/model/product_model.dart';
import 'component/populer_product_card.dart';

class AllPopularProductScreen extends StatefulWidget {
  const AllPopularProductScreen({super.key, required this.keyword});

  final String keyword;

  @override
  State<AllPopularProductScreen> createState() =>
      _AllPopularProductScreenState();
}

class _AllPopularProductScreenState extends State<AllPopularProductScreen> {
  @override
  void initState() {
    Future.microtask(() =>
        context.read<ProductsCubit>().getHighlightedProduct(widget.keyword));
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final customerCubit = context.read<ProductsCubit>();
    // final maxScroll = _scrollController.position.maxScrollExtent;
    // final currentScroll = _scrollController.position.pixels;

    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0.0) {
        if (customerCubit.state.isListEmpty == false) {
          context.read<ProductsCubit>().getHighlightedProduct(widget.keyword);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productCubit = context.read<ProductsCubit>();
    // debugPrint('initial-page ${productCubit.state.initialPage}');
    return Scaffold(
      appBar: RoundedAppBar(
        titleText: productCubit.state.name,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: PageRefresh(
        onRefresh: () async {
          if (productCubit.state.initialPage > 1) {
            // print('page-number ${productCubit.state.initialPage}');
            productCubit.initPage();
          }
          productCubit.getHighlightedProduct(widget.keyword);
        },
        child: BlocConsumer<ProductsCubit, ProductStateModel>(
            listener: (context, productState) {
          final state = productState.productState;
          if (state is ProductsStateError) {
            if (state.statusCode == 401) {
              //Utils.logoutFunction(context);
            } else if (state.statusCode == 503) {
              productCubit.getHighlightedProduct(widget.keyword);
            }
          } else if (state is ProductsStateLoading &&
              productCubit.state.initialPage != 1) {
            Utils.loadingDialog(context);
          } else if (state is MoreProductsStateLoaded) {
            Utils.closeDialog(context);
          }
        },
            // builder: (context, productState) {
            //   final state = productState.productState;
            //   if (state is ProductsStateLoading) {
            //     return const Center(child: CircularProgressIndicator());
            //   } else if (state is ProductsStateError) {
            //   } else if (state is ProductsStateLoaded) {
            //     return buildListView(state);
            //   }
            //   return const SizedBox();
            // },
            builder: (context, productState) {
          final state = productState.productState;
          if (state is ProductsStateLoading &&
              productCubit.state.initialPage == 1) {
            return const LoadingWidget(color: greenColor);
          } else if (state is ProductsStateError) {
            if (state.statusCode == 503) {
              return LoadedHighlightedProduct(
                  highlighted: productCubit.highLightedProducts,
                  controller: _scrollController);
            } else {
              return FetchErrorText(text: state.errorMessage);
            }
          } else if (state is ProductsStateLoaded) {
            return LoadedHighlightedProduct(
                highlighted: state.highlightedProducts,
                // customers: customerCubit.customers,
                controller: _scrollController);
          } else if (state is MoreProductsStateLoaded) {
            return LoadedHighlightedProduct(
                highlighted: state.highlightedProducts,
                controller: _scrollController);
          }

          if (productCubit.highLightedProducts.isNotEmpty) {
            return LoadedHighlightedProduct(
                highlighted: productCubit.highLightedProducts,
                controller: _scrollController);
          } else {
            return const FetchErrorText(text: 'Something went wrong');
          }
        }),
      ),
    );
  }
}

class LoadedHighlightedProduct extends StatelessWidget {
  const LoadedHighlightedProduct(
      {super.key, required this.highlighted, required this.controller});

  final List<ProductModel> highlighted;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    // debugPrint('length ${highlighted.length}');
    return ListView.builder(
      controller: controller,
      // padding: Utils.symmetric(h: 20.0, v: 16.0),
      itemCount: highlighted.length,
      itemBuilder: (context, index) =>
          Padding(
            padding: Utils.symmetric(h: 20.0).copyWith(top: index == 0?10.0:0.0,bottom: index == highlighted.length -1 ?30.0:0.0),
            child: PopularProductCard(productModel: highlighted[index]),
          ),
    );
  }
}
