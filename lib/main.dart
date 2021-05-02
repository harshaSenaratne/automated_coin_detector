import 'dart:async';

import 'package:automated_coin_detector/components/reusable_card.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'coin_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider<CoinBloc>(
        builder: (context) => CoinBloc(),
        child:  MyHomePage(title: 'Automated Coin Genarator'),
      ),

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer timer;
  final String coinValue =  "Real";
  //
  // Future<AudioPlayer> playLocalAsset() async {
  //   print("playLocalAsset");
  //   AudioCache cache = new AudioCache();
  //   return await cache.play("customsoundeffect.mp3");
  // }

  AudioCache audioCache = AudioCache();

  playAudio(){
    audioCache.load("customsoundeffect.mp3");
    audioCache.play("customsoundeffect.mp3");
  }

  @override
  Widget build(BuildContext context) {
    final CoinBloc coinBloc = BlocProvider.of<CoinBloc>(context);

    Timer.periodic(Duration(seconds: 5), (timer) => coinBloc.add(RandomCoinGenerateEvent.getNewCoin)) ;



    return Scaffold(
      appBar: AppBar(title:
        BlocBuilder<CoinBloc, List<String>>(
          builder:(context, count) {
           count.length>0 && count[count.length-1] == coinValue ?  playAudio():null;

            return  Text(count.length == 0 ? "" :count[count.length-1] );

          } ,
        )

      ),
      body: BlocBuilder<CoinBloc, List<String>>(
        builder: (context, count) {
          List <String> coins = count;
          return
            ListView.separated(
              itemCount: coins == null ? 0 : coins.length,
              itemBuilder: (BuildContext context, int index){
                return
                  ReusableCard(
                    cardChild:  Text(coins[index]),
                  );
              },
              separatorBuilder: (context,index) => Divider(),
            );
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: playAudio
            ),
          ),

        ],
      ),
    );
  }
}
