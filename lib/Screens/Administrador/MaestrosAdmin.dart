import 'package:flutter/material.dart';
import 'AdminScaffold.dart';
import 'DashboardAdmin.dart';
import 'AlumnosAdmin.dart';
import '../../BD/Maestros.dart'; // <- Import para API

class MaestrosAdmin extends StatefulWidget {
  const MaestrosAdmin({super.key});
  @override
  State<MaestrosAdmin> createState() => _MaestrosAdminState();
}

class _MaestrosAdminState extends State<MaestrosAdmin> {
  int _currentPage = 1;
  final int _totalPages = 3;
  final TextEditingController _searchController = TextEditingController();

  final List<_TeacherData> _teachers = [];
  bool _isLoading = true;
  final MaestrosApiService _apiService = MaestrosApiService();

  @override
  void initState() {
    super.initState();
    _loadMaestros();
  }

  Future<void> _loadMaestros() async {
    setState(() => _isLoading = true);
    final data = await _apiService.getMaestros();
    if (mounted) {
      setState(() {
        _teachers.clear();
        _teachers.addAll(data.map((m) => _TeacherData.fromJson(m)).toList());
        _isLoading = false;
      });
    }
  }

  Future<void> _agregarMaestroPrueba() async {
    setState(() => _isLoading = true);
    final stamp = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    final data = {
      'nombre_completo': 'Mtro. Prueba $stamp',
      'correo_electronico': 'prueba$stamp@ejemplo.com',
      'telefono': '555$stamp',
      'curp': 'XXXYY9$stamp',
      'fecha_nacimiento': '1980-05-15',
      'pin_acceso': '1234',
    };
    bool success = await _apiService.agregarMaestro(data);
    if (success) {
      _loadMaestros();
    } else {
      setState(() => _isLoading = false);
    }
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 1050;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);

