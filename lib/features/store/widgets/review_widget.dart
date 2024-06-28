import 'package:novo_flashMart/features/splash/controllers/splash_controller.dart';
import 'package:novo_flashMart/features/review/domain/models/review_model.dart';
import 'package:novo_flashMart/helper/responsive_helper.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import 'package:novo_flashMart/util/styles.dart';
import 'package:novo_flashMart/common/widgets/custom_image.dart';
import 'package:novo_flashMart/common/widgets/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_flashMart/features/store/widgets/review_dialog_widget.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;
  final bool hasDivider;
  const ReviewWidget(
      {super.key, required this.review, required this.hasDivider});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.dialog(ReviewDialogWidget(review: review)),
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipOval(
            child: CustomImage(
              image:
                  '${Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl}/${review.itemImage ?? ''}',
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  review.itemName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      figTreeBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
                RatingBar(
                    rating: review.rating!.toDouble(),
                    ratingCount: null,
                    size: 15),
                Text(
                  review.customerName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: figTreeMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall),
                ),
                Text(
                  review.comment!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: figTreeRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).disabledColor),
                ),
              ])),
        ]),
        (hasDivider && ResponsiveHelper.isMobile(context))
            ? Padding(
                padding: const EdgeInsets.only(left: 70),
                child: Divider(color: Theme.of(context).disabledColor),
              )
            : const SizedBox(),
      ]),
    );
  }
}
