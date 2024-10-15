import 'package:flutter/material.dart';
import 'package:novo_instamart/util/styles.dart';

class CustomText extends StatelessWidget {
  final String text;
  final bool isActive;
  const CustomText({super.key, required this.text, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Text(
          text,
          style: figTreeMedium.copyWith(
              color: isActive
                  ? Theme.of(context).textTheme.bodyLarge!.color
                  : Theme.of(context).hintColor),
        ),
      ),
    );
  }
}
