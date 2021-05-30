import 'package:findmyshot/model/alert.dart';
import 'package:findmyshot/model/centers.dart';
import 'package:findmyshot/util/constant.dart';
import 'package:findmyshot/util/theme.dart';
import 'package:flutter/material.dart';
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
  List<CenterData> _nearbyCenter = List();
  Alert _alert;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      _currentLat = value.getDouble(Constant.CURRENT_LAT) ?? 0.00;
      _currentLong = value.getDouble(Constant.CURRENT_LONG) ?? 0.00;
    });
    _getCreatedAlert().then((value) {
      setState(() {
        _alert = value;
      });
    });
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

  Widget _createAlertWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: 250,
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
            )
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
                      _alert == null
                          ? 'No alert created'
                          : 'Active alert is searching vaccination slot near',
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
    setState(() {
      _currentLat = userLocation.latitude;
      _currentLong = userLocation.longitude;
    });
    await _getNearestCentres(_currentLat, _currentLong);
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
    _nearbyCenter.addAll(
        centerResponseFromJson(_pref.getString(Constant.NEARBY_CENTERS))
            .centers);
    return _nearbyCenter;
  }

  Future<Alert> _getCreatedAlert() async {
    final _pref = await SharedPreferences.getInstance();
    return alertFromJson(_pref.getString(Constant.CREATED_ALERT));
  }
}
