import 'package:flutter/material.dart';

enum ContentKind { theme, widget, wallpaper }

class Category {
  final String id;
  final String name;
  const Category(this.id, this.name);
}

class Wallpaper {
  final String id, name, category, asset;
  final bool isPremium, isSaved;
  final List<Color> colors;
  final int motif;
  const Wallpaper({required this.id, required this.name, required this.category, required this.asset, required this.colors, this.motif = 0, this.isPremium = false, this.isSaved = false});
}

class WidgetItem {
  final String id, name, type, size, previewStyle, category;
  final bool isPremium, isSaved;
  const WidgetItem({required this.id, required this.name, required this.type, required this.size, required this.previewStyle, required this.category, this.isPremium = false, this.isSaved = false});
}

class ThemeItem {
  final String id, name, description, thumbnail, wallpaper, category;
  final List<String> widgetIds;
  final bool featured, isPremium, isSaved;
  const ThemeItem({required this.id, required this.name, required this.description, required this.thumbnail, required this.wallpaper, required this.widgetIds, required this.category, this.featured = false, this.isPremium = false, this.isSaved = false});
}
