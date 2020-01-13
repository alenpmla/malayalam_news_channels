import 'dart:convert';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:http/http.dart' as http;
import 'package:malayalam_live_news_channels/model/hashgroup.dart';
import 'package:youtube_player/youtube_player.dart';

import 'constants.dart';

class _HomePage extends State<HomePage> with WidgetsBindingObserver {
  List<ChannelItem> channelItem = new List();
  bool adShown = true;
  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>[
      'oldpeople',
      'insurance',
      'agedpeople',
      'agriculture',
      'india',
      'kerala',
      'economy',
      'health care',
      'car loan',
      'housing loan',
      'pension plan',
      'bank',
      'diet',
      'sugar free',
      'share market',
      'trading',
      'medicines',
      'ayurveda',
      'yoga',
      'current affairs',
      'politics'
    ],
    childDirected: false,
    testDevices: <String>[
      "DEVICE_ID_EMULATOR",
      "cecc0612aa7e985d",
      "86b4fc0a9cfda365",
      "091960031BA6E7BEA19460085A8D905B"
    ],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Malayalam News Channels',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
            color: Colors.grey[100],
            child: new FutureBuilder(
                future: loadAsset(),
                builder: (context, snapshot) {
                  return gotDataAction(snapshot, context);
                })));
  }

  Widget gotDataAction(AsyncSnapshot snapshot, BuildContext context) {
    //debugPrint("populating data");
    channelItem.clear();
    if (snapshot.hasData) {
      //debugPrint("Data - " + snapshot.data.toString());
      var data = json.decode(snapshot.data);
      var rest = data["channels"];
      for (var model in rest) {
        channelItem.add(new ChannelItem.fromJson(model));
      }
      return Center(
          child: Column(
        children: <Widget>[
          Expanded(
            flex: 10,
            child: buildCategoriesGridView(context, channelItem),
          ),
          adShown
              ? Expanded(
                  flex: 2,
                  child: AdmobBanner(
                    adUnitId: getBannerAdUnitId(),
                    adSize: AdmobBannerSize.LARGE_BANNER,
                    listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                      switch (event) {
                        case AdmobAdEvent.loaded:
                          print('Admob banner loaded!');
                          break;

                        case AdmobAdEvent.opened:
                          print('Admob banner opened!');
                          break;

                        case AdmobAdEvent.closed:
                          print('Admob banner closed!');
                          break;

                        case AdmobAdEvent.failedToLoad:
                          adShown = false;
                          setState(() {});
                          print(
                              'Admob banner failed to load. Error code: ${args['errorCode']}');
                          break;
                        case AdmobAdEvent.clicked:
                          // TODO: Handle this case.
                          break;
                        case AdmobAdEvent.impression:
                          // TODO: Handle this case.
                          break;
                        case AdmobAdEvent.leftApplication:
                          // TODO: Handle this case.
                          break;
                        case AdmobAdEvent.completed:
                          // TODO: Handle this case.
                          break;
                        case AdmobAdEvent.rewarded:
                          // TODO: Handle this case.
                          break;
                        case AdmobAdEvent.started:
                          // TODO: Handle this case.
                          break;
                      }
                    },
                  ),
                )
              : Text("")
        ],
      ));
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  GridView buildCategoriesGridView(
      BuildContext context, List<ChannelItem> channelItems) {
    return GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(channelItems.length, (index) {
          return getCategoryItem(context, channelItems[index]);
        }));
  }

  Card getCategoryItem(BuildContext context, ChannelItem channelItem) {
    return Card(
        color: Colors.white,
        child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              categoryItemPressed(context, channelItem);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                  flex: 8,
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: new CachedNetworkImage(
                        fit: BoxFit.contain,
                        height: 100,
                        placeholder: (context, url) => new Image.asset(
                            "assets/place.png",
                            fit: BoxFit.fitWidth),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                        imageUrl: channelItem.imageurl,
                      ),
                    ),
                  ),
                ),
                new Expanded(
                    flex: 2,
                    child: Container(
                      height: 25,
                      child: Center(
                          child: Text(
                        channelItem.name,
                        style: styleCardTextCat,
                      )),
                    )),
              ],
            )));
  }

  Future<String> loadAsset() async {
    //debugPrint("Loading Assests");
    var data;
    final response = await http
        .get('https://instatag-896dd.firebaseapp.com/allchannels.html');
    if (response.statusCode == 200) {
      data = response.body;
      //debugPrint("Fetched data" +data.toString());
    } else {
      debugPrint("Fetching data failed");
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
    //return await rootBundle.loadString('assets/tags.json');
    return data.toString();
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePage();
  }
}

