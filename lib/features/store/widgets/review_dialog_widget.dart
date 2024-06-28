import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_flashMart/features/splash/controllers/splash_controller.dart';
import 'package:novo_flashMart/features/review/domain/models/review_model.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import 'package:novo_flashMart/util/styles.dart';
import 'package:novo_flashMart/common/widgets/custom_image.dart';
import 'package:novo_flashMart/common/widgets/rating_bar.dart';

class ReviewDialogWidget extends StatelessWidget {
  final ReviewModel review;
  final bool fromOrderDetails;
  const ReviewDialogWidget(
      {super.key, required this.review, this.fromOrderDetails = false});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: !fromOrderDetails
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                            style: figTreeBold.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
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
                            style: figTreeRegular.copyWith(
                                fontSize: Dimensions.fontSizeExtraSmall,
                                color: Theme.of(context).disabledColor),
                          ),
                        ])),
                  ])
                : Text(
                    review.comment!,
                    style: figTreeRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
          )),
    );
  }
}
