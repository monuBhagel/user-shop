import 'package:flutter/material.dart';

import 'component/signle_review_card_component.dart';
import 'model/details_product_reviews_model.dart';

class SeelAllReviewsScreen extends StatelessWidget {
  const SeelAllReviewsScreen({
    super.key,
    required this.productReviews,
  });

  final List<DetailsProductReviewModel> productReviews;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View all review')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          return SingleReviewCardComponent(productReviews[index]);
        },
        itemCount: productReviews.length,
      ),
    );
  }
}
