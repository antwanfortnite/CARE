import 'package:flutter/material.dart';
import 'AdminScaffold.dart';
import 'DashboardAdmin.dart';
import 'MaestrosAdmin.dart';
import 'AlumnosAdmin.dart';
import 'EvidenciasAdmin.dart';
import 'AdministradoresAdmin.dart';
import '../../BD/Grupos.dart';
import '../../BD/Maestros.dart';
import '../../BD/Alumnos.dart';

class GruposAdmin extends StatefulWidget {
  final Map<String, dynamic>? user;
  const GruposAdmin({super.key, this.user});
  @override
  State<GruposAdmin> createState() => _GruposAdminState();
}

class _GruposAdminState extends State<GruposAdmin> {
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  List<_GroupData> _groups = [];
  List<dynamic> _alumnos = [];
  List<dynamic> _maestros = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);
    try {
      final gruposData = await GruposApiService().getGrupos();
      final maestrosData = await MaestrosApiService().getMaestros();
      final alumnosData = await ApiService().getAlumnos();

      final colors = [
        const Color(0xFF7E57C2),
        const Color(0xFF4CAF50),
        const Color(0xFF26A69A),
        const Color(0xFFE91E63),
        const Color(0xFF42A5F5),
        const Color(0xFFFFA726),
      ];

      final mappedGroups = gruposData.map((g) {
        final idMaestro = g['id_maestro'];
        final teacherObj = maestrosData.firstWhere(
          (m) => m['id_maestro'] == idMaestro,
          orElse: () => null,
        );
        final String teacherName = teacherObj != null
            ? (teacherObj['nombre_completo'] ?? 'Sin maestro')
            : 'Sin maestro';

        final assignedStudents = alumnosData
            .where((a) => a['id_grupo'] == g['id_grupo'])
            .toList();

        return _GroupData(
          idGrupo: g['id_grupo'] ?? 0,
          name: g['nombre_grupo'] ?? 'Sin nombre',
          turno: g['turno'] ?? 'N/A',
          aula: g['aula'] ?? 'N/A',
          capacidadMaxima: g['capacidad_maxima'] ?? 30,
          accentColor: colors[(g['id_grupo'] ?? 0) % colors.length],
          students: assignedStudents,
          teacherName: teacherName,
          idMaestro: idMaestro,
        );
      }).toList();

      if (mounted) {
        setState(() {
          _groups = mappedGroups.cast<_GroupData>();
          _maestros = maestrosData;
          _alumnos = alumnosData;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error cargando datos: ');
      if (mounted) setState(() => _isLoading = false);
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
      selectedIndex: 3,
      user: widget.user,
      destinations: {
        0: (_) => DashboardAdmin(user: widget.user),
        1: (_) => MaestrosAdmin(user: widget.user),
        2: (_) => AlumnosAdmin(user: widget.user),
        4: (_) => EvidenciasAdmin(user: widget.user),
        5: (_) => AdministradoresAdmin(user: widget.user),
      },
      bodyPadding: EdgeInsets.all(mobile ? 16 : 28),
      body: _buildContent(mobile),
    );
  }

  // ──────── CONTENT ────────
  Widget _buildContent(bool isMobile) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
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
      return Column(children: _groups.map((g) => _buildGroupCard(g)).toList());
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
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowChildren,
        ),
      );
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF42A5F5).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 13,
                            color: Color(0xFF42A5F5),
                          ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF26A69A).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person_outline,
                              size: 13,
                              color: Color(0xFF26A69A),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                g.teacherName.isEmpty
                                    ? 'Sin maestro'
                                    : g.teacherName,
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
                                        _getInitials(
                                          g.students[i]['nombre_completo'] ??
                                              '',
                                        ),
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
    required int? selectedTeacherId,
    required void Function(int?) onChanged,
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
        child: DropdownButton<int>(
          value: selectedTeacherId,
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
            const DropdownMenuItem<int>(
              value: null,
              child: Text(
                'Sin maestro asignado',
                style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
              ),
            ),
            ..._maestros.map(
              (t) => DropdownMenuItem<int>(
                value: t['id_maestro'],
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: const Color(
                        0xFF26A69A,
                      ).withOpacity(0.15),
                      child: Text(
                        _getInitials(t['nombre_completo'] ?? ''),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF26A69A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      t['nombre_completo'] ?? 'Sin Nombre',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
          onChanged: readOnly ? null : onChanged,
        ),
      ),
    );
  }

  // ──────── STUDENT SELECTOR WIDGET ────────
  Widget _buildStudentSelector({
    required List<dynamic> selectedStudents,
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
              children: selectedStudents.map((s) {
                final name = s['nombre_completo'] ?? 'Sin Nombre';
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
                        backgroundColor: const Color(
                          0xFF4CAF50,
                        ).withOpacity(0.2),
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
                              selectedStudents.removeWhere(
                                (item) => item['id_alumno'] == s['id_alumno'],
                              );
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
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFFBBBBBB),
              ),
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
                final filtered = _alumnos.where((s) {
                  if (s['estado'] != 1 || s['id_grupo'] != null) return false;

                  final name = (s['nombre_completo'] ?? '').toLowerCase();
                  final curp = (s['curp'] ?? '').toLowerCase();
                  final matchesSearch =
                      query.isEmpty ||
                      name.contains(query) ||
                      curp.contains(query);
                  final notSelected = !selectedStudents.any(
                    (selected) => selected['id_alumno'] == s['id_alumno'],
                  );
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
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  itemBuilder: (context, index) {
                    final student = filtered[index];
                    final name = student['nombre_completo'] ?? 'Sin Nombre';
                    final curp = student['curp'] ?? 'Sin CURP';
                    final color = const Color(0xFF4CAF50);
                    return InkWell(
                      onTap: () {
                        setDlg(() {
                          selectedStudents.add(student);
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
                              backgroundColor: color.withOpacity(0.15),
                              child: Text(
                                _getInitials(name),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  Text(
                                    curp,
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
    final aulaCtrl = TextEditingController();
    final capCtrl = TextEditingController(text: '30');
    final studentSearchCtrl = TextEditingController();
    final List<dynamic> selectedStudents = [];
    int? selectedTeacherId;
    bool isSaving = false;

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
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dialogLabel('TURNO'),
                                  const SizedBox(height: 6),
                                  _dialogTextField(
                                    controller: turnoCtrl,
                                    hint: 'Ej. Matutino',
                                    icon: Icons.schedule_outlined,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dialogLabel('AULA'),
                                  const SizedBox(height: 6),
                                  _dialogTextField(
                                    controller: aulaCtrl,
                                    hint: 'Ej. 101',
                                    icon: Icons.room_outlined,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _dialogLabel('CAPACIDAD MÁXIMA'),
                        const SizedBox(height: 6),
                        _dialogTextField(
                          controller: capCtrl,
                          hint: 'Ej. 30',
                          icon: Icons.group_outlined,
                        ),
                        const SizedBox(height: 16),
                        _dialogLabel('MAESTRO ASIGNADO'),
                        const SizedBox(height: 6),
                        _buildTeacherDropdown(
                          selectedTeacherId: selectedTeacherId,
                          onChanged: (val) =>
                              setDlg(() => selectedTeacherId = val),
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
                          onPressed: isSaving
                              ? null
                              : () async {
                                  if (nameCtrl.text.trim().isNotEmpty) {
                                    setDlg(() => isSaving = true);
                                    final nuevoGrupoId =
                                        await GruposApiService().agregarGrupo({
                                          "nombre_grupo": nameCtrl.text.trim(),
                                          "turno": turnoCtrl.text.trim().isEmpty
                                              ? 'N/A'
                                              : turnoCtrl.text.trim(),
                                          "aula": aulaCtrl.text.trim().isEmpty
                                              ? 'N/A'
                                              : aulaCtrl.text.trim(),
                                          "capacidad_maxima":
                                              int.tryParse(
                                                capCtrl.text.trim(),
                                              ) ??
                                              30,
                                          "id_maestro": selectedTeacherId,
                                          "id_usuario_actual":
                                              widget.user?['id_usuario'] ?? 0,
                                        });

                                    if (nuevoGrupoId != null &&
                                        selectedStudents.isNotEmpty) {
                                      await Future.wait(
                                        selectedStudents.map((s) {
                                          final fechaNac =
                                              s['fecha_nacimiento'] != null
                                              ? s['fecha_nacimiento']
                                                    .toString()
                                                    .split('T')
                                                    .first
                                              : '2000-01-01';
                                          return ApiService().actualizarAlumno(
                                            s['id_alumno'],
                                            s['nombre_completo'] ??
                                                'Sin Nombre',
                                            s['curp'] ?? '',
                                            s['estado'] ?? 1,
                                            fechaNac,
                                            nuevoGrupoId,
                                            widget.user?['id_usuario'] ?? 0,
                                            idPadre: s['id_padre'],
                                          );
                                        }),
                                      );
                                    }

                                    if (mounted) {
                                      Navigator.pop(ctx);
                                      _cargarDatos();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Grupo creado correctamente.',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                          icon: isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.check_circle_outline,
                                  size: 18,
                                ),
                          label: Text(
                            isSaving ? 'Guardando...' : 'Guardar Grupo',
                          ),
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
    final aulaCtrl = TextEditingController(text: g.aula);
    final capCtrl = TextEditingController(text: g.capacidadMaxima.toString());
    final studentSearchCtrl = TextEditingController();
    final List<dynamic> selectedStudents = List.from(g.students);
    int? selectedTeacherId = g.idMaestro;
    bool isSaving = false;

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
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dialogLabel('TURNO'),
                                  const SizedBox(height: 6),
                                  _dialogTextField(
                                    controller: turnoCtrl,
                                    hint: 'Ej. Matutino',
                                    icon: Icons.schedule_outlined,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dialogLabel('AULA'),
                                  const SizedBox(height: 6),
                                  _dialogTextField(
                                    controller: aulaCtrl,
                                    hint: 'Ej. 101',
                                    icon: Icons.room_outlined,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _dialogLabel('CAPACIDAD MÁXIMA'),
                        const SizedBox(height: 6),
                        _dialogTextField(
                          controller: capCtrl,
                          hint: 'Ej. 30',
                          icon: Icons.group_outlined,
                        ),
                        const SizedBox(height: 16),
                        _dialogLabel('MAESTRO ASIGNADO'),
                        const SizedBox(height: 6),
                        _buildTeacherDropdown(
                          selectedTeacherId: selectedTeacherId,
                          onChanged: (val) =>
                              setDlg(() => selectedTeacherId = val),
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
                          onPressed: isSaving
                              ? null
                              : () async {
                                  if (nameCtrl.text.trim().isNotEmpty) {
                                    setDlg(() => isSaving = true);

                                    final updated = await GruposApiService()
                                        .actualizarGrupo(g.idGrupo, {
                                          "id_grupo": g.idGrupo,
                                          "nombre_grupo": nameCtrl.text.trim(),
                                          "turno": turnoCtrl.text.trim().isEmpty
                                              ? 'N/A'
                                              : turnoCtrl.text.trim(),
                                          "aula": aulaCtrl.text.trim().isEmpty
                                              ? 'N/A'
                                              : aulaCtrl.text.trim(),
                                          "capacidad_maxima":
                                              int.tryParse(
                                                capCtrl.text.trim(),
                                              ) ??
                                              30,
                                          "id_maestro": selectedTeacherId,
                                          "id_usuario_actual":
                                              widget.user?['id_usuario'] ?? 0,
                                        });

                                    if (updated) {
                                      // Find removed students
                                      final removedStudents = g.students
                                          .where(
                                            (oldS) => !selectedStudents.any(
                                              (newS) =>
                                                  newS['id_alumno'] ==
                                                  oldS['id_alumno'],
                                            ),
                                          )
                                          .toList();
                                      // Find added students
                                      final addedStudents = selectedStudents
                                          .where(
                                            (newS) => !g.students.any(
                                              (oldS) =>
                                                  oldS['id_alumno'] ==
                                                  newS['id_alumno'],
                                            ),
                                          )
                                          .toList();

                                      final futures = <Future>[];

                                      for (var s in removedStudents) {
                                        final fechaNac =
                                            s['fecha_nacimiento'] != null
                                            ? s['fecha_nacimiento']
                                                  .toString()
                                                  .split('T')
                                                  .first
                                            : '2000-01-01';
                                        futures.add(
                                          ApiService().actualizarAlumno(
                                            s['id_alumno'],
                                            s['nombre_completo'] ??
                                                'Sin Nombre',
                                            s['curp'] ?? '',
                                            s['estado'] ?? 1,
                                            fechaNac,
                                            null, // set group to null
                                            widget.user?['id_usuario'] ?? 0,
                                            idPadre: s['id_padre'],
                                          ),
                                        );
                                      }

                                      for (var s in addedStudents) {
                                        final fechaNac =
                                            s['fecha_nacimiento'] != null
                                            ? s['fecha_nacimiento']
                                                  .toString()
                                                  .split('T')
                                                  .first
                                            : '2000-01-01';
                                        futures.add(
                                          ApiService().actualizarAlumno(
                                            s['id_alumno'],
                                            s['nombre_completo'] ??
                                                'Sin Nombre',
                                            s['curp'] ?? '',
                                            s['estado'] ?? 1,
                                            fechaNac,
                                            g.idGrupo, // assign to group
                                            widget.user?['id_usuario'] ?? 0,
                                            idPadre: s['id_padre'],
                                          ),
                                        );
                                      }

                                      await Future.wait(futures);

                                      if (mounted) {
                                        Navigator.pop(ctx);
                                        _cargarDatos();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Grupo actualizado correctamente.',
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      setDlg(() => isSaving = false);
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Error al actualizar el grupo.',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                          icon: isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.check_circle_outline,
                                  size: 18,
                                ),
                          label: Text(
                            isSaving ? 'Guardando...' : 'Guardar Cambios',
                          ),
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
    final aulaCtrl = TextEditingController(text: g.aula);
    final teacherCtrl = TextEditingController(
      text: g.teacherName.isEmpty ? 'Sin maestro asignado' : g.teacherName,
    );
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
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dialogLabel('TURNO'),
                                  const SizedBox(height: 6),
                                  _dialogTextField(
                                    controller: turnoCtrl,
                                    hint: '',
                                    icon: Icons.schedule_outlined,
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
                                  _dialogLabel('AULA'),
                                  const SizedBox(height: 6),
                                  _dialogTextField(
                                    controller: aulaCtrl,
                                    hint: '',
                                    icon: Icons.room_outlined,
                                    readOnly: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
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
              const TextSpan(
                text: '¿Está seguro de que desea eliminar el grupo ',
              ),
              TextSpan(
                text: g.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              TextSpan(
                text:
                    '? Este grupo tiene ${g.students.length} ${g.students.length == 1 ? 'alumno asignado' : 'alumnos asignados'}. Esta acción no se puede deshacer.',
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
  final int idGrupo;
  final String name;
  final String turno;
  final String aula;
  final int capacidadMaxima;
  final Color accentColor;
  final List<dynamic> students;
  final String teacherName;
  final int? idMaestro;
  const _GroupData({
    required this.idGrupo,
    required this.name,
    required this.turno,
    required this.aula,
    required this.capacidadMaxima,
    required this.accentColor,
    required this.students,
    required this.teacherName,
    this.idMaestro,
  });
}

class _StudentOption {
  final String name;
  final String curp;
  final Color color;
  const _StudentOption(this.name, this.curp, this.color);
}
