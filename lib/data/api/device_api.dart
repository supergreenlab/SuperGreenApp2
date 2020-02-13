import 'package:http/http.dart';
import 'package:multicast_dns/multicast_dns.dart';

class DeviceAPI {
  static Future<String> resolveLocalName(String name) async {
    name = '${name.toLowerCase()}.local';
    final MDnsClient client = MDnsClient();
    await client.start();

    String foundIP;
    await for (IPAddressResourceRecord record
        in client.lookup<IPAddressResourceRecord>(
            ResourceRecordQuery.addressIPv4(name))) {
      foundIP = record.address.address;
      break;
    }
    client.stop();
    return foundIP;
  }

  static Future<String> fetchConfig(String controllerIP) async {
    Response r = await get('http://$controllerIP/fs/config.json');
    return r.body;
  }

  static Future<String> fetchStringParam(
      String controllerIP, String paramName) async {
    Response r = await get('http://$controllerIP/s?k=${paramName.toUpperCase()}');
    return r.body;
  }

  static Future<int> fetchIntParam(
      String controllerIP, String paramName) async {
    Response r = await get('http://$controllerIP/i?k=${paramName.toUpperCase()}');
    return int.parse(r.body);
  }

  static Future<String> setStringParam(
      String controllerIP, String paramName, String value) async {
    await post('http://$controllerIP/s?k=${paramName.toUpperCase()}&v=$value');
    return fetchStringParam(controllerIP, paramName);
  }

  static Future<int> setIntParam(
      String controllerIP, String paramName, int value) async {
    await post('http://$controllerIP/i?k=${paramName.toUpperCase()}&v=$value');
    return fetchIntParam(controllerIP, paramName);
  }

}
