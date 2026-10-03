import 'package:flutter/material.dart';
import '../core/design.dart';
import '../core/favorites.dart';
import '../data/mock_content.dart';
import '../models/content.dart';
import '../widgets/common.dart';
import '../widgets/visuals.dart';
import 'details.dart';

class AppShell extends StatefulWidget {
  final Favorites favorites;
  const AppShell({super.key, required this.favorites});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int tab = 0;
  void openTheme(ThemeItem item) => Navigator.push(context, MaterialPageRoute(builder: (_) => ThemeDetail(item: item, favorites: widget.favorites)));
  void openWidget(WidgetItem item) => Navigator.push(context, MaterialPageRoute(builder: (_) => WidgetDetail(item: item, favorites: widget.favorites)));
  void openWallpaper(Wallpaper item) => Navigator.push(context, MaterialPageRoute(builder: (_) => WallpaperDetail(item: item, favorites: widget.favorites)));
  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: tab, children: [
      HomeScreen(favorites: widget.favorites, onTheme: openTheme, onWidget: openWidget, onWallpaper: openWallpaper, onTab: (x) => setState(() => tab = x)),
      WidgetsScreen(favorites: widget.favorites, onWidget: openWidget),
      WallpapersScreen(favorites: widget.favorites, onWallpaper: openWallpaper),
      SavedScreen(favorites: widget.favorites, onTheme: openTheme, onWidget: openWidget, onWallpaper: openWallpaper, onExplore: () => setState(() => tab = 0)),
    ]),
    bottomNavigationBar: SafeArea(top: false, child: Container(
      decoration: const BoxDecoration(color: AppColors.ivory, border: Border(top: BorderSide(color: Color(0xFFE6E3DD)))),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Row(children: [
        _NavItem(icon: Icons.house_outlined, activeIcon: Icons.house_rounded, label: 'Home', selected: tab == 0, onTap: () => setState(() => tab = 0)),
        _NavItem(icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view_rounded, label: 'Widgets', selected: tab == 1, onTap: () => setState(() => tab = 1)),
        _NavItem(icon: Icons.image_outlined, activeIcon: Icons.image_rounded, label: 'Wallpapers', selected: tab == 2, onTap: () => setState(() => tab = 2)),
        _NavItem(icon: Icons.favorite_border_rounded, activeIcon: Icons.favorite_rounded, label: 'Saved', selected: tab == 3, onTap: () => setState(() => tab = 3)),
      ]),
    )),
  );
}

class _NavItem extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.activeIcon, required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => Expanded(child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: SizedBox(height: 55, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(selected ? activeIcon : icon, size: 23, color: selected ? AppColors.ink : AppColors.muted), const SizedBox(height: 3), Text(label, style: TextStyle(fontSize: 11, fontWeight: selected ? FontWeight.w600 : FontWeight.w400, color: selected ? AppColors.ink : AppColors.muted))]))));
}

class HomeScreen extends StatefulWidget {
  final Favorites favorites;
  final ValueChanged<ThemeItem> onTheme;
  final ValueChanged<WidgetItem> onWidget;
  final ValueChanged<Wallpaper> onWallpaper;
  final ValueChanged<int> onTab;
  const HomeScreen({super.key, required this.favorites, required this.onTheme, required this.onWidget, required this.onWallpaper, required this.onTab});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String category = 'For You';
  @override
  Widget build(BuildContext context) {
    final themes = category == 'For You' ? MockContent.themes : MockContent.themes.where((x) => x.category == category).toList();
    final wallpapers = category == 'For You' ? MockContent.wallpapers : MockContent.wallpapers.where((x) => x.category == category).toList();
    return SafeArea(child: CustomScrollView(slivers: [SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(24, 28, 24, 27), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Make it yours.', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 5), Text('Widgets, wallpapers and themes for your screen.', style: Theme.of(context).textTheme.bodySmall)])), IconButton(onPressed: () => showPhaseSheet(context, 'More preferences will be available in a future build.'), style: IconButton.styleFrom(backgroundColor: AppColors.white, minimumSize: const Size(46, 46)), icon: const Icon(Icons.person_outline_rounded, size: 22))])),
      Padding(padding: const EdgeInsets.symmetric(horizontal: Space.lg), child: _FeaturedHero(onTap: () => widget.onTheme(MockContent.themes.first))),
      const SizedBox(height: 28), PillStrip(items: MockContent.categories.take(7).map((x) => x.name).toList(), selected: category, onSelected: (x) => setState(() => category = x)),
      const SizedBox(height: 28), SectionHeading(title: 'Trending widgets', onSeeAll: () => widget.onTab(1)),
      const SizedBox(height: 15), SizedBox(height: 224, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: Space.lg), scrollDirection: Axis.horizontal, itemCount: 5, separatorBuilder: (_, _) => const SizedBox(width: 13), itemBuilder: (_, i) => WidgetCard(item: MockContent.widgets[i], favorites: widget.favorites, onTap: () => widget.onWidget(MockContent.widgets[i])))),
      const SizedBox(height: 28), const SectionHeading(title: 'Themes for you'), const SizedBox(height: 15),
      if (themes.isEmpty) _NoMatches(category: category) else SizedBox(height: 324, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: Space.lg), scrollDirection: Axis.horizontal, itemCount: themes.length, separatorBuilder: (_, _) => const SizedBox(width: 13), itemBuilder: (_, i) => ThemeCard(item: themes[i], favorites: widget.favorites, onTap: () => widget.onTheme(themes[i])))),
      const SizedBox(height: 28), SectionHeading(title: 'Fresh wallpapers', onSeeAll: () => widget.onTab(2)), const SizedBox(height: 15),
      if (wallpapers.isEmpty) _NoMatches(category: category) else Padding(padding: const EdgeInsets.symmetric(horizontal: Space.lg), child: _WallpaperColumns(items: wallpapers.take(6).toList(), favorites: widget.favorites, onTap: widget.onWallpaper)),
      const SizedBox(height: 36),
    ]))]));
  }
}

