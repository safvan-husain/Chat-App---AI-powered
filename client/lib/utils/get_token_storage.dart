import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getTokenFromStorage() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}
