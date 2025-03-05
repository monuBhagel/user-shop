import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/custom_text.dart';
import '/utils/language_string.dart';
import '/widgets/page_refresh.dart';
import '../../core/router_name.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widgets/fetch_error_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/please_signin_widget.dart';
import '../home/controller/cubit/product/product_state_model.dart';
import 'component/bottom_tab.dart';
import 'component/empty_order_component.dart';
import 'component/ordered_list_component.dart';
import 'controllers/order/order_cubit.dart';
import 'controllers/order_tracking/order_tracking_cubit.dart';
import 'model/order_model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late OrderCubit orderCubit;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  final _scrollController = ScrollController();

  @override
  void dispose() {
    if (orderCubit.state.initialPage > 1) {
      orderCubit.initPage();
    }
    _scrollController.dispose();
    super.dispose();
  }

  _initState() {
    orderCubit = context.read<OrderCubit>();
    Future.microtask(() {
      orderCubit.getOrderList();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // final maxScroll = _scrollController.position.maxScrollExtent;
    // final currentScroll = _scrollController.position.pixels;

    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0.0) {
        if (orderCubit.state.isListEmpty == false) {
          orderCubit.getOrderList();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderList = context.read<OrderCubit>();
    // print('order-length ${orderList.orderList.length}');
    return Scaffold(
      body: PageRefresh(
        onRefresh: () async {
          //if (orderCubit.state.initialPage > 1) {
          orderCubit.initPage();
          //}
          orderCubit.getOrderList();
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<OrderTrackingCubit, OrderTrackingState>(
              listener: (context, state) {
                if (state is OrderStateTrackingLoading) {
                  Utils.loadingDialog(context);
                } else {
                  Utils.closeDialog(context);
                  if (state is OrderTrackingStateError) {
                    Utils.errorSnackBar(context, state.message);
                  } else if (state is OrderStateTrackingLoaded) {
                    Navigator.pushNamed(
                      context,
                      RouteNames.orderTrackingScreen,
                      arguments: state.singleOrder,
                    );
                  }
                }
              },
            ),
            BlocListener<OrderCubit, ProductStateModel>(
              listener: (context, productState) {
                final state = productState.orderState;
                if (state is OrderStateError) {
                  if (state.statusCode == 401) {
                    //Utils.logoutFunction(context);
                  } else if (state.statusCode == 503) {
                    orderList.getOrderList();
                  }
                }
                if (state is OrderStateLoading &&
                    orderCubit.state.initialPage != 1) {
                  Utils.loadingDialog(context);
                } else if (state is OrderStateMoreLoaded) {
                  Utils.closeDialog(context);
                }
              },
            ),
          ],
          child: BlocBuilder<OrderCubit, ProductStateModel>(
            builder: (context, productState) {
              final state = productState.orderState;
              if (state is OrderStateLoading &&
                  orderCubit.state.initialPage == 1) {
                return const LoadingWidget(color: greenColor);
              } else if (state is OrderStateError) {
                if (state.statusCode == 503) {
                  return OrderLoadedWidget(
                      orderedList: orderList.orderList,
                      controller: _scrollController);
                } else if (state.statusCode == 401) {
                  return const PleaseSigninWidget();
                } else {
                  return FetchErrorText(text: state.message);
                }
              } else if (state is OrderStateLoaded) {
                return OrderLoadedWidget(
                    orderedList: state.orderList,
                    controller: _scrollController);
              } else if (state is OrderStateMoreLoaded) {
                return OrderLoadedWidget(
                    orderedList: state.orderList,
                    controller: _scrollController);
              }

              if (orderList.orderList.isNotEmpty) {
                return OrderLoadedWidget(
                    orderedList: orderList.orderList,
                    controller: _scrollController);
              } else {
                if (orderList.orderList.isEmpty) {
                  return const LoadingWidget(color: greenColor);
                } else {
                  return const FetchErrorText(text: 'Something went wrong');
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

class OrderLoadedWidget extends StatelessWidget {
  final List<OrderModel> orderedList;
  final ScrollController controller;

  const OrderLoadedWidget(
      {super.key, required this.orderedList, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bookingCubit = context.read<OrderCubit>();
    List<List<OrderModel>> filteredList = [
      bookingCubit.orderList,
      bookingCubit.pending,
      bookingCubit.progress,
      bookingCubit.delivered,
      bookingCubit.completed,
      bookingCubit.declined,
    ];
    final routeName = ModalRoute.of(context)?.settings.name ?? '';
    return CustomScrollView(
      controller: controller,
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: scaBgColor,
          titleSpacing: routeName != RouteNames.mainPage ? 0 : null,
          automaticallyImplyLeading: routeName != RouteNames.mainPage,
          toolbarHeight: 80.0,
          centerTitle: true,
          title: CustomText(text:
            Language.order,
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
            color: blackColor,
          ),
          bottom:  const BottomTab(),
        ),
        if (filteredList[bookingCubit.state.currentIndex].isNotEmpty) ...[
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = filteredList[bookingCubit.state.currentIndex][index];
              return OrderedListComponent(orderedItem: item);
            },
                childCount: filteredList[bookingCubit.state.currentIndex]
                    .length //orders.length,
                ),
          )
        ] else ...[
          const SliverToBoxAdapter(child: EmptyOrderComponent()),
        ],
        routeName == RouteNames.mainPage
            ? const SliverToBoxAdapter(child: SizedBox(height: 80.0))
            : const SliverToBoxAdapter(),
      ],
    );
  }
}
