import 'package:flutter/material.dart';
import '../InicioSesion.dart';

/// Data model for navigation items in the sidebar.
class AlumnoNavItem {
  final IconData icon;
  final String label;
  const AlumnoNavItem(this.icon, this.label);
}

/// A generic alumno/padre dashboard scaffold.
///
/// Provides the sidebar, top bar (with hamburger on mobile), and navigation.
/// Simplified version for parents — only Dashboard and Evidencias.
class AlumnoScaffold extends StatefulWidget {
  final Widget body;
  final int selectedIndex;
  final EdgeInsets? bodyPadding;
  final String? topBarTitle;
  final Map<int, WidgetBuilder> destinations;

  const AlumnoScaffold({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.destinations,
    this.bodyPadding,
    this.topBarTitle,
  });

  @override
  State<AlumnoScaffold> createState() => _AlumnoScaffoldState();
}

class _AlumnoScaffoldState extends State<AlumnoScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<AlumnoNavItem> _navItems = [
    AlumnoNavItem(Icons.dashboard_outlined, 'Inicio'),
    AlumnoNavItem(Icons.folder_shared_outlined, 'Evidencias'),
  ];

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 700;

  void _onNavTap(int i) {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeDrawer();
    }
    if (i == widget.selectedIndex) return;
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
                    'Portal Padre de Familia',
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

        // Perfil
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showProfileDialog(),
              borderRadius: BorderRadius.circular(28),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_pin_outlined,
                      size: 20,
                      color: Color(0xFF555555),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Perfil del Alumno',
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

          // Iconos (solo desktop)
          if (!isMobile) ...[
            _iconBtn(Icons.notifications_outlined),
            const SizedBox(width: 8),
          ],

          // Perfil padre
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
                    'María López García',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'PADRE',
                    style: TextStyle(fontSize: 9, color: Color(0xFF999999)),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFF4CAF50),
                    child: Icon(Icons.family_restroom, size: 18, color: Colors.white),
                  ),
                ],
              ),
            ),

          if (isMobile) ...[
            _iconBtn(Icons.notifications_outlined),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF4CAF50),
              child: Icon(Icons.family_restroom, size: 18, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE8E8E8)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, size: 20, color: const Color(0xFF555555)),
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  // ──────── PERFIL DIALOG (solo lectura) ────────
  void _showProfileDialog() {
    final mobile = _isMobile(context);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        insetPadding: EdgeInsets.symmetric(
          horizontal: mobile ? 16 : 40,
          vertical: 24,
        ),
        child: Container(
          width: mobile ? double.infinity : 520,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
                    ),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.school, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Carlos Méndez López',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Alumno',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Info (read-only)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _profileLabel('NOMBRE DEL ALUMNO'),
                      const SizedBox(height: 6),
                      _profileReadOnlyField('Carlos Méndez López', Icons.person_outline),
                      const SizedBox(height: 16),
                      if (mobile) ...[
                        _profileLabel('MAESTRO ASIGNADO'),
                        const SizedBox(height: 6),
                        _profileReadOnlyField('Prof. Julián Sánchez', Icons.person_outline),
                        const SizedBox(height: 16),
                        _profileLabel('GRUPO'),
                        const SizedBox(height: 6),
                        _profileReadOnlyField('Grupo 3A - Matutino', Icons.group_outlined),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _profileLabel('MAESTRO ASIGNADO'),
                                  const SizedBox(height: 6),
                                  _profileReadOnlyField('Prof. Julián Sánchez', Icons.person_outline),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _profileLabel('GRUPO'),
                                  const SizedBox(height: 6),
                                  _profileReadOnlyField('Grupo 3A - Matutino', Icons.group_outlined),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      if (mobile) ...[
                        _profileLabel('FECHA DE NACIMIENTO'),
                        const SizedBox(height: 6),
                        _profileReadOnlyField('2008-05-15', Icons.cake_outlined),
                        const SizedBox(height: 16),
                        _profileLabel('EDAD'),
                        const SizedBox(height: 6),
                        _profileReadOnlyField('17 años', Icons.hourglass_bottom),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _profileLabel('FECHA DE NACIMIENTO'),
                                  const SizedBox(height: 6),
                                  _profileReadOnlyField('2008-05-15', Icons.cake_outlined),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _profileLabel('EDAD'),
                                  const SizedBox(height: 6),
                                  _profileReadOnlyField('17 años', Icons.hourglass_bottom),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 12),
                      const Divider(color: Color(0xFFE0E0E0)),
                      const SizedBox(height: 12),
                      _profileLabel('PADRE/MADRE DE FAMILIA'),
                      const SizedBox(height: 6),
                      _profileReadOnlyField('María López García', Icons.family_restroom),
                      const SizedBox(height: 16),
                      if (mobile) ...[
                        _profileLabel('TELÉFONO DEL PADRE'),
                        const SizedBox(height: 6),
                        _profileReadOnlyField('+52 614 123 4567', Icons.phone_outlined),
                        const SizedBox(height: 16),
                        _profileLabel('CORREO DEL PADRE'),
                        const SizedBox(height: 6),
                        _profileReadOnlyField('maria.lopez@correo.com', Icons.alternate_email),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _profileLabel('TELÉFONO DEL PADRE'),
                                  const SizedBox(height: 6),
                                  _profileReadOnlyField('+52 614 123 4567', Icons.phone_outlined),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _profileLabel('CORREO DEL PADRE'),
                                  const SizedBox(height: 6),
                                  _profileReadOnlyField('maria.lopez@correo.com', Icons.alternate_email),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Close button
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Color(0xFF555555),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _profileReadOnlyField(String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF999999)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF555555),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
