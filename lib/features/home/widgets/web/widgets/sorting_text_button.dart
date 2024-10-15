import 'package:flutter/material.dart';
import 'package:novo_instamart/util/dimensions.dart';
import 'package:novo_instamart/util/styles.dart';

class SortingTextButton extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final bool isSelected;
  const SortingTextButton(
      {super.key, required this.title, this.onTap, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(title,
          style: figTreeMedium.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor)),
    );
  }
}
