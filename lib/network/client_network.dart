import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as client;
import 'endpoint.dart';
import 'result.dart';

class ClientNetwork {
  static Result<client.Response> handleResponse(
    client.Response response,
  ) {
    if (response.statusCode == 200) {
      return Result.ok(response);
    } else if (response.statusCode == 400) {
      return Result.error(HttpException('Bad request'));
    } else if (response.statusCode == 401) {
      return Result.error(HttpException('Unauthorized'));
    } else if (response.statusCode == 403) {
      return Result.error(HttpException('Forbidden'));
    } else if (response.statusCode == 404) {
      return Result.error(HttpException('Product not found'));
    } else if (response.statusCode == 500) {
      return Result.error(HttpException('Server error'));
    } else {
      return Result.error(HttpException('Invalid response'));
    }
  }

 static Future<Result<client.Response>> get({required String endpoint, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.get(
        Uri.https(
          Endpoint.baseUrl,
          endpoint,
          queryParameters,
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptCharsetHeader: 'utf-8',
          HttpHeaders.acceptLanguageHeader: 'en',
        },
      );

      return handleResponse(response);
    } on TimeoutException catch (exception) {
      return Result.error(Exception('Request timeout'));
    } on SocketException catch (exception) {
      return Result.error(Exception('No internet connection'));
    } on HttpException catch (exception) {
      return Result.error(exception);
    } on FormatException catch (exception) {
      return Result.error(exception);
    } on Exception catch (exception) {
      return Result.error(exception);
    }
  }
}