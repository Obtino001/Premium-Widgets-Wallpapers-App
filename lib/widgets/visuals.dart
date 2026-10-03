import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/design.dart';
import '../models/content.dart';

class WallpaperArt extends StatelessWidget {
  final Wallpaper wallpaper;
  final BorderRadius? radius;
  const WallpaperArt({super.key, required this.wallpaper, this.radius});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: radius ?? BorderRadius.zero,
    child: LayoutBuilder(
      builder: (context, size) => CustomPaint(
        painter: _WallpaperPainter(wallpaper),
        size: Size(size.maxWidth, size.maxHeight),
      ),
    ),
  );
}

class _WallpaperPainter extends CustomPainter {
  final Wallpaper wallpaper;
  _WallpaperPainter(this.wallpaper);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final colors = wallpaper.colors;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ).createShader(rect),
    );
    final w = size.width, h = size.height;
    final p = Paint()..isAntiAlias = true;
    switch (wallpaper.motif) {
      case 1:
        p.color = colors[1].withValues(alpha: .70);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(w * .8, h * .38),
            width: w * 1.15,
            height: h * .62,
          ),
          p,
        );
        p.color = colors[2].withValues(alpha: .26);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(w * .13, h * .92),
            width: w * 1.5,
            height: h * .64,
          ),
          p,
        );
      case 2:
        p.color = colors[1].withValues(alpha: .35);
        canvas.drawCircle(Offset(w * .82, h * .15), w * .57, p);
        p.color = colors[2].withValues(alpha: .37);
        canvas.drawOval(Rect.fromLTWH(-w * .4, h * .48, w * 1.8, h * .7), p);
      case 3:
        for (var i = 0; i < 5; i++) {
          p.color = colors[(i + 1) % 3].withValues(alpha: .16 + i * .045);
          canvas.save();
          canvas.translate(w * (.14 + i * .19), h * (.25 + i * .14));
          canvas.rotate(-.55 + i * .2);
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset.zero,
              width: w * .85,
              height: h * .22,
            ),
            p,
          );
          canvas.restore();
        }
      case 4:
        p.color = colors[2].withValues(alpha: .65);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(-w * .22, h * .1, w * .95, h * .67),
            Radius.circular(w * .48),
          ),
          p,
        );
        p.color = colors[1].withValues(alpha: .35);
        canvas.drawCircle(Offset(w * 1.05, h * .72), w * .67, p);
      case 5:
        p.color = colors[2].withValues(alpha: .38);
        canvas.drawRect(Rect.fromLTWH(w * .52, -h * .1, w * .29, h * 1.2), p);
        p.color = colors[1].withValues(alpha: .42);
        canvas.drawArc(
          Rect.fromLTWH(-w * .36, h * .36, w * 1.18, h * .76),
          math.pi,
          math.pi,
          true,
          p,
        );
      default:
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _WallpaperPainter oldDelegate) =>
      oldDelegate.wallpaper.id != wallpaper.id;
}

class WidgetPreview extends StatelessWidget {
  final WidgetItem item;
  final String? appearance;
  const WidgetPreview({super.key, required this.item, this.appearance});

