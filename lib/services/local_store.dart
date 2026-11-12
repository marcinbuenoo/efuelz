import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fill_up.dart';
import '../models/vehicle.dart';

class LocalStore {
  static const _vehicleKey = 'vehicle';
  static const _fillsKey = 'fills';

  Future<(Vehicle?, List<FillUp>)> load() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final vehicleJson = prefs.getString(_vehicleKey);
      final vehicle = vehicleJson == null
          ? null
          : Vehicle.fromJson(jsonDecode(vehicleJson) as Map<String, dynamic>);
      final fillJson = jsonDecode(prefs.getString(_fillsKey) ?? '[]') as List;
      final fills = fillJson
          .map((item) => FillUp.fromJson(item as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
      return (vehicle, fills);
    } catch (_) {
      return (null, <FillUp>[]);
    }
  }

  Future<void> save(Vehicle? vehicle, List<FillUp> fills) async {
    final prefs = await SharedPreferences.getInstance();
    if (vehicle == null) {
      await prefs.remove(_vehicleKey);
      await prefs.remove(_fillsKey);
      return;
    }
    await prefs.setString(_vehicleKey, jsonEncode(vehicle.toJson()));
    await prefs.setString(
      _fillsKey,
      jsonEncode(fills.map((fill) => fill.toJson()).toList()),
    );
  }
}
