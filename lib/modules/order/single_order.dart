import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/router_name.dart';
import '../../utils/constants.dart';
import '../../utils/language_string.dart';
import '../../utils/utils.dart';
import '../../widgets/capitalized_word.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/fetch_error_text.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/please_signin_widget.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/rounded_app_bar.dart';
import '../home/controller/cubit/product/product_state_model.dart';
import '../profile/controllers/map/map_cubit.dart';
import 'component/ordered_list_component.dart';
import 'component/single_order_details_component.dart';
import 'controllers/order/order_cubit.dart';
import 'model/order_model.dart';

class SingleOrderDetails extends StatefulWidget {
  const SingleOrderDetails({super.key, this.trackNumber});

  final String? trackNumber;

  @override
  State<SingleOrderDetails> createState() => _SingleOrderDetailsState();
}

class _SingleOrderDetailsState extends State<SingleOrderDetails> {
  late OrderCubit oCubit;

  @override
  void initState() {
    oCubit = context.read<OrderCubit>();
    super.initState();
    Future.microtask(() => oCubit.showOrderTracking(widget.trackNumber!));
  }

  @override
  Widget build(BuildContext context) {
    // print('tracking-number ${widget.trackNumber}');
    // final oCubit = context.read<OrderCubit>();
    return Scaffold(
      backgroundColor: scaBgColor,
      appBar: RoundedAppBar(titleText: Language.singleOrder.capitalizeByWord()),
      body: BlocConsumer<OrderCubit, ProductStateModel>(
        listener: (context, order) {
          final state = order.orderState;
          if (state is OrderStateError) {
            if (state.statusCode == 503 || oCubit.singleOrder == null) {
              oCubit.showOrderTracking(widget.trackNumber!);
            }
          }
        },
        builder: (context, order) {
          final state = order.orderState;
          if (state is OrderStateLoading) {
            return const LoadingWidget();
          } else if (state is OrderStateError) {
            if (state.statusCode == 503 || oCubit.singleOrder != null) {
              return LoadedList(singleOrder: oCubit.singleOrder!);
            }
            if (state.statusCode == 401) {
              return const PleaseSigninWidget();
            }
            return FetchErrorText(text: state.message);
          } else if (state is OrderSingleStateLoaded) {
            return LoadedList(singleOrder: state.singleOrder);
          }

          if (oCubit.singleOrder != null) {
            return LoadedList(singleOrder: oCubit.singleOrder!);
          } else {
            return const FetchErrorText(text: 'Something went wrong!');
          }
        },
      ),
    );
  }
}

List<StepperData> _steppers(BuildContext context) => [
  StepperData(
    title: StepperText(Utils.formText(context, 'Pending')),
  ),
  StepperData(
    title: StepperText(Utils.formText(context, 'Progress')),
  ),
  StepperData(
    title: StepperText(Utils.formText(context, 'Delivered')),
  ),
];

class LoadedList extends StatelessWidget {
  const LoadedList({super.key, required this.singleOrder});

  final OrderModel? singleOrder;

  @override
  Widget build(BuildContext context) {
    int getTrackingIndex(int status) {
      if (status == 1) {
        return 1;
      } else if (status == 2 || status == 3) {
        return 2;
      }
      return 0;
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
                color: const Color(0xFFCBECFF),
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnotherStepper(
                  stepperList: _steppers(context),
                  stepperDirection: Axis.horizontal,
                  verticalGap: 60.0,
                  activeIndex: getTrackingIndex(singleOrder!.orderStatus),
                  activeBarColor: blackColor,
                  inActiveBarColor: primaryColor,
                  barThickness: 6.0,
                ),
                SizedBox(height: singleOrder!.orderStatus == 4 ? 10.0 : 10.0),
                Visibility(
                  visible: singleOrder!.orderStatus == 4,
                  child: const CustomText(
                      text: 'Order is Declined',
                      color: redColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: Utils.borderRadius(r: 12.0),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0.0, 0.0),
                      spreadRadius: 0.0,
                      blurRadius: 0.0,
                      // color: whiteColor
                      color: const Color(0xFF000000).withOpacity(0.4)),
                ]),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomText(
                      text: Utils.formatDate(
                          singleOrder?.createdAt ?? '11/10/2024'),
                      textAlign: TextAlign.end,
                      color: const Color(0xff85959E)),
                ),
                ...List.generate(
                  singleOrder!.orderProducts.length,
                  (index) => Column(
                    children: [
                      SingleOrderDetailsComponent(
                        orderItem: singleOrder!.orderProducts[index],
                        isOrdered: true,
                      ),
                      Divider(color: grayColor.withOpacity(0.2)),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                OrderText(
                  title: Language.orderNumber.capitalizeByWord(),
                  text: singleOrder!.id.toString(),
                  isUnderline: true,
                ),
                const SizedBox(height: 8.0),
                OrderText(
                  title: 'Order tracking number',
                  text: singleOrder!.orderId,
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                      text: Utils.orderStatus("${singleOrder?.orderStatus}"),
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: "${singleOrder!.orderStatus}" == '4'
                          ? redColor
                          : greenColor),
                )
              ],
            ),
          ),
        ),
        if (Utils.isMapEnable(context) == true &&
            singleOrder?.orderStatus == 2 &&
            singleOrder?.delivery?.latitude != 0.0 &&
            singleOrder?.delivery?.longitude != 0.0) ...[
          SliverPadding(
            padding: Utils.symmetric(v: 40.0),
            sliver: SliverToBoxAdapter(
              child: PrimaryButton(
                onPressed: () {
                  final mapCubit = context.read<MapCubit>();
                  mapCubit
                    ..deliveryIdStore(singleOrder!.orderId)
                    ..addLatitude(singleOrder!.latitude)
                    ..addLongitude(singleOrder!.longitude)
                    ..addDLatitude(singleOrder!.delivery!.latitude)
                    ..addDLongitude(singleOrder!.delivery!.longitude);
                  debugPrint('id ${mapCubit.state.deliveryId}');
                  debugPrint(
                      'user-lat ${mapCubit.state.latitude} | ${mapCubit.state.longitude}');
                  debugPrint(
                      'del-lat ${mapCubit.state.dLatitude} | ${mapCubit.state.dLongitude}');
                  Navigator.pushNamed(
                      context, RouteNames.trackingLocationScreen);
                },
                text: 'Track Location',
                bgColor: greenColor,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class OrderText extends StatelessWidget {
  const OrderText({super.key, this.title, this.text, this.isUnderline = false});

  final String? title;
  final String? text;
  final bool isUnderline;

  @override
  Widget build(BuildContext context) {
    return OrderItem(title: "$title:", value: text ?? '');
  }
}
