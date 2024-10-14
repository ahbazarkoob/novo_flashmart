import 'package:novo_flashMart/features/category/controllers/category_controller.dart';
import 'package:novo_flashMart/features/language/controllers/language_controller.dart';
import 'package:novo_flashMart/features/splash/controllers/splash_controller.dart';
import 'package:novo_flashMart/helper/responsive_helper.dart';
import 'package:novo_flashMart/helper/route_helper.dart';
import 'package:novo_flashMart/util/app_constants.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import 'package:novo_flashMart/util/styles.dart';
import 'package:novo_flashMart/common/widgets/custom_image.dart';
import 'package:novo_flashMart/features/home/widgets/category_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/card_design/item_card.dart';
import '../../../item/domain/models/item_model.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return GetBuilder<SplashController>(builder: (splashController) {
      bool isPharmacy = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.pharmacy;
      bool isFood = splashController.module != null &&
          splashController.module!.moduleType.toString() == AppConstants.food;

      return GetBuilder<CategoryController>(builder: (categoryController) {
        return (categoryController.categoryList != null &&
                categoryController.categoryList!.isEmpty)
            ? const SizedBox()
            : isPharmacy
                ? PharmacyCategoryView(categoryController: categoryController)
                : isFood
                    ? FoodCategoryView(categoryController: categoryController)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault),
                            child: Text(
                              "SHOP BY CATEGORY",
                              style: figTreeBold,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height:
                                      // categoryController.categoryList!.length > 4 ?
                                      250,
                                  // :
                                  // 168,
                                  child: categoryController.categoryList != null
                                      ? GridView.builder(
                                          controller: scrollController,
                                          itemCount: categoryController
                                                      .categoryList!.length >
                                                  8
                                              ? 8
                                              : categoryController
                                                  .categoryList!.length,
                                          padding: const EdgeInsets.only(
                                              left: Dimensions.paddingSizeSmall,
                                              top: Dimensions.paddingSizeSmall),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4,
                                                  mainAxisSpacing: 3),
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  // bottom: Dimensions
                                                  //     .paddingSizeDefault,
                                                  right: Dimensions
                                                      .paddingSizeSmall,
                                                  top: Dimensions
                                                      .paddingSizeSmall),
                                              child: InkWell(
                                                onTap: () {
                                                  if (index == 7 &&
                                                      categoryController
                                                              .categoryList!
                                                              .length >
                                                          8) {
                                                    Get.toNamed(RouteHelper
                                                        .getCategoryRoute());
                                                  } else {
                                                    Get.toNamed(RouteHelper
                                                        .getCategoryItemRoute(
                                                      categoryController
                                                          .categoryList![index]
                                                          .id,
                                                      categoryController
                                                          .categoryList![index]
                                                          .name!,
                                                    ));
                                                  }
                                                },
                                                child: SizedBox(
                                                  width: 80,
                                                  child: Column(children: [
                                                    SizedBox(
                                                      height: 70,
                                                      width: 75,
                                                      child: Stack(children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusSmall),
                                                          child: CustomImage(
                                                            image:
                                                                '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                                                            height: 75,
                                                            width: 75,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        (index == 7 &&
                                                                categoryController
                                                                        .categoryList!
                                                                        .length >
                                                                    8)
                                                            ? Positioned(
                                                                right: 0,
                                                                left: 0,
                                                                top: 0,
                                                                bottom: 0,
                                                                child:
                                                                    Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(Dimensions.radiusSmall),
                                                                          gradient:
                                                                              LinearGradient(
                                                                            begin:
                                                                                Alignment.topCenter,
                                                                            end:
                                                                                Alignment.bottomCenter,
                                                                            colors: [
                                                                              Theme.of(context).primaryColor.withOpacity(0.4),
                                                                              Theme.of(context).primaryColor.withOpacity(0.6),
                                                                              Theme.of(context).primaryColor.withOpacity(0.4),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            '+${categoryController.categoryList!.length - 10}',
                                                                            style:
                                                                                figTreeMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        )),
                                                              )
                                                            : const SizedBox(),
                                                      ]),
                                                    ),
                                                    const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: index == 0
                                                              ? Dimensions
                                                                  .paddingSizeExtraSmall
                                                              : 0),
                                                      child: Text(
                                                        (index == 7 &&
                                                                categoryController
                                                                        .categoryList!
                                                                        .length >
                                                                    8)
                                                            ? 'see_all'.tr
                                                            : categoryController
                                                                .categoryList![
                                                                    index]
                                                                .name!,
                                                        style: figTreeMedium.copyWith(
                                                            fontSize: 11,
                                                            color: (index ==
                                                                        7 &&
                                                                    categoryController
                                                                            .categoryList!
                                                                            .length >
                                                                        8)
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .color),
                                                        maxLines: Get.find<
                                                                    LocalizationController>()
                                                                .isLtr
                                                            ? 2
                                                            : 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            );
                                          })

                                      // ListView.builder(
                                      //     controller: scrollController,
                                      //     itemCount: categoryController
                                      //                 .categoryList!.length >
                                      //             10
                                      //         ? 10
                                      //         : categoryController
                                      //             .categoryList!.length,
                                      //     padding: const EdgeInsets.only(
                                      //         left: Dimensions.paddingSizeSmall,
                                      //         top: Dimensions
                                      //             .paddingSizeDefault),
                                      //     physics:
                                      //         const BouncingScrollPhysics(),
                                      //     scrollDirection: Axis.horizontal,
                                      //     itemBuilder: (context, index) {
                                      //       return Padding(
                                      //         padding: const EdgeInsets.only(
                                      //             bottom: Dimensions
                                      //                 .paddingSizeDefault,
                                      //             right: Dimensions
                                      //                 .paddingSizeSmall,
                                      //             top: Dimensions
                                      //                 .paddingSizeDefault),
                                      //         child: InkWell(
                                      //           onTap: () {
                                      //             if (index == 9 &&
                                      //                 categoryController
                                      //                         .categoryList!
                                      //                         .length >
                                      //                     10) {
                                      //               Get.toNamed(RouteHelper
                                      //                   .getCategoryRoute());
                                      //             } else {
                                      //               Get.toNamed(RouteHelper
                                      //                   .getCategoryItemRoute(
                                      //                 categoryController
                                      //                     .categoryList![index]
                                      //                     .id,
                                      //                 categoryController
                                      //                     .categoryList![index]
                                      //                     .name!,
                                      //               ));
                                      //             }
                                      //           },
                                      //           child: SizedBox(
                                      //             width: 80,
                                      //             child: Column(children: [
                                      //               SizedBox(
                                      //                 height: 75,
                                      //                 width: 75,
                                      //                 child: Stack(children: [
                                      //                   ClipRRect(
                                      //                     borderRadius: BorderRadius
                                      //                         .circular(Dimensions
                                      //                             .radiusSmall),
                                      //                     child: CustomImage(
                                      //                       image:
                                      //                           '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                                      //                       height: 75,
                                      //                       width: 75,
                                      //                       fit: BoxFit.cover,
                                      //                     ),
                                      //                   ),
                                      //                   (index == 9 &&
                                      //                           categoryController
                                      //                                   .categoryList!
                                      //                                   .length >
                                      //                               10)
                                      //                       ? Positioned(
                                      //                           right: 0,
                                      //                           left: 0,
                                      //                           top: 0,
                                      //                           bottom: 0,
                                      //                           child:
                                      //                               Container(
                                      //                                   decoration:
                                      //                                       BoxDecoration(
                                      //                                     borderRadius:
                                      //                                         BorderRadius.circular(Dimensions.radiusSmall),
                                      //                                     gradient:
                                      //                                         LinearGradient(
                                      //                                       begin:
                                      //                                           Alignment.topCenter,
                                      //                                       end:
                                      //                                           Alignment.bottomCenter,
                                      //                                       colors: [
                                      //                                         Theme.of(context).primaryColor.withOpacity(0.4),
                                      //                                         Theme.of(context).primaryColor.withOpacity(0.6),
                                      //                                         Theme.of(context).primaryColor.withOpacity(0.4),
                                      //                                       ],
                                      //                                     ),
                                      //                                   ),
                                      //                                   child:
                                      //                                       Center(
                                      //                                     child:
                                      //                                         Text(
                                      //                                       '+${categoryController.categoryList!.length - 10}',
                                      //                                       style:
                                      //                                           figTreeMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
                                      //                                       maxLines:
                                      //                                           2,
                                      //                                       overflow:
                                      //                                           TextOverflow.ellipsis,
                                      //                                       textAlign:
                                      //                                           TextAlign.center,
                                      //                                     ),
                                      //                                   )),
                                      //                         )
                                      //                       : const SizedBox(),
                                      //                 ]),
                                      //               ),
                                      //               const SizedBox(
                                      //                   height: Dimensions
                                      //                       .paddingSizeExtraSmall),
                                      //               Padding(
                                      //                 padding: EdgeInsets.only(
                                      //                     right: index == 0
                                      //                         ? Dimensions
                                      //                             .paddingSizeExtraSmall
                                      //                         : 0),
                                      //                 child: Text(
                                      //                   (index == 9 &&
                                      //                           categoryController
                                      //                                   .categoryList!
                                      //                                   .length >
                                      //                               10)
                                      //                       ? 'see_all'.tr
                                      //                       : categoryController
                                      //                           .categoryList![
                                      //                               index]
                                      //                           .name!,
                                      //                   style: figTreeMedium.copyWith(
                                      //                       fontSize: 11,
                                      //                       color: (index ==
                                      //                                   9 &&
                                      //                               categoryController
                                      //                                       .categoryList!
                                      //                                       .length >
                                      //                                   10)
                                      //                           ? Theme.of(
                                      //                                   context)
                                      //                               .primaryColor
                                      //                           : Theme.of(
                                      //                                   context)
                                      //                               .textTheme
                                      //                               .bodyMedium!
                                      //                               .color),
                                      //                   maxLines: Get.find<
                                      //                               LocalizationController>()
                                      //                           .isLtr
                                      //                       ? 2
                                      //                       : 1,
                                      //                   overflow: TextOverflow
                                      //                       .ellipsis,
                                      //                   textAlign:
                                      //                       TextAlign.center,
                                      //                 ),
                                      //               ),
                                      //             ]),
                                      //           ),
                                      //         ),
                                      //       );
                                      //     },
                                      //   )

                                      : CategoryShimmer(
                                          categoryController:
                                              categoryController),
                                ),
                              ),
                              ResponsiveHelper.isMobile(context)
                                  ? const SizedBox()
                                  : categoryController.categoryList != null
                                      ? Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (con) => Dialog(
                                                        child: SizedBox(
                                                            height: 550,
                                                            width: 600,
                                                            child:
                                                                CategoryPopUp(
                                                              categoryController:
                                                                  categoryController,
                                                            ))));
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: Dimensions
                                                        .paddingSizeSmall),
                                                child: CircleAvatar(
                                                  radius: 35,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  child: Text('view_all'.tr,
                                                      style: TextStyle(
                                                          fontSize: Dimensions
                                                              .paddingSizeDefault,
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        )
                                      : CategoryShimmer(
                                          categoryController:
                                              categoryController),
                            ],
                          ),
                        ],
                      );
      });
    });
  }
}

