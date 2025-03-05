
import '../../../widgets/custom_text.dart';
import '/modules/cart/model/shipping_response_model.dart';
import '../../../state_packages_names.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';

class ShippingMethodList extends StatefulWidget {
  const ShippingMethodList(
      {super.key, required this.shippingMethods, required this.onChange});

  final List<ShippingResponseModel> shippingMethods;

  final ValueChanged<int> onChange;

  @override
  State<ShippingMethodList> createState() => _ShippingMethodListState();
}

class _ShippingMethodListState extends State<ShippingMethodList> {
  ShippingResponseModel? shippingMethodModel;

  @override
  void initState() {
    super.initState();
    if (widget.shippingMethods.isNotEmpty) {
      shippingMethodModel = widget.shippingMethods.first;

      widget.onChange(shippingMethodModel!.id);
    }
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Utils.symmetric(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const CustomText(
              text: "Shipping charge",
              fontSize: 16,
              fontWeight: FontWeight.w600),
          const SizedBox(height: 10),
          ...widget.shippingMethods.map(
            (e) {
              final isSelected = e == shippingMethodModel;
              return Container(
                margin: Utils.only(bottom: 8.0),
                decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: Utils.borderRadius(r: 12.0),
                    border: Border.all(
                        color: isSelected ? greenColor : transparent),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0.0, 0.0),
                        spreadRadius: 0.0,
                        blurRadius: 0.0,
                        // color: whiteColor
                        color: const Color(0xFF000000).withOpacity(0.4),
                      ),
                    ]),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: Utils.borderRadius(r: 12.0)),
                  onTap: () {
                    // debugPrint('${shippingMethodModel!.id}');
                    setState(() {
                      shippingMethodModel = e;
                      widget.onChange(e.id);
                    });
                  },
                  horizontalTitleGap: 0,
                  title: CustomText(
                      text:
                          "Fee: ${Utils.formatPrice(e.shippingFee, context)}"),
                  //subtitle: Text(e.shippingRule),
                  subtitle: CustomText(text: Utils.shippingType(e.type)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
