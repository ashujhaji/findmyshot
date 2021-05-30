import 'package:http/http.dart' as http;

import '../../data/api/api_provider.dart';
import '../../model/centers.dart';
import '../../model/districts.dart';
import '../../model/states.dart';

class HomeRepo {
  HomeRepo._privateConstructor();

  static final HomeRepo instance = HomeRepo._privateConstructor();

  Future<List<int>> getDistrictIds(List<CenterData> centers) async {
    final districtCode = [];
    //Do API call and other stuffs
    http.Response stateResponse = await ApiProvider.instance.getStates();
    if (stateResponse.statusCode == 200) {
      final states = statesResponseFromJson(stateResponse.body).states;
      final currentState = states
          .firstWhere((element) => element.stateName == centers[0].stateName);

      //call districts
      http.Response districtsResponse = await ApiProvider.instance
          .getDistrictsByStateId(currentState.stateId);
      if (districtsResponse.statusCode == 200) {
        final districts =
            districtsResponseFromJson(districtsResponse.body).districts;

        //filter district codes
        for (CenterData centerData in centers) {
          final districtId = districts
              .firstWhere(
                  (element) => element.districtName == centerData.districtName)
              .districtId;
          if (!districtCode.contains(districtId)) {
            districtCode.add(districtId);
          }
        }
      }
    }
    return districtCode;
  }
}
