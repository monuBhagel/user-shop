import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:shop_o/modules/category/model/category_model.dart';
import 'package:shop_o/modules/product_details/model/active_variant_items_model.dart';

import '../../../../category/controller/cubit/category_cubit.dart';
import '../../../../order/controllers/order/order_cubit.dart';
import '../../../model/brand_model.dart';
import 'products_state.dart';

// ignore: must_be_immutable
class ProductStateModel extends Equatable {
  final int id;
  final int providerId;
  final String name;
  final String phone;
  final String gender;
  final String title;
  final String slug;
  int initialPage;
  int currentIndex;
  bool isListEmpty;
  List<BrandModel> brands;
  List<ActiveVariantItemModel> variantItems;
  List<CategoriesModel> categories;
  final double minPrice;
  final double maxPrice;
  final ProductsState productState;
  final OrderState orderState;
  final CategoryState catState;

  ProductStateModel({
    this.id = 0,
    this.providerId = 0,
    this.name = '',
    this.phone = '',
    this.gender = '',
    this.title = '',
    this.slug = '',
    this.initialPage = 1,
    this.currentIndex = 0,
    this.minPrice = 0.0,
    this.maxPrice = 0.0,
    this.isListEmpty = false,
    this.brands = const <BrandModel>[],
    this.variantItems = const <ActiveVariantItemModel>[],
    this.categories = const <CategoriesModel>[],
    this.productState = const ProductsInitial(),
    this.orderState = const OrderStateInitial(),
    this.catState = const CategoryInitialState(),
  });

  ProductStateModel copyWith({
    int? id,
    int? providerId,
    int? initialPage,
    int? currentIndex,
    String? name,
    String? phone,
    String? gender,
    String? title,
    String? slug,
    double? minPrice,
    double? maxPrice,
    bool? isListEmpty,
    List<BrandModel>? brands,
    List<ActiveVariantItemModel>? variantItems,
    List<CategoriesModel>? categories,
    ProductsState? productState,
    OrderState? orderState,
    CategoryState? catState,
  }) {
    return ProductStateModel(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      productState: productState ?? this.productState,
      orderState: orderState ?? this.orderState,
      catState: catState ?? this.catState,
      initialPage: initialPage ?? this.initialPage,
      currentIndex: currentIndex ?? this.currentIndex,
      isListEmpty: isListEmpty ?? this.isListEmpty,
      brands: brands ?? this.brands,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      variantItems: variantItems ?? this.variantItems,
      categories: categories ?? this.categories,
      title: title ?? this.title,
      slug: slug ?? this.slug,
    );
  }

  Map<String, String> toMap() {
    return <String, String>{
      'id': id.toString(),
      'provider_id': providerId.toString(),
      'name': name,
      'phone': phone,
      'gender': gender.toLowerCase(),
      'created_at': title,
      'updated_at': slug,
    };
  }

  Map<String, dynamic> toFilterMap() {
    final result = <String, String>{};
    brands.toList().asMap().forEach((k, element) {
      if (element.id != -1) {
        result.addAll({'brands[]': element.id.toString()});
      }
    });

    categories.toList().asMap().forEach((k, element) {
      if (element.id != -1) {
        result.addAll({'categories[]': element.id.toString()});
      }
    });
    variantItems.toList().asMap().forEach((k, element) {
      if (element.name.isNotEmpty) {
        result.addAll({'variantItems[]': element.name});
      }
    });

    result.addAll({'min_price': minPrice.toString()});
    result.addAll({'max_price': maxPrice.toString()});
    // result.addAll({'page': page.isEmpty ? '1' : page});

    return result;
  }

  factory ProductStateModel.fromMap(Map<String, dynamic> map) {
    return ProductStateModel(
      id: map['id'] ?? 0,
      providerId: map['provider_id'] != null
          ? int.parse(map['provider_id'].toString())
          : 0,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      gender: map['gender'] ?? '',
      title: map['created_at'] ?? '',
      slug: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductStateModel.fromJson(String source) =>
      ProductStateModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  static ProductStateModel init() {
    return ProductStateModel(
      id: 0,
      providerId: 0,
      name: '',
      phone: '',
      gender: 'Male',
      title: '',
      slug: '',
      initialPage: 1,
      currentIndex: 0,
      minPrice: 0.0,
      maxPrice: 0.0,
      isListEmpty: false,
      brands: const <BrandModel>[],
      variantItems: const <ActiveVariantItemModel>[],
      categories: const <CategoriesModel>[],
      productState: const ProductsInitial(),
      orderState: const OrderStateInitial(),
      catState: const CategoryInitialState(),
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      providerId,
      name,
      phone,
      gender,
      initialPage,
      currentIndex,
      isListEmpty,
      brands,
      variantItems,
      categories,
      productState,
      orderState,
      minPrice,
      maxPrice,
      catState,
      title,
      slug,
    ];
  }
}
