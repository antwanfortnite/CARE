import 'package:flutter/material.dart';
import 'AdminScaffold.dart';
import 'DashboardAdmin.dart';
import 'MaestrosAdmin.dart';
import 'AlumnosAdmin.dart';

class GruposAdmin extends StatefulWidget {
  const GruposAdmin({super.key});
  @override
  State<GruposAdmin> createState() => _GruposAdminState();
}

class _GruposAdminState extends State<GruposAdmin> {
  final TextEditingController _searchController = TextEditingController();

  // ──────── Datos de ejemplo de estudiantes disponibles ────────
  final List<_StudentOption> _allStudents = [
    _StudentOption('Carlos Méndez', 'MECC080515HDHNRL01', const Color(0xFF7E57C2)),
    _StudentOption('Ana Sofía Rivera', 'RIAA090320MDFVNN02', const Color(0xFF4CAF50)),
    _StudentOption('Diego Hernández', 'HEAD071205HDFRGL03', const Color(0xFF26A69A)),
    _StudentOption('Valentina Torres', 'TORV100810MDFRLR04', const Color(0xFFE91E63)),
    _StudentOption('Miguel Ángel Ruiz', 'RUIM060714HDFRGL05', const Color(0xFFFFA726)),
    _StudentOption('Fernanda López', 'LOPF080922MDFPZR06', const Color(0xFF42A5F5)),
    _StudentOption('Emilio Castro', 'CASE091130HDFSML07', const Color(0xFF66BB6A)),
    _StudentOption('Sofía Ramírez', 'RAMS100215MDFMFR08', const Color(0xFFAB47BC)),
    _StudentOption('Andrés Martínez', 'MARA080730HDFNRD09', const Color(0xFF29B6F6)),
    _StudentOption('Camila Delgado', 'DELC090412MDFMLC10', const Color(0xFFEF5350)),
  ];

  // ──────── Datos de ejemplo de maestros disponibles ────────
  final List<String> _allTeachers = [
    'Julián Sánchez',
    'Rosa María Moreno',
    'Alberto González',
    'Elena Ledesma',
  ];

  // ──────── Datos de ejemplo de grupos ────────
  final List<_GroupData> _groups = [
    _GroupData(
      'Grupo 3A',
      'Matutino',
      const Color(0xFF7E57C2),
      ['Carlos Méndez', 'Ana Sofía Rivera', 'Diego Hernández'],
      'Julián Sánchez',
    ),
    _GroupData(
      'Grupo 1B',
      'Vespertino',
      const Color(0xFF4CAF50),
      ['Valentina Torres', 'Miguel Ángel Ruiz', 'Fernanda López', 'Emilio Castro'],
      'Rosa María Moreno',
    ),
    _GroupData(
      'Grupo 2A',
      'Matutino',
      const Color(0xFF26A69A),
      ['Sofía Ramírez', 'Andrés Martínez'],
      'Alberto González',
    ),
    _GroupData(
      'Grupo 1A',
      'Matutino',
      const Color(0xFFE91E63),
      ['Camila Delgado', 'Carlos Méndez', 'Ana Sofía Rivera', 'Valentina Torres', 'Emilio Castro'],
      'Elena Ledesma',
    ),
    _GroupData(
      'Grupo 3B',
      'Vespertino',
      const Color(0xFF42A5F5),
      ['Diego Hernández', 'Miguel Ángel Ruiz', 'Andrés Martínez'],
      'Julián Sánchez',
    ),
    _GroupData(
      'Grupo 2B',
      'Vespertino',
      const Color(0xFFFFA726),
      ['Fernanda López', 'Sofía Ramírez', 'Camila Delgado'],
      'Rosa María Moreno',
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
      selectedIndex: 3,
      destinations: {
        0: (_) => const DashboardAdmin(),
        1: (_) => const MaestrosAdmin(),
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
        _buildGroupCards(isMobile),
      ],
    );
  }

  // ──────── HEADER ────────
  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestión de Grupos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Administración de grupos y asignación de alumnos.',
            style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddGroupDialog(),
              icon: const Icon(Icons.group_add, size: 18),
              label: const Text('Agregar Nuevo Grupo'),
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
                'Gestión de Grupos',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Administración de grupos y asignación de alumnos.',
                style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => _showAddGroupDialog(),
          icon: const Icon(Icons.group_add, size: 18),
          label: const Text('Agregar Nuevo Grupo'),
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

  // ──────── FILTER BAR ────────
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
                hintText: 'Filtrar por nombre de grupo...',
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

