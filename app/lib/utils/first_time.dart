// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

const String firstLaunchKey = 'first_launch';

Future<bool> isFirstLaunch() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool(firstLaunchKey) ?? true;
  return isFirstLaunch;
}

Future<void> markAlreadyLaunched() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(firstLaunchKey, false);
}
