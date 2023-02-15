import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getTokenFromStorage() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('token') != null) {
    return prefs.getString('token');
  } else
    print('gettokennull');
  return null;
}