  // ──────── GROUP CARDS GRID ────────
  Widget _buildGroupCards(bool isMobile) {
    if (isMobile) {
      return Column(
        children: _groups.map((g) => _buildGroupCard(g)).toList(),
      );
    }

    // Desktop: grid de 2 o 3 columnas
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1400 ? 3 : 2;

    List<Widget> rows = [];
    for (int i = 0; i < _groups.length; i += crossAxisCount) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < crossAxisCount; j++) {
        if (i + j < _groups.length) {
          rowChildren.add(Expanded(child: _buildGroupCard(_groups[i + j])));
        } else {
          rowChildren.add(const Expanded(child: SizedBox()));
        }
        if (j < crossAxisCount - 1) {
          rowChildren.add(const SizedBox(width: 16));
        }
      }
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rowChildren,
      ));
      if (i + crossAxisCount < _groups.length) {
        rows.add(const SizedBox(height: 0)); // spacing handled by card margin
      }
    }

    return Column(children: rows);
  }

  // ──────── SINGLE GROUP CARD ────────
  Widget _buildGroupCard(_GroupData g) {
    final initials = g.name.length >= 2
        ? g.name.substring(0, 2).toUpperCase()
        : g.name.toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Color accent bar ──
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: g.accentColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header row ──
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: g.accentColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: TextStyle(
                            color: g.accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            g.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF333333),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: g.accentColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${g.students.length} ${g.students.length == 1 ? 'alumno' : 'alumnos'}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: g.accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ── Turno & Maestro info ──
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF42A5F5).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.schedule, size: 13, color: Color(0xFF42A5F5)),
                          const SizedBox(width: 4),
                          Text(
                            g.turno,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF42A5F5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF26A69A).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person_outline, size: 13, color: Color(0xFF26A69A)),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                g.teacher.isEmpty ? 'Sin maestro' : g.teacher,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF26A69A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Student avatars preview ──
                Row(
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: 16,
                      color: Color(0xFF888888),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 32,
                        child: Stack(
                          children: [
                            ...List.generate(
                              g.students.length > 5 ? 5 : g.students.length,
                              (i) {
                                final colors = [
                                  const Color(0xFF7E57C2),
                                  const Color(0xFF4CAF50),
                                  const Color(0xFF26A69A),
                                  const Color(0xFFE91E63),
                                  const Color(0xFF42A5F5),
                                ];
                                return Positioned(
                                  left: i * 22.0,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: colors[i % colors.length]
                                          .withOpacity(0.15),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _getInitials(g.students[i]),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: colors[i % colors.length],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (g.students.length > 5)
                              Positioned(
                                left: 5 * 22.0,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8E8E8),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '+${g.students.length - 5}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF555555),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(color: Color(0xFFF0F0F0), height: 1),
                const SizedBox(height: 14),

                // ── Action buttons ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _actionBtn(
                      Icons.visibility_outlined,
                      const Color(0xFF7E57C2),
                      'Ver información',
                      () => _showViewGroupDialog(g),
                    ),
                    const SizedBox(width: 10),
                    _actionBtn(
                      Icons.edit_outlined,
                      const Color(0xFF42A5F5),
                      'Modificar',
                      () => _showEditGroupDialog(g),
                    ),
                    const SizedBox(width: 10),
                    _actionBtn(
                      Icons.delete_outline,
                      const Color(0xFFEF5350),
                      'Eliminar',
                      () => _showDeleteGroupDialog(g),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
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

  // ──────── HELPER: dialog label & text field ────────
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
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      enabled: !readOnly,
      maxLines: maxLines,
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

  // ──────── TEACHER DROPDOWN ────────
  Widget _buildTeacherDropdown({
    required String selectedTeacher,
    required void Function(String) onChanged,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? const Color(0xFFEFEFEF) : const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedTeacher.isEmpty ? null : selectedTeacher,
          isExpanded: true,
          hint: const Text(
            'Seleccionar maestro...',
            style: TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: Color(0xFF999999),
          ),
          style: const TextStyle(fontSize: 13, color: Color(0xFF333333)),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(10),
          items: [
            const DropdownMenuItem<String>(
              value: '',
              child: Text(
                'Sin maestro asignado',
                style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
              ),
            ),
            ..._allTeachers.map((t) => DropdownMenuItem<String>(
              value: t,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: const Color(0xFF26A69A).withOpacity(0.15),
                    child: Text(
                      _getInitials(t),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF26A69A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(t, style: const TextStyle(fontSize: 13)),
                ],
              ),
            )),
          ],
          onChanged: readOnly ? null : (val) => onChanged(val ?? ''),
        ),
      ),
    );
  }

  // ──────── STUDENT SELECTOR WIDGET ────────
  Widget _buildStudentSelector({
    required List<String> selectedStudents,
    required void Function(VoidCallback) setDlg,
    required TextEditingController searchCtrl,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dialogLabel('ALUMNOS ASIGNADOS'),
        const SizedBox(height: 6),

        // Chips de estudiantes seleccionados
        if (selectedStudents.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: selectedStudents.map((name) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF4CAF50).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: const Color(0xFF4CAF50).withOpacity(0.2),
                        child: Text(
                          _getInitials(name),
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (!readOnly) ...[
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {
                            setDlg(() {
                              selectedStudents.remove(name);
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Buscador de estudiantes (solo si no es readOnly)
        if (!readOnly) ...[
          _dialogLabel('BUSCAR Y AGREGAR ALUMNOS'),
          const SizedBox(height: 6),
          TextField(
            controller: searchCtrl,
            onChanged: (_) => setDlg(() {}),
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Buscar alumno por nombre...',
              hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
              prefixIcon: const Icon(
                Icons.search,
                size: 18,
                color: Color(0xFF999999),
              ),
              filled: true,
              fillColor: const Color(0xFFF9F9F9),
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
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF4CAF50)),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Lista filtrada de estudiantes disponibles
          Container(
            constraints: const BoxConstraints(maxHeight: 180),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE8E8E8)),
            ),
            child: Builder(
              builder: (context) {
                final query = searchCtrl.text.toLowerCase();
                final filtered = _allStudents.where((s) {
                  final matchesSearch = query.isEmpty ||
                      s.name.toLowerCase().contains(query) ||
                      s.curp.toLowerCase().contains(query);
                  final notSelected = !selectedStudents.contains(s.name);
                  return matchesSearch && notSelected;
                }).toList();

                if (filtered.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'No se encontraron alumnos disponibles',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: Color(0xFFF0F0F0),
                  ),
                  itemBuilder: (context, index) {
                    final student = filtered[index];
                    return InkWell(
                      onTap: () {
                        setDlg(() {
                          selectedStudents.add(student.name);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: student.color.withOpacity(0.15),
                              child: Text(
                                _getInitials(student.name),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: student.color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student.name,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  Text(
                                    student.curp,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF999999),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 16,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  // ──────── AGREGAR GRUPO ────────
  void _showAddGroupDialog() {
    final mobile = _isMobile(context);
    final nameCtrl = TextEditingController();
    final turnoCtrl = TextEditingController();
    final studentSearchCtrl = TextEditingController();
    final List<String> selectedStudents = [];
    String selectedTeacher = '';

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
            width: mobile ? double.infinity : 540,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogHeader(
                    icon: Icons.group_add,
                    subtitle: 'GESTIÓN DE GRUPOS',
                    title: 'Agregar Nuevo Grupo',
                  ),

                  // ── Form fields ──
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _dialogLabel('NOMBRE DEL GRUPO'),
                        const SizedBox(height: 6),
                        _dialogTextField(
                          controller: nameCtrl,
                          hint: 'Ej. Grupo 1A',
                          icon: Icons.group_outlined,
                        ),
                        const SizedBox(height: 16),
                        _dialogLabel('TURNO'),
                        const SizedBox(height: 6),
                        _dialogTextField(
                          controller: turnoCtrl,
                          hint: 'Ej. Matutino, Vespertino',
                          icon: Icons.schedule_outlined,
                        ),
                        const SizedBox(height: 16),
                        _dialogLabel('MAESTRO ASIGNADO'),
                        const SizedBox(height: 6),
                        _buildTeacherDropdown(
                          selectedTeacher: selectedTeacher,
                          onChanged: (val) => setDlg(() => selectedTeacher = val),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Color(0xFFE0E0E0)),
                        const SizedBox(height: 16),
                        _buildStudentSelector(
                          selectedStudents: selectedStudents,
                          setDlg: setDlg,
                          searchCtrl: studentSearchCtrl,
                        ),
                      ],
                    ),
                  ),

                  // ── Action buttons ──
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
                            if (nameCtrl.text.trim().isNotEmpty) {
                              final colors = [
                                const Color(0xFF7E57C2),
                                const Color(0xFF4CAF50),
                                const Color(0xFF26A69A),
                                const Color(0xFFE91E63),
                                const Color(0xFF42A5F5),
                                const Color(0xFFFFA726),
                              ];
                              setState(() {
                                _groups.add(_GroupData(
                                  nameCtrl.text.trim(),
                                  turnoCtrl.text.trim().isEmpty
                                      ? 'Sin turno'
                                      : turnoCtrl.text.trim(),
                                  colors[_groups.length % colors.length],
                                  List.from(selectedStudents),
                                  selectedTeacher,
                                ));
                              });
                            }
                            Navigator.pop(ctx);
                          },
                          icon: const Icon(Icons.check_circle_outline, size: 18),
                          label: const Text('Guardar Grupo'),
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

  // ──────── MODIFICAR GRUPO ────────
  void _showEditGroupDialog(_GroupData g) {
    final mobile = _isMobile(context);
    final nameCtrl = TextEditingController(text: g.name);
    final turnoCtrl = TextEditingController(text: g.turno);
    final studentSearchCtrl = TextEditingController();
    final List<String> selectedStudents = List.from(g.students);
    String selectedTeacher = g.teacher;

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
            width: mobile ? double.infinity : 540,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogHeader(
                    icon: Icons.edit,
                    subtitle: 'GESTIÓN DE GRUPOS',
                    title: 'Modificar Grupo',
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _dialogLabel('NOMBRE DEL GRUPO'),
                        const SizedBox(height: 6),
                        _dialogTextField(
                          controller: nameCtrl,
                          hint: 'Ej. Grupo 1A',
                          icon: Icons.group_outlined,
                        ),
                        const SizedBox(height: 16),
                        _dialogLabel('TURNO'),
                        const SizedBox(height: 6),
                        _dialogTextField(
                          controller: turnoCtrl,
                          hint: 'Ej. Matutino, Vespertino',
                          icon: Icons.schedule_outlined,
                        ),
                        const SizedBox(height: 16),
                        _dialogLabel('MAESTRO ASIGNADO'),
                        const SizedBox(height: 6),
                        _buildTeacherDropdown(
                          selectedTeacher: selectedTeacher,
                          onChanged: (val) => setDlg(() => selectedTeacher = val),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Color(0xFFE0E0E0)),
                        const SizedBox(height: 16),
                        _buildStudentSelector(
                          selectedStudents: selectedStudents,
                          setDlg: setDlg,
                          searchCtrl: studentSearchCtrl,
                        ),
                      ],
                    ),
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
                            if (nameCtrl.text.trim().isNotEmpty) {
                              setState(() {
                                final index = _groups.indexOf(g);
                                if (index != -1) {
                                  _groups[index] = _GroupData(
                                    nameCtrl.text.trim(),
                                    turnoCtrl.text.trim().isEmpty
                                        ? 'Sin turno'
                                        : turnoCtrl.text.trim(),
                                    g.accentColor,
                                    List.from(selectedStudents),
                                    selectedTeacher,
                                  );
                                }
                              });
                            }
                            Navigator.pop(ctx);
                          },
                          icon: const Icon(Icons.check_circle_outline, size: 18),
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

  // ──────── VER INFORMACIÓN DEL GRUPO ────────
  void _showViewGroupDialog(_GroupData g) {
    final mobile = _isMobile(context);
    final nameCtrl = TextEditingController(text: g.name);
    final turnoCtrl = TextEditingController(text: g.turno);
    final teacherCtrl = TextEditingController(text: g.teacher.isEmpty ? 'Sin maestro asignado' : g.teacher);
    final studentSearchCtrl = TextEditingController();

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
            width: mobile ? double.infinity : 540,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogHeader(
                    icon: Icons.visibility,
                    subtitle: 'GESTIÓN DE GRUPOS',
                    title: 'Información del Grupo',
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _dialogLabel('NOMBRE DEL GRUPO'),
                        const SizedBox(height: 6),
                        _dialogTextField(
                          controller: nameCtrl,
                          hint: '',
                          icon: Icons.group_outlined,
                          readOnly: true,
                        ),
                        const SizedBox(height: 16),
                        _dialogLabel('TURNO'),
                        const SizedBox(height: 6),
                        _dialogTextField(
                          controller: turnoCtrl,
                          hint: '',
                          icon: Icons.schedule_outlined,
                          readOnly: true,
                        ),
                        const SizedBox(height: 16),
                        _dialogLabel('MAESTRO ASIGNADO'),
                        const SizedBox(height: 6),
                        _dialogTextField(
                          controller: teacherCtrl,
                          hint: '',
                          icon: Icons.person_outline,
                          readOnly: true,
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Color(0xFFE0E0E0)),
                        const SizedBox(height: 16),
                        _buildStudentSelector(
                          selectedStudents: List.from(g.students),
                          setDlg: setDlg,
                          searchCtrl: studentSearchCtrl,
                          readOnly: true,
                        ),
                      ],
                    ),
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

  // ──────── ELIMINAR GRUPO ────────
  void _showDeleteGroupDialog(_GroupData g) {
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
                'Eliminar Grupo',
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
              const TextSpan(text: '¿Está seguro de que desea eliminar el grupo '),
              TextSpan(
                text: g.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              TextSpan(
                text: '? Este grupo tiene ${g.students.length} ${g.students.length == 1 ? 'alumno asignado' : 'alumnos asignados'}. Esta acción no se puede deshacer.',
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
                _groups.remove(g);
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

// ──────── DATA MODELS ────────
class _GroupData {
  final String name;
  final String turno;
  final Color accentColor;
  final List<String> students;
  final String teacher;
  const _GroupData(this.name, this.turno, this.accentColor, this.students, this.teacher);
}

class _StudentOption {
  final String name;
  final String curp;
  final Color color;
  const _StudentOption(this.name, this.curp, this.color);
}
