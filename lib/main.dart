import 'dart:async';

import 'package:automated_coin_detector/components/reusable_card.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/coin_bloc.dart';
import 'model/coin_model.dart';

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

  UniqueKey keyTile;
  bool isExpanded = false;


  AudioCache audioCache = AudioCache();

  playAudio(){
    audioCache.load("customsoundeffect.mp3");
    audioCache.play("customsoundeffect.mp3");
  }

  void expandTile() {
    setState(() {
      isExpanded = true;
      keyTile = UniqueKey();
    });
  }

  void shrinkTile() {
    setState(() {
      isExpanded = false;
      keyTile = UniqueKey();
    });
  }

  Widget buildTile({BuildContext context, String value, DateTime timestamp}) => Theme(
    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      key: keyTile,
      initiallyExpanded: isExpanded,
      childrenPadding: EdgeInsets.all(16).copyWith(top: 0),
      title: Center(
        child: Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      children: [
        Text(
          "Timestamp : ${timestamp.toIso8601String()}",
          style: TextStyle(fontSize: 18, height: 1.4),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final CoinBloc coinBloc = BlocProvider.of<CoinBloc>(context);

    Timer.periodic(Duration(seconds: 5), (timer) => coinBloc.add(RandomCoinGenerateEvent.getNewCoin)) ;
    
    return Scaffold(
      appBar: AppBar(title:
        BlocBuilder<CoinBloc, List<Coin>>(
          builder:(context, count) {
           count.length>0 && count[count.length-1].value == coinValue ?  playAudio():null;
            return  Text(count.length == 0 ? "" :count[count.length-1].value );
          } ,
        )

      ),
      body: BlocBuilder<CoinBloc, List<Coin>>(
        builder: (context, count) {
          List <Coin> coins = count;
          return
            ListView.separated(
              itemCount: coins == null ? 0 : coins.length,
              itemBuilder: (BuildContext context, int index){
                return  buildTile(context: context,value: coins[index].value,timestamp: coins[index].timestamp);
              },
              separatorBuilder: (context,index) => Divider(),
            );
        },
      ),

    );
  }
}
