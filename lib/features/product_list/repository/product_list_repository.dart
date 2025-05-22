import 'dart:isolate';
import 'package:http/http.dart';

import '../../../network/result.dart';
import '../model/product_model.dart';
import '../service/favorite_sqflite_service.dart';
import '../service/product_list_service.dart';

class ProductListRepository {
  ProductListRepository({
    required ProductListService service,
    required FavoriteService favoriteService,
  }) : _productListService = service,
       _favoriteService = favoriteService;

  final ProductListService _productListService;
  final FavoriteService _favoriteService;


  Future<Result<ListProductModel>> getListProduct({required String searchText, required int page, required int pageSize}) async {
    try {
      final response = await _productListService.getListProduct(searchText: searchText, page: page, pageSize: pageSize);

      if (response is Ok<Response>) {
        final data = await Isolate.run<ListProductModel>(() {
          return ListProductModel.fromRawJson(response.value.body);
        });
        // final data = ListProductModel.fromRawJson(response.value.body);
        return Ok(data);
      } else if (response is Error<Response>) {

        return Error(response.error);
      }
    } catch (e) {
      return Error(Exception('Error when handling response'));
    }

    return Error(Exception('Unknown error'));
  }

  Future<Result<ProductModel>> addFavorite(ProductModel user) async {
    try {
      int? id = await _favoriteService.insert(user);
      if (id != null) {
        return Ok(user);
      }
    } catch (e) {
      return Error(Exception('Error when adding bookmark'));
    }
    return Error(Exception('Unknown error'));
  }

  Future<Result<List<ProductModel>>> getFavoriteList({List<String>? columns}) async {
    try {
      final listResult = await _favoriteService.getList(columns: columns);
      if (listResult != null) {
        final listMap = await Isolate.run<List<ProductModel>>(() {
          return listResult.map((e) => ProductModel.fromJson(e)).toList();
        });
        return Ok(listMap);
      }
    } catch (e) {
      return Error(Exception('Error when getting bookmark list'));
    }
    return Error(Exception('Unknown error'));
  }

  Future<Result> deleteFavorite(int id) async {
    try {
      await _favoriteService.delete(id);
      return Ok(null);
    } catch (e) {
      return Error(Exception('Error when deleting bookmark'));
    }
  }
}