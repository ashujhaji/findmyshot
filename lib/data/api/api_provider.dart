import 'package:http/http.dart' as http;

import 'api_constant.dart';

class ApiProvider {
  ApiProvider._privateConstructor();

  static final ApiProvider instance = ApiProvider._privateConstructor();

  Future<http.Response> getCenterByLocation(double lat, double long) =>
      http.get(ApiConstant.GET_CENTER_BY_LOCATION + '?lat=$lat&long=$long',
          headers: {ApiConstant.CONTENT_TYPE: ApiConstant.APPLICATION_JSON});

  Future<http.Response> getStates() => http.get(ApiConstant.GET_STATES,
      headers: {ApiConstant.CONTENT_TYPE: ApiConstant.APPLICATION_JSON});

  Future<http.Response> getDistrictsByStateId(stateId) =>
      http.get('${ApiConstant.GET_DISTRICTS_BY_STATE}/$stateId',
          headers: {ApiConstant.CONTENT_TYPE: ApiConstant.APPLICATION_JSON});

  Future<http.Response> findSlotByDistrict(districtId, date) =>
      http.get('${ApiConstant.FIND_SLOTS}?district_id=$districtId&date=$date',
          headers: {ApiConstant.CONTENT_TYPE: ApiConstant.APPLICATION_JSON});
}
