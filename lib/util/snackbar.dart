import 'package:flutter/material.dart';

import '../util/theme.dart';

void showSnackbar(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style:
            Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white,
                fontSize: Theme.of(context)
                    .textTheme
                    .bodyText1.fontSize),
      ),
      backgroundColor: AppColor.BLUE_900,
      duration: Duration(seconds: 1),
    ),
  );
}

void snackBarWithAction(BuildContext context, String message,
    {String actionText = 'Ok',
    Function dismissCallback,
    Function actionHandler}) {
  Scaffold.of(context)
      .showSnackBar(
        SnackBar(
          margin: EdgeInsets.all(10),
          content: Text(
            message,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Colors.white,
                fontSize: Theme.of(context)
                    .textTheme
                    .bodyText1.fontSize),
          ),
          action: SnackBarAction(
            label: actionText,
            textColor: AppColor.BLUE_200,
            onPressed: () {
              if(actionHandler!=null){
                actionHandler();
              }
            },
          ),
          backgroundColor: AppColor.BLUE_900,
          behavior: SnackBarBehavior.floating,
          elevation: 5.0,
        ),
      ).closed.then((value) => dismissCallback());
}
