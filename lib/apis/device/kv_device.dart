import 'dart:convert';

import 'package:http/http.dart';
import 'package:multicast_dns/multicast_dns.dart';

class KVDevice {

  static Future<String> resolveLocalName(String name) async {
    final MDnsClient client = MDnsClient();
    await client.start();

    String foundIP;
    await for (IPAddressResourceRecord record in client
        .lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv4(name))) {
      foundIP = record.address.address;
      print('Found address (${record.address}).');
      break;
    }
    client.stop();
    return foundIP;
  }

  static Future<Map<String, dynamic>> fetchConfig(String controllerIP) async {
    Response r = await get("http://${controllerIP}/fs/config.json");
    return jsonDecode(r.body);
  }

  static Future<String> fetchStringParam(String controllerIP, String paramName) async {
    Response r = await get("http://${controllerIP}/s?k=${paramName}");
    return r.body;
  }
}