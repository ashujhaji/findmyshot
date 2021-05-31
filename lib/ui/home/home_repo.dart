import 'package:findmyshot/model/alert.dart';
import 'package:findmyshot/model/slots.dart';
import 'package:findmyshot/util/constant.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api/api_provider.dart';
import '../../model/centers.dart';
import '../../model/districts.dart';
import '../../model/states.dart';

class HomeRepo {
  HomeRepo._privateConstructor();

  static final HomeRepo instance = HomeRepo._privateConstructor();

  Future<List<int>> getDistrictIds(List<CenterData> centers) async {
    final districtCode = List<int>();
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
        try {
          for (CenterData centerData in centers) {
            final districtId = districts
                .firstWhere((element) =>
                    element.districtName == centerData.districtName)
                .districtId;
            if (!districtCode.contains(districtId)) {
              districtCode.add(districtId);
            }
          }
        } catch (e) {
          return districtCode;
        }
      }
    }
    return districtCode;
  }

  Future<void> findSlot(FlutterLocalNotificationsPlugin plugin) async {
    final pref = await SharedPreferences.getInstance();
    final alert =
        alertFromJson(pref.getString(Constant.CREATED_ALERT));

    final date = DateTime.now();

    for (int districtCode in alert.districtId) {
      http.Response response = await ApiProvider.instance.findSlotByDistrict(
          districtCode, '${date.day}-${date.month}-${date.year}');
      if (response.statusCode == 200) {
        final slots = slotResponseFromJson(response.body).centers;
        for(SlotCenter center in slots){
          if(center.sessions.any((element) => alert.age.contains(element.minAgeLimit.toString())&&element.availableCapacityDose1>0)){
            scheduleNotification(plugin,center);
          }
        }
      }
    }
  }

  Future<void> scheduleNotification(
      FlutterLocalNotificationsPlugin plugin, SlotCenter center) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await plugin.show(
      0,
      'Vaccine slot available',
      'We found a slot at ${center.address} for you. Please check cowin.gov.in',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}
