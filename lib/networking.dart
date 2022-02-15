import 'dart:convert';

import 'package:http/http.dart' as http;

const String apikey = '73D20E05-222E-4512-B4AB-D1C665C45976';
const String baseUrl = 'https://rest.coinapi.io/v1/exchangerate/';

class Networking {
  Future getCoinData(String? currency, String coin) async {
    http.Response response =
        await http.get(Uri.parse('$baseUrl$coin/$currency?apikey=$apikey'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  }
}