    return AdminScaffold(
      selectedIndex: 1,
      destinations: {
        0: (_) => const DashboardAdmin(),
        2: (_) => const AlumnosAdmin(),
      },
      bodyPadding: EdgeInsets.all(mobile ? 16 : 28),
      body: _buildContent(mobile),
    );
  }

  // ──────── CONTENT ────────
  Widget _buildContent(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(isMobile),
        const SizedBox(height: 24),
        _buildFilterBar(),
        const SizedBox(height: 24),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(40.0),
            child: Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50))),
          )
        else
          isMobile ? _buildTeacherCards() : _buildTeacherTable(),
      ],
    );
  }

  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestión de Maestros',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Administración central de la facultad académica.',
            style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddTeacherDialog(),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Agregar Maestro'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _agregarMaestroPrueba,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.bug_report, size: 20),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gestión de Maestros',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Administración central de la facultad académica.',
                style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _agregarMaestroPrueba,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bug_report, size: 18),
                  SizedBox(width: 8),
                  Text('Prueba'),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () => _showAddTeacherDialog(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Agregar Nuevo Maestro'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
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
                prefixIcon: const Icon(
                  Icons.filter_list,
                  color: Color(0xFF999999),
                ),
                hintText: 'Filtrar por nombre o CURP...',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF999999),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE8E8E8)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.refresh, color: Color(0xFF888888)),
            ),
          ),
        ],
      ),
    );
  }

  // ──────── MOBILE TEACHER CARDS ────────
  Widget _buildTeacherCards() {
    return Column(
      children: [
        ..._teachers.map((t) => _buildTeacherCardMobile(t)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: _buildPaginationContent(),
        ),
      ],
    );
  }

  Widget _buildTeacherCardMobile(_TeacherData t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: t.avatarColor.withOpacity(0.15),
                child: Text(
                  t.initials,
                  style: TextStyle(
                    color: t.avatarColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.badge_outlined,
                size: 14,
                color: Color(0xFF888888),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  t.curp,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF555555),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${t.groups} Grupos',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _actionBtn(
                Icons.visibility_outlined,
                const Color(0xFF7E57C2),
                'Ver información',
                () => _showViewTeacherDialog(t),
              ),
              const SizedBox(width: 16),
              _actionBtn(
                Icons.edit_outlined,
                const Color(0xFF42A5F5),
                'Modificar',
                () => _showEditTeacherDialog(t),
              ),
              const SizedBox(width: 8),
              _actionBtn(
                Icons.menu_book_outlined,
                const Color(0xFF4CAF50),
                'Asignar materias',
                () => _showAssignSubjectsDialog(t),
              ),
              const SizedBox(width: 8),
              _actionBtn(
                Icons.delete_outline,
                const Color(0xFFEF5350),
                'Eliminar',
                () => _showDeleteDialog(t),
              ),
            ],
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final tableWidth = constraints.maxWidth < 800
                  ? 800.0
                  : constraints.maxWidth;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'NOMBRE DEL MAESTRO',
                                style: _headerStyle,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('CURP', style: _headerStyle),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'GRUPOS ASIGNADOS',
                                style: _headerStyle,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'ACCIONES',
                                style: _headerStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFF0F0F0)),
                      ...List.generate(
                        _teachers.length,
                        (i) => _buildTeacherRow(_teachers[i]),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: _buildPaginationContent(),
          ),
        ],
      ),
    );
  }

  TextStyle get _headerStyle => const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Color(0xFF999999),
    letterSpacing: 0.5,
  );

  Widget _buildTeacherRow(_TeacherData t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: t.avatarColor.withOpacity(0.15),
                  child: Text(
                    t.initials,
                    style: TextStyle(
                      color: t.avatarColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        t.email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              t.curp,
              style: const TextStyle(fontSize: 11, color: Color(0xFF555555)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${t.groups} Grupos',
              style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _actionBtn(
                  Icons.visibility_outlined,
                  const Color(0xFF7E57C2),
                  'Ver información',
                  () => _showViewTeacherDialog(t),
                ),
                const SizedBox(width: 16),
                _actionBtn(
                  Icons.edit_outlined,
                  const Color(0xFF42A5F5),
                  'Modificar',
                  () => _showEditTeacherDialog(t),
                ),
                const SizedBox(width: 8),
                _actionBtn(
                  Icons.menu_book_outlined,
                  const Color(0xFF4CAF50),
                  'Asignar materias',
                  () => _showAssignSubjectsDialog(t),
                ),
                const SizedBox(width: 8),
                _actionBtn(
                  Icons.delete_outline,
                  const Color(0xFFEF5350),
                  'Eliminar',
                  () => _showDeleteDialog(t),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(
    IconData icon,
    Color color,
    String tooltip,
    VoidCallback onTap,
  ) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }

  Widget _buildPaginationContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Mostrando ${_teachers.length} de 124 maestros',
            style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            _pageBtn(
              '‹',
              enabled: _currentPage > 1,
              onTap: () => setState(() => _currentPage--),
            ),
            ...List.generate(
              _totalPages,
              (i) => _pageBtn(
                '${i + 1}',
                isSelected: i + 1 == _currentPage,
                onTap: () => setState(() => _currentPage = i + 1),
              ),
            ),
            _pageBtn(
              '›',
              enabled: _currentPage < _totalPages,
              onTap: () => setState(() => _currentPage++),
            ),
          ],
        ),
      ],
    );
  }

  Widget _pageBtn(
    String label, {
    bool isSelected = false,
    bool enabled = true,
    VoidCallback? onTap,
  }) {
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
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isSelected
                  ? Colors.white
                  : (enabled
                        ? const Color(0xFF555555)
                        : const Color(0xFFCCCCCC)),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // ──────── HELPER: dialog text field ────────
  Widget _dialogLabel(String text) {
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

  Widget _dialogTextField({
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
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

  // ──────── HELPERS: fecha de nacimiento & edad ────────
  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> _pickBirthDate(
    BuildContext ctx,
    TextEditingController birthDateCtrl,
    TextEditingController ageCtrl,
    void Function(VoidCallback) setDlg,
  ) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CAF50),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF333333),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      setDlg(() {
        birthDateCtrl.text = '$day/$month/${picked.year}';
        ageCtrl.text = '${_calculateAge(picked)}';
      });
    }
  }

  // ──────── DIALOG: header reutilizable ────────
  Widget _dialogHeader({
    required IconData icon,
    required String subtitle,
    required String title,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.white70),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ──────── DIALOG: form fields reutilizable ────────
  Widget _teacherFormFields({
    required TextEditingController nameCtrl,
    required TextEditingController emailCtrl,
    required TextEditingController phoneCtrl,
    required TextEditingController curpCtrl,
    required TextEditingController dateCtrl,
    required TextEditingController birthDateCtrl,
    required TextEditingController ageCtrl,
    required VoidCallback onPickBirthDate,
    required bool isMobile,
    bool readOnly = false,
    TextEditingController? userCtrl,
    TextEditingController? passCtrl,
    bool obscureUser = true,
    bool obscurePass = true,
    VoidCallback? onToggleUser,
    VoidCallback? onTogglePass,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dialogLabel('NOMBRE COMPLETO'),
          const SizedBox(height: 6),
          _dialogTextField(
            controller: nameCtrl,
            hint: 'Ej. Dr. Armando Casas',
            icon: Icons.person_outline,
            readOnly: readOnly,
          ),
          const SizedBox(height: 16),
          if (isMobile) ...[
            _dialogLabel('CORREO ELECTRÓNICO'),
            const SizedBox(height: 6),
            _dialogTextField(
              controller: emailCtrl,
              hint: 'maestro@care.edu',
              icon: Icons.alternate_email,
              readOnly: readOnly,
            ),
            const SizedBox(height: 16),
            _dialogLabel('TELÉFONO'),
            const SizedBox(height: 6),
            _dialogTextField(
              controller: phoneCtrl,
              hint: '+52 000 000 0000',
              icon: Icons.phone_outlined,
              readOnly: readOnly,
            ),
            const SizedBox(height: 16),
            _dialogLabel('CURP'),
            const SizedBox(height: 6),
            _dialogTextField(
              controller: curpCtrl,
              hint: 'XXXX000000XXXXXXXX',
              icon: Icons.badge_outlined,
              readOnly: readOnly,
            ),
            const SizedBox(height: 16),
            _dialogLabel('FECHA DE CONTRATACIÓN'),
            const SizedBox(height: 6),
            _dialogTextField(
              controller: dateCtrl,
              hint: 'mm/dd/yyyy',
              icon: Icons.calendar_today_outlined,
              readOnly: readOnly,
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _dialogLabel('CORREO ELECTRÓNICO'),
                      const SizedBox(height: 6),
                      _dialogTextField(
                        controller: emailCtrl,
                        hint: 'maestro@care.edu',
                        icon: Icons.alternate_email,
                        readOnly: readOnly,
                      ),
                    ],
                  ),
                ),
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
                        icon: Icons.phone_outlined,
                        readOnly: readOnly,
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
                      _dialogLabel('CURP'),
                      const SizedBox(height: 6),
                      _dialogTextField(
                        controller: curpCtrl,
                        hint: 'XXXX000000XXXXXXXX',
                        icon: Icons.badge_outlined,
                        readOnly: readOnly,
                      ),
                    ],
                  ),
                ),
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
                        icon: Icons.calendar_today_outlined,
                        readOnly: readOnly,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          if (isMobile) ...[
            _dialogLabel('FECHA DE NACIMIENTO'),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: readOnly ? null : onPickBirthDate,
              child: AbsorbPointer(
                child: _dialogTextField(
                  controller: birthDateCtrl,
                  hint: 'Seleccione una fecha',
                  icon: Icons.cake_outlined,
                  readOnly: readOnly,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _dialogLabel('EDAD'),
            const SizedBox(height: 6),
            TextField(
              controller: ageCtrl,
              readOnly: true,
              enabled: false,
              style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
              decoration: InputDecoration(
                hintText: 'Se calcula automáticamente',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFBBBBBB),
                ),
                suffixIcon: const Icon(
                  Icons.hourglass_bottom,
                  size: 18,
                  color: Color(0xFF999999),
                ),
                filled: true,
                fillColor: const Color(0xFFEFEFEF),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
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
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _dialogLabel('FECHA DE NACIMIENTO'),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: readOnly ? null : onPickBirthDate,
                        child: AbsorbPointer(
                          child: _dialogTextField(
                            controller: birthDateCtrl,
                            hint: 'Seleccione una fecha',
                            icon: Icons.cake_outlined,
                            readOnly: readOnly,
                          ),
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
                      _dialogLabel('EDAD'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: ageCtrl,
                        readOnly: true,
                        enabled: false,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF555555),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Se calcula automáticamente',
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFBBBBBB),
                          ),
                          suffixIcon: const Icon(
                            Icons.hourglass_bottom,
                            size: 18,
                            color: Color(0xFF999999),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFEFEFEF),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          // ── Separador y campos de credenciales ──
          if (userCtrl != null && passCtrl != null) ...[
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFE0E0E0)),
            const SizedBox(height: 12),
            if (isMobile) ...[
              _dialogLabel('USUARIO'),
              const SizedBox(height: 6),
              TextField(
                controller: userCtrl,
                readOnly: readOnly,
                obscureText: obscureUser,
                style: TextStyle(
                  fontSize: 13,
                  color: readOnly ? const Color(0xFF555555) : null,
                ),
                decoration: InputDecoration(
                  hintText: 'Ej. julian.sanchez',
                  hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureUser ? Icons.visibility_off : Icons.visibility,
                      size: 18,
                      color: const Color(0xFF999999),
                    ),
                    onPressed: onToggleUser,
                  ),
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
              ),
              const SizedBox(height: 16),
              _dialogLabel('CONTRASEÑA'),
              const SizedBox(height: 6),
              TextField(
                controller: passCtrl,
                readOnly: readOnly,
                obscureText: obscurePass,
                style: TextStyle(
                  fontSize: 13,
                  color: readOnly ? const Color(0xFF555555) : null,
                ),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePass ? Icons.visibility_off : Icons.visibility,
                      size: 18,
                      color: const Color(0xFF999999),
                    ),
                    onPressed: onTogglePass,
                  ),
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
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _dialogLabel('USUARIO'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: userCtrl,
                          readOnly: readOnly,
                          obscureText: obscureUser,
                          style: TextStyle(
                            fontSize: 13,
                            color: readOnly ? const Color(0xFF555555) : null,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Ej. julian.sanchez',
                            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureUser ? Icons.visibility_off : Icons.visibility,
                                size: 18,
                                color: const Color(0xFF999999),
                              ),
                              onPressed: onToggleUser,
                            ),
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _dialogLabel('CONTRASEÑA'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: passCtrl,
                          readOnly: readOnly,
                          obscureText: obscurePass,
                          style: TextStyle(
                            fontSize: 13,
                            color: readOnly ? const Color(0xFF555555) : null,
                          ),
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePass ? Icons.visibility_off : Icons.visibility,
                                size: 18,
                                color: const Color(0xFF999999),
                              ),
                              onPressed: onTogglePass,
                            ),
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  // ──────── AGREGAR MAESTRO ────────
  void _showAddTeacherDialog() {
    final mobile = _isMobile(context);
    final n = TextEditingController(),
        e = TextEditingController(),
        p = TextEditingController(),
        c = TextEditingController(),
        d = TextEditingController(),
        bd = TextEditingController(),
        age = TextEditingController(),
        usr = TextEditingController(),
        pwd = TextEditingController();
    bool hideUser = true, hidePass = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: mobile ? 16 : 40,
            vertical: 24,
          ),
          child: Container(
            width: mobile ? double.infinity : 500,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogHeader(
                    icon: Icons.person_add,
                    subtitle: 'PERSONAL DOCENTE',
                    title: 'Agregar Nuevo Maestro',
                  ),
                  _teacherFormFields(
                    nameCtrl: n,
                    emailCtrl: e,
                    phoneCtrl: p,
                    curpCtrl: c,
                    dateCtrl: d,
                    birthDateCtrl: bd,
                    ageCtrl: age,
                    onPickBirthDate: () => _pickBirthDate(ctx, bd, age, setDlg),
                    isMobile: mobile,
                    userCtrl: usr,
                    passCtrl: pwd,
                    obscureUser: hideUser,
                    obscurePass: hidePass,
                    onToggleUser: () => setDlg(() => hideUser = !hideUser),
                    onTogglePass: () => setDlg(() => hidePass = !hidePass),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 24,
                    ),
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
                          onPressed: () async {
                            Navigator.pop(ctx);
                            setState(() => _isLoading = true);
                            final data = {
                              'nombre_completo': n.text,
                              'correo_electronico': e.text,
                              'telefono': p.text,
                              'curp': c.text,
                              'fecha_contratacion': d.text,
                              'fecha_nacimiento': bd.text,
                              'edad': int.tryParse(age.text) ?? 0,
                              if (pwd.text.isNotEmpty) 'pin_acceso': pwd.text,
                            };
                            bool success = await _apiService.agregarMaestro(data);
                            if (success) {
                              _loadMaestros();
                            } else {
                              setState(() => _isLoading = false);
                            }
                          },
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 18,
                          ),
                          label: const Text('Guardar Maestro'),
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
        ),
      ),
    );
  }

  // ──────── MODIFICAR MAESTRO ────────
  void _showEditTeacherDialog(_TeacherData t) {
    final mobile = _isMobile(context);
    final n = TextEditingController(text: t.name),
        e = TextEditingController(text: t.email),
        p = TextEditingController(text: t.telefono),
        c = TextEditingController(text: t.curp),
        d = TextEditingController(text: t.fechaContratacion),
        bd = TextEditingController(text: t.fechaNacimiento),
        age = TextEditingController(text: t.edad.toString()),
        usr = TextEditingController(),
        pwd = TextEditingController();
    bool hideUser = true, hidePass = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: mobile ? 16 : 40,
            vertical: 24,
          ),
          child: Container(
            width: mobile ? double.infinity : 500,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogHeader(
                    icon: Icons.edit,
                    subtitle: 'PERSONAL DOCENTE',
                    title: 'Modificar Información',
                  ),
                  _teacherFormFields(
                    nameCtrl: n,
                    emailCtrl: e,
                    phoneCtrl: p,
                    curpCtrl: c,
                    dateCtrl: d,
                    birthDateCtrl: bd,
                    ageCtrl: age,
                    onPickBirthDate: () => _pickBirthDate(ctx, bd, age, setDlg),
                    isMobile: mobile,
                    userCtrl: usr,
                    passCtrl: pwd,
                    obscureUser: hideUser,
                    obscurePass: hidePass,
                    onToggleUser: () => setDlg(() => hideUser = !hideUser),
                    onTogglePass: () => setDlg(() => hidePass = !hidePass),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 24,
                    ),
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
                          onPressed: () async {
                            Navigator.pop(ctx);
                            setState(() => _isLoading = true);
                            final data = {
                              'nombre_completo': n.text,
                              'correo_electronico': e.text,
                              'telefono': p.text,
                              'curp': c.text,
                              'fecha_contratacion': d.text,
                              'fecha_nacimiento': bd.text,
                              'edad': int.tryParse(age.text) ?? 0,
                              if (pwd.text.isNotEmpty) 'pin_acceso': pwd.text,
                            };
                            bool success = await _apiService.actualizarMaestro(t.idMaestro, data);
                            if (success) {
                              _loadMaestros();
                            } else {
                              setState(() => _isLoading = false);
                            }
                          },
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 18,
                          ),
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
        ),
      ),
    );
  }

  // ──────── VER INFORMACIÓN MAESTRO ────────
  void _showViewTeacherDialog(_TeacherData t) {
    final mobile = _isMobile(context);
    final n = TextEditingController(text: t.name),
        e = TextEditingController(text: t.email),
        p = TextEditingController(text: t.telefono),
        c = TextEditingController(text: t.curp),
        d = TextEditingController(text: t.fechaContratacion),
        bd = TextEditingController(text: t.fechaNacimiento),
        age = TextEditingController(text: t.edad.toString()),
        usr = TextEditingController(),
        pwd = TextEditingController();
    bool hideUser = true, hidePass = true;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: EdgeInsets.symmetric(
            horizontal: mobile ? 16 : 40,
            vertical: 24,
          ),
          child: Container(
            width: mobile ? double.infinity : 500,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogHeader(
                    icon: Icons.visibility,
                    subtitle: 'PERSONAL DOCENTE',
                    title: 'Información del Maestro',
                  ),
                  _teacherFormFields(
                    nameCtrl: n,
                    emailCtrl: e,
                    phoneCtrl: p,
                    curpCtrl: c,
                    dateCtrl: d,
                    birthDateCtrl: bd,
                    ageCtrl: age,
                    onPickBirthDate: () {},
                    isMobile: mobile,
                    readOnly: true,
                    userCtrl: usr,
                    passCtrl: pwd,
                    obscureUser: hideUser,
                    obscurePass: hidePass,
                    onToggleUser: () => setDlg(() => hideUser = !hideUser),
                    onTogglePass: () => setDlg(() => hidePass = !hidePass),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text('Cerrar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF757575),
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
        ),
      ),
    );
  }

  // ──────── ASIGNAR MATERIAS ────────
  void _showAssignSubjectsDialog(_TeacherData t) {
    final mobile = _isMobile(context);
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
              borderRadius: BorderRadius.circular(16),
            ),
            insetPadding: EdgeInsets.symmetric(
              horizontal: mobile ? 16 : 40,
              vertical: 24,
            ),
            child: Container(
              width: mobile ? double.infinity : 540,
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.menu_book,
                              size: 16,
                              color: Color(0xFF4CAF50),
                            ),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'GESTIÓN ACADÉMICA',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                            children: [
                              const TextSpan(text: 'Asignar Materias a '),
                              TextSpan(
                                text: t.name,
                                style: const TextStyle(
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Seleccione las materias que impartirá el docente durante el período escolar actual.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF888888),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: subjects
                          .map(
                            (s) => SizedBox(
                              width: mobile
                                  ? double.infinity
                                  : (540 - 48 - 12) / 2,
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
                                          ? const Color(
                                              0xFF4CAF50,
                                            ).withOpacity(0.3)
                                          : const Color(0xFFE8E8E8),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
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
                                            width: 2,
                                          ),
                                        ),
                                        child: s.selected
                                            ? const Icon(
                                                Icons.check,
                                                size: 14,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              s.name,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF333333),
                                              ),
                                            ),
                                            Text(
                                              '${s.category} • ${s.hours}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFF999999),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    mobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '$count',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4CAF50),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Materias seleccionadas',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF888888),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(
                                        color: Color(0xFF888888),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
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
                                    child: const Text('Actualizar'),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                '$count',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Materias seleccionadas',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF888888),
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(color: Color(0xFF888888)),
                                ),
                              ),
                              const SizedBox(width: 8),
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
                                child: const Text('Actualizar Asignaciones'),
                              ),
                            ],
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

  // ──────── ELIMINAR MAESTRO ────────
  void _showDeleteDialog(_TeacherData t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEF5350).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFEF5350),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Flexible(
              child: Text(
                'Eliminar Maestro',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
              height: 1.5,
            ),
            children: [
              const TextSpan(text: '¿Está seguro de que desea eliminar a '),
              TextSpan(
                text: t.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const TextSpan(text: '? Esta acción no se puede deshacer.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFF888888)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() => _isLoading = true);
              bool success = await _apiService.eliminarMaestro(t.idMaestro);
              if (success) {
                _loadMaestros();
              } else {
                setState(() => _isLoading = false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Sí, eliminar'),
          ),
        ],
      ),
    );
  }
}

