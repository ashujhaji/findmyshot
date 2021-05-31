import 'package:findmyshot/model/alert.dart';
import 'package:findmyshot/model/centers.dart';
import 'package:findmyshot/ui/home/home_repo.dart';
import 'package:findmyshot/util/constant.dart';
import 'package:findmyshot/util/snackbar.dart';
import 'package:findmyshot/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api/api_provider.dart';
import '../../model/centers.dart';

class HomePage extends StatefulWidget {
  static const TAG = 'HomePageTag';

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isNewLocation = false;
  double _currentLat = 0.00;
  double _currentLong = 0.00;
  String _address = '';
  List<CenterData> _nearbyCenter = List();
  Alert _alert = Alert();
  bool _isAlertActive = false;
  final _vaccines = ['Covaxin', 'Covishield', 'Sputnik V'];
  final _price = ['All', 'Free', 'Paid'];
  final _age = ['All', '18+', '45+'];
  String _selectedVaccine = '';
  String _selectedPrice = '';
  String _selectedAge = '';

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      _currentLat = value.getDouble(Constant.CURRENT_LAT) ?? 0.00;
      _currentLong = value.getDouble(Constant.CURRENT_LONG) ?? 0.00;
      setState(() {
        _isAlertActive = value.getBool(Constant.IS_ALERT_ACTIVE);
      });
    });
    if (_isAlertActive) {
      _getCreatedAlert().then((value) {
        setState(() {
          _alert = value;
          _selectedVaccine = _alert.vaccine;
          _selectedAge = _alert.age;
          _selectedPrice = _alert.price;
        });
      });
    } else {
      _alert.vaccine = _vaccines[0];
      _alert.age = _age[0];
      _alert.price = _price[0];
      setState(() {
        _selectedVaccine = _vaccines[0];
        _selectedAge = _age[0];
        _selectedPrice = _price[0];
      });
    }
    if (_currentLat != 0.00 && _currentLong != 0.00) {
      _getAddress(_currentLat, _currentLong).then((value) {
        setState(() {
          _address = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Dashboard',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      body: (_currentLat == 0.00 && _currentLong == 0.00)
          ? _locationNotFoundWidget(context)
          : _isNewLocation
              ? _configuringWindowWidget(context)
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _createAlertWidget(context),
                      _createdAlert(context),
                      _nearbyCenters(context)
                    ],
                  ),
                ),
    );
  }

  Widget _locationNotFoundWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/ic_no_location.png',
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Enable location to find nearby vaccination centers.',
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ),
        RaisedButton(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
          onPressed: () {
            _getCurrentLocation();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: AppColor.SECONDARY_COLOR,
          child: FittedBox(
            child: Row(
              children: [
                Text(
                  'Enable location',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _configuringWindowWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/ic_no_location.png',
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Finding nearest vaccination centers for you. Please wait...',
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ),
        CircularProgressIndicator()
      ],
    );
  }

  Widget _createAlertWidget(BuildContext mContext) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.10),
              blurRadius: 20.0,
              spreadRadius: 5.0,
              offset: Offset(
                3.0,
                3.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: RaisedButton(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                onPressed: () {
                  _getNearestCentres(_currentLat, _currentLong);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: AppColor.SECONDARY_COLOR,
                child: FittedBox(
                  child: Text(
                    'Refresh',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize:
                            Theme.of(context).textTheme.bodyText1.fontSize,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Select Vaccine',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize:
                              Theme.of(context).textTheme.bodyText1.fontSize),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedVaccine,
                          isDense: true,
                          items: _vaccines.map((value) {
                            return DropdownMenuItem<String>(
                              value: '$value',
                              child: Text(
                                '$value',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: Colors.black,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .fontSize),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _alert.vaccine = value;
                            setState(() {
                              _selectedVaccine = value;
                            });
                          },
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Select Price',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize:
                              Theme.of(context).textTheme.bodyText1.fontSize),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedPrice,
                          isDense: true,
                          items: _price.map((value) {
                            return DropdownMenuItem<String>(
                              value: '$value',
                              child: Text(
                                '$value',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: Colors.black,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .fontSize),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _alert.price = value;
                            setState(() {
                              _selectedPrice = value;
                            });
                          },
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Select Age',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize:
                              Theme.of(context).textTheme.bodyText1.fontSize),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedAge,
                          isDense: true,
                          items: _age.map((value) {
                            return DropdownMenuItem<String>(
                              value: '$value',
                              child: Text(
                                '$value',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: Colors.black,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .fontSize),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _alert.age = value;
                            setState(() {
                              _selectedAge = value;
                            });
                          },
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: RaisedButton(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                onPressed: () {
                  _createNewAlert().then((value) {
                    showSnackbar(mContext, 'New Alert Created');
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: AppColor.SECONDARY_COLOR,
                child: FittedBox(
                  child: Text(
                    'Create Alert',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize:
                            Theme.of(context).textTheme.bodyText1.fontSize,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createdAlert(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Alert',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Colors.grey[500]),
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.10),
                          blurRadius: 20.0,
                          spreadRadius: 5.0,
                          offset: Offset(
                            3.0,
                            3.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Text(
                      _isAlertActive == false
                          ? 'No alert created'
                          : 'Active alert is searching vaccination slot near $_address',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.grey[700]),
                    )),
              ],
            ),
          );
        }
        return Container();
      },
      future: _fetchLocalNearestCentres(),
    );
  }

  Widget _nearbyCenters(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nearest vaccination centers',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Colors.grey[500]),
                ),
                ListView.separated(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_nearbyCenter[index].name}, ${_nearbyCenter[index].location}, ${_nearbyCenter[index].blockName}',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[300],
                      height: 1,
                    );
                  },
                  itemCount: _nearbyCenter.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                )
              ],
            ),
          );
        }
        return Container();
      },
      future: _fetchLocalNearestCentres(),
    );
  }

  _getCurrentLocation() async {
    var location = new Location();
    final userLocation = await location.getLocation();
    final _sharedPreference = await SharedPreferences.getInstance();
    _sharedPreference.setDouble(Constant.CURRENT_LAT, userLocation.latitude);
    _sharedPreference.setDouble(Constant.CURRENT_LONG, userLocation.longitude);
    final address =
        await _getAddress(userLocation.latitude, userLocation.longitude);
    setState(() {
      _address = address;
      _currentLat = userLocation.latitude;
      _currentLong = userLocation.longitude;
    });
    await _getNearestCentres(_currentLat, _currentLong);
  }

  Future<String> _getAddress(double lat, double long) async {
    final coordinates = new Coordinates(lat, long);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    return ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}';
  }

  Future<void> _getNearestCentres(double lat, double long) async {
    setState(() {
      _isNewLocation = true;
    });

    //Do API call and other stuffs
    http.Response response =
        await ApiProvider.instance.getCenterByLocation(28.6293432, 77.3530757);
    if (response.statusCode == 200) {
      final _pref = await SharedPreferences.getInstance();
      _pref.setString(Constant.NEARBY_CENTERS, response.body);
      /*final centers = centerResponseFromJson(_pref.getString(Constant.NEARBY_CENTERS)).centers;
     print(centers.length);*/
      setState(() {
        _isNewLocation = false;
      });
    }
    return;
  }

  Future<List<CenterData>> _fetchLocalNearestCentres() async {
    final _pref = await SharedPreferences.getInstance();
    _nearbyCenter.clear();
    _nearbyCenter.addAll(
        centerResponseFromJson(_pref.getString(Constant.NEARBY_CENTERS))
            .centers);
    final districtIds = await HomeRepo.instance.getDistrictIds(_nearbyCenter);
    print(districtIds);
    _alert.districtId = districtIds;
    return _nearbyCenter;
  }

  Future<Alert> _getCreatedAlert() async {
    final _pref = await SharedPreferences.getInstance();
    try {
      return alertFromJson(_pref.getString(Constant.CREATED_ALERT));
    } catch (e) {
      return _alert;
    }
  }

  Future<bool> _createNewAlert() async {
    try{
      final reqJson = alertToJson(_alert);
      print(reqJson);
      SharedPreferences.getInstance().then((pref) {
        pref.setString(Constant.CREATED_ALERT, reqJson);
        pref.setBool(Constant.IS_ALERT_ACTIVE, true);
      });
      setState(() {
        _isAlertActive = true;
      });
      return true;
    }catch(e){
      return false;
    }

  }
}
