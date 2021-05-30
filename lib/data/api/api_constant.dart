class ApiConstant {
  static const BASE_URL = 'https://cdn-api.co-vin.in';

  //End points
  static const GET_CENTER_BY_LOCATION =
      '$BASE_URL/api/v2/appointment/centers/public/findByLatLong';
  static const GET_STATES = '$BASE_URL/api/v2/admin/location/states';
  static const GET_DISTRICTS_BY_STATE =
      '$BASE_URL/api/v2/admin/location/districts';

  static const CONTENT_TYPE = 'Content-Type';
  static const APPLICATION_JSON = "application/json";
}
