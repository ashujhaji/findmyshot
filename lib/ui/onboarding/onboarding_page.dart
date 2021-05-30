import 'package:findmyshot/util/constant.dart';
import 'package:findmyshot/util/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home_page.dart';

class OnBoardingPage extends StatelessWidget {
  static const TAG = 'OnBoardingTag';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/ic_onboarding.png',
                fit: BoxFit.fill,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Discover nearby vaccination center and stay updated when slot is available',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Get Started',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: AppColor.APP_COLOR),
                ),
              ),
              onTap: (){
                _openHomePage(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> _openHomePage(BuildContext context) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(Constant.IS_NEW_USER, false);
    Navigator.pushNamedAndRemoveUntil(
        context, HomePage.TAG, ModalRoute.withName(HomePage.TAG));
    return;
  }
}