class PharmacyCategoryView extends StatelessWidget {
  final CategoryController categoryController;
  const PharmacyCategoryView({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 160,
        child: categoryController.categoryList != null
            ? ListView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(
                    left: Dimensions.paddingSizeDefault,
                    top: Dimensions.paddingSizeDefault),
                itemCount: categoryController.categoryList!.length > 10
                    ? 10
                    : categoryController.categoryList!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeDefault,
                        right: Dimensions.paddingSizeSmall,
                        top: Dimensions.paddingSizeDefault),
                    child: InkWell(
                      onTap: () {
                        if (index == 9 &&
                            categoryController.categoryList!.length > 10) {
                          Get.toNamed(RouteHelper.getCategoryRoute());
                        } else {
                          Get.toNamed(RouteHelper.getCategoryItemRoute(
                            categoryController.categoryList![index].id,
                            categoryController.categoryList![index].name!,
                          ));
                        }
                      },
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      child: Container(
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(100),
                              topRight: Radius.circular(100)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.3),
                              Theme.of(context).cardColor.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: Column(children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(100),
                                    topRight: Radius.circular(100)),
                                child: CustomImage(
                                  image:
                                      '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                                  height: 60,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              (index == 9 &&
                                      categoryController.categoryList!.length >
                                          10)
                                  ? Positioned(
                                      right: 0,
                                      left: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(100),
                                                    topRight:
                                                        Radius.circular(100)),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.4),
                                                Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.6),
                                                Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.4),
                                              ],
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '+${categoryController.categoryList!.length - 10}',
                                              style: figTreeMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraLarge,
                                                  color: Theme.of(context)
                                                      .cardColor),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Expanded(
                              child: Text(
                            (index == 9 &&
                                    categoryController.categoryList!.length >
                                        10)
                                ? 'see_all'.tr
                                : categoryController.categoryList![index].name!,
                            style: figTreeMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: (index == 9 &&
                                        categoryController
                                                .categoryList!.length >
                                            10)
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          )),
                        ]),
                      ),
                    ),
                  );
                },
              )
            : PharmacyCategoryShimmer(categoryController: categoryController),
      ),
    ]);
  }
}

