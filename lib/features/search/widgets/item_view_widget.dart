import 'package:novo_flashMart/features/search/controllers/search_controller.dart'
    as search;
import 'package:novo_flashMart/helper/responsive_helper.dart';
import 'package:novo_flashMart/util/dimensions.dart';
import 'package:novo_flashMart/common/widgets/footer_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novo_flashMart/common/widgets/item_view.dart';
import 'package:novo_flashMart/common/widgets/web_item_view.dart';

class ItemViewWidget extends StatelessWidget {
  final bool isItem;
  const ItemViewWidget({super.key, required this.isItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<search.SearchController>(builder: (searchController) {
        return SingleChildScrollView(
          child: FooterView(
            child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: ResponsiveHelper.isDesktop(context)
                  ? WebItemsView(
                      isStore: isItem,
                      items: searchController.searchItemList,
                      stores: searchController.searchStoreList,
                    )
                  : ItemsView(
                      isStore: isItem,
                      items: searchController.searchItemList,
                      stores: searchController.searchStoreList,
                    ),
            ),
          ),
        );
      }),
    );
  }
}
