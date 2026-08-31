import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfluttersactivity/platform_helper.dart';

class NavDestination {
  const NavDestination({required this.label, required this.icon});
  final String label;
  final IconData icon;
}

const _destinations = [
  NavDestination(label: 'Home', icon: Icons.home_rounded),
  NavDestination(label: 'Profile', icon: Icons.person_rounded),
];

/// Adaptive navigation bar with three genuinely distinct looks, matching the
/// assignment's reference slide:
/// - Material (Android/other): light gray pill container, selected item gets
///   a soft rounded highlight chip behind icon+label.
/// - iOS: a floating white "liquid glass" pill with Home/Profile, plus a
///   separate circular search button off to the side (the iOS 26+ style).
/// - Web: a horizontal segmented tab strip sized for mouse use, with visible
///   hover highlighting on every item (not just the selected one) — a
///   mouse-only affordance that touch devices don't get.
class AdaptiveBottomNav extends StatelessWidget {
  const AdaptiveBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    switch (PlatformHelper.current) {
      case AppPlatform.ios:
        return _IosNav(currentIndex: currentIndex, onTap: onTap);
      case AppPlatform.web:
        return _WebTabStrip(currentIndex: currentIndex, onTap: onTap);
      case AppPlatform.android:
      case AppPlatform.other:
        return _MaterialNav(currentIndex: currentIndex, onTap: onTap);
    }
  }
}

// ---------------------------------------------------------------------------
// Material (Android)
// ---------------------------------------------------------------------------
class _MaterialNav extends StatelessWidget {
  const _MaterialNav({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F5),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < _destinations.length; i++)
                _MaterialNavItem(
                  destination: _destinations[i],
                  selected: currentIndex == i,
                  onTap: () => onTap(i),
                ),
              _MaterialSearchItem(onTap: () => onTap(_destinations.length)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MaterialNavItem extends StatelessWidget {
  const _MaterialNavItem({required this.destination, required this.selected, required this.onTap});
  final NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFDCE7FB) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(destination.icon, size: 20, color: selected ? const Color(0xFF2C3E50) : Colors.grey.shade600),
              const SizedBox(height: 2),
              Text(destination.label, style: TextStyle(fontSize: 10, color: selected ? const Color(0xFF2C3E50) : Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MaterialSearchItem extends StatelessWidget {
  const _MaterialSearchItem({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search, size: 20, color: Colors.grey),
              SizedBox(height: 2),
              Text('Search', style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// iOS (Cupertino) — floating pill + separate circular search button
// ---------------------------------------------------------------------------
class _IosNav extends StatelessWidget {
  const _IosNav({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (var i = 0; i < _destinations.length; i++)
                      _IosNavItem(destination: _destinations[i], selected: currentIndex == i, onTap: () => onTap(i)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            _IosSearchButton(onTap: () => onTap(_destinations.length)),
          ],
        ),
      ),
    );
  }
}

class _IosNavItem extends StatelessWidget {
  const _IosNavItem({required this.destination, required this.selected, required this.onTap});
  final NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF0A84FF) : CupertinoColors.systemGrey;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(destination.icon, size: 22, color: color),
          const SizedBox(height: 2),
          Text(destination.label, style: TextStyle(fontSize: 10, color: color, fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
        ],
      ),
    );
  }
}

class _IosSearchButton extends StatelessWidget {
  const _IosSearchButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: const Icon(CupertinoIcons.search, color: CupertinoColors.black, size: 22),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Web — mouse-friendly horizontal tab strip with hover feedback on every item
// ---------------------------------------------------------------------------
class _WebTabStrip extends StatelessWidget {
  const _WebTabStrip({required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final items = [..._destinations, const NavDestination(label: 'Search', icon: Icons.search)];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < items.length; i++)
                _WebTabItem(destination: items[i], selected: currentIndex == i, onTap: () => onTap(i)),
            ],
          ),
        ),
      ),
    );
  }
}

class _WebTabItem extends StatefulWidget {
  const _WebTabItem({required this.destination, required this.selected, required this.onTap});
  final NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_WebTabItem> createState() => _WebTabItemState();
}

class _WebTabItemState extends State<_WebTabItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || _hovering;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: active ? Colors.grey.shade100 : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.destination.icon, size: 18, color: active ? const Color(0xFF2C3E50) : Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                widget.destination.label,
                style: TextStyle(
                  fontSize: 12,
                  color: active ? const Color(0xFF2C3E50) : Colors.grey.shade600,
                  fontWeight: widget.selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}