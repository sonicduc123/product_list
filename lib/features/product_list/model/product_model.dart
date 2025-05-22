import 'dart:convert';

class ListProductModel {
  List<ProductModel>? products;
  int? total;
  int? skip;
  int? limit;

  ListProductModel({
    this.products,
    this.total,
    this.skip,
    this.limit,
  });

  ListProductModel copyWith({
    List<ProductModel>? products,
    int? total,
    int? skip,
    int? limit,
  }) =>
      ListProductModel(
        products: products ?? this.products,
        total: total ?? this.total,
        skip: skip ?? this.skip,
        limit: limit ?? this.limit,
      );

  factory ListProductModel.fromRawJson(String str) => ListProductModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListProductModel.fromJson(Map<String, dynamic> json) => ListProductModel(
    products: json["products"] == null ? [] : List<ProductModel>.from(json["products"]!.map((x) => ProductModel.fromJson(x))),
    total: json["total"],
    skip: json["skip"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
    "total": total,
    "skip": skip,
    "limit": limit,
  };
}

class ProductModel {
  int? id;
  String? title;
  double? price;
  String? thumbnail;
  bool? isFavorite;

  ProductModel({
    this.id,
    this.title,
    this.price,
    this.thumbnail,
    this.isFavorite,
  });

  ProductModel copyWith({
    int? id,
    String? title,
    double? price,
    String? thumbnail,
    bool? isFavorite,
  }) =>
      ProductModel(
        id: id ?? this.id,
        title: title ?? this.title,
        price: price ?? this.price,
        thumbnail: thumbnail ?? this.thumbnail,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  factory ProductModel.fromRawJson(String str) => ProductModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    title: json["title"],
    price: json["price"]?.toDouble(),
    thumbnail: json["thumbnail"],
    isFavorite: json["isFavorite"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "thumbnail": thumbnail,
    "is_favorite": isFavorite == true ? 1 : 0,
  };
}
