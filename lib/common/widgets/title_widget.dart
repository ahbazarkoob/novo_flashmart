import 'package:novo_flashMart/helper/responsive_helper.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import 'package:novo_flashMart/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Function? onTap;
  final String? image;
  const TitleWidget({super.key, required this.title, this.onTap, this.image});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(
        children: [
          Text(title,
              style: figTreeBold.copyWith(
                  fontSize: ResponsiveHelper.isDesktop(context)
                      ? Dimensions.fontSizeLarge
                      : Dimensions.fontSizeLarge)),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          image != null
              ? Image.asset(image!, height: 20, width: 20)
              : const SizedBox(),
        ],
      ),
      (onTap != null)
          ? InkWell(
              onTap: onTap as void Function()?,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                child: Text(
                  'see_all'.tr,
                  style: figTreeMedium.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline),
                ),
              ),
            )
          : const SizedBox(),
    ]);
  }
}
