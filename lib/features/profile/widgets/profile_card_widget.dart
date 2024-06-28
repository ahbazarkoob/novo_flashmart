import 'package:novo_flashMart/helper/responsive_helper.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import 'package:novo_flashMart/util/styles.dart';
import 'package:flutter/material.dart';

class ProfileCardWidget extends StatelessWidget {
  final String image;
  final String title;
  final String data;
  const ProfileCardWidget(
      {super.key,
      required this.data,
      required this.title,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveHelper.isDesktop(context) ? 130 : 112,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).primaryColor, width: 0.1),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1)
        ],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(image, height: 30, width: 30),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Text(
          data,
          textDirection: TextDirection.ltr,
          style: figTreeMedium.copyWith(
              fontSize: ResponsiveHelper.isDesktop(context)
                  ? Dimensions.fontSizeDefault
                  : Dimensions.fontSizeExtraLarge),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Text(title,
            style: figTreeRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
              color: Theme.of(context).disabledColor,
            )),
      ]),
    );
  }
}
