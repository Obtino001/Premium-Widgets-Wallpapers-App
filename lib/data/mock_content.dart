import 'package:flutter/material.dart';
import '../models/content.dart';

class MockContent {
  static const categories = <Category>[
    Category('for-you', 'For You'), Category('minimal', 'Minimal'), Category('dark', 'Dark'),
    Category('nature', 'Nature'), Category('color', 'Color'), Category('photography', 'Photography'),
    Category('abstract', 'Abstract'), Category('architecture', 'Architecture'),
  ];

  static const wallpapers = <Wallpaper>[
    Wallpaper(id: 'dawn', name: 'Morning Haze', category: 'Minimal', asset: 'local:morning-haze', colors: [Color(0xFFE9DDCB), Color(0xFFF6F0E7), Color(0xFFC7B49A)], motif: 1),
    Wallpaper(id: 'nocturne', name: 'Nocturne', category: 'Dark', asset: 'local:nocturne', colors: [Color(0xFF1E2831), Color(0xFF536479), Color(0xFF12171D)], motif: 2),
    Wallpaper(id: 'moss', name: 'Mosslight', category: 'Nature', asset: 'local:mosslight', colors: [Color(0xFF32483A), Color(0xFF8A9A78), Color(0xFFE4DCC1)], motif: 3),
    Wallpaper(id: 'paper', name: 'Soft Paper', category: 'Minimal', asset: 'local:soft-paper', colors: [Color(0xFFF1E9DB), Color(0xFFD2BFA9), Color(0xFFFCF8EF)], motif: 4),
    Wallpaper(id: 'stone', name: 'Stone Study', category: 'Architecture', asset: 'local:stone-study', colors: [Color(0xFFB7B5AC), Color(0xFFE5E2D9), Color(0xFF898B83)], motif: 5),
    Wallpaper(id: 'blue', name: 'Blue Hour', category: 'Abstract', asset: 'local:blue-hour', colors: [Color(0xFFB9C9D7), Color(0xFF718FA7), Color(0xFFE4E9E7)], motif: 2),
    Wallpaper(id: 'clay', name: 'Warm Current', category: 'Color', asset: 'local:warm-current', colors: [Color(0xFFD0A58F), Color(0xFFF0D5BB), Color(0xFFB6786D)], motif: 1),
    Wallpaper(id: 'arch', name: 'Still Forms', category: 'Architecture', asset: 'local:still-forms', colors: [Color(0xFFD7CDBD), Color(0xFF998F82), Color(0xFFF1E9DC)], motif: 5),
    Wallpaper(id: 'nightfall', name: 'Nightfall', category: 'Dark', asset: 'local:nightfall', colors: [Color(0xFF302E36), Color(0xFF6A6272), Color(0xFF15171C)], motif: 3),
  ];

  static const widgets = <WidgetItem>[
    WidgetItem(id: 'minimal-clock', name: 'Minimal Clock', type: 'clock', size: '2 × 2', previewStyle: 'light', category: 'Clock'),
    WidgetItem(id: 'daily-date', name: 'Daily Date', type: 'calendar', size: '2 × 1', previewStyle: 'sand', category: 'Calendar'),
    WidgetItem(id: 'photo-frame', name: 'Photo Frame', type: 'photo', size: '2 × 2', previewStyle: 'sage', category: 'Photo'),
    WidgetItem(id: 'battery-ring', name: 'Battery Ring', type: 'battery', size: '2 × 2', previewStyle: 'dark', category: 'Battery'),
    WidgetItem(id: 'countdown', name: 'Countdown', type: 'countdown', size: '2 × 1', previewStyle: 'blue', category: 'Countdown'),
    WidgetItem(id: 'week-view', name: 'Week View', type: 'week', size: '4 × 1', previewStyle: 'light', category: 'Calendar'),
    WidgetItem(id: 'quote', name: 'Quote', type: 'quote', size: '2 × 2', previewStyle: 'sand', category: 'Other'),
    WidgetItem(id: 'digital-clock', name: 'Digital Clock', type: 'digital', size: '4 × 1', previewStyle: 'dark', category: 'Clock'),
  ];

  static const themes = <ThemeItem>[
    ThemeItem(id: 'quiet-morning', name: 'Quiet Morning', description: 'A calm neutral setup built for slow starts.', thumbnail: 'local:quiet-morning', wallpaper: 'dawn', widgetIds: ['minimal-clock', 'daily-date', 'battery-ring'], category: 'Minimal', featured: true),
    ThemeItem(id: 'midnight', name: 'Midnight', description: 'A quietly dramatic look for after dark.', thumbnail: 'local:midnight', wallpaper: 'nocturne', widgetIds: ['digital-clock', 'week-view', 'battery-ring'], category: 'Dark'),
    ThemeItem(id: 'forest', name: 'Forest', description: 'A little more room to breathe, inspired by nature.', thumbnail: 'local:forest', wallpaper: 'moss', widgetIds: ['minimal-clock', 'daily-date', 'photo-frame'], category: 'Nature'),
    ThemeItem(id: 'paper', name: 'Paper', description: 'Warm texture and an uncluttered point of view.', thumbnail: 'local:paper', wallpaper: 'paper', widgetIds: ['minimal-clock', 'quote', 'week-view'], category: 'Minimal'),
    ThemeItem(id: 'stone', name: 'Stone', description: 'Soft architectural shapes in balanced neutrals.', thumbnail: 'local:stone', wallpaper: 'stone', widgetIds: ['digital-clock', 'daily-date', 'battery-ring'], category: 'Architecture'),
    ThemeItem(id: 'soft-blue', name: 'Soft Blue', description: 'A fresh, clear feeling for everyday moments.', thumbnail: 'local:soft-blue', wallpaper: 'blue', widgetIds: ['minimal-clock', 'week-view', 'countdown'], category: 'Color'),
  ];

  static Wallpaper wallpaper(String id) => wallpapers.firstWhere((x) => x.id == id);
  static WidgetItem widget(String id) => widgets.firstWhere((x) => x.id == id);
}
