import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/product_list/provider/product_list_provider.dart';
import 'features/product_list/repository/product_list_repository.dart';
import 'features/product_list/screen/product_list_screen.dart';
import 'features/product_list/service/favorite_sqflite_service.dart';
import 'features/product_list/service/product_list_service.dart';

class Routes {
  // static routes
  static const String productList = '/productList';

  static final routes = <String, WidgetBuilder> {
    productList: (BuildContext context) => MultiProvider(
      providers: [
        Provider(create: (context) => ProductListService()),
        Provider(create: (context) => FavoriteService()),
        Provider(create: (context) => ProductListRepository(service: context.read<ProductListService>(), favoriteService: context.read<FavoriteService>())),
        ChangeNotifierProvider(create: (context) => ProductListProvider(
            repository: context.read<ProductListRepository>(),
          )..initData(),
        ),
      ],
      child: ProductListScreen(),
    ),
  };

  static Route<dynamic>? generateRoutes(settings) {
    switch (settings.name) {
    }

    return null;
  }
}