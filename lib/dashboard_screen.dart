import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfluttersactivity/adaptive_bottom_nav.dart';
import 'package:myfluttersactivity/adaptive_button.dart';
import 'package:myfluttersactivity/platform_helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _navIndex = 0;
  int _menuIndex = 0; // which sidebar/drawer item is selected

  static const int _rowCount = 3;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = Responsive.isMobile(width);
        final isDesktop = Responsive.isDesktop(width);

        // Nav bar placement: matches the reference slide, which shows the
        // nav bar at the BOTTOM for every platform (Material, iOS 26+, iOS
        // 18). Desktop width still swaps it for a permanent sidebar. Web's
        // "mouse-friendly" adaptation lives in the widget's hover styling
        // (see AdaptiveBottomNav's web variant), not in repositioning it.
        final showSidebar = isDesktop;
        final showBottomNav = !isDesktop;

        final navBar = AdaptiveBottomNav(currentIndex: _navIndex, onTap: (i) => setState(() => _navIndex = i));

        final body = SafeArea(
          child: Row(
            children: [
              if (showSidebar)
                _Sidebar(
                  selectedIndex: _menuIndex,
                  onSelect: (i) => setState(() => _menuIndex = i),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _CardGrid(width: width),
                      const SizedBox(height: 16),
                      _ListRows(count: _rowCount),
                      const SizedBox(height: 16),
                      AdaptiveButton(label: 'Refresh Dashboard', icon: Icons.refresh, onPressed: () {}),
                      const SizedBox(height: 8),
                      const AdaptiveButton(label: 'Disabled Action'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

        if (PlatformHelper.isCupertino) {
          return CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('responsivedashboard'),
            ),
            child: Column(
              children: [
                Expanded(child: body),
                if (showBottomNav) navBar,
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('responsivedashboard')),
          drawer: isMobile
              ? _MobileDrawer(
                  selectedIndex: _menuIndex,
                  onSelect: (i) => setState(() => _menuIndex = i),
                )
              : null,
          body: body,
          bottomNavigationBar: showBottomNav ? navBar : null,
        );
      },
    );
  }
}

class _CardGrid extends StatelessWidget {
  const _CardGrid({required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.gridColumns(width);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: columns == 2 ? 1.1 : 0.9,
      ),
      itemBuilder: (context, i) => Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _ListRows extends StatelessWidget {
  const _ListRows({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (i) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

const List<_MenuEntry> _menuEntries = [
  _MenuEntry(icon: Icons.dashboard_outlined, label: 'Dashboard'),
  _MenuEntry(icon: Icons.settings_outlined, label: 'Settings'),
  _MenuEntry(icon: Icons.info_outline, label: 'About'),
  _MenuEntry(icon: Icons.logout, label: 'Logout'),
];

class _MenuEntry {
  const _MenuEntry({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer({required this.selectedIndex, required this.onSelect});
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: Icon(Icons.favorite, size: 40)),
            ),
            for (var i = 0; i < _menuEntries.length; i++)
              _DrawerItem(
                icon: _menuEntries[i].icon,
                label: _menuEntries[i].label,
                selected: selectedIndex == i,
                onTap: () {
                  onSelect(i);
                  Navigator.maybePop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Theme.of(context).colorScheme.primary : Colors.black87;
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        leading: Icon(icon, size: 18, color: color),
        title: Text(
          label.toUpperCase(),
          style: TextStyle(fontSize: 12, letterSpacing: 1, color: color, fontWeight: selected ? FontWeight.bold : FontWeight.normal),
        ),
        selected: selected,
        selectedTileColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        hoverColor: Colors.black.withValues(alpha: 0.04),
        onTap: onTap,
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.selectedIndex, required this.onSelect});
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(24),
            child: Icon(Icons.favorite, size: 32),
          ),
          for (var i = 0; i < _menuEntries.length; i++)
            _DrawerItem(
              icon: _menuEntries[i].icon,
              label: _menuEntries[i].label,
              selected: selectedIndex == i,
              onTap: () => onSelect(i),
            ),
        ],
      ),
    );
  }
}