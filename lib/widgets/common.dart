import 'package:flutter/material.dart';
import '../core/design.dart';
import '../core/favorites.dart';
import '../data/mock_content.dart';
import '../models/content.dart';
import 'visuals.dart';

class PillStrip extends StatelessWidget {
  final List<String> items;
  final String selected;
  final ValueChanged<String> onSelected;
  const PillStrip({super.key, required this.items, required this.selected, required this.onSelected});
  @override
  Widget build(BuildContext context) => SizedBox(height: 48, child: ListView.separated(
    padding: const EdgeInsets.symmetric(horizontal: Space.lg), scrollDirection: Axis.horizontal,
    itemCount: items.length, separatorBuilder: (_, _) => const SizedBox(width: 8),
    itemBuilder: (_, i) { final item = items[i]; final active = item == selected; return ChoiceChip(
      label: Text(item), selected: active, onSelected: (_) => onSelected(item),
      showCheckmark: false, side: BorderSide.none,
      backgroundColor: AppColors.secondary, selectedColor: AppColors.ink,
      labelStyle: TextStyle(color: active ? Colors.white : AppColors.ink, fontWeight: FontWeight.w500, fontSize: 13),
      shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 10),
    ); },
  ));
}

class SectionHeading extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const SectionHeading({super.key, required this.title, this.onSeeAll});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(horizontal: Space.lg), child: Row(children: [Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)), if (onSeeAll != null) TextButton(onPressed: onSeeAll, child: const Text('See all', style: TextStyle(color: AppColors.muted)))]));
}

class FavoriteButton extends StatelessWidget {
  final Favorites favorites;
  final ContentKind kind;
  final String id;
  final bool onDark;
  const FavoriteButton({super.key, required this.favorites, required this.kind, required this.id, this.onDark = false});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: favorites, builder: (_, _) {
    final saved = favorites.contains(kind, id);
    return IconButton(
      tooltip: saved ? 'Remove from saved' : 'Save', onPressed: () => favorites.toggle(kind, id),
      style: IconButton.styleFrom(backgroundColor: onDark ? Colors.white.withValues(alpha: .86) : AppColors.white, minimumSize: const Size(44, 44)),
      icon: AnimatedSwitcher(duration: const Duration(milliseconds: 200), transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child), child: Icon(saved ? Icons.favorite_rounded : Icons.favorite_border_rounded, key: ValueKey(saved), color: saved ? const Color(0xFFB7746F) : AppColors.ink, size: 21)),
    );
  });
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool secondary;
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.secondary = false});
  @override
  Widget build(BuildContext context) => SizedBox(height: 56, width: double.infinity, child: FilledButton(
    onPressed: onPressed,
    style: FilledButton.styleFrom(backgroundColor: secondary ? AppColors.secondary : AppColors.ink, foregroundColor: AppColors.ink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RadiusSize.button))),
    child: Text(label, style: TextStyle(color: secondary ? AppColors.ink : Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
  ));
}

Future<void> showPhaseSheet(BuildContext context, String message) => showModalBottomSheet<void>(
  context: context, backgroundColor: AppColors.ivory, showDragHandle: true,
  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
  builder: (context) => SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(24, 12, 24, 28), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Icon(Icons.auto_awesome_outlined, size: 27, color: AppColors.sage),
    const SizedBox(height: 18), Text('Coming soon', style: Theme.of(context).textTheme.headlineMedium),
    const SizedBox(height: 8), Text(message, style: Theme.of(context).textTheme.bodyMedium),
    const SizedBox(height: 24), PrimaryButton(label: 'Got it', onPressed: () => Navigator.pop(context)),
  ]))),
);

class WidgetCard extends StatelessWidget {
  final WidgetItem item;
  final Favorites favorites;
  final VoidCallback onTap;
  final double width;
  const WidgetCard({super.key, required this.item, required this.favorites, required this.onTap, this.width = 170});
  @override
  Widget build(BuildContext context) => SizedBox(width: width, child: GestureDetector(onTap: onTap, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    AspectRatio(aspectRatio: 1, child: Stack(children: [Positioned.fill(child: WidgetPreview(item: item)), Positioned(top: 5, right: 5, child: FavoriteButton(favorites: favorites, kind: ContentKind.widget, id: item.id))])),
    const SizedBox(height: 10), Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
    const SizedBox(height: 2), Text(item.size, style: Theme.of(context).textTheme.bodySmall),
  ])));
}

class ThemeCard extends StatelessWidget {
  final ThemeItem item;
  final Favorites favorites;
  final VoidCallback onTap;
  final double width;
  const ThemeCard({super.key, required this.item, required this.favorites, required this.onTap, this.width = 220});
  @override
  Widget build(BuildContext context) {
    final wallpaper = MockContent.wallpaper(item.wallpaper);
    return SizedBox(width: width, child: GestureDetector(onTap: onTap, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AspectRatio(aspectRatio: .77, child: ClipRRect(borderRadius: BorderRadius.circular(RadiusSize.card), child: Stack(alignment: Alignment.center, children: [
        Positioned.fill(child: WallpaperArt(wallpaper: wallpaper)),
        Positioned(bottom: -39, child: PhonePreview(wallpaper: wallpaper, widgets: item.widgetIds.map(MockContent.widget).toList(), width: width * .58)),
        Positioned(top: 8, right: 8, child: FavoriteButton(favorites: favorites, kind: ContentKind.theme, id: item.id)),
      ]))),
      const SizedBox(height: 11), Text(item.name, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 2), Text('${item.widgetIds.length + 1} pieces · ${item.category}', style: Theme.of(context).textTheme.bodySmall),
    ])));
  }
}

class WallpaperCard extends StatelessWidget {
  final Wallpaper item;
  final Favorites favorites;
  final VoidCallback onTap;
  final double height;
  const WallpaperCard({super.key, required this.item, required this.favorites, required this.onTap, this.height = 240});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: ClipRRect(borderRadius: BorderRadius.circular(RadiusSize.small), child: SizedBox(height: height, child: Stack(children: [
    Positioned.fill(child: WallpaperArt(wallpaper: item)),
    Positioned(top: 7, right: 7, child: FavoriteButton(favorites: favorites, kind: ContentKind.wallpaper, id: item.id)),
    Positioned(left: 12, right: 12, bottom: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8), decoration: BoxDecoration(color: AppColors.white.withValues(alpha: .88), borderRadius: BorderRadius.circular(10)), child: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.ink)))),
  ]))));
}

class PageIntro extends StatelessWidget {
  final String title, subtitle;
  const PageIntro({super.key, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(24, 26, 24, 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 7), Text(subtitle, style: Theme.of(context).textTheme.bodySmall)]));
}
