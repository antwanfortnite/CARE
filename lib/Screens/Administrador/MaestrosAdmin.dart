import 'package:flutter/material.dart';
import 'DashboardAdmin.dart';
import '../InicioSesion.dart';

class MaestrosAdmin extends StatefulWidget {
  const MaestrosAdmin({super.key});
  @override
  State<MaestrosAdmin> createState() => _MaestrosAdminState();
}

class _MaestrosAdminState extends State<MaestrosAdmin> {
  int _currentPage = 1;
  final int _totalPages = 3;
  final TextEditingController _searchController = TextEditingController();
  int _selectedNavIndex = 1;

  final List<_NavItem> _navItems = [
    _NavItem(Icons.dashboard, 'Dashboard'),
    _NavItem(Icons.person_outline, 'Maestros'),
    _NavItem(Icons.school_outlined, 'Alumnos'),
    _NavItem(Icons.group_outlined, 'Grupos'),
    _NavItem(Icons.menu_book_outlined, 'Materias'),
    _NavItem(Icons.admin_panel_settings_outlined, 'Administradores'),
  ];

  final List<_TeacherData> _teachers = [
    _TeacherData('Julián Sánchez', 'julian.sanchez@care.edu.mx', 'JS',
        const Color(0xFF7E57C2), 'SACJ850101HDHNLR00', 3),
    _TeacherData('Rosa María Moreno', 'rosa.moreno@care.edu.mx', 'RM',
        const Color(0xFF4CAF50), 'MORR900215MDFRSN01', 5),
    _TeacherData('Alberto González', 'alberto.gonz@care.edu.mx', 'AG',
        const Color(0xFF26A69A), 'GOAA880520HDFLBL02', 2),
    _TeacherData('Elena Ledesma', 'elena.l@care.edu.mx', 'EL',
        const Color(0xFFE91E63), 'LEDE930312MDFLDN03', 4),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────── SIDEBAR ────────
  Widget _buildSidebar() {
    return Container(
      width: 200,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE8E8E8))),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logoCARE.png',
                    width: 38, height: 38, fit: BoxFit.contain),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CARE',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF333333))),
                    Text('Santuario Académico',
                        style:
                            TextStyle(fontSize: 10, color: Color(0xFF999999))),
                  ],
                ),
              ],
            ),
          ),
          ...List.generate(_navItems.length, (i) {
            final item = _navItems[i];
            final isSelected = _selectedNavIndex == i;
            return InkWell(
              onTap: () {
                if (i == 0) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const DashboardAdmin(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                }
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4CAF50).withOpacity(0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(item.icon,
                        size: 20,
                        color: isSelected
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFF888888)),
                    const SizedBox(width: 12),
                    Text(item.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFF555555),
                        )),
                  ],
                ),
              ),
            );
          }),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(children: [
                  Icon(Icons.settings_outlined,
                      size: 20, color: Color(0xFF888888)),
                  SizedBox(width: 12),
                  Text('Ajustes',
                      style: TextStyle(fontSize: 13, color: Color(0xFF555555))),
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
            child: InkWell(
              onTap: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const InicioSesion())),
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(children: [
                  Icon(Icons.logout, size: 20, color: Color(0xFFE53935)),
                  SizedBox(width: 12),
                  Text('Cerrar Sesión',
                      style: TextStyle(fontSize: 13, color: Color(0xFFE53935))),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────── TOP BAR ────────
  Widget _buildTopBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE8E8E8))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10)),
              child: const Row(children: [
                Icon(Icons.search, size: 20, color: Color(0xFF999999)),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar en el sistema...',
                      hintStyle:
                          TextStyle(fontSize: 13, color: Color(0xFF999999)),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chat_bubble_outline,
                  size: 22, color: Color(0xFF555555))),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined,
                  size: 22, color: Color(0xFF555555))),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20)),
            child: const Row(children: [
              Text('Admin Principal',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              SizedBox(width: 4),
              Text('SUPERUSUARIO',
                  style: TextStyle(fontSize: 9, color: Color(0xFF999999))),
              SizedBox(width: 8),
              CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF4CAF50),
                  child: Icon(Icons.person, size: 18, color: Colors.white)),
            ]),
          ),
        ],
      ),
    );
  }

  // ──────── CONTENT ────────
  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildFilterBar(),
        const SizedBox(height: 24),
        _buildTeacherTable(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gestión de Maestros',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333))),
            SizedBox(height: 4),
            Text('Administración central de la facultad académica.',
                style: TextStyle(fontSize: 14, color: Color(0xFF888888))),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddTeacherDialog(),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Agregar Nuevo Maestro'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.filter_list, color: Color(0xFF999999)),
                hintText: 'Filtrar por nombre o CURP...',
                hintStyle:
                    const TextStyle(fontSize: 13, color: Color(0xFF999999)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE8E8E8))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE8E8E8))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF4CAF50))),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE8E8E8)),
                borderRadius: BorderRadius.circular(10)),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.refresh, color: Color(0xFF888888))),
          ),
        ],
      ),
    );
  }

  // ──────── TABLE ────────
  Widget _buildTeacherTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(children: [
              Expanded(
                  flex: 3,
                  child: Text('NOMBRE DEL MAESTRO', style: _headerStyle)),
              Expanded(flex: 2, child: Text('CURP', style: _headerStyle)),
              Expanded(
                  flex: 2,
                  child: Text('GRUPOS ASIGNADOS', style: _headerStyle)),
              Expanded(
                  flex: 2,
                  child: Text('ACCIONES',
                      style: _headerStyle, textAlign: TextAlign.center)),
            ]),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          ...List.generate(
              _teachers.length, (i) => _buildTeacherRow(_teachers[i])),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          _buildPagination(),
        ],
      ),
    );
  }

  TextStyle get _headerStyle => const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: Color(0xFF999999),
      letterSpacing: 0.5);

  Widget _buildTeacherRow(_TeacherData t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5)))),
      child: Row(children: [
        Expanded(
          flex: 3,
          child: Row(children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: t.avatarColor.withOpacity(0.15),
              child: Text(t.initials,
                  style: TextStyle(
                      color: t.avatarColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.name,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333))),
              const SizedBox(height: 2),
              Text(t.email,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF999999))),
            ]),
          ]),
        ),
        Expanded(
          flex: 2,
          child: Text(t.curp,
              style: const TextStyle(fontSize: 11, color: Color(0xFF555555))),
        ),
        Expanded(
          flex: 2,
          child: Text('${t.groups} Grupos',
              style: const TextStyle(fontSize: 13, color: Color(0xFF555555))),
        ),
        Expanded(
          flex: 2,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _actionBtn(Icons.edit_outlined, const Color(0xFF42A5F5),
                'Modificar', () => _showEditTeacherDialog(t)),
            const SizedBox(width: 8),
            _actionBtn(Icons.menu_book_outlined, const Color(0xFF4CAF50),
                'Asignar materias', () => _showAssignSubjectsDialog(t)),
            const SizedBox(width: 8),
            _actionBtn(Icons.delete_outline, const Color(0xFFEF5350),
                'Eliminar', () => _showDeleteDialog(t)),
          ]),
        ),
      ]),
    );
  }

  Widget _actionBtn(
      IconData icon, Color color, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Mostrando ${_teachers.length} de 124 maestros',
              style: const TextStyle(fontSize: 12, color: Color(0xFF999999))),
          Row(children: [
            _pageBtn('‹', enabled: _currentPage > 1,
                onTap: () => setState(() => _currentPage--)),
            ...List.generate(
                _totalPages,
                (i) => _pageBtn('${i + 1}',
                    isSelected: i + 1 == _currentPage,
                    onTap: () => setState(() => _currentPage = i + 1))),
            _pageBtn('›', enabled: _currentPage < _totalPages,
                onTap: () => setState(() => _currentPage++)),
          ]),
        ],
      ),
    );
  }

  Widget _pageBtn(String label,
      {bool isSelected = false, bool enabled = true, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? null
                : Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: Text(label,
              style: TextStyle(
                fontSize: 13,
                color: isSelected
                    ? Colors.white
                    : (enabled
                        ? const Color(0xFF555555)
                        : const Color(0xFFCCCCCC)),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              )),
        ),
      ),
    );
  }

  // ──────── HELPER: dialog text field ────────
  Widget _dialogLabel(String text) {
    return Text(text,
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF555555),
            letterSpacing: 0.5));
  }

  Widget _dialogTextField(
      {required TextEditingController controller,
      required String hint,
      required IconData icon}) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
        suffixIcon: Icon(icon, size: 18, color: const Color(0xFF999999)),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF4CAF50))),
      ),
    );
  }

  // ──────── DIALOG: header reutilizable ────────
  Widget _dialogHeader(
      {required IconData icon,
      required String subtitle,
      required String title,
      required BuildContext ctx}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF388E3C)])),
      child: Row(children: [
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(icon, size: 16, color: Colors.white70),
              const SizedBox(width: 6),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1)),
            ]),
            const SizedBox(height: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ]),
        ),
        IconButton(
          onPressed: () => Navigator.pop(ctx),
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6)),
            child: const Icon(Icons.close, color: Colors.white, size: 18),
          ),
        ),
      ]),
    );
  }

  // ──────── DIALOG: form fields reutilizable ────────
  Widget _teacherFormFields({
    required TextEditingController nameCtrl,
    required TextEditingController emailCtrl,
    required TextEditingController phoneCtrl,
    required TextEditingController curpCtrl,
    required TextEditingController dateCtrl,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _dialogLabel('NOMBRE COMPLETO'),
        const SizedBox(height: 6),
        _dialogTextField(
            controller: nameCtrl,
            hint: 'Ej. Dr. Armando Casas',
            icon: Icons.person_outline),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                _dialogLabel('CORREO ELECTRÓNICO'),
                const SizedBox(height: 6),
                _dialogTextField(
                    controller: emailCtrl,
                    hint: 'maestro@care.edu',
                    icon: Icons.alternate_email),
              ])),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                _dialogLabel('TELÉFONO'),
                const SizedBox(height: 6),
                _dialogTextField(
                    controller: phoneCtrl,
                    hint: '+52 000 000 0000',
                    icon: Icons.phone_outlined),
              ])),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                _dialogLabel('CURP'),
                const SizedBox(height: 6),
                _dialogTextField(
                    controller: curpCtrl,
                    hint: 'XXXX000000XXXXXXXX',
                    icon: Icons.badge_outlined),
              ])),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                _dialogLabel('FECHA DE CONTRATACIÓN'),
                const SizedBox(height: 6),
                _dialogTextField(
                    controller: dateCtrl,
                    hint: 'mm/dd/yyyy',
                    icon: Icons.calendar_today_outlined),
              ])),
        ]),
      ]),
    );
  }

  // ──────── AGREGAR MAESTRO ────────
  void _showAddTeacherDialog() {
    final n = TextEditingController(),
        e = TextEditingController(),
        p = TextEditingController(),
        c = TextEditingController(),
        d = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 500,
          clipBehavior: Clip.antiAlias,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _dialogHeader(
                icon: Icons.person_add,
                subtitle: 'PERSONAL DOCENTE',
                title: 'Agregar Nuevo Maestro',
                ctx: ctx),
            _teacherFormFields(
                nameCtrl: n,
                emailCtrl: e,
                phoneCtrl: p,
                curpCtrl: c,
                dateCtrl: d),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancelar',
                            style: TextStyle(
                                color: Color(0xFF888888), fontSize: 14))),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(ctx),
                      icon:
                          const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Guardar Maestro'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24))),
                    ),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }

  // ──────── MODIFICAR MAESTRO ────────
  void _showEditTeacherDialog(_TeacherData t) {
    final n = TextEditingController(text: t.name),
        e = TextEditingController(text: t.email),
        p = TextEditingController(),
        c = TextEditingController(text: t.curp),
        d = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 500,
          clipBehavior: Clip.antiAlias,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _dialogHeader(
                icon: Icons.edit,
                subtitle: 'PERSONAL DOCENTE',
                title: 'Modificar Información',
                ctx: ctx),
            _teacherFormFields(
                nameCtrl: n,
                emailCtrl: e,
                phoneCtrl: p,
                curpCtrl: c,
                dateCtrl: d),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancelar',
                            style: TextStyle(
                                color: Color(0xFF888888), fontSize: 14))),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(ctx),
                      icon:
                          const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Guardar Cambios'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24))),
                    ),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }

  // ──────── ASIGNAR MATERIAS ────────
  void _showAssignSubjectsDialog(_TeacherData t) {
    final subjects = [
      _SubjectData('Matemáticas I', 'Tronco Común', '5h/semana', true),
      _SubjectData('Física II', 'Especialidad', '4h/semana', true),
      _SubjectData('Comprensión Lectora', 'Humanidades', '5h/semana', false),
      _SubjectData('Inglés Básico', 'Lenguas', '6h/semana', false),
      _SubjectData('Química Inorgánica', 'Laboratorio', '5h/semana', false),
      _SubjectData('Cálculo Diferencial', 'Avanzado', '5h/semana', false),
    ];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) {
          final count = subjects.where((s) => s.selected).length;
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: 540,
              padding: const EdgeInsets.all(28),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(children: [
                                Icon(Icons.menu_book,
                                    size: 16, color: Color(0xFF4CAF50)),
                                SizedBox(width: 6),
                                Text('GESTIÓN ACADÉMICA',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF4CAF50),
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1)),
                              ]),
                              const SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF333333)),
                                    children: [
                                      const TextSpan(
                                          text: 'Asignar Materias a '),
                                      TextSpan(
                                          text: t.name,
                                          style: const TextStyle(
                                              color: Color(0xFF4CAF50))),
                                    ]),
                              ),
                            ]),
                      ),
                      IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close,
                              color: Color(0xFF888888), size: 20)),
                    ]),
                    const SizedBox(height: 8),
                    const Text(
                      'Seleccione las materias que impartirá el docente durante el período escolar actual. Los cambios se aplicarán inmediatamente a su horario.',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF888888),
                          height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: subjects
                          .map((s) => SizedBox(
                                width: (540 - 56 - 12) / 2,
                                child: InkWell(
                                  onTap: () =>
                                      setDlg(() => s.selected = !s.selected),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: s.selected
                                          ? const Color(0xFFE8F5E9)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: s.selected
                                              ? const Color(0xFF4CAF50)
                                                  .withOpacity(0.3)
                                              : const Color(0xFFE8E8E8)),
                                    ),
                                    child: Row(children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: s.selected
                                              ? const Color(0xFF4CAF50)
                                              : Colors.transparent,
                                          border: Border.all(
                                              color: s.selected
                                                  ? const Color(0xFF4CAF50)
                                                  : const Color(0xFFCCCCCC),
                                              width: 2),
                                        ),
                                        child: s.selected
                                            ? const Icon(Icons.check,
                                                size: 14, color: Colors.white)
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(s.name,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Color(0xFF333333))),
                                              Text(
                                                  '${s.category} • ${s.hours}',
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color:
                                                          Color(0xFF999999))),
                                            ]),
                                      ),
                                    ]),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    Row(children: [
                      Text('$count',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50))),
                      const SizedBox(width: 6),
                      const Text('Materias seleccionadas',
                          style: TextStyle(
                              fontSize: 13, color: Color(0xFF888888))),
                      const Spacer(),
                      TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancelar',
                              style: TextStyle(color: Color(0xFF888888)))),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24))),
                        child: const Text('Actualizar Asignaciones'),
                      ),
                    ]),
                  ]),
            ),
          );
        },
      ),
    );
  }

  // ──────── ELIMINAR MAESTRO ────────
  void _showDeleteDialog(_TeacherData t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: const Color(0xFFEF5350).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.warning_amber_rounded,
                color: Color(0xFFEF5350), size: 24),
          ),
          const SizedBox(width: 12),
          const Text('Eliminar Maestro',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ]),
        content: RichText(
          text: TextSpan(
              style: const TextStyle(
                  fontSize: 14, color: Color(0xFF555555), height: 1.5),
              children: [
                const TextSpan(
                    text: '¿Está seguro de que desea eliminar a '),
                TextSpan(
                    text: t.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333))),
                const TextSpan(
                    text:
                        '? Esta acción no se puede deshacer y se eliminarán todos sus datos asociados.'),
              ]),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar',
                  style: TextStyle(color: Color(0xFF888888)))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF5350),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text('Sí, eliminar'),
          ),
        ],
      ),
    );
  }
}

// ──────── DATA MODELS ────────
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

class _TeacherData {
  final String name, email, initials, curp;
  final Color avatarColor;
  final int groups;
  const _TeacherData(this.name, this.email, this.initials, this.avatarColor,
      this.curp, this.groups);
}

class _SubjectData {
  final String name, category, hours;
  bool selected;
  _SubjectData(this.name, this.category, this.hours, this.selected);
}
