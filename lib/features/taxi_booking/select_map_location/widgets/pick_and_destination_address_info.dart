import 'package:flutter/material.dart';
import 'package:novo_instamart/util/dimensions.dart';
import 'package:novo_instamart/util/styles.dart';

class RideAddressInfo extends StatelessWidget {
  final String? title;
  final String subTitle;
  final bool isInsideCity;

  const RideAddressInfo(
      {super.key,
      required this.title,
      required this.isInsideCity,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title!,
            style: figTreeMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        Text(subTitle,
            style: figTreeRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall))
      ],
    );
  }
}
