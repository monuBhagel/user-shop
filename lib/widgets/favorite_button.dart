import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/modules/profile/profile_offer/controllers/wish_list/wish_list_cubit.dart';
import '../modules/profile/profile_offer/model/wish_list_model.dart';
import '../utils/constants.dart';
import '../utils/language_string.dart';
import '../utils/utils.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.productId, this.isBg = true});

  final String productId;
  final bool isBg;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final double height = 30;

  late Set<WishListModel> wishItem;

  @override
  void initState() {
    super.initState();
    wishItem = <WishListModel>{};
    loadWishItems();
  }

  bool isFav = false;

  loadWishItems() {
    final wishListItems = context.read<WishListCubit>().wishList;
    final i = wishListItems
        .where((element) => element.id.toString() == widget.productId)
        .toSet();
    //debugPrint("Wishlist item: $i");
    if (i.isNotEmpty) {
      setState(() {
        isFav = true;
        wishItem = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // bool isFav = false;
    return BlocListener<WishListCubit, WishListState>(
        listener: (context, state) {
      if (state is WishListStateLoading) {
        //Utils.loadingDialog(context);
      } else {
        //Utils.closeDialog(context);
        if (state is WishListStateError) {
          Utils.errorSnackBar(context, state.message);
        } else if (state is WishListStateSuccess) {
          Utils.showSnackBar(context, state.message);
        } else if (state is WishListStateLoaded) {
          wishItem = state.productList
              .where((element) => element.id.toString() == widget.productId)
              .toSet();
        }
      }
    }, child: StatefulBuilder(
      builder: (context, StateSetter setState) {
        return InkWell(
          onTap: () async {
            if (isFav) {
              if (wishItem.isNotEmpty) {
                final r = await context
                    .read<WishListCubit>()
                    .removeWishList(wishItem.first);
                r.fold(
                  (failure) {
                    Utils.showSnackBar(context, failure.message);
                  },
                  (success) {
                    Utils.showSnackBar(context, success);
                  },
                );
              } else {
                Utils.showSnackBar(context, Language.somethingWentWrong);
              }
            } else {
              context.read<WishListCubit>().addWishList(widget.productId);
            }
            setState(() => isFav = !isFav);
          },
          child: Container(
            height: height,
            width: height,
            alignment: Alignment.center,
            // margin: const EdgeInsets.only(top: 10.0, left: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: redColor,
              ),
            ),
          ),
        );
      },
    ));
  }
}

Widget favorite() {
  return Container(
    height: 40.0,
    width: 40.0,
    margin: const EdgeInsets.only(top: 10.0, left: 10.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4.0),
    ),
    child: const Icon(Icons.favorite_outline_sharp, color: primaryColor, size: 28.0),
  );
}

// class FavoriteButton extends StatelessWidget {
//   const FavoriteButton({super.key, required this.productId});
//
//   final String productId;
//   final double height = 30;
//
//   @override
//   Widget build(BuildContext context) {
//     final loginBloc = context.read<LoginBloc>();
//     return BlocConsumer<WishListCubit, WishListModel>(
//       listener: (context, book) {
//         final state = book.wState;
//         if (state is WishListStateError) {
//           Utils.errorSnackBar(context, state.message);
//         } else if (state is WishListStateSuccess) {
//           context.read<WishListCubit>().addSingComId(int.parse(productId));
//           context.read<WishListCubit>().getWishList();
//           Utils.showSnackBar(context, state.message);
//         }
//       },
//       builder: (context, book) {
//         final state = book.wState;
//         final pId = book.tempWishId.contains(int.parse(productId));
//         return GestureDetector(
//           onTap: () async {
//             if (loginBloc.userInfo != null &&
//                 loginBloc.userInfo!.accessToken.isNotEmpty) {
//               if (pId) {
//                 context
//                     .read<WishListCubit>()
//                     .addRemoveClearWishlist(productId, WishType.remove);
//               } else {
//                 context
//                     .read<WishListCubit>()
//                     .addRemoveClearWishlist(productId, WishType.add);
//               }
//             } else {
//               Utils.showSnackBarWithLogin(
//                   context,
//                   'Please login first',
//                       () => Navigator.pushNamed(
//                       context, RouteNames.authenticationScreen));
//             }
//           },
//           child: Container(
//             height: height,
//             width: height,
//             alignment: Alignment.center,
//             // margin: const EdgeInsets.only(top: 10.0, left: 10.0),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(4.0),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(4.0),
//               child: Icon(
//                 pId ? Icons.favorite : Icons.favorite_border,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
