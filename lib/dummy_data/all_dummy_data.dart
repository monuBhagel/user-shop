import 'package:equatable/equatable.dart';

import '/utils/language_string.dart';
import '/widgets/capitalized_word.dart';
import '../modules/message/model_dummy/chat_list_model.dart';
import '../modules/message/model_dummy/message_model.dart';
import '../modules/notification/model/notification_model.dart';

class IdentityType extends Equatable {
  final int id;
  final String title;

  const IdentityType({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];
}

final List<IdentityType> identityType = [
  const IdentityType(id: 1, title: 'Passport'),
  const IdentityType(id: 2, title: 'Driving License'),
  const IdentityType(id: 3, title: 'Nid'),
];

final List<IdentityType> manType = [
  const IdentityType(id: 1, title: 'Freelancer'),
  const IdentityType(id: 2, title: 'Salary Based'),
];

final addressType = [
  Language.billingAddress.capitalizeByWord(),
  Language.shippingAddress.capitalizeByWord()
];
final dropDownItem = [
  Language.california.capitalizeByWord(),
  Language.victoria.capitalizeByWord(),
  Language.toronto.capitalizeByWord(),
];

final notificationList = [
  NotificationModel(
      id: 0,
      text: '50% OFF in Ultraboost All Terrain ltd Shoes!!',
      time: '9:35AM',
      image: 'https://picsum.photos/50/50'),
  NotificationModel(
      id: 1,
      text: 'New amagizing collection for our Topcommres',
      time: '6:35AM',
      image: 'https://picsum.photos/50/50'),
  NotificationModel(
      id: 2,
      text: 'Your get amazing gift for Shop Bulli.',
      time: '4:35AM',
      image: 'https://picsum.photos/50/50'),
  NotificationModel(
      id: 3,
      text: '33% OFF in Ultraboost All Terrain ltd Shoes!!',
      time: '2:35AM',
      image: 'https://picsum.photos/50/50'),
  NotificationModel(
      id: 4,
      text: 'Free ! in bike cover in R15 V3 BS6 !!',
      time: '11:35AM',
      image: 'https://picsum.photos/50/50'),
  NotificationModel(
      id: 3,
      text: '33% OFF in Ultraboost All Terrain ltd Shoes!!',
      time: '2:35AM',
      image: 'https://picsum.photos/50/50'),
  NotificationModel(
      id: 4,
      text: 'Free ! in bike cover in R15 V3 BS6 !!',
      time: '11:35AM',
      image: 'https://picsum.photos/50/50'),
  NotificationModel(
      id: 3,
      text: '33% OFF in Ultraboost All Terrain ltd Shoes!!',
      time: '2:35AM',
      image: 'https://picsum.photos/50/50'),
  NotificationModel(
      id: 4,
      text: 'Free ! in bike cover in R15 V3 BS6 !!',
      time: '11:35AM',
      image: 'https://picsum.photos/50/50'),
];
final chatMessageList = [
  MessageModel(
    id: 0,
    dateTime: DateTime.now(),
    isMe: true,
    text: 'Sound null safety support!',
  ),
  MessageModel(
    id: 1,
    dateTime: DateTime.now(),
    isMe: true,
    text: 'Add the package to your pubspec.yaml',
  ),
  MessageModel(
    id: 2,
    dateTime: DateTime.now(),
    isMe: true,
    text: 'Almost all fields from ListView.builder available.',
  ),
  MessageModel(
    id: 3,
    dateTime: DateTime.now(),
    isMe: true,
    text: 'Sound null safety support!',
  ),
  MessageModel(
    id: 4,
    dateTime: DateTime.now(),
    isMe: true,
    text: 'For the groups an individual header can be set.',
  ),
  MessageModel(
    id: 5,
    dateTime: DateTime.now(),
    isMe: false,
    text: 'List Items can be separated in groups.',
  ),
  MessageModel(
    id: 6,
    dateTime: DateTime.now().subtract(const Duration(days: 3)),
    isMe: true,
    text: 'Sound null safety support!',
  ),
  MessageModel(
    id: 7,
    dateTime: DateTime.now().subtract(const Duration(days: 4)),
    isMe: false,
    text: 'Easy creation of chat dialog.',
  ),
  MessageModel(
    id: 4,
    dateTime: DateTime.now().subtract(const Duration(days: 1)),
    isMe: false,
    text: 'For the groups an individual header can be set.',
  ),
  MessageModel(
    id: 5,
    dateTime: DateTime.now(),
    isMe: false,
    text: 'List Items can be separated in groups.',
  ),
  MessageModel(
    id: 6,
    dateTime: DateTime.now().subtract(const Duration(days: 3)),
    isMe: true,
    text: 'Sound null safety support!',
  ),
  MessageModel(
    id: 7,
    dateTime: DateTime.now().subtract(const Duration(days: 4)),
    isMe: false,
    text: 'Easy creation of chat dialog.',
  ),
];

final chatList = [
  ChatListModel(
      id: 0,
      image: '',
      msg: 'What is the size the',
      name: 'Harry Potter Film',
      dateTime: '10:00',
      numberOfMsg: '3'),
  ChatListModel(
      id: 1,
      image: '',
      msg: 'What is the size the',
      name: 'Harry Potter Film',
      dateTime: '10:01',
      numberOfMsg: '1'),
  ChatListModel(
      id: 2,
      image: '',
      msg: 'Nike',
      name: 'This is going to cost Potter Film',
      dateTime: '10:03',
      numberOfMsg: ''),
];

class DemoCurrencies extends Equatable {
  final int id;
  final String currencyName;
  final String countryCode;
  final String currencyCode;
  final String currencyIcon;
  final String isDefault;
  final double currencyRate;
  final String currencyPosition;
  final int status;

