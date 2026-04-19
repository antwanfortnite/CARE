import 'package:flutter/material.dart';
import 'AdminScaffold.dart';
import 'DashboardAdmin.dart';
import 'MaestrosAdmin.dart';
import 'GruposAdmin.dart';
import 'EvidenciasAdmin.dart';
import 'AdministradoresAdmin.dart';

class AlumnosAdmin extends StatefulWidget {
  const AlumnosAdmin({super.key});
  @override
  State<AlumnosAdmin> createState() => _AlumnosAdminState();
}

class _AlumnosAdminState extends State<AlumnosAdmin>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentPageCursando = 1;
  int _currentPageNoCursando = 1;
  final int _totalPages = 3;
  final TextEditingController _searchController = TextEditingController();

  final List<_StudentData> _studentsCursando = [
    _StudentData(
      'Carlos Méndez',
      'carlos.mendez@correo.com',
      'CM',
      const Color(0xFF7E57C2),
      'MECC080515HDHNRL01',
      'María Luisa Méndez García',
      'maria.mendez@correo.com',
      '6441234567',
      16,
    ),
    _StudentData(
      'Ana Sofía Rivera',
      'ana.rivera@correo.com',
      'AR',
      const Color(0xFF4CAF50),
      'RIAA090320MDFVNN02',
      'Laura Patricia Rivera López',
      'laura.rivera@correo.com',
      '6449876543',
      15,
    ),
    _StudentData(
      'Diego Hernández',
      'diego.hernan@correo.com',
      'DH',
      const Color(0xFF26A69A),
      'HEAD071205HDFRGL03',
      'Pedro Hernández Ruiz',
      'pedro.hernandez@correo.com',
      '6442345678',
      17,
    ),
    _StudentData(
      'Valentina Torres',
      'val.torres@correo.com',
      'VT',
      const Color(0xFFE91E63),
      'TORV100810MDFRLR04',
      'Rosa María Torres Vega',
      'rosa.torres@correo.com',
      '6443456789',
      14,
    ),
  ];

  final List<_StudentData> _studentsNoCursando = [
    _StudentData(
      'Miguel Ángel Ruiz',
      'miguel.ruiz@correo.com',
      'MR',
      const Color(0xFFFFA726),
      'RUIM060714HDFRGL05',
      'Elena Ruiz Sánchez',
      'elena.ruiz@correo.com',
      '6444567890',
      18,
    ),
    _StudentData(
      'Fernanda López',
      'fer.lopez@correo.com',
      'FL',
      const Color(0xFF42A5F5),
      'LOPF080922MDFPZR06',
      'Carmen López Díaz',
      'carmen.lopez@correo.com',
      '6445678901',
      16,
    ),
    _StudentData(
      'Emilio Castro',
      'emilio.c@correo.com',
      'EC',
      const Color(0xFF66BB6A),
      'CASE091130HDFSML07',
      'Jorge Castro Mendoza',
      'jorge.castro@correo.com',
      '6446789012',
      15,
    ),
  ];

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 1050;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);

    return AdminScaffold(
      selectedIndex: 2,
      destinations: {
        0: (_) => const DashboardAdmin(),
        1: (_) => const MaestrosAdmin(),
        3: (_) => const GruposAdmin(),
        4: (_) => const EvidenciasAdmin(),
        5: (_) => const AdministradoresAdmin(),
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
        _buildTabBar(),
        const SizedBox(height: 20),
        _tabController.index == 0
            ? (isMobile
                  ? _buildStudentCards(_studentsCursando, true)
                  : _buildStudentTable(_studentsCursando, true))
            : (isMobile
                  ? _buildStudentCards(_studentsNoCursando, false)
                  : _buildStudentTable(_studentsNoCursando, false)),
      ],
    );
  }

  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestión de Alumnos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Administración del alumnado inscrito y no cursando.',
            style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddStudentDialog(),
              icon: const Icon(Icons.person_add, size: 18),
              label: const Text('Agregar Nuevo Alumno'),
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
                'Gestión de Alumnos',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Administración del alumnado inscrito y no cursando.',
                style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => _showAddStudentDialog(),
          icon: const Icon(Icons.person_add, size: 18),
          label: const Text('Agregar Nuevo Alumno'),
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

  // ──────── TAB BAR ────────
  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (_) => setState(() {}),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF555555),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF4CAF50),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.all(4),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school,
                  size: 18,
                  color: _tabController.index == 0
                      ? Colors.white
                      : const Color(0xFF555555),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Alumnos Cursando',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _tabController.index == 0
                        ? Colors.white.withOpacity(0.25)
                        : const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_studentsCursando.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _tabController.index == 0
                          ? Colors.white
                          : const Color(0xFF4CAF50),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off,
                  size: 18,
                  color: _tabController.index == 1
                      ? Colors.white
                      : const Color(0xFF555555),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Alumnos No Cursando',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _tabController.index == 1
                        ? Colors.white.withOpacity(0.25)
                        : const Color(0xFFEF5350).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_studentsNoCursando.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _tabController.index == 1
                          ? Colors.white
                          : const Color(0xFFEF5350),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────── MOBILE STUDENT CARDS ────────
  Widget _buildStudentCards(List<_StudentData> students, bool isCursando) {
    return Column(
      children: [
        ...students.map((s) => _buildStudentCardMobile(s, isCursando)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: _buildPaginationContent(students, isCursando),
        ),
      ],
    );
  }

  Widget _buildStudentCardMobile(_StudentData s, bool isCursando) {
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
                backgroundColor: s.avatarColor.withOpacity(0.15),
                child: Text(
                  s.initials,
                  style: TextStyle(
                    color: s.avatarColor,
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
                      s.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCursando
                      ? const Color(0xFF4CAF50).withOpacity(0.1)
                      : const Color(0xFFEF5350).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isCursando ? 'Activo' : 'Inactivo',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isCursando
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFEF5350),
                  ),
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
                  s.curp,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF555555),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.cake_outlined,
                size: 14,
                color: Color(0xFF888888),
              ),
              const SizedBox(width: 4),
              Text(
                '${s.edad} años',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF555555),
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
                () => _showViewStudentDialog(s),
              ),
              const SizedBox(width: 16),
              _actionBtn(
                Icons.edit_outlined,
                const Color(0xFF42A5F5),
                'Modificar',
                () => _showEditStudentDialog(s),
              ),
              const SizedBox(width: 8),
              if (isCursando)
                _actionBtn(
                  Icons.arrow_downward,
                  const Color(0xFFEF5350),
                  'Dar de baja',
                  () => _showDarDeBajaDialog(s),
                )
              else
                _actionBtn(
                  Icons.arrow_upward,
                  const Color(0xFF4CAF50),
                  'Dar de alta',
                  () => _showDarDeAltaDialog(s),
                ),
              const SizedBox(width: 8),
              _actionBtn(
                Icons.delete_outline,
                const Color(0xFFEF5350),
                'Eliminar',
                () => _showDeleteDialog(s),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────── TABLE ────────
  Widget _buildStudentTable(List<_StudentData> students, bool isCursando) {
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
              final tableWidth = constraints.maxWidth < 900
                  ? 900.0
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
                                'NOMBRE DEL ALUMNO',
                                style: _headerStyle,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('CURP', style: _headerStyle),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'EDAD',
                                style: _headerStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'ESTADO',
                                style: _headerStyle,
                                textAlign: TextAlign.center,
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
                        students.length,
                        (i) => _buildStudentRow(students[i], isCursando),
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
            child: _buildPaginationContent(students, isCursando),
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

  Widget _buildStudentRow(_StudentData s, bool isCursando) {
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
                  backgroundColor: s.avatarColor.withOpacity(0.15),
                  child: Text(
                    s.initials,
                    style: TextStyle(
                      color: s.avatarColor,
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
                        s.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s.email,
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
              s.curp,
              style: const TextStyle(fontSize: 11, color: Color(0xFF555555)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${s.edad} años',
              style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isCursando
                      ? const Color(0xFF4CAF50).withOpacity(0.1)
                      : const Color(0xFFEF5350).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isCursando ? 'Activo' : 'Inactivo',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isCursando
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFEF5350),
                  ),
                ),
              ),
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
                  () => _showViewStudentDialog(s),
                ),
                const SizedBox(width: 16),
                _actionBtn(
                  Icons.edit_outlined,
                  const Color(0xFF42A5F5),
                  'Modificar',
                  () => _showEditStudentDialog(s),
                ),
                const SizedBox(width: 8),
                if (isCursando)
                  _actionBtn(
                    Icons.arrow_downward,
                    const Color(0xFFEF5350),
                    'Dar de baja',
                    () => _showDarDeBajaDialog(s),
                  )
                else
                  _actionBtn(
                    Icons.arrow_upward,
                    const Color(0xFF4CAF50),
                    'Dar de alta',
                    () => _showDarDeAltaDialog(s),
                  ),
                const SizedBox(width: 8),
                _actionBtn(
                  Icons.delete_outline,
                  const Color(0xFFEF5350),
                  'Eliminar',
                  () => _showDeleteDialog(s),
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

  Widget _buildPaginationContent(List<_StudentData> students, bool isCursando) {
    final currentPage = isCursando
        ? _currentPageCursando
        : _currentPageNoCursando;
    final totalLabel = isCursando ? '124' : '38';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Mostrando ${students.length} de $totalLabel alumnos',
            style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            _pageBtn(
              '‹',
              enabled: currentPage > 1,
              onTap: () => setState(() {
                if (isCursando) {
                  _currentPageCursando--;
                } else {
                  _currentPageNoCursando--;
                }
              }),
            ),
            ...List.generate(
              _totalPages,
              (i) => _pageBtn(
                '${i + 1}',
                isSelected: i + 1 == currentPage,
                onTap: () => setState(() {
                  if (isCursando) {
                    _currentPageCursando = i + 1;
                  } else {
                    _currentPageNoCursando = i + 1;
                  }
                }),
              ),
            ),
            _pageBtn(
              '›',
              enabled: currentPage < _totalPages,
              onTap: () => setState(() {
                if (isCursando) {
                  _currentPageCursando++;
                } else {
                  _currentPageNoCursando++;
                }
              }),
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
      initialDate: DateTime(2010),
      firstDate: DateTime(2000),
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
  Widget _studentFormFields({
    required TextEditingController nameCtrl,
    required TextEditingController parentNameCtrl,
    required TextEditingController parentEmailCtrl,
    required TextEditingController parentPhoneCtrl,
    required TextEditingController curpCtrl,
    required TextEditingController birthDateCtrl,
    required TextEditingController ageCtrl,
    required VoidCallback onPickBirthDate,
    required bool isMobile,
    bool readOnly = false,
    TextEditingController? passCtrl,
    bool obscurePass = true,
    VoidCallback? onTogglePass,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dialogLabel('NOMBRE COMPLETO DEL PADRE'),
          const SizedBox(height: 6),
          _dialogTextField(
            controller: parentNameCtrl,
            hint: 'Ej. María Luisa Méndez García',
            icon: Icons.family_restroom_outlined,
            readOnly: readOnly,
          ),
          const SizedBox(height: 16),
          _dialogLabel('NOMBRE COMPLETO'),
          const SizedBox(height: 6),
          _dialogTextField(
            controller: nameCtrl,
            hint: 'Ej. Carlos Méndez López',
            icon: Icons.person_outline,
            readOnly: readOnly,
          ),
          const SizedBox(height: 16),
          if (isMobile) ...[
            _dialogLabel('CORREO ELECTRÓNICO DEL PADRE'),
            const SizedBox(height: 6),
            _dialogTextField(
              controller: parentEmailCtrl,
              hint: 'padre@correo.com',
              icon: Icons.alternate_email,
              readOnly: readOnly,
            ),
            const SizedBox(height: 16),
            _dialogLabel('TELÉFONO DEL PADRE'),
            const SizedBox(height: 6),
            _dialogTextField(
              controller: parentPhoneCtrl,
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
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _dialogLabel('CORREO ELECTRÓNICO DEL PADRE'),
                      const SizedBox(height: 6),
                      _dialogTextField(
                        controller: parentEmailCtrl,
                        hint: 'padre@correo.com',
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
                      _dialogLabel('TELÉFONO DEL PADRE'),
                      const SizedBox(height: 6),
                      _dialogTextField(
                        controller: parentPhoneCtrl,
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
            // CURP ocupa toda la fila (sin fecha de contratación)
            _dialogLabel('CURP'),
            const SizedBox(height: 6),
            _dialogTextField(
              controller: curpCtrl,
              hint: 'XXXX000000XXXXXXXX',
              icon: Icons.badge_outlined,
              readOnly: readOnly,
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
          // ── Separador y campo de contraseña ──
          if (passCtrl != null) ...[
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFE0E0E0)),
            const SizedBox(height: 12),
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
          ],
        ],
      ),
    );
  }

  // ──────── AGREGAR ALUMNO ────────
  void _showAddStudentDialog() {
    final mobile = _isMobile(context);
    final n = TextEditingController(),
        pn = TextEditingController(),
        pe = TextEditingController(),
        pp = TextEditingController(),
        c = TextEditingController(),
        bd = TextEditingController(),
        age = TextEditingController(),
        pwd = TextEditingController();
    bool hidePass = true;
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
                    subtitle: 'REGISTRO DE ALUMNOS',
                    title: 'Agregar Nuevo Alumno',
                  ),
                  _studentFormFields(
                    nameCtrl: n,
                    parentNameCtrl: pn,
                    parentEmailCtrl: pe,
                    parentPhoneCtrl: pp,
                    curpCtrl: c,
                    birthDateCtrl: bd,
                    ageCtrl: age,
                    onPickBirthDate: () => _pickBirthDate(ctx, bd, age, setDlg),
                    isMobile: mobile,
                    passCtrl: pwd,
                    obscurePass: hidePass,
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
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 18,
                          ),
                          label: const Text('Guardar Alumno'),
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

  // ──────── MODIFICAR ALUMNO ────────
  void _showEditStudentDialog(_StudentData s) {
    final mobile = _isMobile(context);
    final n = TextEditingController(text: s.name),
        pn = TextEditingController(text: s.parentName),
        pe = TextEditingController(text: s.parentEmail),
        pp = TextEditingController(text: s.parentPhone),
        c = TextEditingController(text: s.curp),
        bd = TextEditingController(),
        age = TextEditingController(text: '${s.edad}'),
        pwd = TextEditingController();
    bool hidePass = true;
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
                    subtitle: 'REGISTRO DE ALUMNOS',
                    title: 'Modificar Información',
                  ),
                  _studentFormFields(
                    nameCtrl: n,
                    parentNameCtrl: pn,
                    parentEmailCtrl: pe,
                    parentPhoneCtrl: pp,
                    curpCtrl: c,
                    birthDateCtrl: bd,
                    ageCtrl: age,
                    onPickBirthDate: () => _pickBirthDate(ctx, bd, age, setDlg),
                    isMobile: mobile,
                    passCtrl: pwd,
                    obscurePass: hidePass,
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
                          onPressed: () => Navigator.pop(ctx),
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

  // ──────── VER INFORMACIÓN ALUMNO ────────
  void _showViewStudentDialog(_StudentData s) {
    final mobile = _isMobile(context);
    final n = TextEditingController(text: s.name),
        pn = TextEditingController(text: s.parentName),
        pe = TextEditingController(text: s.parentEmail),
        pp = TextEditingController(text: s.parentPhone),
        c = TextEditingController(text: s.curp),
        bd = TextEditingController(),
        age = TextEditingController(text: '${s.edad}'),
        pwd = TextEditingController();
    bool hidePass = true;
    showDialog(
      context: context,
      barrierDismissible: true,
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
                    icon: Icons.visibility,
                    subtitle: 'REGISTRO DE ALUMNOS',
                    title: 'Información del Alumno',
                  ),
                  _studentFormFields(
                    nameCtrl: n,
                    parentNameCtrl: pn,
                    parentEmailCtrl: pe,
                    parentPhoneCtrl: pp,
                    curpCtrl: c,
                    birthDateCtrl: bd,
                    ageCtrl: age,
                    onPickBirthDate: () {},
                    isMobile: mobile,
                    readOnly: true,
                    passCtrl: pwd,
                    obscurePass: hidePass,
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

  // ──────── DAR DE BAJA ────────
  void _showDarDeBajaDialog(_StudentData s) {
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
                Icons.arrow_downward,
                color: Color(0xFFEF5350),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Flexible(
              child: Text(
                'Dar de Baja',
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
              const TextSpan(text: '¿Está seguro de que desea dar de baja a '),
              TextSpan(
                text: s.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const TextSpan(
                text: '? El alumno será movido a la sección de "No Cursando".',
              ),
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
            onPressed: () {
              setState(() {
                _studentsCursando.remove(s);
                _studentsNoCursando.add(s);
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Sí, dar de baja'),
          ),
        ],
      ),
    );
  }

  // ──────── DAR DE ALTA ────────
  void _showDarDeAltaDialog(_StudentData s) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_upward,
                color: Color(0xFF4CAF50),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Flexible(
              child: Text(
                'Dar de Alta',
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
              const TextSpan(text: '¿Está seguro de que desea dar de alta a '),
              TextSpan(
                text: s.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const TextSpan(
                text: '? El alumno será movido a la sección de "Cursando".',
              ),
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
            onPressed: () {
              setState(() {
                _studentsNoCursando.remove(s);
                _studentsCursando.add(s);
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Sí, dar de alta'),
          ),
        ],
      ),
    );
  }

  // ──────── ELIMINAR ALUMNO ────────
  void _showDeleteDialog(_StudentData s) {
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
                'Eliminar Alumno',
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
                text: s.name,
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
            onPressed: () {
              setState(() {
                _studentsCursando.remove(s);
                _studentsNoCursando.remove(s);
              });
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
class _StudentData {
  final String name,
      email,
      initials,
      curp,
      parentName,
      parentEmail,
      parentPhone;
  final Color avatarColor;
  final int edad;
  const _StudentData(
    this.name,
    this.email,
    this.initials,
    this.avatarColor,
    this.curp,
    this.parentName,
    this.parentEmail,
    this.parentPhone,
    this.edad,
  );
}