class FoodCategoryView extends StatelessWidget {
  final CategoryController categoryController;
  const FoodCategoryView({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 160,
          child: categoryController.categoryList != null
              ? ListView.builder(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeDefault,
                      top: Dimensions.paddingSizeDefault),
                  itemCount: categoryController.categoryList!.length > 10
                      ? 10
                      : categoryController.categoryList!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: Dimensions.paddingSizeDefault,
                          right: Dimensions.paddingSizeDefault,
                          top: Dimensions.paddingSizeDefault),
                      child: InkWell(
                        onTap: () {
                          if (index == 9 &&
                              categoryController.categoryList!.length > 10) {
                            Get.toNamed(RouteHelper.getCategoryRoute());
                          } else {
                            Get.toNamed(RouteHelper.getCategoryItemRoute(
                              categoryController.categoryList![index].id,
                              categoryController.categoryList![index].name!,
                            ));
                          }
                        },
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        child: SizedBox(
                          width: 60,
                          child: Column(children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  child: CustomImage(
                                    image:
                                        '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                                    height: 60,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                (index == 9 &&
                                        categoryController
                                                .categoryList!.length >
                                            10)
                                    ? Positioned(
                                        right: 0,
                                        left: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(100)),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.4),
                                                  Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.6),
                                                  Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.4),
                                                ],
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '+${categoryController.categoryList!.length - 10}',
                                                style: figTreeMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraLarge,
                                                    color: Theme.of(context)
                                                        .cardColor),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Expanded(
                                child: Text(
                              (index == 9 &&
                                      categoryController.categoryList!.length >
                                          10)
                                  ? 'see_all'.tr
                                  : categoryController
                                          .categoryList![index].name ??
                                      '',
                              style: figTreeMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: (index == 9 &&
                                          categoryController
                                                  .categoryList!.length >
                                              10)
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            )),
                          ]),
                        ),
                      ),
                    );
                  },
                )
              : FoodCategoryShimmer(categoryController: categoryController),
        ),
      ]),
    ]);
  }
}

class CategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const CategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      padding: const EdgeInsets.only(
          left: Dimensions.paddingSizeSmall,
          top: Dimensions.paddingSizeDefault),
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 1, vertical: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: SizedBox(
              width: 80,
              child: Column(children: [
                Container(
                    height: 75,
                    width: 75,
                    margin: EdgeInsets.only(
                      left: index == 0 ? 0 : Dimensions.paddingSizeExtraSmall,
                      right: Dimensions.paddingSizeExtraSmall,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSmall),
                      color: Colors.grey[300],
                    )),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Padding(
                  padding: EdgeInsets.only(
                      right: index == 0 ? Dimensions.paddingSizeExtraSmall : 0),
                  child: Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey[300],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class FoodCategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const FoodCategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
              bottom: Dimensions.paddingSizeDefault,
              left: Dimensions.paddingSizeDefault,
              top: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: SizedBox(
              width: 60,
              child: Column(children: [
                Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                      color: Colors.grey[300],
                    )),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey[300],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class PharmacyCategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const PharmacyCategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
              bottom: Dimensions.paddingSizeDefault,
              left: Dimensions.paddingSizeDefault,
              top: Dimensions.paddingSizeDefault),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: true,
            child: Container(
              width: 70,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100)),
              ),
              child: Column(children: [
                Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                          topRight: Radius.circular(100)),
                      color: Colors.grey[300],
                    )),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey[300],
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class CategorySection extends StatefulWidget {
  final int index;
  final String categoryID;
  const CategorySection(
      {super.key, required this.index, required this.categoryID});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        Get.find<CategoryController>().categoryItemsMap[widget.categoryID] !=
            null &&
        // Get.find<CategoryController>().categoryItemList != null &&
        !Get.find<CategoryController>().isLoading) {
      int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
      if (Get.find<CategoryController>().offset < pageSize) {
        debugPrint('end of the page');
        Get.find<CategoryController>().showBottomLoader();
        Get.find<CategoryController>().getCategoryItemList(
          widget.categoryID,
          Get.find<CategoryController>().offset + 1,
          Get.find<CategoryController>().type,
          false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      return GetBuilder<CategoryController>(builder: (categoryController) {
        List<Item> item =
            categoryController.categoryItemsMap[widget.categoryID] ?? [];
        // categoryController.categoryItemList!;
        // List<Item>? item;
        // item = [];
        // if (categoryController.categoryItemList != null) {
        //   item.addAll(categoryController.categoryItemList!);
        // }
        return (item.isEmpty)
            // (categoryController.categoryItemList != null &&
            //         categoryController.categoryItemList!.isEmpty)
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault),
                    child: Text(
                      "The ${categoryController.categoryList![widget.index].name} Shop",
                      style: figTreeBold,
                    ),
                  ),
                  (item != null)
                      ? Row(children: [
                          Expanded(
                            child: SizedBox(
                                height: 300,
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: item.length,
                                  padding: const EdgeInsets.only(
                                      left: Dimensions.paddingSizeSmall,
                                      top: Dimensions.paddingSizeDefault),
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    // debugPrint(
                                    //     "category Item:  ${categoryController.categoryItemList![index].name}");
                                    // debugPrint("${item.length}");
                                    // debugPrint("${item}");

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: Dimensions.paddingSizeSmall,
                                          top: Dimensions.paddingSizeSmall),
                                      child: ItemCard(
                                          item: item[index],
                                          isPopularItem: false,
                                          isFood: false,
                                          isShop: false),
                                    );
                                  },
                                )),
                          )
                        ])
                      : CategoryShimmer(categoryController: categoryController),
                  ResponsiveHelper.isMobile(context)
                      ? const SizedBox()
                      : categoryController.categoryList != null
                          ? Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (con) => Dialog(
                                            child: SizedBox(
                                                height: 550,
                                                width: 600,
                                                child: CategoryPopUp(
                                                  categoryController:
                                                      categoryController,
                                                ))));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: Dimensions.paddingSizeSmall),
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: Text('view_all'.tr,
                                          style: TextStyle(
                                              fontSize:
                                                  Dimensions.paddingSizeDefault,
                                              color:
                                                  Theme.of(context).cardColor)),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            )
                          : CategoryShimmer(
                              categoryController: categoryController),
                ],
              );
      });
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }
}
