import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:malayalam_live_news_channels/view/scaleroute.dart';

import 'constants.dart';
import 'homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("SplashScreen Init");
    Future.delayed(const Duration(milliseconds: 2000), () {
// Here you can write your code

      setState(() {
        // Here you can write your code for open new view

        Navigator.pushAndRemoveUntil(context, ScaleRoute(page: HomePage()),
            ModalRoute.withName("/_Home"));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          // Add box decoration
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Center(
                    child: Text(titleString, style: splashScreenTitle),
                  ),
                ),
                Container(
                  padding: paddingSubtitle,
                  child: Text(subtitleString, style: splashScreenSubTitle),
                ),
              ],
            ),
          ),
        ));
  }
}