  const DemoCurrencies({
    required this.id,
    required this.currencyName,
    required this.countryCode,
    required this.currencyCode,
    required this.currencyIcon,
    required this.isDefault,
    required this.currencyRate,
    required this.currencyPosition,
    required this.status,
  });

  @override
  List<Object> get props {
    return [
      id,
      currencyName,
      countryCode,
      currencyCode,
      currencyIcon,
      isDefault,
      currencyRate,
      currencyPosition,
      status,
    ];
  }
}

final List<DemoCurrencies> demoCurrencies = [
  const DemoCurrencies(
    id: 1,
    currencyName: '\$-USD',
    currencyCode: 'USD',
    countryCode: 'USD',
    currencyIcon: '\$',
    isDefault: 'Yes',
    currencyPosition: 'left',
    status: 0,
    currencyRate: 1.0,
  ),
  const DemoCurrencies(
    id: 2,
    currencyName: '€-Euro',
    currencyCode: 'EUR',
    countryCode: 'EU',
    currencyIcon: '€',
    isDefault: 'No',
    currencyPosition: 'right',
    status: 1,
    currencyRate: 0.93,
  ),
  const DemoCurrencies(
    id: 3,
    currencyName: '£-GBP',
    currencyCode: 'GBP',
    countryCode: 'GB',
    currencyIcon: '£',
    isDefault: 'No',
    currencyPosition: 'left',
    status: 1,
    currencyRate: 0.74,
  ),
  const DemoCurrencies(
    id: 4,
    currencyName: '¥-Yen',
    currencyCode: 'JPY',
    countryCode: 'JP',
    currencyIcon: '¥',
    isDefault: 'No',
    currencyPosition: 'right',
    status: 1,
    currencyRate: 110.0,
  ),
  const DemoCurrencies(
    id: 5,
    currencyName: '₹-INR',
    currencyCode: 'INR',
    countryCode: 'IN',
    currencyIcon: '₹',
    isDefault: 'No',
    currencyPosition: 'left',
    status: 1,
    currencyRate: 73.5,
  ),
  const DemoCurrencies(
    id: 6,
    currencyName: '₽-RUB',
    currencyCode: 'RUB',
    countryCode: 'RU',
    currencyIcon: '₽',
    isDefault: 'No',
    currencyPosition: 'right',
    status: 1,
    currencyRate: 73.5,
  ),
  const DemoCurrencies(
    id: 7,
    currencyName: '฿-Baht',
    currencyCode: 'THB',
    countryCode: 'TH',
    currencyIcon: '฿',
    isDefault: 'No',
    currencyPosition: 'left',
    status: 1,
    currencyRate: 32.8,
  ),
  const DemoCurrencies(
    id: 11,
    currencyName: '৳-BDT',
    currencyCode: 'BDT',
    countryCode: 'BD',
    currencyIcon: '৳',
    isDefault: 'No',
    currencyPosition: 'right',
    status: 1,
    currencyRate: 109.76,
  ),
];
