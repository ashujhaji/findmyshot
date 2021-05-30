import 'package:http/http.dart' as http;

import 'api_constant.dart';

class ApiProvider {
  ApiProvider._privateConstructor();

  static final ApiProvider instance = ApiProvider._privateConstructor();

  Future<http.Response> getCenterByLocation(double lat, double long) =>
      http.get(ApiConstant.GET_CENTER_BY_LOCATION + '?lat=$lat&long=$long',
          headers: {ApiConstant.CONTENT_TYPE: ApiConstant.APPLICATION_JSON});
}
