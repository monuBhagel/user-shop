import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translator/translator.dart';

import 'translate_state_model.dart';

part 'translate_state.dart';

class TranslateCubit extends Cubit<TranslateStateModel> {
  TranslateCubit() : super(TranslateStateModel.init());
  final translator = GoogleTranslator();
  String langCode = '';

  Future<void> translated(String text, String code) async {
    if (code == langCode && text.isNotEmpty) {
      return;
    }
    emit(state.copyWith(loading: true));
    try {
      final translation = await translator.translate(text, to: code);
      if (!isClosed) {
        langCode = code;
        emit(state.copyWith(text: translation.text, loading: false));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(text: text, loading: false));
      }
    }
  }

  Future<String> singleText(String text, String code) async {
    if (code == langCode && text.isNotEmpty) {
      return '';
    }
    emit(state.copyWith(loading: true));
    try {
      final translation = await translator.translate(text, to: code);
      langCode = code;

      // final bottomText =  {'home':translation.text,'shop':translation.text,'orders':translation.text,'wallet':translation.text};

      emit(state.copyWith(text: translation.text, loading: false));

      return translation.text;
    } catch (e) {
      emit(state.copyWith(text: text, loading: false));
      return text;
    }
  }

  Future<String> translateBottom(String text, String code, String key) async {
    // if (code == langCode && state.bottomText.containsKey(key)) {
    //   return state.bottomText[key]!;
    // }

    try {
      final translation = await translator.translate(text, to: code);
      langCode = code;
      return translation.text;
    } catch (e) {
      return text;
    }
  }

  void translateNavText(String code) async {
    final keys = {
      // Language.home: Language.home[0].toUpperCase()+Language.home.substring(1),
      'home': 'Home',
      'inbox': 'Inbox',
      'order': 'Order',
      'profile': 'Profile',
      'Promo Code': 'Promo Code',
      'Pending': 'Pending',
      'Progress': 'Progress',
      'Delivered': 'Delivered',
      'Choose your Location': 'Choose your Location',
      'Search Location': 'Search Location',
      'Type Here': 'Type Here',
      'Search Products': 'Search Products',
      'Days': 'Days',
      'Hours': 'Hours',
      'Minutes': 'Minutes',
      'Seconds': 'Seconds',
      'Password': 'Password',
      'Shop Name': 'Shop Name',
      'Phone Number': 'Phone Number',
      'Address': 'Address',
      'Open At': 'Open At',
      'Close At': 'Close At',
      'Email': 'Email',
    };

    Map<String, String> tempTranslated = {};

    for (var entry in keys.entries) {
      final text = await translateBottom(entry.value, code, entry.key);
      tempTranslated[entry.key] = text;
    }

    emit(state.copyWith(bottomText: tempTranslated, loading: false));
  }
}
