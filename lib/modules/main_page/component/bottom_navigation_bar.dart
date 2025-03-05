import 'package:flutter_svg/flutter_svg.dart';

import '../../../state_packages_names.dart';
import '../../../utils/constants.dart';
import '../../../utils/k_images.dart';
import '../../../utils/language_string.dart';
import '../../animated_splash_screen/controller/translate_cubit/translate_cubit.dart';
import '../../animated_splash_screen/controller/translate_cubit/translate_state_model.dart';
import '../main_controller.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MainController();
    return BlocBuilder<TranslateCubit, TranslateStateModel>(
      builder: (context, state) {
        return SizedBox(
          // height: Platform.isAndroid ?  80 : 100,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: StreamBuilder(
              initialData: 0,
              stream: controller.naveListener.stream,
              builder: (_, AsyncSnapshot<int> index) {
                int selectedIndex = index.data ?? 0;
                return BottomNavigationBar(
                  showUnselectedLabels: true,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedLabelStyle:
                      const TextStyle(fontSize: 14, color: blackColor),
                  unselectedLabelStyle:
                      const TextStyle(fontSize: 14, color: grayColor),
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(Kimages.homeIcon),
                      activeIcon: SvgPicture.asset(Kimages.homeActive),
                      label: state.bottomText['home'] ?? Language.home,
                      tooltip: state.bottomText['home'] ?? Language.home,
                      // label: Language.home.capitalizeByWord(),
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(Kimages.inboxIcon),
                      activeIcon: SvgPicture.asset(Kimages.inboxActive),
                      label: state.bottomText['inbox'] ?? 'Inbox',
                      tooltip: state.bottomText['inbox'] ?? 'Inbox',
                    ),
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(Kimages.orderIcon),
                        activeIcon: SvgPicture.asset(Kimages.orderActive),
                        label: state.bottomText['order'] ?? Language.order,
                        tooltip: state.bottomText['order'] ?? Language.order),
                    BottomNavigationBarItem(
                      activeIcon: SvgPicture.asset(Kimages.profileActive),
                      icon: SvgPicture.asset(Kimages.profileIcon),
                      label: state.bottomText['profile'] ?? Language.profile,
                      tooltip: state.bottomText['profile'] ?? Language.profile,
                    ),
                  ],
                  // type: BottomNavigationBarType.fixed,
                  currentIndex: selectedIndex,
                  onTap: (int index) {
                    controller.naveListener.sink.add(index);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
