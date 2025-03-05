import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_o/widgets/fetch_error_text.dart';
import 'package:shop_o/widgets/loading_widget.dart';

import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widgets/empty_widget.dart';
import '../category/component/product_card.dart';
import 'components/rounded_app_bar.dart';
import 'controllers/search/search_bloc.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => ProductSearchScreenState();
}

class ProductSearchScreenState extends State<ProductSearchScreen> {
  @override
  void initState() {
    super.initState();
    //_init();
  }

  void _init() {
    _controller.addListener(() {
      final maxExtent = _controller.position.maxScrollExtent - 200;
      if (maxExtent < _controller.position.pixels) {
        searchBloc.add(const SearchEventLoadMore());
      }
    });
  }

  final searchCtr = TextEditingController();
  final _controller = ScrollController();

  late SearchBloc searchBloc;

  @override
  void dispose() {
    super.dispose();

    searchBloc.products.clear();
  }

  @override
  Widget build(BuildContext context) {
    searchBloc = context.read<SearchBloc>();

    return Scaffold(
      appBar: SearchAppBar(
        titleWidget: Container(
          margin: const EdgeInsets.only(right: 20),
          height: 40,
          child: TextFormField(
            controller: searchCtr,
            textInputAction: TextInputAction.done,
            autofocus: true,
            onChanged: (v) {
              if (v.isEmpty) return;
              context.read<SearchBloc>().add(SearchEventSearch(v.trim()));
            },
            onFieldSubmitted: (v) {
              if (v.isEmpty) return;
              context.read<SearchBloc>().add(SearchEventSearch(v.trim()));
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              hintText: Utils.formText(context, 'Search Products'),
            ),
          ),
        ),
      ),
      body: BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state is SearchStateMoreError) {
            Utils.errorSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          final products = searchBloc.products;
          if (state is SearchStateLoading) {
            return const LoadingWidget();
          } else if (state is SearchStateError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FetchErrorText(text: state.message),
              ],
            );
          }
          if (products.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: _controller,
                    padding: const EdgeInsets.all(15),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      mainAxisExtent: cardSize,
                    ),
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductCard(productModel: products[index]);
                    },
                  ),
                ),
                // if (state is SearchStateLoadMore)
                //   Container(
                //       padding: const EdgeInsets.symmetric(vertical: 10),
                //       child: const CircularProgressIndicator()),
              ],
            );
          } else {
            return Padding(
              padding: Utils.all(value: 50.0),
              child: EmptyWidget(
                icon: Utils.imageContent(context, 'empty_cart'),
                title: "No Product found",
                isSliver: false,
              ),
            );
          }
        },
      ),
    );
  }
}
