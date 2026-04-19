import 'package:flutter/material.dart';
import '../InicioSesion.dart';

/// Data model for navigation items in the sidebar.
class ProfesorNavItem {
  final IconData icon;
  final String label;
  const ProfesorNavItem(this.icon, this.label);
}

/// A generic profesor dashboard scaffold.
///
/// Provides the sidebar, top bar (with hamburger on mobile), and navigation.
/// Each profesor screen only needs to provide its [body] widget and its
/// [selectedIndex] in the nav list.
class ProfesorScaffold extends StatefulWidget {
  final Widget body;
  final int selectedIndex;
  final EdgeInsets? bodyPadding;
  final String? topBarTitle;
  final Map<int, WidgetBuilder> destinations;

  const ProfesorScaffold({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.destinations,
    this.bodyPadding,
    this.topBarTitle,
  });

  @override
  State<ProfesorScaffold> createState() => _ProfesorScaffoldState();
}

class _ProfesorScaffoldState extends State<ProfesorScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<ProfesorNavItem> _navItems = [
    ProfesorNavItem(Icons.dashboard_outlined, 'Dashboard'),
    ProfesorNavItem(Icons.group_outlined, 'Mis Grupos'),
    ProfesorNavItem(Icons.folder_shared_outlined, 'Evidencias'),
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
                    'Portal Docente',
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
                      'Perfil',
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

          // Perfil profesor
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
                    'Prof. Julián Sánchez',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'DOCENTE',
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

  // ──────── PERFIL DIALOG ────────
  void _showProfileDialog() {
    final mobile = _isMobile(context);
    final nameCtrl = TextEditingController(text: 'Julián Sánchez Romero');
    final emailCtrl = TextEditingController(text: 'julian.sanchez@care.edu.mx');
    final phoneCtrl = TextEditingController(text: '+52 614 987 6543');
    final curpCtrl = TextEditingController(text: 'SARJ880215HDFNCL04');
    final fechaNacCtrl = TextEditingController(text: '1988-02-15');
    final edadCtrl = TextEditingController(text: '38');
    final fechaContrCtrl = TextEditingController(text: '2015-08-20');
    final rolCtrl = TextEditingController(text: 'Docente');
    final userCtrl = TextEditingController(text: 'julian.sanchez');
    final passCtrl = TextEditingController(text: 'prof1234');
    bool hideUser = true, hidePass = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) {
          return Dialog(
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
                            child: Icon(Icons.person, size: 40, color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            nameCtrl.text,
                            style: const TextStyle(
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
                            child: Text(
                              rolCtrl.text,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Form
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _profileLabel('NOMBRE COMPLETO'),
                          const SizedBox(height: 6),
                          _profileTextField(
                            controller: nameCtrl,
                            hint: 'Nombre completo',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          if (mobile) ...[
                            _profileLabel('CORREO ELECTRÓNICO'),
                            const SizedBox(height: 6),
                            _profileTextField(
                              controller: emailCtrl,
                              hint: 'profesor@care.edu',
                              icon: Icons.alternate_email,
                            ),
                            const SizedBox(height: 16),
                            _profileLabel('TELÉFONO'),
                            const SizedBox(height: 6),
                            _profileTextField(
                              controller: phoneCtrl,
                              hint: '+52 000 000 0000',
                              icon: Icons.phone_outlined,
                            ),
                          ] else ...[
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _profileLabel('CORREO ELECTRÓNICO'),
                                      const SizedBox(height: 6),
                                      _profileTextField(
                                        controller: emailCtrl,
                                        hint: 'profesor@care.edu',
                                        icon: Icons.alternate_email,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _profileLabel('TELÉFONO'),
                                      const SizedBox(height: 6),
                                      _profileTextField(
                                        controller: phoneCtrl,
                                        hint: '+52 000 000 0000',
                                        icon: Icons.phone_outlined,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 16),
                          if (mobile) ...[
                            _profileLabel('CURP'),
                            const SizedBox(height: 6),
                            _profileTextField(
                              controller: curpCtrl,
                              hint: 'XXXX000000XXXXXXXX',
                              icon: Icons.badge_outlined,
                            ),
                            const SizedBox(height: 16),
                            _profileLabel('FECHA DE NACIMIENTO'),
                            const SizedBox(height: 6),
                            _profileTextField(
                              controller: fechaNacCtrl,
                              hint: 'yyyy-mm-dd',
                              icon: Icons.cake_outlined,
                            ),
                            const SizedBox(height: 16),
                            _profileLabel('EDAD'),
                            const SizedBox(height: 6),
                            _profileTextField(
                              controller: edadCtrl,
                              hint: 'Edad',
                              icon: Icons.hourglass_bottom,
                              readOnly: true,
                            ),
                          ] else ...[
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _profileLabel('CURP'),
                                      const SizedBox(height: 6),
                                      _profileTextField(
                                        controller: curpCtrl,
                                        hint: 'XXXX000000XXXXXXXX',
                                        icon: Icons.badge_outlined,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _profileLabel('FECHA DE NACIMIENTO'),
                                      const SizedBox(height: 6),
                                      _profileTextField(
                                        controller: fechaNacCtrl,
                                        hint: 'yyyy-mm-dd',
                                        icon: Icons.cake_outlined,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _profileLabel('EDAD'),
                                      const SizedBox(height: 6),
                                      _profileTextField(
                                        controller: edadCtrl,
                                        hint: 'Edad',
                                        icon: Icons.hourglass_bottom,
                                        readOnly: true,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _profileLabel('FECHA DE CONTRATACIÓN'),
                                      const SizedBox(height: 6),
                                      _profileTextField(
                                        controller: fechaContrCtrl,
                                        hint: 'yyyy-mm-dd',
                                        icon: Icons.calendar_today_outlined,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (mobile) ...[
                            const SizedBox(height: 16),
                            _profileLabel('FECHA DE CONTRATACIÓN'),
                            const SizedBox(height: 6),
                            _profileTextField(
                              controller: fechaContrCtrl,
                              hint: 'yyyy-mm-dd',
                              icon: Icons.calendar_today_outlined,
                            ),
                          ],
                          const SizedBox(height: 16),
                          _profileLabel('ROL'),
                          const SizedBox(height: 6),
                          _profileTextField(
                            controller: rolCtrl,
                            hint: 'Rol',
                            icon: Icons.school_outlined,
                            readOnly: true,
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: Color(0xFFE0E0E0)),
                          const SizedBox(height: 12),
                          if (mobile) ...[
                            _profileLabel('USUARIO'),
                            const SizedBox(height: 6),
                            TextField(
                              controller: userCtrl,
                              obscureText: hideUser,
                              style: const TextStyle(fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'Usuario',
                                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    hideUser ? Icons.visibility_off : Icons.visibility,
                                    size: 18,
                                    color: const Color(0xFF999999),
                                  ),
                                  onPressed: () => setDlg(() => hideUser = !hideUser),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF9F9F9),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF4CAF50))),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _profileLabel('CONTRASEÑA'),
                            const SizedBox(height: 6),
                            TextField(
                              controller: passCtrl,
                              obscureText: hidePass,
                              style: const TextStyle(fontSize: 13),
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    hidePass ? Icons.visibility_off : Icons.visibility,
                                    size: 18,
                                    color: const Color(0xFF999999),
                                  ),
                                  onPressed: () => setDlg(() => hidePass = !hidePass),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF9F9F9),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF4CAF50))),
                              ),
                            ),
                          ] else ...[
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _profileLabel('USUARIO'),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: userCtrl,
                                        obscureText: hideUser,
                                        style: const TextStyle(fontSize: 13),
                                        decoration: InputDecoration(
                                          hintText: 'Usuario',
                                          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              hideUser ? Icons.visibility_off : Icons.visibility,
                                              size: 18,
                                              color: const Color(0xFF999999),
                                            ),
                                            onPressed: () => setDlg(() => hideUser = !hideUser),
                                          ),
                                          filled: true,
                                          fillColor: const Color(0xFFF9F9F9),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF4CAF50))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _profileLabel('CONTRASEÑA'),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: passCtrl,
                                        obscureText: hidePass,
                                        style: const TextStyle(fontSize: 13),
                                        decoration: InputDecoration(
                                          hintText: '••••••••',
                                          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              hidePass ? Icons.visibility_off : Icons.visibility,
                                              size: 18,
                                              color: const Color(0xFF999999),
                                            ),
                                            onPressed: () => setDlg(() => hidePass = !hidePass),
                                          ),
                                          filled: true,
                                          fillColor: const Color(0xFFF9F9F9),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF4CAF50))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Botones
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(ctx);
                            },
                            icon: const Icon(Icons.save_outlined, size: 18),
                            label: const Text('Guardar Cambios'),
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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

  Widget _profileTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      enabled: !readOnly,
      style: TextStyle(
        fontSize: 13,
        color: readOnly ? const Color(0xFF555555) : null,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
        suffixIcon: Icon(icon, size: 18, color: const Color(0xFF999999)),
        filled: true,
        fillColor: readOnly ? const Color(0xFFEFEFEF) : const Color(0xFFF9F9F9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF4CAF50)),
        ),
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
