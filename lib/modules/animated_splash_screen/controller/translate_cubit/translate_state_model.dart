import 'package:equatable/equatable.dart';

import 'translate_cubit.dart';

class TranslateStateModel extends Equatable {
  final String text;
  final Map<String, String> translations;
  final Map<String, String> bottomText;
  final bool loading;
  final bool isRebuild;
  final String langCode;
  final List<String> translateText;
  final TranslateState tState;

  const TranslateStateModel({
    required this.text,
    required this.translations,
    required this.bottomText,
    required this.tState,
    required this.loading,
    required this.isRebuild,
    required this.translateText,
    required this.langCode,
  });

  TranslateStateModel copyWith({
    String? text,
    Map<String, String>? translations,
    Map<String, String>? bottomText,
    String? langCode,
    List<String>? translateText,
    TranslateState? tState,
    bool? loading,
    bool? isRebuild,
  }) {
    return TranslateStateModel(
      text: text ?? this.text,
      translations: translations ?? this.translations,
      bottomText: bottomText ?? this.bottomText,
      langCode: langCode ?? this.langCode,
      tState: tState ?? this.tState,
      isRebuild: isRebuild ?? this.isRebuild,
      translateText: translateText ?? this.translateText,
      loading: loading ?? this.loading,
    );
  }

  static TranslateStateModel init() {
    return const TranslateStateModel(
      text: '',
      translations: {},
      bottomText: {
        // Language.home: Language.home[0].toUpperCase()+Language.home.substring(1).toLowerCase(),
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
      },
      langCode: '',
      loading: true,
      isRebuild: true,
      translateText: <String>[],
      tState: TranslateInitial(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'text': text};
  }

  @override
  List<Object?> get props =>
      [text, langCode, loading, isRebuild, bottomText, translateText, tState];
}
