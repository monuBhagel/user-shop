import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../models/auth_error_model.dart';
import '../../repository/auth_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpModelState> {
  final AuthRepository repository;

  //final formKey = GlobalKey<FormState>();
  SignUpBloc(this.repository) : super(const SignUpModelState()) {
    on<SignUpEventName>((event, emit) {
      emit(state.copyWith(name: event.name, state: const SignUpStateInitial()));
    });
    on<SignUpEventEmail>((event, emit) {
      emit(state.copyWith(
          email: event.email, state: const SignUpStateInitial()));
    });
    on<SignUpEventPhone>((event, emit) {
      emit(state.copyWith(
          phone: event.phone, state: const SignUpStateInitial()));
    });
    on<SignUpEventCountryCode>((event, emit) {
      emit(state.copyWith(
          countryCode: event.code, state: const SignUpStateInitial()));
    });
    on<SignUpEventPassword>((event, emit) {
      emit(state.copyWith(
          password: event.password, state: const SignUpStateInitial()));
    });
    on<SignUpEventPasswordConfirm>((event, emit) {
      emit(state.copyWith(
          passwordConfirmation: event.passwordConfirm,
          state: const SignUpStateInitial()));
    });
    on<SignUpEventAgree>((event, emit) {
      emit(state.copyWith(
          agree: event.agree, state: const SignUpStateInitial()));
    });

    on<SignUpEventShowPassword>((event, emit) {
      emit(state.copyWith(
          showPassword: !(event.value), state: const SignUpStateInitial()));
    });

    on<SignUpEventShowConPassword>((event, emit) {
      emit(state.copyWith(
          showConPassword: !(event.value), state: const SignUpStateInitial()));
    });

    on<SignUpEventActive>((event, emit) {
      emit(state.copyWith(
          active: !(event.value), state: const SignUpStateInitial()));
    });
    on<SignUpEventSubmit>(_submitForm);
  }

  void _submitForm(
      SignUpEventSubmit event, Emitter<SignUpModelState> emit) async {
    debugPrint('signup-body ${state.toMap()}');
    if (state.agree == 0) {
      const stateError =
          SignUpStateFormError('Please agree terms & condition', 404);
      emit(state.copyWith(state: const SignUpStateInitial()));
      emit(state.copyWith(state: stateError));
      return;
    } else {
      emit(state.copyWith(state: const SignUpStateLoading()));

      final result = await repository.signUp(state.toMap());
      result.fold(
        (failure) {
          if (failure is InvalidAuthData) {
            final errors = SignUpStateFormValidationError(failure.errors);
            emit(state.copyWith(state: errors));
          } else {
            final error =
                SignUpStateFormError(failure.message, failure.statusCode);
            emit(state.copyWith(state: error));
          }
        },
        (user) {
          emit(state.copyWith(state: SignUpStateLoaded(user)));
        },
      );
    }
  }
}
