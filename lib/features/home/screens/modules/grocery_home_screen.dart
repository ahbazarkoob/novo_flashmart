import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_instamart/features/banner/controllers/banner_controller.dart';
import 'package:novo_instamart/features/flash_sale/controllers/flash_sale_controller.dart';
import 'package:novo_instamart/features/flash_sale/widgets/flash_sale_view_widget.dart';
import 'package:novo_instamart/features/home/widgets/bad_weather_widget.dart';
import 'package:novo_instamart/features/home/widgets/views/banner_view.dart';
import 'package:novo_instamart/features/home/widgets/views/best_reviewed_item_view.dart';
import 'package:novo_instamart/features/home/widgets/views/category_view.dart';
import 'package:novo_instamart/features/home/widgets/views/just_for_you_view.dart';
import 'package:novo_instamart/features/home/widgets/views/most_popular_item_view.dart';
import 'package:novo_instamart/features/home/widgets/views/middle_section_banner_view.dart';
import 'package:novo_instamart/features/home/widgets/views/special_offer_view.dart';
import 'package:novo_instamart/features/home/widgets/views/promotional_banner_view.dart';
import 'package:novo_instamart/features/item/controllers/campaign_controller.dart';
import 'package:novo_instamart/features/item/controllers/item_controller.dart';
import 'package:novo_instamart/features/store/controllers/store_controller.dart';
import 'package:novo_instamart/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../category/controllers/category_controller.dart';

class GroceryHomeScreen extends StatefulWidget {
  const GroceryHomeScreen({super.key});

  @override
  State<GroceryHomeScreen> createState() => _GroceryHomeScreenState();
}

class _GroceryHomeScreenState extends State<GroceryHomeScreen> {
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    // _checkFirstTimeScreenLoad();
    Get.find<CategoryController>;
    bool? isFirstTime = Get.find<CategoryController>().showFirstTime();
    // bool isFirstTime =
    //     sharedPreferences.getBool(AppConstants.firstTime) ?? true;
    debugPrint('________________________________________________');
    debugPrint("$isFirstTime");
    if (isFirstTime == true || isFirstTime == null) {
      Get.find<FlashSaleController>().getFlashSale(true, true);
      Get.find<BannerController>().getPromotionalBannerList(true);
      Get.find<ItemController>().getDiscountedItemList(true, false, 'all');
      Get.find<CategoryController>().getCategoryList(true);
      Get.find<StoreController>().getPopularStoreList(true, 'all', false);
      Get.find<CampaignController>().getItemCampaignList(true);
      Get.find<CampaignController>().getBasicCampaignList(true);
      Get.find<ItemController>().getPopularItemList(true, 'all', false);
      Get.find<StoreController>().getLatestStoreList(true, 'all', false);
      Get.find<ItemController>().getReviewedItemList(true, 'all', false);
      Get.find<StoreController>().getStoreList(1, true);
    }

    Get.find<CategoryController>().disableFirstTime();
  }

  // _checkFirstTimeScreenLoad() {
  //   bool isFirstTime =
  //       sharedPreferences.getBool(AppConstants.firstTime) ?? true;
  //   debugPrint('________________________________________________');
  //   debugPrint("$isFirstTime");
  //   if (isFirstTime) {
  //     Get.find<FlashSaleController>().getFlashSale(true, true);
  //     Get.find<BannerController>().getPromotionalBannerList(true);
  //     Get.find<ItemController>().getDiscountedItemList(true, false, 'all');
  //     Get.find<CategoryController>().getCategoryList(true);
  //     Get.find<StoreController>().getPopularStoreList(true, 'all', false);
  //     Get.find<CampaignController>().getItemCampaignList(true);
  //     Get.find<CampaignController>().getBasicCampaignList(true);
  //     Get.find<ItemController>().getPopularItemList(true, 'all', false);
  //     Get.find<StoreController>().getLatestStoreList(true, 'all', false);
  //     Get.find<ItemController>().getReviewedItemList(true, 'all', false);
  //     Get.find<StoreController>().getStoreList(1, true);
  //   }
  //   sharedPreferences.setBool(AppConstants.firstTime, false);
  // }

  @override
  Widget build(BuildContext context) {
    // bool isLoggedIn = AuthHelper.isLoggedIn();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).disabledColor.withOpacity(0.1),
        child: const Column(
          children: [
            BadWeatherWidget(),
            // BannerView(isFeatured: false),
            SizedBox(height: 12),
          ],
        ),
      ),
      const PromotionalBannerView(),
      const SpecialOfferView(isFood: false, isShop: false),
      const CategoryView(),
      const CategorySectionView(),
      const BannerView(isFeatured: false),
      // isLoggedIn ? const VisitAgainView() : const SizedBox(),
      // const SpecialOfferView(isFood: false, isShop: false),
      const FlashSaleViewWidget(),
      // const BestStoreNearbyView(),
      const MostPopularItemView(isFood: false, isShop: false),
      const MiddleSectionBannerView(),
      const BestReviewItemView(),
      const JustForYouView(),
      // const ItemThatYouLoveView(forShop: false),
      // const PromoCodeBannerView(),
      // const NewOnMartView(isPharmacy: false, isShop: false),
      // const PromotionalBannerView(),
    ]);
  }
}

class CategorySectionView extends StatefulWidget {
  const CategorySectionView({super.key});

  @override
  State<CategorySectionView> createState() => _CategorySectionViewState();
}

class _CategorySectionViewState extends State<CategorySectionView> {
  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return (categoryController.categoryList == null ||
              categoryController.categoryList!.isEmpty)
          ? const SizedBox()
          : Column(
              children: [
                for (int i = 0;
                    i < (categoryController.categoryList!.length);
                    i++)
                  CategorySection(
                    index: i,
                    categoryID: "${categoryController.categoryList![i].id}",
                  ),
              ],
            );
    });
  }
}
