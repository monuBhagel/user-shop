import '../../../state_packages_names.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom_text.dart';
import '../../animated_splash_screen/controller/currency/currency_cubit.dart';
import '../../animated_splash_screen/controller/currency/currency_state_model.dart';

class PriceCardWidget extends StatelessWidget {
  const PriceCardWidget(
      {super.key,
      required this.price,
      required this.offerPrice,
      this.textSize = 16.0});

  final String price;
  final double textSize;
  final String offerPrice;

  @override
  Widget build(BuildContext context) {
    if (offerPrice == "0.0") {
      return _buildPrice(context, price);
    }

    return BlocBuilder<CurrencyCubit, CurrencyStateModel>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPrice(context, offerPrice),
            const SizedBox(width: 10),
            Expanded(
              child: CustomText(
                isTranslate: false,
                text: Utils.formatPrice(price, context),
                //Utils.formatPrice(price, context),
                textAlign: TextAlign.left,
                decoration: TextDecoration.lineThrough,
                color: const Color(0xff85959E),
                height: 1.5,
                fontSize: textSize,
                maxLine: 1,
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildPrice(BuildContext context, String price) {
    return BlocBuilder<CurrencyCubit, CurrencyStateModel>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
              isTranslate: false,
              text: Utils.formatPrice(price, context),
              color: redColor,
              height: 1.5,
              fontSize: textSize,
              fontWeight: FontWeight.w600),
        );
      },
    );
  }
}
