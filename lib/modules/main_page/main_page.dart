import 'package:flutter/services.dart';

import '/state_packages_names.dart';
import '../../utils/k_images.dart';
import '../../widgets/confirm_dialog.dart';
import '../home/home_screen.dart';
import '../message/chat_list/chat_list_screen.dart';
import '../order/order_screen.dart';
import '../profile/profile_screen.dart';
import 'component/bottom_navigation_bar.dart';
import 'main_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _homeController = MainController();

  late List<Widget> pageList;

  @override
  void initState() {
    super.initState();

    pageList = [
      const HomeScreen(),
      const ChatListScreen(),
      const OrderScreen(),
      const ProfileScreen(),
    ];

    context.read<CountryStateByIdCubit>().countryListLoaded();
    context.read<UserProfileInfoCubit>().getUserProfileInfo();
    context.read<CartCubit>().getCartProducts();
    context.read<ChatBloc>().add(const ChatStarted());
  }


  @override
  Widget build(BuildContext context) {
    // context.read<CartCubit>().getCartProducts();
    // context.read<WishListCubit>().getWishList();
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => ConfirmDialog(
            icon: Kimages.logout2,
            message: 'Are you sure, you\nwant to EXIT?',
            confirmText: 'Yes, Exit',
            onTap: () => SystemNavigator.pop(),
          ),
        );
        return true;
      },
      child: Scaffold(
        extendBody: true,
        // key: _homeController.scaffoldKey,
        // drawer: const DrawerWidget(),
        body: StreamBuilder<int>(
          initialData: 0,
          stream: _homeController.naveListener.stream,
          builder: (context, AsyncSnapshot<int> snapshot) {
            int index = snapshot.data ?? 0;
            if (index == 1) {
              context.read<OrderCubit>().changeCurrentIndex(0);
            }
            return pageList[index];
          },
        ),
        bottomNavigationBar: const MyBottomNavigationBar(),
      ),
    );
  }
}
