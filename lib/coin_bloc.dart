import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';

enum RandomCoinGenerateEvent { getNewCoin }

class CoinBloc extends Bloc<RandomCoinGenerateEvent, List<String>> {

  final _random = new Random();
  List <String> coin_type = ["Real", "Fake",];
  List<String> coin_names = [];

  @override
  List<String> get initialState => [];

  @override
  Stream<List<String>> mapEventToState(RandomCoinGenerateEvent event) async* {
    switch (event) {
      case RandomCoinGenerateEvent.getNewCoin:
        var element = coin_type[_random.nextInt(coin_type.length)];
        coin_names.add(element);
        print("current coin list :  ${coin_names}");
       yield coin_names.toList();
        break;

    }
  }





}