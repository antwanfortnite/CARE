import 'package:flutter/material.dart';
import 'AdminScaffold.dart';
import 'DashboardAdmin.dart';
import 'MaestrosAdmin.dart';
import 'AlumnosAdmin.dart';
import 'GruposAdmin.dart';
import 'EvidenciasAdmin.dart';

class AdministradoresAdmin extends StatefulWidget {
  const AdministradoresAdmin({super.key});
  @override
  State<AdministradoresAdmin> createState() => _AdministradoresAdminState();
}

class _AdministradoresAdminState extends State<AdministradoresAdmin> {
  int _currentPage = 1;
  final int _totalPages = 2;
  final TextEditingController _searchController = TextEditingController();

  // Datos falsos de administradores
  final List<_AdminData> _admins = [
    _AdminData(
      idAdmin: 1,
      name: 'Carlos Rodríguez López',
      email: 'carlos.rodriguez@care.edu',
      initials: 'CR',
      avatarColor: const Color(0xFF4CAF50),
      curp: 'ROLC850312HDFDRR08',
      telefono: '+52 614 123 4567',
      fechaNacimiento: '1985-03-12',
      fechaContratacion: '2018-08-15',
      edad: 41,
      rol: 'Superusuario',
      usuario: 'carlos.rodriguez',
      contrasena: 'admin1234',
    ),
    _AdminData(
      idAdmin: 2,
      name: 'María Elena Fernández',
      email: 'maria.fernandez@care.edu',
      initials: 'MF',
      avatarColor: const Color(0xFF7E57C2),
      curp: 'FEMM900625MDFRRR02',
      telefono: '+52 614 987 6543',
      fechaNacimiento: '1990-06-25',
      fechaContratacion: '2020-01-10',
      edad: 35,
      rol: 'Administrador',
      usuario: 'maria.fernandez',
      contrasena: 'admin5678',
    ),
    _AdminData(
      idAdmin: 3,
      name: 'Roberto Sánchez Díaz',
      email: 'roberto.sanchez@care.edu',
      initials: 'RS',
      avatarColor: const Color(0xFF42A5F5),
      curp: 'SADR880914HDFNZB03',
      telefono: '+52 614 456 7890',
      fechaNacimiento: '1988-09-14',
      fechaContratacion: '2019-05-20',
      edad: 37,
      rol: 'Administrador',
      usuario: 'roberto.sanchez',
      contrasena: 'admin9012',
    ),
    _AdminData(
      idAdmin: 4,
      name: 'Ana Patricia Morales',
      email: 'ana.morales@care.edu',
      initials: 'AM',
      avatarColor: const Color(0xFFEF5350),
      curp: 'MOAA920130MDFRLP07',
      telefono: '+52 614 321 0987',
      fechaNacimiento: '1992-01-30',
      fechaContratacion: '2021-09-01',
      edad: 34,
      rol: 'Administrador',
      usuario: 'ana.morales',
      contrasena: 'admin3456',
    ),
    _AdminData(
      idAdmin: 5,
      name: 'Javier Hernández Ruiz',
      email: 'javier.hernandez@care.edu',
      initials: 'JH',
      avatarColor: const Color(0xFFFFA726),
      curp: 'HERJ870720HDFRNV05',
      telefono: '+52 614 654 3210',
      fechaNacimiento: '1987-07-20',
      fechaContratacion: '2017-03-15',
      edad: 38,
      rol: 'Superusuario',
      usuario: 'javier.hernandez',
      contrasena: 'admin7890',
    ),
  ];

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
      selectedIndex: 5,
      destinations: {
        0: (_) => const DashboardAdmin(),
        1: (_) => const MaestrosAdmin(),
        2: (_) => const AlumnosAdmin(),
        3: (_) => const GruposAdmin(),
        4: (_) => const EvidenciasAdmin(),
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
        isMobile ? _buildAdminCards() : _buildAdminTable(),
      ],
    );
  }

  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestión de Administradores',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Administración de usuarios con acceso al panel.',
            style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddAdminDialog(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Agregar Administrador'),
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
                'Gestión de Administradores',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Administración de usuarios con acceso al panel.',
                style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => _showAddAdminDialog(),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Agregar Nuevo Administrador'),
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

  // ──────── MOBILE ADMIN CARDS ────────
  Widget _buildAdminCards() {
    return Column(
      children: [
        ..._admins.map((a) => _buildAdminCardMobile(a)),
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

  Widget _buildAdminCardMobile(_AdminData a) {
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
                backgroundColor: a.avatarColor.withOpacity(0.15),
                child: Text(
                  a.initials,
                  style: TextStyle(
                    color: a.avatarColor,
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
                      a.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      a.email,
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
                  a.curp,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF555555),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: a.rol == 'Superusuario'
                      ? const Color(0xFF4CAF50).withOpacity(0.1)
                      : const Color(0xFF42A5F5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  a.rol,
                  style: TextStyle(
                    fontSize: 11,
                    color: a.rol == 'Superusuario'
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF42A5F5),
                    fontWeight: FontWeight.w600,
                  ),
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
                () => _showViewAdminDialog(a),
              ),
              const SizedBox(width: 8),
              _actionBtn(
                Icons.edit_outlined,
                const Color(0xFF42A5F5),
                'Modificar',
                () => _showEditAdminDialog(a),
              ),
              const SizedBox(width: 8),
              _actionBtn(
                Icons.delete_outline,
                const Color(0xFFEF5350),
                'Eliminar',
                () => _showDeleteDialog(a),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────── TABLE ────────
  Widget _buildAdminTable() {
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
                                'NOMBRE DEL ADMINISTRADOR',
                                style: _headerStyle,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('CURP', style: _headerStyle),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('ROL', style: _headerStyle),
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
                        _admins.length,
                        (i) => _buildAdminRow(_admins[i]),
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

  Widget _buildAdminRow(_AdminData a) {
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
                  backgroundColor: a.avatarColor.withOpacity(0.15),
                  child: Text(
                    a.initials,
                    style: TextStyle(
                      color: a.avatarColor,
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
                        a.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        a.email,
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
              a.curp,
              style: const TextStyle(fontSize: 11, color: Color(0xFF555555)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: a.rol == 'Superusuario'
                        ? const Color(0xFF4CAF50).withOpacity(0.1)
                        : const Color(0xFF42A5F5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    a.rol,
                    style: TextStyle(
                      fontSize: 11,
                      color: a.rol == 'Superusuario'
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF42A5F5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
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
                  () => _showViewAdminDialog(a),
                ),
                const SizedBox(width: 8),
                _actionBtn(
                  Icons.edit_outlined,
                  const Color(0xFF42A5F5),
                  'Modificar',
                  () => _showEditAdminDialog(a),
                ),
                const SizedBox(width: 8),
                _actionBtn(
                  Icons.delete_outline,
                  const Color(0xFFEF5350),
                  'Eliminar',
                  () => _showDeleteDialog(a),
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
            'Mostrando ${_admins.length} de ${_admins.length} administradores',
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

  // ──────── HELPERS ────────
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
        birthDateCtrl.text = '${picked.year}-$month-$day';
        ageCtrl.text = '${_calculateAge(picked)}';
      });
    }
  }

  Future<void> _pickHireDate(
    BuildContext ctx,
    TextEditingController dateCtrl,
    StateSetter setDlg,
  ) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF4CAF50),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CAF50),
              secondary: Color(0xFF4CAF50),
              onPrimary: Colors.white,
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
        dateCtrl.text = '${picked.year}-$month-$day';
      });
    }
  }

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

  // ──────── FORM FIELDS ────────
  Widget _adminFormFields({
    required TextEditingController nameCtrl,
    required TextEditingController emailCtrl,
    required TextEditingController phoneCtrl,
    required TextEditingController curpCtrl,
    required TextEditingController dateCtrl,
    required TextEditingController birthDateCtrl,
    required TextEditingController ageCtrl,
    required TextEditingController rolCtrl,
    required VoidCallback onPickBirthDate,
    required VoidCallback onPickHireDate,
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
            hint: 'Ej. Carlos Rodríguez López',
            icon: Icons.person_outline,
            readOnly: readOnly,
          ),
          const SizedBox(height: 16),
          if (isMobile) ...[
            _dialogLabel('CORREO ELECTRÓNICO'),
            const SizedBox(height: 6),
            _dialogTextField(
              controller: emailCtrl,
              hint: 'admin@care.edu',
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
            GestureDetector(
              onTap: readOnly ? null : onPickHireDate,
              child: AbsorbPointer(
                child: _dialogTextField(
                  controller: dateCtrl,
                  hint: 'yyyy-mm-dd',
                  icon: Icons.calendar_today_outlined,
                  readOnly: readOnly,
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
                      _dialogLabel('CORREO ELECTRÓNICO'),
                      const SizedBox(height: 6),
                      _dialogTextField(
                        controller: emailCtrl,
                        hint: 'admin@care.edu',
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
                      GestureDetector(
                        onTap: readOnly ? null : onPickHireDate,
                        child: AbsorbPointer(
                          child: _dialogTextField(
                            controller: dateCtrl,
                            hint: 'yyyy-mm-dd',
                            icon: Icons.calendar_today_outlined,
                            readOnly: readOnly,
                          ),
                        ),
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
                  hint: 'yyyy-mm-dd',
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
            const SizedBox(height: 16),
            _dialogLabel('ROL'),
            const SizedBox(height: 6),
            _dialogTextField(
              controller: rolCtrl,
              hint: 'Ej. Administrador',
              icon: Icons.admin_panel_settings_outlined,
              readOnly: readOnly,
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
                            hint: 'yyyy-mm-dd',
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
            const SizedBox(height: 16),
            _dialogLabel('ROL'),
            const SizedBox(height: 6),
            _dialogTextField(
              controller: rolCtrl,
              hint: 'Ej. Administrador',
              icon: Icons.admin_panel_settings_outlined,
              readOnly: readOnly,
            ),
          ],
          // ── Credenciales ──
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
                  hintText: 'Ej. carlos.rodriguez',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFBBBBBB),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureUser ? Icons.visibility_off : Icons.visibility,
                      size: 18,
                      color: const Color(0xFF999999),
                    ),
                    onPressed: onToggleUser,
                  ),
                  filled: true,
                  fillColor: readOnly
                      ? const Color(0xFFEFEFEF)
                      : const Color(0xFFF9F9F9),
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
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFBBBBBB),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePass ? Icons.visibility_off : Icons.visibility,
                      size: 18,
                      color: const Color(0xFF999999),
                    ),
                    onPressed: onTogglePass,
                  ),
                  filled: true,
                  fillColor: readOnly
                      ? const Color(0xFFEFEFEF)
                      : const Color(0xFFF9F9F9),
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
                            hintText: 'Ej. carlos.rodriguez',
                            hintStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFFBBBBBB),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureUser
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 18,
                                color: const Color(0xFF999999),
                              ),
                              onPressed: onToggleUser,
                            ),
                            filled: true,
                            fillColor: readOnly
                                ? const Color(0xFFEFEFEF)
                                : const Color(0xFFF9F9F9),
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
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF4CAF50),
                              ),
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
                            hintStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFFBBBBBB),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePass
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 18,
                                color: const Color(0xFF999999),
                              ),
                              onPressed: onTogglePass,
                            ),
                            filled: true,
                            fillColor: readOnly
                                ? const Color(0xFFEFEFEF)
                                : const Color(0xFFF9F9F9),
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
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF4CAF50),
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
          ],
        ],
      ),
    );
  }

  // ──────── AGREGAR ADMINISTRADOR ────────
  void _showAddAdminDialog() {
    final mobile = _isMobile(context);
    final n = TextEditingController(),
        e = TextEditingController(),
        p = TextEditingController(),
        c = TextEditingController(),
        d = TextEditingController(),
        bd = TextEditingController(),
        age = TextEditingController(),
        rol = TextEditingController(),
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
                    subtitle: 'PANEL ADMINISTRATIVO',
                    title: 'Agregar Nuevo Administrador',
                  ),
                  _adminFormFields(
                    nameCtrl: n,
                    emailCtrl: e,
                    phoneCtrl: p,
                    curpCtrl: c,
                    dateCtrl: d,
                    birthDateCtrl: bd,
                    ageCtrl: age,
                    rolCtrl: rol,
                    onPickBirthDate: () => _pickBirthDate(ctx, bd, age, setDlg),
                    onPickHireDate: () => _pickHireDate(ctx, d, setDlg),
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
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 18,
                          ),
                          label: const Text('Guardar Administrador'),
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

  // ──────── VER ADMINISTRADOR ────────
  void _showViewAdminDialog(_AdminData a) {
    final mobile = _isMobile(context);
    final n = TextEditingController(text: a.name),
        e = TextEditingController(text: a.email),
        p = TextEditingController(text: a.telefono),
        c = TextEditingController(text: a.curp),
        d = TextEditingController(text: a.fechaContratacion),
        bd = TextEditingController(text: a.fechaNacimiento),
        age = TextEditingController(text: a.edad.toString()),
        rol = TextEditingController(text: a.rol),
        usr = TextEditingController(text: a.usuario),
        pwd = TextEditingController(text: a.contrasena);
    bool hideUser = true, hidePass = true;
    showDialog(
      context: context,
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
                    icon: Icons.admin_panel_settings,
                    subtitle: 'INFORMACIÓN DEL ADMINISTRADOR',
                    title: a.name,
                  ),
                  _adminFormFields(
                    nameCtrl: n,
                    emailCtrl: e,
                    phoneCtrl: p,
                    curpCtrl: c,
                    dateCtrl: d,
                    birthDateCtrl: bd,
                    ageCtrl: age,
                    rolCtrl: rol,
                    onPickBirthDate: () {},
                    onPickHireDate: () {},
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
      ),
    );
  }

  // ──────── EDITAR ADMINISTRADOR ────────
  void _showEditAdminDialog(_AdminData a) {
    final mobile = _isMobile(context);
    final n = TextEditingController(text: a.name),
        e = TextEditingController(text: a.email),
        p = TextEditingController(text: a.telefono),
        c = TextEditingController(text: a.curp),
        d = TextEditingController(text: a.fechaContratacion),
        bd = TextEditingController(text: a.fechaNacimiento),
        age = TextEditingController(text: a.edad.toString()),
        rol = TextEditingController(text: a.rol),
        usr = TextEditingController(text: a.usuario),
        pwd = TextEditingController(text: a.contrasena);
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
                    subtitle: 'EDITAR ADMINISTRADOR',
                    title: 'Modificar Información',
                  ),
                  _adminFormFields(
                    nameCtrl: n,
                    emailCtrl: e,
                    phoneCtrl: p,
                    curpCtrl: c,
                    dateCtrl: d,
                    birthDateCtrl: bd,
                    ageCtrl: age,
                    rolCtrl: rol,
                    onPickBirthDate: () => _pickBirthDate(ctx, bd, age, setDlg),
                    onPickHireDate: () => _pickHireDate(ctx, d, setDlg),
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
        ),
      ),
    );
  }

  // ──────── ELIMINAR ADMINISTRADOR ────────
  void _showDeleteDialog(_AdminData a) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '¿Eliminar administrador?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar a ${a.name}? Esta acción no se puede deshacer.',
          style: const TextStyle(fontSize: 14, color: Color(0xFF555555)),
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
            onPressed: () {
              Navigator.pop(ctx);
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

// ──────── DATA MODEL ────────
class _AdminData {
  final int idAdmin;
  final String name, email, initials, curp, telefono;
  final String fechaNacimiento, fechaContratacion;
  final int edad;
  final Color avatarColor;
  final String rol;
  final String usuario, contrasena;

  const _AdminData({
    required this.idAdmin,
    required this.name,
    required this.email,
    required this.initials,
    required this.avatarColor,
    required this.curp,
    required this.telefono,
    required this.fechaNacimiento,
    required this.fechaContratacion,
    required this.edad,
    required this.rol,
    required this.usuario,
    required this.contrasena,
  });
}
