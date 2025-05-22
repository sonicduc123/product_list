import 'package:flutter/material.dart';

import '../../../common/handle_state/view_state.dart';
import '../../../network/result.dart';
import '../model/product_model.dart';
import '../repository/product_list_repository.dart';

class ProductListProvider extends ChangeNotifier {
  ProductListProvider({required ProductListRepository repository})
      : _repository = repository;

  final ProductListRepository _repository;

  final List<ProductModel> _productList = [];
  int get productListLength => _productList.length;
  ViewState<List<ProductModel>> _productListState = InitialState();
  ViewState<List<ProductModel>> get productListState => _productListState;

  final List<ProductModel> _favoriteList = [];
  int get favoriteListLength => _favoriteList.length;
  ViewState<List<ProductModel>> _favoriteListState = InitialState();
  ViewState<List<ProductModel>> get favoriteListState => _favoriteListState;

  ViewState _addFavoriteState = InitialState();
  ViewState get addFavoriteState => _addFavoriteState;

  ViewState _deleteFavoriteState = InitialState();
  ViewState get deleteFavoriteState => _deleteFavoriteState;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String? _loadMoreError;
  String? get loadMoreError => _loadMoreError;

  int page = 0;
  final int pageSize = 20;

  String _searchText = '';

  Future<void> initData() async {
    _productListState = LoadingState();
    notifyListeners();
    await Future.wait([
      getListProduct(),
      getFavoriteList(),
    ]);
  }

  Future<void> getListProduct() async {
    final result = await _repository.getListProduct(searchText: _searchText, page: page, pageSize: pageSize);
    if (result is Ok<ListProductModel>) {
      List<ProductModel> productList = result.value.products ?? [];

      if (productList.isEmpty) {
        _productListState = EmptyState();
      } else {
        for (var product in productList) {
          product.isFavorite = _favoriteList.any((favorite) => favorite.id == product.id);
        }
        _productList.addAll(productList);
        _productListState = SuccessState(_productList.sublist(0));
        _hasMore = (result.value.total != _productList.length);
      }
    } else if (result is Error<ListProductModel>) {
      if (page == 0) {
        _productListState = FailureState(result.error);
      } else {
        _loadMoreError = result.error.toString();
      }
    }

    notifyListeners();
  }

  Future<void> loadMore() async {
    _loadMoreError = null;
    if (_hasMore) {
      page++;
      await getListProduct();
    }
  }

  Future<void> searchProduct(String searchText) async {
    _searchText = searchText;
    page = 0;
    _productList.clear();
    _productListState = LoadingState();
    notifyListeners();
    await getListProduct();
  }

  Future<void> addFavorite(ProductModel product) async {
    _addFavoriteState = LoadingState();
    final result = await _repository.addFavorite(product);
    if (result is Ok<ProductModel>) {
      _favoriteList.insert(0, product);
      _favoriteListState = SuccessState(_favoriteList);
      _addFavoriteState = SuccessState(null);
    } else if (result is Error<ProductModel>) {
      _addFavoriteState = FailureState(result.error);
    }
    notifyListeners();
  }

  Future<void> deleteFavorite(int id) async {
    _deleteFavoriteState = LoadingState();
    final result = await _repository.deleteFavorite(id);
    if (result is Ok<void>) {
      _favoriteList.removeWhere((product) => product.id == id);
      _favoriteListState = SuccessState(_favoriteList);
      _productList.where((product) => product.id == id).toList().firstOrNull?.isFavorite = false;
      if (_favoriteList.isEmpty) {
        _favoriteListState = EmptyState();
      }
      _deleteFavoriteState = SuccessState(null);
    } else if (result is Error<void>) {
      _deleteFavoriteState = FailureState(result.error);
    }
    notifyListeners();
  }

  Future<void> getFavoriteList({List<String>? columns}) async {
    _favoriteListState = LoadingState();
    notifyListeners();
    final result = await _repository.getFavoriteList(columns: columns);
    if (result is Ok<List<ProductModel>>) {
      _favoriteList.addAll(result.value);
      _favoriteListState = SuccessState(_favoriteList);
      if (_favoriteList.isEmpty) {
        _favoriteListState = EmptyState();
      }
    } else if (result is Error<List<ProductModel>>) {
      _favoriteListState = FailureState(result.error);
    }
    notifyListeners();
  }

  Future<void> onTapFavorite(ProductModel product) async {
    if (product.isFavorite == true) {
      product.isFavorite = false;
      await deleteFavorite(product.id ?? 0);
    } else {
      product.isFavorite = true;
      await addFavorite(product);
    }
    notifyListeners();
  }
}