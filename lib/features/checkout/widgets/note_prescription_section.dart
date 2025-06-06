import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_flashMart/features/checkout/controllers/checkout_controller.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import 'package:novo_flashMart/util/styles.dart';
import 'package:novo_flashMart/common/widgets/custom_text_field.dart';

class NoteAndPrescriptionSection extends StatelessWidget {
  final CheckoutController checkoutController;
  final int? storeId;
  const NoteAndPrescriptionSection({
    super.key,
    required this.checkoutController,
    this.storeId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('additional_note'.tr, style: figTreeMedium),
      const SizedBox(height: Dimensions.paddingSizeSmall),
      CustomTextField(
        controller: checkoutController.noteController,
        titleText: 'please_provide_extra_napkin'.tr,
        maxLines: 3,
        inputType: TextInputType.multiline,
        inputAction: TextInputAction.done,
        capitalization: TextCapitalization.sentences,
      ),
      const SizedBox(height: Dimensions.paddingSizeLarge),

      /*storeId == null && Get.find<SplashController>().configModel!.moduleConfig!.module!.orderAttachment! ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('prescription'.tr, style: figTreeMedium),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Text(
              '(${'max_size_2_mb'.tr})',
              style: figTreeRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ImagePickerWidget(
            image: '', rawFile: checkoutController.rawAttachment,
            onTap: () => checkoutController.pickImage(),
          ),
        ],
      ) : const SizedBox(),*/
    ]);
  }
}
