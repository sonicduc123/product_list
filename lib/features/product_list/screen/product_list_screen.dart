import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:product_list/widgets/search_widget.dart';
import 'package:provider/provider.dart';

import '../../../common/handle_state/state_widget.dart';
import '../../../common/handle_state/view_state.dart';
import '../../../common/loadmore/load_more_listview.dart';
import '../../../constants.dart';
import '../provider/product_list_provider.dart';
import '../widget/product_list_item.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProductListProvider provider = context.read<ProductListProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () async {

                },
              ),
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Text(
                  provider.favoriteListLength.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.paddingLayout),
        child: Column(
          children: [
            const SizedBox(height: Space.marginElement),
            SearchWidget(
              onChanged: (value) async {
                log(value);
                await provider.searchProduct(value);
              },
            ),
            const SizedBox(height: Space.marginElement),
            Expanded(
              child: StateWidget(
                state: context.watch<ProductListProvider>().productListState,
                successBuilder: (productList) {
                  return LoadMoreListview(
                    // key: PageStorageKey(0),
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      return ProductListItem(
                        data: productList[index],
                        onBookmark: () async{
                          await provider.onTapFavorite(productList[index]);

                          if (productList[index].isFavorite == true) {
                            if (provider.addFavoriteState is SuccessState) {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Add favorite success'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else if (provider.addFavoriteState is FailureState) {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Add favorite failed'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            if (provider.deleteFavoriteState is SuccessState) {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Remove favorite success'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Remove favorite failed'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      );
                    },
                    onGetMoreData: provider.loadMore,
                    hasMore: provider.hasMore,
                    loadMoreError: provider.loadMoreError,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
