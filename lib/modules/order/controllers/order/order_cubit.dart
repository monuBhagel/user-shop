import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/controller/login/login_bloc.dart';
import '../../../home/controller/cubit/product/product_state_model.dart';
import '../../model/order_model.dart';
import '../repository/order_repository.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<ProductStateModel> {
  final LoginBloc _loginBloc;
  final OrderRepository _orderRepository;

  OrderCubit({
    required LoginBloc loginBloc,
    required OrderRepository orderRepository,
  })  : _loginBloc = loginBloc,
        _orderRepository = orderRepository,
        super(ProductStateModel());

  List<OrderModel> orderList = [];
  OrderModel? singleOrder;

  void changeCurrentIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  Future<void> getOrderList() async {
    if (_loginBloc.userInfo == null) {
      emit(state.copyWith(
          orderState: const OrderStateError('Sign-In please', 401)));
      return;
    } else {
      emit(state.copyWith(orderState: const OrderStateLoading()));
      final result = await _orderRepository.orderList(
          state.initialPage.toString(), _loginBloc.userInfo!.accessToken);
      result.fold(
        (failure) {
          final errors = OrderStateError(failure.message, failure.statusCode);
          emit(state.copyWith(orderState: errors));
        },
        (data) {
          if (state.initialPage == 1) {
            orderList = data;
            final loaded = OrderStateLoaded(orderList);
            emit(state.copyWith(orderState: loaded));
          } else {
            orderList.addAll(data);
            final loaded = OrderStateMoreLoaded(orderList);
            emit(state.copyWith(orderState: loaded));
          }
          state.initialPage++;
          if (data.isEmpty && state.initialPage != 1) {
            emit(state.copyWith(isListEmpty: true));
          }
          countOrder();
        },
      );
    }
  }

  Future<void> showOrderTracking(String trackNumber) async {
    if (_loginBloc.userInfo == null) {
      emit(state.copyWith(
          orderState: const OrderStateError('Sign-In please', 401)));
      return;
    }
    emit(state.copyWith(orderState: const OrderStateLoading()));
    final result = await _orderRepository.showOrderTracking(
        trackNumber, _loginBloc.userInfo!.accessToken);
    result.fold(
      (failure) {
        final error = OrderStateError(failure.message, failure.statusCode);
        emit(state.copyWith(orderState: error));
      },
      (data) {
        singleOrder = data;
        final loadedState = OrderSingleStateLoaded(data);
        emit(state.copyWith(orderState: loadedState));
      },
    );
  }

  List<OrderModel> pending = [];
  List<OrderModel> progress = [];
  List<OrderModel> delivered = [];
  List<OrderModel> completed = [];
  List<OrderModel> declined = [];

  void countOrder() {
    if (orderList.isNotEmpty) {
      pending.clear();
      progress.clear();
      delivered.clear();
      completed.clear();
      declined.clear();
      for (int i = 0; i < orderList.length; i++) {
        final booking = orderList[i];
        if (booking.orderStatus == 0) {
          pending.add(booking);
        } else if (booking.orderStatus == 1) {
          progress.add(booking);
        } else if (booking.orderStatus == 2) {
          delivered.add(booking);
        } else if (booking.orderStatus == 3) {
          completed.add(booking);
        } else if (booking.orderStatus == 4) {
          declined.add(booking);
        }
      }
    }
  }

  void initPage({bool isPaginate = true}) {
    if (isPaginate) {
      emit(state.copyWith(initialPage: 1, isListEmpty: false));
    } else {
      emit(state.copyWith(initialPage: 1, orderState: const OrderStateInitial()));
    }
  }
}
