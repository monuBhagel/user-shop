import 'package:flutter/material.dart';

import '../utils/utils.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Utils.dynamicPrimaryColor(context);
    return Center(
      child: CircularProgressIndicator(color: c),
    );
  }
}
