import 'dart:async';
import 'dart:math';
import 'package:automated_coin_detector/model/coin_model.dart';
import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';

enum RandomCoinGenerateEvent { getNewCoin }

class CoinBloc extends Bloc<RandomCoinGenerateEvent, List<Coin>> {
  var uuid = Uuid();

  final _random = new Random();

  // Real and Fake coin types are added to this coin_type list
  List<Coin> coin_type = [
    Coin(id: "1", value: "Real", timestamp: DateTime.now().toUtc()),
    Coin(id: "2", value: "Fake", timestamp: DateTime.now().toUtc())
  ];
  List<Coin> coin_names = [];

  @override
  List<Coin> get initialState => [];

  @override
  Stream<List<Coin>> mapEventToState(RandomCoinGenerateEvent event) async* {
    switch (event) {
      //Once getNewCoin is triggered a random index value is taken from the coin_type list & that object is added to coin_names list & yield to the UI
      case RandomCoinGenerateEvent.getNewCoin:
        var element = coin_type[_random.nextInt(coin_type.length)];
        coin_names.add(Coin(
            id: "12", value: element.value, timestamp: DateTime.now().toUtc()));
        print("current coin list :  ${coin_names}");
        yield coin_names.toList();
        break;
    }
  }
}
