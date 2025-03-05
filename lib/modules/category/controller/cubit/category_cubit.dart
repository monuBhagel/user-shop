import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/modules/category/model/category_model.dart';
import '/modules/home/model/brand_model.dart';
import '/modules/product_details/model/active_variant_items_model.dart';

import '/modules/category/controller/repository/category_repository.dart';
import '/modules/category/model/product_categories_model.dart';
import '/modules/home/model/product_model.dart';
import '../../../home/controller/cubit/product/product_state_model.dart';
import '../../../home/model/home_category_model.dart';
import '../../../seller/seller_model.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<ProductStateModel> {
  CategoryCubit(CategoryRepository categoryRepository)
      : _categoryRepository = categoryRepository,
        super(ProductStateModel.init());
  final CategoryRepository _categoryRepository;
  ProductCategoriesModel? productCategoriesModel;
  late SellerProductModel homeSellerModel;
  late List<ProductModel> categoryProducts;
  late List<ProductModel> brandProducts;

  // late List<CategoriesModel> categoryList;
  List<HomePageCategoriesModel> categoryList = [];
  List<ProductModel> catProducts = [];

  void changeTitle(String title) {
    emit(state.copyWith(title: title));
  }

  void addBrand(BrandModel brands) {
    final updatedItem = List.of(state.brands);
    if (state.brands.contains(brands)) {
      // print('removed ${brands.name}');
      updatedItem.remove(brands);
    } else {
      // print('added ${brands.name}');
      updatedItem.add(brands);
    }
    emit(state.copyWith(brands: updatedItem));
  }

  void addVariantItem(ActiveVariantItemModel brands) {
    final updatedItem = List.of(state.variantItems);
    if (state.variantItems.contains(brands)) {
      updatedItem.remove(brands);
    } else {
      updatedItem.add(brands);
    }
    emit(state.copyWith(variantItems: updatedItem));
  }

  void addCategories(CategoriesModel brands) {
    final updatedItem = List.of(state.categories);
    if (state.categories.contains(brands)) {
      updatedItem.remove(brands);
    } else {
      updatedItem.add(brands);
    }
    emit(state.copyWith(categories: updatedItem));
  }

  void minPriceChange(double value) {
    emit(state.copyWith(
        minPrice: value, catState: const CategoryInitialState()));
  }

  void maxPriceChange(double value) {
    emit(state.copyWith(
        maxPrice: value, catState: const CategoryInitialState()));
  }

  Future<void> getCategoryList() async {
    emit(state.copyWith(catState: CategoryLoadingState()));
    final result = await _categoryRepository.getCategoryList();
    result.fold(
      (failure) {
        final error = CategoryErrorState(
            message: failure.message, statusCode: failure.statusCode);
        emit(state.copyWith(catState: error));
      },
      (data) {
        categoryList = data;
        emit(state.copyWith(
            catState: CategoryListLoadedState(categoryListModel: data)));
      },
    );
  }

  Future<void> getCategoryProduct(String slug) async {
    debugPrint('called-getCategoryProduct');
    emit(state.copyWith(catState: CategoryLoadingState()));
    final result =
        await _categoryRepository.getCategoryProducts(slug, state.initialPage);
    result.fold(
      (failure) {
        final errors = CategoryErrorState(
            message: failure.message, statusCode: failure.statusCode);
        emit(state.copyWith(catState: errors));
      },
      (data) {
        if (state.initialPage == 1) {
          productCategoriesModel = data;
          catProducts = data.products;
          final loaded = CategoryLoadedState(categoryProducts: catProducts);
          emit(state.copyWith(catState: loaded));
        } else {
          productCategoriesModel = data;
          catProducts.addAll(data.products);
          final loaded = CategoryMoreLoadedState(categoryProducts: catProducts);
          emit(state.copyWith(catState: loaded));
        }
        state.initialPage++;
        if (data.products.isEmpty && state.initialPage != 1) {
          emit(state.copyWith(isListEmpty: true));
        }
      },
    );
  }

  Future<void> loadCategoryProducts(String slug, int page) async {
    emit(state.copyWith(catState: CategoryLoadingState()));

    final result = await _categoryRepository.getCategoryProducts(slug, page);
    result.fold(
      (failure) {
        emit(state.copyWith(
            catState: CategoryErrorState(
                message: failure.message, statusCode: failure.statusCode)));
      },
      (data) {
        productCategoriesModel = data;
        categoryProducts.addAll(data.products);
        log(productCategoriesModel!.products.length.toString(),
            name: "CategoryCubit");
        emit(state.copyWith(
            catState: CategoryLoadedState(categoryProducts: categoryProducts)));
      },
    );
  }

  Future<void> getFilterProducts() async {
    debugPrint('filter-body ${state.toFilterMap()}');
    emit(state.copyWith(catState: CategoryLoadingState()));

    final result = await _categoryRepository.getFilterProducts(state);
    result.fold(
      (failure) {
        final errors = CategoryErrorState(
            message: failure.message, statusCode: failure.statusCode);
        emit(state.copyWith(catState: errors));
      },
      (data) {
        categoryProducts = data;
        emit(state.copyWith(catState: CategoryLoadedState(categoryProducts: data)));
      },
    );
  }

  Future<void> getBrandProduct(String slug) async {
    emit(state.copyWith(catState: CategoryLoadingState()));

    final result = await _categoryRepository.getBrandProducts(slug);
    result.fold(
      (failure) {
        emit(state.copyWith(
            catState: CategoryErrorState(
                message: failure.message, statusCode: failure.statusCode)));
      },
      (data) {
        brandProducts = data;
        emit(state.copyWith(
            catState: CategoryLoadedState(categoryProducts: data)));
      },
    );
  }

  Future<void> getSellerProduct(String slug) async {
    emit(state.copyWith(catState: CategoryLoadingState()));

    final result = await _categoryRepository.getSellerList(slug);

    result.fold((f) {
      emit(state.copyWith(
          catState: CategoryErrorState(
              message: f.message, statusCode: f.statusCode)));
    }, (sellerData) {
      homeSellerModel = sellerData;
      emit(state.copyWith(
          catState: SellerProductState(sellerModel: sellerData)));
    });
  }

  void initPage() {
    emit(state.copyWith(initialPage: 1, isListEmpty: false));
  }

  void clearFilterData() {
    emit(state.copyWith(
        categories: <CategoriesModel>[],
        brands: <BrandModel>[],
        variantItems: <ActiveVariantItemModel>[]));
  }
}