// ──────── DATA MODELS ────────
class _TeacherData {
  final int idMaestro;
  final String name, email, initials, curp, telefono, fechaContratacion, fechaNacimiento;
  final int edad;
  final Color avatarColor;
  final int groups;

  const _TeacherData(
    this.name,
    this.email,
    this.initials,
    this.avatarColor,
    this.curp,
    this.groups,
    this.idMaestro,
    this.telefono,
    this.fechaContratacion,
    this.fechaNacimiento,
    this.edad,
  );

  factory _TeacherData.fromJson(Map<String, dynamic> json) {
    String nombre = json['nombre_completo'] ?? '';
    List<String> nomParts = nombre.split(' ');
    String ini = nomParts.length > 1 
      ? '${nomParts[0][0]}${nomParts[1][0]}'.toUpperCase()
      : (nombre.isNotEmpty ? nombre.substring(0, 1).toUpperCase() : '?');

    return _TeacherData(
      nombre,
      json['correo_electronico'] ?? '',
      ini,
      const Color(0xFF4CAF50), // Color placeholder
      json['curp'] ?? '',
      0, // Groups: hardcoded placeholder for now if not in table
      json['id_maestro'] ?? 0,
      json['telefono'] ?? '',
      json['fecha_contratacion'] ?? '',
      json['fecha_nacimiento'] ?? '',
      json['edad'] ?? 0,
    );
  }
}

class _SubjectData {
  final String name, category, hours;
  bool selected;
  _SubjectData(this.name, this.category, this.hours, this.selected);
}
