import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import 'package:novo_flashMart/util/styles.dart';

class DeliveryDetailsWidget extends StatelessWidget {
  final bool from;
  final String? address;
  const DeliveryDetailsWidget({super.key, this.from = true, this.address});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Icon(from ? Icons.store : Icons.location_on,
          size: 28, color: from ? Colors.blue : Theme.of(context).primaryColor),
      const SizedBox(width: Dimensions.paddingSizeSmall),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(from ? 'from_store'.tr : 'to'.tr, style: figTreeMedium),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        Text(
          address ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:
              figTreeRegular.copyWith(color: Theme.of(context).disabledColor),
        )
      ])),
    ]);
  }
}
