import 'package:flutter/material.dart';
import '../core/design.dart';
import '../core/favorites.dart';
import '../data/mock_content.dart';
import '../models/content.dart';
import '../widgets/common.dart';
import '../widgets/visuals.dart';

class _DetailBar extends StatelessWidget {
  final Favorites favorites;
  final ContentKind kind;
  final String id;
  const _DetailBar({required this.favorites, required this.kind, required this.id});
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    IconButton(onPressed: () => Navigator.pop(context), tooltip: 'Back', style: IconButton.styleFrom(backgroundColor: AppColors.white, minimumSize: const Size(46, 46)), icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink)),
    FavoriteButton(favorites: favorites, kind: kind, id: id),
  ]);
}

class ThemeDetail extends StatelessWidget {
  final ThemeItem item;
  final Favorites favorites;
  const ThemeDetail({super.key, required this.item, required this.favorites});
  @override
  Widget build(BuildContext context) {
    final wallpaper = MockContent.wallpaper(item.wallpaper);
    final related = MockContent.themes.where((x) => x.id != item.id).take(3).toList();
    return Scaffold(body: SafeArea(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(24, 15, 24, 15), child: _DetailBar(favorites: favorites, kind: ContentKind.theme, id: item.id)),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: SizedBox(height: 420, width: double.infinity, child: ClipRRect(borderRadius: BorderRadius.circular(26), child: Stack(alignment: Alignment.center, children: [
        Positioned.fill(child: WallpaperArt(wallpaper: wallpaper)),
        Positioned(bottom: -42, child: PhonePreview(wallpaper: wallpaper, widgets: item.widgetIds.map(MockContent.widget).toList(), width: 225)),
      ])))),
      Padding(padding: const EdgeInsets.fromLTRB(24, 26, 24, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(item.name, style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 7), Text(item.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.muted)),
        const SizedBox(height: 30), Text('Includes', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 15),
        _IncludeRow(icon: Icons.image_outlined, title: 'Wallpaper', subtitle: wallpaper.name, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WallpaperDetail(item: wallpaper, favorites: favorites)))),
        for (final id in item.widgetIds) _IncludeRow(icon: Icons.widgets_outlined, title: MockContent.widget(id).name, subtitle: MockContent.widget(id).size, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WidgetDetail(item: MockContent.widget(id), favorites: favorites)))),
        const SizedBox(height: 25), PrimaryButton(label: 'Apply Theme', onPressed: () => showPhaseSheet(context, 'Theme application will be available in the next build.')),
        const SizedBox(height: 10), PrimaryButton(label: favorites.contains(ContentKind.theme, item.id) ? 'Saved' : 'Save', secondary: true, onPressed: () => favorites.toggle(ContentKind.theme, item.id)),
        const SizedBox(height: 34), Text('You may also like', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 16),
      ])),
      SizedBox(
        height: 350,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          itemCount: related.length,
          separatorBuilder: (_, _) => const SizedBox(width: 13),
          itemBuilder: (_, i) => ThemeCard(
            item: related[i],
            favorites: favorites,
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ThemeDetail(item: related[i], favorites: favorites)),
            ),
          ),
        ),
      ),
      const SizedBox(height: 30),
    ]))));
  }
}

class _IncludeRow extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  const _IncludeRow({required this.icon, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 9), child: Material(color: AppColors.white, borderRadius: BorderRadius.circular(RadiusSize.small), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(RadiusSize.small), child: Padding(padding: const EdgeInsets.all(13), child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(11)), child: Icon(icon, color: AppColors.ink)), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleMedium), Text(subtitle, style: Theme.of(context).textTheme.bodySmall)])), const Icon(Icons.chevron_right_rounded, color: AppColors.muted)])))));
}

class WidgetDetail extends StatefulWidget {
  final WidgetItem item;
  final Favorites favorites;
  const WidgetDetail({super.key, required this.item, required this.favorites});
  @override
  State<WidgetDetail> createState() => _WidgetDetailState();
}

class _WidgetDetailState extends State<WidgetDetail> {
  String appearance = 'Light';
  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(padding: const EdgeInsets.fromLTRB(24, 15, 24, 15), child: _DetailBar(favorites: widget.favorites, kind: ContentKind.widget, id: widget.item.id)),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Container(height: 345, width: double.infinity, alignment: Alignment.center, decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(26)), child: SizedBox(width: 245, height: widget.item.size == '4 × 1' ? 125 : 245, child: WidgetPreview(item: widget.item, appearance: appearance.toLowerCase())))),
    Padding(padding: const EdgeInsets.fromLTRB(24, 27, 24, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.item.name, style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 6), Text('${widget.item.category} widget', style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 32), Text('Appearance', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 15),
    ])),
    PillStrip(items: const ['Light', 'Dark', 'Sand', 'Sage'], selected: appearance, onSelected: (x) => setState(() => appearance = x)),
    Padding(padding: const EdgeInsets.fromLTRB(24, 28, 24, 35), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Widget size', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 10), Text(widget.item.size, style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: 35), PrimaryButton(label: 'Add Widget', onPressed: () => showPhaseSheet(context, 'Home-screen widgets will be available in the next build.')),
    ])),
  ]))));
}

class WallpaperDetail extends StatelessWidget {
  final Wallpaper item;
  final Favorites favorites;
  const WallpaperDetail({super.key, required this.item, required this.favorites});
  @override
  Widget build(BuildContext context) {
    final paired = MockContent.themes.where((x) => x.wallpaper == item.id).expand((x) => x.widgetIds).toSet().take(3).map(MockContent.widget).toList();
    final suggestions = paired.isEmpty ? MockContent.widgets.take(3).toList() : paired;
    return Scaffold(body: SafeArea(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: MediaQuery.sizeOf(context).height * .57, child: Stack(children: [Positioned.fill(child: WallpaperArt(wallpaper: item)), Positioned(top: 15, left: 24, right: 24, child: _DetailBar(favorites: favorites, kind: ContentKind.wallpaper, id: item.id))])),
      Padding(padding: const EdgeInsets.fromLTRB(24, 24, 24, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(item.name, style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 4), Text(item.category, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 26), Row(children: [Expanded(flex: 2, child: PrimaryButton(label: 'Set Wallpaper', onPressed: () => showPhaseSheet(context, 'Wallpaper setting will be available in the next build.'))), const SizedBox(width: 10), Expanded(child: PrimaryButton(label: 'Save', secondary: true, onPressed: () => favorites.toggle(ContentKind.wallpaper, item.id)))]),
        const SizedBox(height: 32), Text('Pairs well with', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 8), Text('Complete the look with a matching widget.', style: Theme.of(context).textTheme.bodySmall), const SizedBox(height: 16),
      ])),
      SizedBox(height: 224, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 24), scrollDirection: Axis.horizontal, itemCount: suggestions.length, separatorBuilder: (_, _) => const SizedBox(width: 13), itemBuilder: (_, i) => WidgetCard(item: suggestions[i], favorites: favorites, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WidgetDetail(item: suggestions[i], favorites: favorites)))))),
      const SizedBox(height: 32),
    ]))));
  }
}
