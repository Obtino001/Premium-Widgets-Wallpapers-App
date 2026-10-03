import 'package:flutter/material.dart';

import '../core/design.dart';
import '../data/mock_content.dart';
import '../widgets/common.dart';
import '../widgets/visuals.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.ink,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'F',
                style: TextStyle(
                  color: AppColors.ivory,
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            Brand.name,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              letterSpacing: 5,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 7),
          Text(Brand.tagline, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    ),
  );
}

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinished;
  const OnboardingScreen({super.key, required this.onFinished});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int page = 0;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  Brand.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                  ),
                ),
                TextButton(
                  onPressed: widget.onFinished,
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: AppColors.muted),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (x) => setState(() => page = x),
              children: const [
                _OnboardPanel(index: 0),
                _OnboardPanel(index: 1),
                _OnboardPanel(index: 2),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == page ? 23 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == page ? AppColors.ink : AppColors.sage,
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 12),
            child: PrimaryButton(
              label: page == 2 ? 'Get Started' : 'Continue',
              onPressed: () {
                if (page == 2) {
                  widget.onFinished();
                } else {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 270),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          if (page == 2)
            TextButton(
              onPressed: widget.onFinished,
              child: const Text(
                'Explore first',
                style: TextStyle(color: AppColors.muted),
              ),
            )
          else
            const SizedBox(height: 48),
        ],
      ),
    ),
  );
}

class _OnboardPanel extends StatelessWidget {
  final int index;
  const _OnboardPanel({required this.index});
  @override
  Widget build(BuildContext context) {
    final title = [
      'Your screen,\nyour style.',
      'Designed to work\ntogether.',
      'Change the mood\nin seconds.',
    ][index];
    final subtitle = [
      'Widgets, wallpapers and themes made to feel like you.',
      'Pair widgets and wallpapers into a complete home-screen look.',
      'Save your favorites and refresh your screen whenever you want.',
    ][index];
    return LayoutBuilder(
      builder: (context, box) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: index == 1
                      ? _ThemeTriptych(height: box.maxHeight * .57)
                      : index == 2
                      ? _MoodPreview(height: box.maxHeight * .57)
                      : _SinglePreview(height: box.maxHeight * .57),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(title, style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

class _SinglePreview extends StatelessWidget {
  final double height;
  const _SinglePreview({required this.height});
  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: BoxDecoration(
      color: const Color(0xFFECE8DF),
      borderRadius: BorderRadius.circular(29),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: -15,
          top: 20,
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFD7D4C8),
            ),
          ),
        ),
        Positioned(
          right: -25,
          bottom: 30,
          child: Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFD6DDD2),
            ),
          ),
        ),
        PhonePreview(
          wallpaper: MockContent.wallpaper('dawn'),
          widgets: MockContent.themes.first.widgetIds
              .map(MockContent.widget)
              .toList(),
          width: height * .42,
        ),
      ],
    ),
  );
}

class _ThemeTriptych extends StatelessWidget {
  final double height;
  const _ThemeTriptych({required this.height});
  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: BoxDecoration(
      color: AppColors.secondary,
      borderRadius: BorderRadius.circular(29),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final id in ['dawn', 'moss', 'nocturne'])
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PhonePreview(
                wallpaper: MockContent.wallpaper(id),
                widgets: const [],
                width: height * .20,
              ),
              const SizedBox(height: 12),
              Text(
                id == 'dawn'
                    ? 'Minimal'
                    : id == 'moss'
                    ? 'Nature'
                    : 'Mono',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
      ],
    ),
  );
}

class _MoodPreview extends StatelessWidget {
  final double height;
  const _MoodPreview({required this.height});
  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: BoxDecoration(
      color: const Color(0xFFE8E5DD),
      borderRadius: BorderRadius.circular(29),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: const Offset(-47, 13),
          child: Transform.rotate(
            angle: -.15,
            child: PhonePreview(
              wallpaper: MockContent.wallpaper('nocturne'),
              widgets: const [],
              width: height * .38,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(53, -8),
          child: Transform.rotate(
            angle: .12,
            child: PhonePreview(
              wallpaper: MockContent.wallpaper('blue'),
              widgets: const [],
              width: height * .38,
            ),
          ),
        ),
      ],
    ),
  );
}
