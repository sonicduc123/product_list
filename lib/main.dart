import 'package:flutter/material.dart';
import 'package:product_list/routes.dart';

void main() {
  runApp(MaterialApp(
    title: 'Product List',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    ),
    initialRoute: Routes.productList,
    routes: Routes.routes,
    onGenerateRoute: Routes.generateRoutes,
    debugShowCheckedModeBanner: false,
  ));
}
