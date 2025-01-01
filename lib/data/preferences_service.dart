import 'package:hive/hive.dart';

class PreferencesService {
  static const String _prefsBox = 'preferences';

  static const String _sortOrderKey = 'sortOrder';

  Future<void> setSortOrder(String order) async {
    final box = Hive.box(_prefsBox);
    await box.put(_sortOrderKey, order);
  }

  Future<String> getSortOrder() async {
    final box = Hive.box(_prefsBox);
    return box.get(_sortOrderKey, defaultValue: 'dueDate');
  }
}
