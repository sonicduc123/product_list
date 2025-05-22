import 'package:http/http.dart';

import '../../../network/client_network.dart';
import '../../../network/endpoint.dart';
import '../../../network/result.dart';

class ProductListService {
  Future<Result<Response>> getListProduct({required String searchText, required int page, required int pageSize}) async {
    return await ClientNetwork.get(
      endpoint: Endpoint.getListProduct,
      queryParameters: {
        'q': searchText,
        'limit': pageSize.toString(),
        'skip': (page * pageSize).toString(),
        'select': 'title,price,thumbnail'
      },
    );
  }
}