class _ChannelPlayingScreen extends State<ChannelPlayingScreen> {
  ChannelItem channelItem;
  VideoPlayerController _videoController;
  static bool _adShown = false;
  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>[
      'oldpeople',
      'insurance',
      'agedpeople',
      'agriculture',
      'india',
      'kerala',
      'economy',
      'health care',
      'car loan',
      'housing loan',
      'pension plan',
      'bank',
      'diet',
      'sugar free',
      'share market',
      'trading',
      'medicines',
      'ayurveda',
      'yoga',
      'current affairs',
      'politics'
    ],
    childDirected: false,
    testDevices: <String>[
      "DEVICE_ID_EMULATOR",
      "cecc0612aa7e985d",
      "86b4fc0a9cfda365",
      "091960031BA6E7BEA19460085A8D905B"
    ],
  );

  InterstitialAd myInterstitial = InterstitialAd(
    adUnitId: getInterStetialAdId(),
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
      if (event == MobileAdEvent.loaded) {
        debugPrint("Ad----loaded");
        _adShown = true;
      } else if (event == MobileAdEvent.failedToLoad) {
        debugPrint("Ad----failed");
        _adShown = false;
      }
    },
  );

  @override
  void initState() {
    myInterstitial..load();
  }

  @override
  void dispose() {
    print("Dispose called channel playing screen");
    _videoController.pause();
    if (_adShown) {
      myInterstitial
        ..show(
          anchorType: AnchorType.bottom,
          anchorOffset: 0.0,
        );
    }
    super.dispose();
  }

  _ChannelPlayingScreen(ChannelItem hashgroup) {
    channelItem = hashgroup;
    print("Construct ChannelPlayingScreen Received - " + channelItem.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(channelItem.name),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.favorite_border),
              tooltip: 'Rate App',
              onPressed: () {
                launchThisAppInPlayStore();
              },
            ),
          ],
        ),
        body: Builder(
          builder: (context) => Container(
            color: Colors.black,
            child: Center(
                child: YoutubePlayer(
                    context: context,
                    source: channelItem.sourceUrl,
                    quality: YoutubeQuality.MEDIUM,
                    isLive: true,
                    showVideoProgressbar: false,
                    showThumbnail: true,
                    hideShareButton: true,
                    onError: (test) {
                      print("Error occured while trying to play -- " + test);
                    },
                    startFullScreen: true,
                    callbackController: (controller) {
                      _videoController = controller;
                    })),
          ),
        ));
  }

  void launchThisAppInPlayStore() {
    AppAvailability.launchApp("hashtag.codme.instatag");
  }

  getBannerAdUnitId() {
    return "ca-app-pub-9079381335168661/5979550451";
  }
}

class ChannelPlayingScreen extends StatefulWidget {
  ChannelItem hashGroup;

  ChannelPlayingScreen(ChannelItem hashgroup) {
    hashGroup = hashgroup;
    print("Construct ChannelPlayingScreen Received - " + hashGroup.name);
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChannelPlayingScreen(hashGroup);
  }
}

getBannerAdUnitId() {
  return "ca-app-pub-9079381335168661/5979550451";
}

getInterStetialAdId() {
  return "ca-app-pub-9079381335168661/8959623936";
}

categoryItemPressed(BuildContext context, ChannelItem hashgroup) {
  Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => ChannelPlayingScreen(hashgroup)));
}
