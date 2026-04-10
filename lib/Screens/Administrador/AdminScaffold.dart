import 'package:flutter/material.dart';
import '../InicioSesion.dart';

/// Data model for navigation items in the sidebar.
class AdminNavItem {
  final IconData icon;
  final String label;
  const AdminNavItem(this.icon, this.label);
}

/// A generic admin dashboard scaffold.
///
/// Provides the sidebar, top bar (with hamburger on mobile), and navigation.
/// Each admin screen only needs to provide its [body] widget and its
/// [selectedIndex] in the nav list.
///
/// Navigation between screens is handled via [onNavChanged] callback or,
/// if not provided, via the built-in [destinations] map that maps nav indices
/// to widget builders for pushReplacement navigation.
class AdminScaffold extends StatefulWidget {
  /// The content to display in the main area.
  final Widget body;

  /// The currently selected navigation index (0 = Dashboard, 1 = Maestros, etc.)
  final int selectedIndex;

  /// Optional padding for the body's scroll view. Defaults to 24 (desktop) / 16 (mobile).
  final EdgeInsets? bodyPadding;

  /// Optional: override the top bar title. If null, uses the nav item label.
  final String? topBarTitle;

  /// Map from nav index → WidgetBuilder for screens that should be navigated to
  /// via pushReplacement. The current screen's index should NOT be in this map.
  final Map<int, WidgetBuilder> destinations;

  const AdminScaffold({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.destinations,
    this.bodyPadding,
    this.topBarTitle,
  });

  @override
  State<AdminScaffold> createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends State<AdminScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<AdminNavItem> _navItems = [
    AdminNavItem(Icons.dashboard_outlined, 'Dashboard'),
    AdminNavItem(Icons.school_outlined, 'Maestros'),
    AdminNavItem(Icons.person_outline, 'Alumnos'),
    AdminNavItem(Icons.group_outlined, 'Grupos'),
    AdminNavItem(Icons.menu_book_outlined, 'Materias'),
    AdminNavItem(Icons.admin_panel_settings_outlined, 'Administradores'),
  ];

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 700;

  void _onNavTap(int i) {
    // Close drawer first if open
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeDrawer();
    }

    // If we're already on this index, do nothing
    if (i == widget.selectedIndex) return;

    // Navigate to the destination if it exists
    final builder = widget.destinations[i];
    if (builder != null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => builder(context),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);
    final padding = widget.bodyPadding ?? EdgeInsets.all(mobile ? 16 : 24);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF4F6F3),
      drawer: mobile
          ? Drawer(
              backgroundColor: const Color(0xFFF4F6F3),
              child: SafeArea(child: _buildSidebarContent()),
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (!mobile) _buildSidebar(),
            Expanded(
              child: Column(
                children: [
                  _buildTopBar(mobile),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: padding,
                      child: widget.body,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────── SIDEBAR ────────
  Widget _buildSidebar() {
    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: Color(0xFFF4F6F3),
        border: Border(right: BorderSide(color: Color(0xFFE8E8E8), width: 0.5)),
      ),
      child: _buildSidebarContent(),
    );
  }

  Widget _buildSidebarContent() {
    return Column(
      children: [
        // Logo
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logoCARE.png',
                width: 38,
                height: 38,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Text(
                    'Santuario Académico',
                    style: TextStyle(fontSize: 10, color: Color(0xFF999999)),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Nav items
        ...List.generate(_navItems.length, (i) {
          final item = _navItems[i];
          final isSelected = widget.selectedIndex == i;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _onNavTap(i),
                borderRadius: BorderRadius.circular(28),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF4CAF50)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        size: 20,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF555555),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          item.label,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF555555),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),

        const Spacer(),

        // Ajustes
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(28),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      size: 20,
                      color: Color(0xFF555555),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Ajustes',
                      style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Cerrar sesión
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const InicioSesion()),
                );
              },
              borderRadius: BorderRadius.circular(28),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: Color(0xFFE53935)),
                    SizedBox(width: 12),
                    Text(
                      'Cerrar Sesión',
                      style: TextStyle(fontSize: 14, color: Color(0xFFE53935)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ──────── TOP BAR ────────
  Widget _buildTopBar(bool isMobile) {
    final title = widget.topBarTitle ?? _navItems[widget.selectedIndex].label;

    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE8E8E8))),
      ),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: const Icon(Icons.menu, size: 24, color: Color(0xFF555555)),
            ),

          // Title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Iconos de notificación (solo desktop)
          if (!isMobile) ...[
            _iconBtn(Icons.chat_bubble_outline),
            _iconBtn(Icons.notifications_outlined),
            const SizedBox(width: 8),
          ],

          // Perfil admin
          if (!isMobile)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Admin Principal',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'SUPERUSUARIO',
                    style: TextStyle(fontSize: 9, color: Color(0xFF999999)),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFF4CAF50),
                    child: Icon(Icons.person, size: 18, color: Colors.white),
                  ),
                ],
              ),
            ),

          if (isMobile) ...[
            _iconBtn(Icons.notifications_outlined),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF4CAF50),
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon, size: 22, color: const Color(0xFF555555)),
      splashRadius: 20,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(),
    );
  }
}
