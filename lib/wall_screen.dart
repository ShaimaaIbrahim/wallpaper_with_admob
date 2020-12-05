import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/full_screen.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice ="";

class WallScreen extends StatefulWidget {

  @override
  _WallScreenState createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {

  //admob banner
  static final  MobileAdTargetingInfo targetingInfo = new MobileAdTargetingInfo(
    testDevices: <String> [] ,
    keywords: <String>['wallpaper', 'photos' ],
    birthday: DateTime.now(),
    childDirected: true,
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd showBannerAdd(){
   return BannerAd(adUnitId: "ca-app-pub-4281229696627015/3865972093",
       size: AdSize.banner ,
       targetingInfo: targetingInfo,
       listener: (MobileAdEvent event){
       print("banner event $event");
   }
   );
  }
   InterstitialAd showInterstitialAdd(){
    return InterstitialAd(adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
          print("banner event $event");
        }
    );
  }

  //datasnapshot firebase
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpapersList;
  final CollectionReference reference =
      Firestore.instance.collection("wallpapers");

  @override
  void initState() {
    super.initState();

    //admob instance
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-4281229696627015~9118298774");

    //start show banner ad
    _bannerAd = showBannerAdd()..load()..show();


    //update list with snapshots....
    subscription = reference.snapshots().listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.documents;
      });
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();

    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("wallpaper"),
        ),
        body: wallpapersList != null
            ? new StaggeredGridView.countBuilder(
                padding: const EdgeInsets.all(8),
                crossAxisCount: 4,
                itemBuilder: (context, i) {
                  String imagePath = wallpapersList[i].data()["url"].toString();
                  return Material(
                    elevation: 8,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: InkWell(
                      onTap: (){
                        //show interstitial ad
                        showInterstitialAdd()..load()..show();
                        Navigator.push(context , MaterialPageRoute(
                          builder: (context){
                            return FullScreenImage(imagePath: imagePath,);

                          }
                        ));
                      },
                      child: Hero(
                          tag: imagePath,
                          child: FadeInImage(
                            image: NetworkImage(imagePath),
                            placeholder: AssetImage("assets/place.jpg"),
                            fit: BoxFit.cover,
                          )),
                    ),
                  );
                },
                staggeredTileBuilder: (i) =>
                    StaggeredTile.count(2, i.isEven ? 2 : 3),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