class _FeaturedHero extends StatelessWidget {
  final VoidCallback onTap;
  const _FeaturedHero({required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: Container(height: 330, clipBehavior: Clip.antiAlias, decoration: BoxDecoration(color: const Color(0xFFE9E2D5), borderRadius: BorderRadius.circular(26)), child: Stack(children: [
    Positioned.fill(child: WallpaperArt(wallpaper: MockContent.wallpaper('dawn'))),
    Positioned(right: -7, bottom: -95, child: PhonePreview(wallpaper: MockContent.wallpaper('dawn'), widgets: MockContent.themes.first.widgetIds.map(MockContent.widget).toList(), width: 184)),
    Positioned(left: 20, top: 20, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .82), borderRadius: BorderRadius.circular(20)), child: const Text('FEATURED', style: TextStyle(fontSize: 10, letterSpacing: 1.3, fontWeight: FontWeight.w600)))),
    Positioned(left: 20, bottom: 26, width: 150, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Quiet\nMorning', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 12), const Row(children: [Text('View theme', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), SizedBox(width: 5), Icon(Icons.arrow_forward_rounded, size: 15)])])),
  ])));
}

class WidgetsScreen extends StatefulWidget {
  final Favorites favorites;
  final ValueChanged<WidgetItem> onWidget;
  const WidgetsScreen({super.key, required this.favorites, required this.onWidget});
  @override
  State<WidgetsScreen> createState() => _WidgetsScreenState();
}

class _WidgetsScreenState extends State<WidgetsScreen> {
  String category = 'All';
  @override
  Widget build(BuildContext context) {
    final items = category == 'All' ? MockContent.widgets : MockContent.widgets.where((x) => x.category == category).toList();
    return SafeArea(child: CustomScrollView(slivers: [SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const PageIntro(title: 'Widgets', subtitle: 'Small things that make your screen yours.'),
      PillStrip(items: const ['All', 'Clock', 'Calendar', 'Photo', 'Battery', 'Countdown'], selected: category, onSelected: (x) => setState(() => category = x)),
      const SizedBox(height: 22),
    ])), SliverPadding(padding: const EdgeInsets.fromLTRB(24, 0, 24, 35), sliver: SliverLayoutBuilder(builder: (context, constraints) => SliverGrid.builder(
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: constraints.crossAxisExtent > 620 ? 3 : 2, mainAxisSpacing: 22, crossAxisSpacing: 14, childAspectRatio: .78),
      itemBuilder: (_, i) => WidgetCard(item: items[i], favorites: widget.favorites, onTap: () => widget.onWidget(items[i])),
    )))]));
  }
}

class WallpapersScreen extends StatefulWidget {
  final Favorites favorites;
  final ValueChanged<Wallpaper> onWallpaper;
  const WallpapersScreen({super.key, required this.favorites, required this.onWallpaper});
  @override
  State<WallpapersScreen> createState() => _WallpapersScreenState();
}

class _WallpapersScreenState extends State<WallpapersScreen> {
  String category = 'For You';
  @override
  Widget build(BuildContext context) {
    final items = category == 'For You' ? MockContent.wallpapers : MockContent.wallpapers.where((x) => x.category == category).toList();
    return SafeArea(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const PageIntro(title: 'Wallpapers', subtitle: 'A new perspective for your everyday.'),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: GestureDetector(onTap: () => widget.onWallpaper(MockContent.wallpapers.first), child: SizedBox(height: 255, width: double.infinity, child: ClipRRect(borderRadius: BorderRadius.circular(RadiusSize.card), child: Stack(children: [Positioned.fill(child: WallpaperArt(wallpaper: MockContent.wallpapers.first)), Positioned(left: 20, bottom: 20, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .85), borderRadius: BorderRadius.circular(12)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('EDITOR’S PICK', style: TextStyle(fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w600)), SizedBox(height: 4), Text('Morning Haze', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))])))]))))),
      const SizedBox(height: 25), PillStrip(items: const ['For You', 'Minimal', 'Nature', 'Dark', 'Abstract', 'Architecture'], selected: category, onSelected: (x) => setState(() => category = x)),
      const SizedBox(height: 23), if (items.isEmpty) _NoMatches(category: category) else Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: _WallpaperColumns(items: items, favorites: widget.favorites, onTap: widget.onWallpaper)), const SizedBox(height: 36),
    ])));
  }
}

