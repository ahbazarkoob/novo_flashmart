import 'package:flutter/material.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import 'package:novo_flashMart/util/styles.dart';
import 'package:novo_flashMart/common/widgets/custom_image.dart';

class LandingCardWidget extends StatelessWidget {
  final String icon;
  final String title;
  const LandingCardWidget({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).primaryColor.withOpacity(0.05),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CustomImage(
          image: icon,
          height: 45,
          width: 45,
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        Text(title,
            style: figTreeRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
            textAlign: TextAlign.center),
      ]),
    );
  }
}