  @override
  Widget build(BuildContext context) {
    final style = appearance ?? item.previewStyle;
    final dark = style == 'dark';
    final bg = switch (style) {
      'dark' => AppColors.dark,
      'sand' => const Color(0xFFEAE0D0),
      'sage' => const Color(0xFFDDE5D7),
      'blue' => const Color(0xFFDCE5EB),
      _ => AppColors.white,
    };
    final fg = dark ? AppColors.white : AppColors.ink;
    final sub = dark ? const Color(0xFFBABBBE) : AppColors.muted;
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(RadiusSize.small),
      ),
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, box) {
          final scale = (box.maxWidth / 160).clamp(.68, 1.35);
          Widget txt(
            String value,
            double size, {
            FontWeight weight = FontWeight.w500,
            Color? color,
            double? spacing,
          }) => Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: size * scale,
              height: 1.15,
              fontWeight: weight,
              color: color ?? fg,
              letterSpacing: spacing,
            ),
          );
          switch (item.type) {
            case 'clock':
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  txt('09:41', 37, weight: FontWeight.w300, spacing: -2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      txt(
                        'MONDAY',
                        10,
                        weight: FontWeight.w600,
                        color: sub,
                        spacing: 1.4,
                      ),
                      txt(
                        'OCT 03',
                        10,
                        weight: FontWeight.w600,
                        color: sub,
                        spacing: 1.4,
                      ),
                    ],
                  ),
                ],
              );
            case 'digital':
              return Center(
                child: txt('09:41', 42, weight: FontWeight.w300, spacing: -2),
              );
            case 'calendar':
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(child: txt('03', 38, weight: FontWeight.w300)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      txt('MONDAY', 10, weight: FontWeight.w600, color: sub),
                      txt('OCTOBER', 10, color: sub),
                    ],
                  ),
                ],
              );
            case 'photo':
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: Color(0xFFAAB6A4)),
                    CustomPaint(painter: _PhotoPainter()),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: txt('a little moment', 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            case 'battery':
              return Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90 * scale,
                      height: 90 * scale,
                      child: CircularProgressIndicator(
                        value: .78,
                        strokeWidth: 6 * scale,
                        backgroundColor: dark ? Colors.white12 : Colors.black12,
                        valueColor: AlwaysStoppedAnimation(
                          dark ? AppColors.sage : const Color(0xFF788C72),
                        ),
                      ),
                    ),
                    txt('78%', 23, weight: FontWeight.w500),
                  ],
                ),
              );
            case 'countdown':
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  txt('12 days', 26, weight: FontWeight.w400),
                  txt('until Tokyo', 12, color: sub),
                ],
              );
            case 'week':
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  txt(
                    'THIS WEEK',
                    10,
                    weight: FontWeight.w600,
                    color: sub,
                    spacing: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      'M',
                      'T',
                      'W',
                      'T',
                      'F',
                      'S',
                      'S',
                    ].map((d) => txt(d, 12)).toList(),
                  ),
                ],
              );
            case 'quote':
              return Center(
                child: txt(
                  '“Stay close to what feels real.”',
                  18,
                  weight: FontWeight.w400,
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _PhotoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFFE0D7BF);
    canvas.drawCircle(
      Offset(size.width * .75, size.height * .28),
      size.width * .17,
      p,
    );
    p.color = const Color(0xFF758D7B);
    final path = Path()
      ..moveTo(0, size.height * .72)
      ..quadraticBezierTo(
        size.width * .35,
        size.height * .2,
        size.width * .7,
        size.height * .82,
      )
      ..lineTo(size.width, size.height * .55)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant _PhotoPainter oldDelegate) => false;
}

class PhonePreview extends StatelessWidget {
  final Wallpaper wallpaper;
  final List<WidgetItem> widgets;
  final double width;
  const PhonePreview({
    super.key,
    required this.wallpaper,
    required this.widgets,
    this.width = 208,
  });

  @override
  Widget build(BuildContext context) {
    final dark = wallpaper.category == 'Dark' || wallpaper.id == 'moss';
    final fg = dark ? Colors.white : AppColors.ink;
    const w = 208.0;
    return SizedBox(
      width: width,
      height: width * 2.06,
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          width: w,
          height: w * 2.06,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D2B),
              borderRadius: BorderRadius.circular(w * .14),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 25,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(w * .115),
              child: Stack(
                children: [
                  Positioned.fill(child: WallpaperArt(wallpaper: wallpaper)),
                  Positioned(
                    top: 10,
                    left: 15,
                    right: 15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '9:41',
                          style: TextStyle(
                            fontSize: w * .055,
                            fontWeight: FontWeight.w600,
                            color: fg,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.signal_cellular_alt_rounded,
                              size: w * .065,
                              color: fg,
                            ),
                            const SizedBox(width: 3),
                            Icon(
                              Icons.battery_full_rounded,
                              size: w * .065,
                              color: fg,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: w * .22,
                    left: 15,
                    right: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '09:41',
                          style: TextStyle(
                            fontSize: w * .27,
                            fontWeight: FontWeight.w300,
                            letterSpacing: -4,
                            color: fg,
                            height: 1,
                          ),
                        ),
                        Text(
                          'Monday, October 3',
                          style: TextStyle(
                            fontSize: w * .065,
                            color: fg.withValues(alpha: .86),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: w * .94,
                    left: 14,
                    right: 14,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: w * .35,
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .78),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'MON  ·  03 OCT',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (widgets.any((x) => x.type == 'battery')) ...[
                          const SizedBox(width: 7),
                          Container(
                            width: w * .35,
                            height: w * .35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .78),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Text(
                              '78%',
                              style: TextStyle(
                                fontSize: w * .1,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 25,
                    right: 25,
                    child: Container(
                      height: w * .19,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .72),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                            [
                                  Icons.call_outlined,
                                  Icons.chat_bubble_outline_rounded,
                                  Icons.camera_alt_outlined,
                                ]
                                .map(
                                  (i) => Icon(
                                    i,
                                    size: w * .095,
                                    color: AppColors.ink,
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
