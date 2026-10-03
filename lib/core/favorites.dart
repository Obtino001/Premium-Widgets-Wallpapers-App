import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/content.dart';

class Favorites extends ChangeNotifier {
  static const _key = 'form.saved.v1';
  final Set<String> _ids = {};
  bool loaded = false;

  String keyFor(ContentKind kind, String id) => '${kind.name}:$id';
  bool contains(ContentKind kind, String id) => _ids.contains(keyFor(kind, id));
  bool get isEmpty => _ids.isEmpty;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _ids.addAll(prefs.getStringList(_key) ?? const []);
    loaded = true;
    notifyListeners();
  }

  Future<void> toggle(ContentKind kind, String id) async {
    final key = keyFor(kind, id);
    if (!_ids.add(key)) _ids.remove(key);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _ids.toList());
  }
}
