import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_flashMart/features/splash/controllers/splash_controller.dart';
import 'package:novo_flashMart/common/controllers/theme_controller.dart';
import 'package:novo_flashMart/features/profile/domain/models/user_information_body.dart';
import 'package:novo_flashMart/features/taxi_booking/models/vehicle_model.dart';
import 'package:novo_flashMart/helper/route_helper.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import 'package:novo_flashMart/util/images.dart';
import 'package:novo_flashMart/util/styles.dart';
import 'package:novo_flashMart/common/widgets/custom_image.dart';
import 'package:novo_flashMart/common/widgets/ripple_button.dart';

class RiderCarCard extends StatelessWidget {
  final Vehicles vehicle;
  final UserInformationBody filterBody;
  const RiderCarCard(
      {super.key, required this.vehicle, required this.filterBody});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeExtraSmall),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [
                BoxShadow(
                  color: Colors
                      .grey[Get.find<ThemeController>().darkTheme ? 800 : 300]!,
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ],
            ),
            margin: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(Dimensions.radiusSmall)),
                  child: CustomImage(
                      image:
                          '${Get.find<SplashController>().configModel!.baseUrls!.vehicleImageUrl}/${vehicle.carImages!.isNotEmpty ? vehicle.carImages![0] : ''}',
                      height: 130,
                      width: Get.width),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      Text(
                        "${vehicle.name}",
                        style: figTreeMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(children: [
                        Image.asset(
                          Images.starFill,
                          height: 10,
                          width: 10,
                        ),
                        const SizedBox(
                          width: Dimensions.paddingSizeExtraSmall,
                        ),
                        Text(
                          '${vehicle.avgRating},',
                          style: figTreeRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                        Text(
                          "(${vehicle.ratingCount} ${'review'.tr})",
                          style: figTreeRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color!
                                .withOpacity(.5),
                          ),
                        )
                      ]),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                carFeatureItem(Images.riderSeat,
                                    '${vehicle.seatingCapacity} ${'seat'.tr}'),
                                const SizedBox(
                                    width: Dimensions.paddingSizeLarge),
                                carFeatureItem(
                                    Images.acIcon,
                                    vehicle.airCondition == 'yes'
                                        ? 'ac'.tr
                                        : 'non_ac'.tr),
                                const SizedBox(
                                  width: Dimensions.paddingSizeLarge,
                                ),
                                carFeatureItem(Images.riderKm,
                                    '${vehicle.engineCapacity}km/h'),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        '${Get.find<SplashController>().configModel!.currencySymbol}',
                                    style: figTreeRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall)),
                                TextSpan(
                                    text:
                                        double.parse(vehicle.minFare.toString())
                                            .toStringAsFixed(
                                                Get.find<SplashController>()
                                                    .configModel!
                                                    .digitAfterDecimalPoint!),
                                    style: figTreeBold.copyWith(
                                        fontSize:
                                            Dimensions.fontSizeExtraLarge)),
                                TextSpan(
                                    text: '/hr',
                                    style: figTreeBold.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!
                                            .withOpacity(.5),
                                        fontSize: Dimensions.fontSizeSmall)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned.fill(
              child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault),
            child: RippleButton(
              onTap: () => Get.toNamed(
                  RouteHelper.getCarDetailsScreen(vehicle, filterBody)),
              radius: Dimensions.radiusSmall,
            ),
          )),
        ],
      ),
    );
  }

  Widget carFeatureItem(String imagePath, String title) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          height: 13,
        ),
        const SizedBox(
          width: Dimensions.paddingSizeExtraSmall,
        ),
        Text(title),
      ],
    );
  }
}
