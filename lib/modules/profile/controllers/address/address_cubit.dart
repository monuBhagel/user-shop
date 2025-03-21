import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '/modules/profile/model/address_model.dart';
import '../../../../core/error/failure.dart';
import '../../../authentication/controller/login/login_bloc.dart';
import '../../../authentication/models/auth_error_model.dart';
import '../../model/billing_shipping_model.dart';
import '../repository/profile_repository.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final ProfileRepository _repository;
  final LoginBloc _loginBloc;

  AddressCubit({
    required ProfileRepository repository,
    required LoginBloc loginBloc,
  })  : _repository = repository,
        _loginBloc = loginBloc,
        super(const AddressStateInitial());

  AddressBook? address;

  TextEditingController addressController = TextEditingController();

  Future<void> addAddress(Map<String, String> dataMap) async {
    emit(const AddressStateUpdating());

    final result =
        await _repository.addAddress(dataMap, _loginBloc.userInfo!.accessToken);

    result.fold(
      (failure) {
        if (failure is InvalidAuthData) {
          emit(AddressStateInvalidDataError(failure.errors));
        } else {
          emit(AddressStateUpdateError(failure.message, failure.statusCode));
        }
      },
      (successData) {
        emit(AddressStateUpdated(successData));
      },
    );
  }

  Future<void> getAddress() async {
    emit(const AddressStateLoading());

    final result =
        await _repository.getAddress(_loginBloc.userInfo!.accessToken);

    result.fold(
      (failure) {
        emit(AddressStateError(failure.message, failure.statusCode));
      },
      (successData) {
        address = successData;
        emit(AddressStateLoaded(successData));
      },
    );
  }

  Future<void> updateAddress(String id, Map<String, String> dataMap) async {
    emit(const AddressStateUpdating());

    final result = await _repository.updateAddress(
        id, dataMap, _loginBloc.userInfo!.accessToken);

    result.fold(
      (failure) {
        if (failure is InvalidAuthData) {
          emit(AddressStateInvalidDataError(failure.errors));
        } else {
          emit(AddressStateUpdateError(failure.message, failure.statusCode));
        }
      },
      (successData) {
        emit(AddressStateUpdated(successData));
      },
    );
  }

  Future<void> billingUpdate(Map<String, String> dataMap) async {
    emit(const AddressStateUpdating());

    final result = await _repository.billingUpdate(
        dataMap, _loginBloc.userInfo!.accessToken);

    result.fold(
      (failure) {
        emit(AddressStateUpdateError(failure.message, failure.statusCode));
      },
      (successData) {
        emit(AddressStateUpdated(successData));
      },
    );
  }

  Future<void> shippingUpdate(Map<String, String> dataMap) async {
    emit(const AddressStateUpdating());

    final result = await _repository.shippingUpdate(
        dataMap, _loginBloc.userInfo!.accessToken);

    result.fold(
      (failure) {
        emit(AddressStateUpdateError(failure.message, failure.statusCode));
      },
      (successData) {
        emit(AddressStateUpdated(successData));
      },
    );
  }

  Future<void> singleAddress(String id) async {
    emit(const AddressStateUpdating());

    final result =
        await _repository.getSingleAddress(id, _loginBloc.userInfo!.accessToken);

    result.fold(
      (failure) {
        emit(AddressStateUpdateError(failure.message, failure.statusCode));
      },
      (successData) {
        emit(BillingAndShippingAddressStateLoaded(successData));
      },
    );
  }

  Future<Either<Failure, String>> deleteSingleAddress(String id) async {
    // emit(const AddressStateUpdating());

    final result =
        await _repository.deleteAddress(id, _loginBloc.userInfo!.accessToken);

    result.fold(
      (failure) {
        // emit(AddressStateError(failure.message, failure.statusCode));
        return false;
      },
      (successData) {
        // emit(AddressDelete(successData));
        return true;
      },
    );
    return result;
  }

  void clearAddress() {
    addressController.clear();
  }
}
