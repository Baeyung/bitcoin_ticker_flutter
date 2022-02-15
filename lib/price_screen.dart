import 'package:bitcoin_ticker_flutter/coin_data.dart';
import 'package:bitcoin_ticker_flutter/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  void initState() {
    super.initState();
    getContentsFromApi();
  }

  String? selectedCurrency = 'USD';
  double btcRate = 0;
  double ethRate = 0;
  double ltcRate = 0;
  void getContentsFromApi() async {
    List<dynamic> coinDetails = [];
    for (String coin in cryptoList) {
      dynamic details = await Networking().getCoinData(selectedCurrency, coin);
      coinDetails.add(details);
    }
    updateUi(coinDetails);
  }

  void updateUi(List<dynamic> coinDetails) {
    setState(() {
      btcRate = coinDetails[0]["rate"];
      ethRate = coinDetails[1]["rate"];
      ltcRate = coinDetails[2]["rate"];
    });
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> currencyList = [];
    for (String currency in currenciesList) {
      currencyList.add(
        DropdownMenuItem(
          child: Text(currency),
          value: currency,
        ),
      );
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: currencyList,
      onChanged: (value) async {
        selectedCurrency = value;
        getContentsFromApi();
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(
        Text(currency),
      );
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (index) {
        selectedCurrency = currenciesList.elementAt(index);
      },
      children: pickerItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CurrencyCard(
                    rate: btcRate, coin: 'BTC', currency: selectedCurrency),
                CurrencyCard(
                    rate: ethRate, coin: 'ETH', currency: selectedCurrency),
                CurrencyCard(
                    rate: ltcRate, coin: 'LTC', currency: selectedCurrency),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CurrencyCard extends StatelessWidget {
  final String? currency;
  final String coin;
  final double rate;
  const CurrencyCard({
    required this.rate,
    required this.coin,
    required this.currency,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $coin = $rate $currency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