class _WallpaperColumns extends StatelessWidget {
  final List<Wallpaper> items;
  final Favorites favorites;
  final ValueChanged<Wallpaper> onTap;
  const _WallpaperColumns({required this.items, required this.favorites, required this.onTap});
  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [for (var col = 0; col < 2; col++) Expanded(child: Padding(padding: EdgeInsets.only(left: col == 1 ? 7 : 0, right: col == 0 ? 7 : 0), child: Column(children: [for (var i = col; i < items.length; i += 2) Padding(padding: const EdgeInsets.only(bottom: 14), child: WallpaperCard(item: items[i], favorites: favorites, onTap: () => onTap(items[i]), height: i.isEven ? 245 : 190))])))]);
}

class _NoMatches extends StatelessWidget {
  final String category;
  const _NoMatches({required this.category});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(24), child: Text('More $category looks are on the way.', style: Theme.of(context).textTheme.bodySmall));
}

class SavedScreen extends StatefulWidget {
  final Favorites favorites;
  final ValueChanged<ThemeItem> onTheme;
  final ValueChanged<WidgetItem> onWidget;
  final ValueChanged<Wallpaper> onWallpaper;
  final VoidCallback onExplore;
  const SavedScreen({super.key, required this.favorites, required this.onTheme, required this.onWidget, required this.onWallpaper, required this.onExplore});
  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  String category = 'All';
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: widget.favorites, builder: (_, _) {
    final themes = MockContent.themes.where((x) => widget.favorites.contains(ContentKind.theme, x.id) && (category == 'All' || category == 'Themes')).toList();
    final widgets = MockContent.widgets.where((x) => widget.favorites.contains(ContentKind.widget, x.id) && (category == 'All' || category == 'Widgets')).toList();
    final wallpapers = MockContent.wallpapers.where((x) => widget.favorites.contains(ContentKind.wallpaper, x.id) && (category == 'All' || category == 'Wallpapers')).toList();
    final empty = themes.isEmpty && widgets.isEmpty && wallpapers.isEmpty;
    return SafeArea(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const PageIntro(title: 'Saved', subtitle: 'Your favorite looks, all in one place.'),
      PillStrip(items: const ['All', 'Widgets', 'Wallpapers', 'Themes'], selected: category, onSelected: (x) => setState(() => category = x)),
      if (empty) Padding(padding: const EdgeInsets.fromLTRB(24, 95, 24, 0), child: Center(child: Column(children: [Container(width: 84, height: 84, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle), child: const Icon(Icons.favorite_border_rounded, size: 35, color: AppColors.muted)), const SizedBox(height: 25), Text('Nothing saved yet.', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 9), Text('Save widgets, wallpapers and themes you want to come back to.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall), const SizedBox(height: 27), SizedBox(width: 190, child: PrimaryButton(label: 'Start exploring', onPressed: widget.onExplore))]))) else ...[
        if (themes.isNotEmpty) ...[const SizedBox(height: 26), const SectionHeading(title: 'Themes'), const SizedBox(height: 14), SizedBox(height: 324, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 24), scrollDirection: Axis.horizontal, itemCount: themes.length, separatorBuilder: (_, _) => const SizedBox(width: 14), itemBuilder: (_, i) => ThemeCard(item: themes[i], favorites: widget.favorites, onTap: () => widget.onTheme(themes[i]))))],
        if (widgets.isNotEmpty) ...[const SizedBox(height: 28), const SectionHeading(title: 'Widgets'), const SizedBox(height: 14), SizedBox(height: 224, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 24), scrollDirection: Axis.horizontal, itemCount: widgets.length, separatorBuilder: (_, _) => const SizedBox(width: 14), itemBuilder: (_, i) => WidgetCard(item: widgets[i], favorites: widget.favorites, onTap: () => widget.onWidget(widgets[i]))))],
        if (wallpapers.isNotEmpty) ...[const SizedBox(height: 28), const SectionHeading(title: 'Wallpapers'), const SizedBox(height: 14), Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: _WallpaperColumns(items: wallpapers, favorites: widget.favorites, onTap: widget.onWallpaper))],
      ], const SizedBox(height: 34),
    ])));
  });
}
