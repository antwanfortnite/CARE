import 'package:flutter/material.dart';
import 'ProfesorScaffold.dart';
import 'DashboardProfesor.dart';
import 'GruposProfesor.dart';
import '../../BD/Alumnos.dart';
import '../../BD/Grupos.dart';
import '../../BD/Evidencias.dart';

class EvidenciasProfesor extends StatefulWidget {
  final Map<String, dynamic>? user;
  const EvidenciasProfesor({super.key, this.user});
  @override
  State<EvidenciasProfesor> createState() => _EvidenciasProfesorState();
}

class _EvidenciasProfesorState extends State<EvidenciasProfesor> {
  final TextEditingController _searchController = TextEditingController();

  int _currentLevel = 0;
  Map<String, dynamic>? _selectedGroup;
  List<dynamic> _selectedGroupStudents = [];

  bool _isLoading = true;
  List<dynamic> _groups = [];
  List<dynamic> _allAlumnos = [];
  List<dynamic> _allEvidencias = [];

  static const List<Color> _accentColors = [
    Color(0xFF7E57C2), Color(0xFF42A5F5), Color(0xFF26A69A),
    Color(0xFFE91E63), Color(0xFFFFA726), Color(0xFF66BB6A),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final idMaestro = widget.user?['id_maestro'];
      final allGrupos = await GruposApiService().getGrupos();
      final alumnos = await ApiService().getAlumnos();
      final evidencias = await EvidenciasApiService().getEvidencias();

      if (mounted) {
        setState(() {
          _groups = idMaestro != null
              ? allGrupos.where((g) => g['id_maestro'] == idMaestro).toList()
              : allGrupos;
          _allAlumnos = alumnos;
          _allEvidencias = evidencias;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error cargando evidencias del maestro: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<dynamic> _getStudentsForGroup(dynamic grupo) {
    final idGrupo = grupo['id_grupo'];
    return _allAlumnos.where((a) => a['id_grupo'] == idGrupo).toList();
  }

  List<dynamic> _getEvidenciasForStudent(dynamic student) {
    final idAlumno = student['id_alumno'];
    return _allEvidencias.where((e) => e['id_alumno'] == idAlumno).toList();
  }

  int _countEvidenciasForGroup(dynamic grupo) {
    final students = _getStudentsForGroup(grupo);
    int count = 0;
    for (final s in students) {
      count += _getEvidenciasForStudent(s).length;
    }
    return count;
  }

  Color _getAccentColor(int index) => _accentColors[index % _accentColors.length];

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

    return ProfesorScaffold(
      user: widget.user,
      selectedIndex: 2,
      destinations: {
        0: (_) => DashboardProfesor(user: widget.user),
        1: (_) => GruposProfesor(user: widget.user),
      },
      bodyPadding: EdgeInsets.all(mobile ? 16 : 28),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1565C0)))
          : _buildBody(mobile),
    );
  }

  Widget _buildBody(bool isMobile) {
    switch (_currentLevel) {
      case 0:
        return _buildGroupsLevel(isMobile);
      case 1:
        return _buildStudentsLevel(isMobile);
      default:
        return _buildGroupsLevel(isMobile);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // NIVEL 0: LISTA DE GRUPOS
  // ═══════════════════════════════════════════════════════════════

  Widget _buildGroupsLevel(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGroupsHeader(isMobile),
        const SizedBox(height: 24),
        _buildFilterBar('Filtrar por nombre de grupo...'),
        const SizedBox(height: 24),
        _buildGroupCardsList(isMobile),
      ],
    );
  }

  Widget _buildGroupsHeader(bool isMobile) {
    if (isMobile) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gestión de Evidencias',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Selecciona un grupo para gestionar las evidencias de tus alumnos.',
            style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
          ),
        ],
      );
    }

    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gestión de Evidencias',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Selecciona un grupo para gestionar las evidencias de tus alumnos.',
                style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGroupCardsList(bool isMobile) {
    if (isMobile) {
      return Column(
        children: _groups.asMap().entries.map((entry) =>
            _buildGroupCard(entry.value, _getAccentColor(entry.key))).toList(),
      );
    }

    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1400 ? 3 : 2;

    List<Widget> rows = [];
    for (int i = 0; i < _groups.length; i += crossAxisCount) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < crossAxisCount; j++) {
        if (i + j < _groups.length) {
          rowChildren.add(
            Expanded(child: _buildGroupCard(_groups[i + j], _getAccentColor(i + j))),
          );
        } else {
          rowChildren.add(const Expanded(child: SizedBox()));
        }
        if (j < crossAxisCount - 1) {
          rowChildren.add(const SizedBox(width: 16));
        }
      }
      rows.add(Row(crossAxisAlignment: CrossAxisAlignment.start, children: rowChildren));
    }

    return Column(children: rows);
  }

  Widget _buildGroupCard(dynamic g, Color accentColor) {
    final name = g['nombre_grupo']?.toString() ?? 'Grupo';
    final turno = g['turno']?.toString() ?? 'N/A';
    final students = _getStudentsForGroup(g);
    final evidCount = _countEvidenciasForGroup(g);
    final initials = name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase();

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGroup = g;
          _selectedGroupStudents = students;
          _currentLevel = 1;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: accentColor,
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
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
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
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF333333),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${students.length} ${students.length == 1 ? 'alumno' : 'alumnos'}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: accentColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _statChip(
                        Icons.schedule,
                        turno,
                        const Color(0xFF42A5F5),
                      ),
                      const SizedBox(width: 8),
                      _statChip(
                        Icons.folder_outlined,
                        '$evidCount ${evidCount == 1 ? 'evidencia' : 'evidencias'}',
                        const Color(0xFFFFA726),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Avatar preview
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
                                students.length > 5 ? 5 : students.length,
                                (i) {
                                  final sColor = _getAccentColor(i);
                                  return Positioned(
                                    left: i * 22.0,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: sColor.withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _getInitials(students[i]['nombre_completo'] ?? ''),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: sColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (students.length > 5)
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
                                        '+${students.length - 5}',
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
                  const SizedBox(height: 14),
                  const Divider(color: Color(0xFFF0F0F0), height: 1),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedGroup = g;
                        _selectedGroupStudents = students;
                        _currentLevel = 1;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.folder_shared_outlined,
                            size: 16,
                            color: Color(0xFF4CAF50),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Gestionar Evidencias',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        ],
                      ),
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

  // ═══════════════════════════════════════════════════════════════
  // NIVEL 1: ALUMNOS DEL GRUPO CON EVIDENCIAS
  // ═══════════════════════════════════════════════════════════════

  Widget _buildStudentsLevel(bool isMobile) {
    final group = _selectedGroup!;
    final name = group['nombre_grupo'] ?? 'Grupo';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBreadcrumb(isMobile, [name]),
        const SizedBox(height: 20),
        _buildStudentsHeader(isMobile, group),
        const SizedBox(height: 24),
        ..._selectedGroupStudents.asMap().entries.map(
          (entry) => _buildStudentEvidenceCard(entry.value, group, isMobile, _getAccentColor(entry.key)),
        ),
      ],
    );
  }

  Widget _buildStudentsHeader(bool isMobile, dynamic group) {
    final name = group['nombre_grupo']?.toString() ?? 'Grupo';
    final turno = group['turno']?.toString() ?? 'N/A';
    final students = _getStudentsForGroup(group);
    final evidCount = _countEvidenciasForGroup(group);
    final accentColor = _getAccentColor(0); // Default for header

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accentColor.withValues(alpha: 0.9), accentColor],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 14,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 4),
              Text(
                turno,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.people_outline,
                size: 14,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 4),
              Text(
                '${students.length} alumnos',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.folder_outlined,
                size: 14,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 4),
              Text(
                '$evidCount evidencias',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentEvidenceCard(
    dynamic student,
    dynamic group,
    bool isMobile,
    Color accentColor,
  ) {
    final evids = _getEvidenciasForStudent(student);
    final name = student['nombre_completo']?.toString() ?? 'Alumno';
    final curp = student['curp']?.toString() ?? 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: accentColor.withValues(alpha: 0.15),
            child: Text(
              _getInitials(name),
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          title: Text(
            name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                curp,
                style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: evids.isEmpty
                      ? const Color(0xFFEF5350).withValues(alpha: 0.1)
                      : const Color(0xFF4CAF50).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${evids.length} ${evids.length == 1 ? 'evidencia' : 'evidencias'}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: evids.isEmpty
                        ? const Color(0xFFEF5350)
                        : const Color(0xFF4CAF50),
                  ),
                ),
              ),
            ],
          ),
          children: [
            const Divider(color: Color(0xFFF0F0F0), height: 1),
            const SizedBox(height: 16),

            // Botón agregar evidencia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Evidencias registradas',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF555555),
                  ),
                ),
                InkWell(
                  onTap: () => _showAddEvidenciaDialog(group, student),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 16,
                          color: Color(0xFF4CAF50),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Agregar',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (evids.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFF0F0F0)),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 32,
                      color: Color(0xFFCCCCCC),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Sin evidencias registradas',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                  ],
                ),
              )
            else
              ...evids.map(
                (e) => _buildEvidenciaItem(e, isMobile, group, student),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenciaItem(
    dynamic e,
    bool isMobile,
    dynamic group,
    dynamic student,
  ) {
    final fecha = e['fecha_evidencia'] ?? '2024-01-01';
    final descripcion = e['descripcion'] ?? '';

    // Format date for header label
    String dateHeader = '';
    try {
      final parts = fecha.split('T')[0].split('-');
      final months = [
        '',
        'ENERO',
        'FEBRERO',
        'MARZO',
        'ABRIL',
        'MAYO',
        'JUNIO',
        'JULIO',
        'AGOSTO',
        'SEPTIEMBRE',
        'OCTUBRE',
        'NOVIEMBRE',
        'DICIEMBRE',
      ];
      dateHeader =
          '${parts[2]} DE ${months[int.parse(parts[1])]}, ${parts[0]}';
    } catch (_) {
      dateHeader = fecha;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header above the card
        Padding(
          padding: const EdgeInsets.only(bottom: 6, top: 4),
          child: Text(
            dateHeader,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFFEF5350),
              letterSpacing: 0.5,
            ),
          ),
        ),
        // Evidence card
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFF0F0F0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Photo icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F0EC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: 22,
                  color: Color(0xFFCBBEB5),
                ),
              ),
              const SizedBox(width: 14),
              // Description
              Expanded(
                child: Text(
                  descripcion,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF444444),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              // Action buttons
              _actionBtn(
                Icons.visibility_outlined,
                const Color(0xFF7E57C2),
                'Ver información',
                () => _showViewEvidenciaDialog(e, group, student),
              ),
              const SizedBox(width: 6),
              _actionBtn(
                Icons.delete_outline,
                const Color(0xFFEF5350),
                'Eliminar',
                () => _showDeleteEvidenciaDialog(e, group, student),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ──────── VER EVIDENCIA (read-only) ────────
  void _showViewEvidenciaDialog(
    dynamic e,
    dynamic group,
    dynamic student,
  ) {
    final mobile = _isMobile(context);
    final fecha = e['fecha_evidencia'] ?? '2024-01-01';
    final desc = e['descripcion'] ?? '';
    final urlFoto = e['url_foto'] ?? '';
    final studentName = student['nombre_completo'] ?? 'Alumno';
    final groupName = group['nombre_grupo'] ?? 'Grupo';

    String formattedDate = '';
    try {
      final parts = fecha.split('T')[0].split('-');
      formattedDate = '${parts[2]}/${parts[1]}/${parts[0]}';
    } catch (_) {
      formattedDate = fecha;
    }

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.photo_library_outlined,
                            size: 16,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'DETALLE DE EVIDENCIA',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Información de Evidencia',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Alumno: $studentName',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Form (read-only)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Group info
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Color(0xFF888888),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                groupName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // FECHA
                      const Text(
                        'FECHA DE LA EVIDENCIA',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF555555),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF555555),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.calendar_month_rounded,
                              size: 18,
                              color: Color(0xFF999999),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // FOTO
                      const Text(
                        'FOTO ADJUNTADA',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF555555),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: TextEditingController(text: urlFoto),
                        readOnly: true,
                        enabled: false,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF555555),
                        ),
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.link,
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
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // DESCRIPCIÓN
                      const Text(
                        'DESCRIPCIÓN',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF555555),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller:
                            TextEditingController(text: desc),
                        readOnly: true,
                        enabled: false,
                        maxLines: 4,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF555555),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFEFEFEF),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Close button
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
    );
  }

  // ──────── ELIMINAR EVIDENCIA ────────
  void _showDeleteEvidenciaDialog(
    dynamic e,
    dynamic group,
    dynamic student,
  ) {
    final desc = e['descripcion'] ?? '';
    final fecha = e['fecha_evidencia'] ?? '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '¿Eliminar evidencia?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Estás seguro de que deseas eliminar esta evidencia?',
              style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF0F0F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF444444),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: Color(0xFF999999),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(fecha),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Esta acción no se puede deshacer.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFEF5350),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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
              final idEvid = e['id_evidencia'];
              if (idEvid != null) {
                final success = await EvidenciasApiService().eliminarEvidencia(
                  idEvid,
                  widget.user?['id_usuario'] ?? 0,
                );
                if (success) {
                  _loadData();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Evidencia eliminada')),
                    );
                  }
                }
              }
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

  // ──────── AGREGAR EVIDENCIA ────────
  void _showAddEvidenciaDialog(
    dynamic group,
    dynamic student,
  ) {
    final mobile = _isMobile(context);
    final urlCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) {
          String formattedSelectedDate =
              '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.add_photo_alternate,
                                size: 16,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'NUEVA EVIDENCIA',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Agregar Evidencia',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Para: ${student['nombre_completo'] ?? 'Alumno'}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.9),
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
                          // Group info
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Color(0xFF888888),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    group['nombre_grupo'] ?? 'Grupo',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ── FECHA DE LA EVIDENCIA ──
                          const Text(
                            'FECHA DE LA EVIDENCIA',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF555555),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: ctx,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                  locale: const Locale('es', 'MX'),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: Color(0xFF4CAF50),
                                          onPrimary: Colors.white,
                                          surface: Colors.white,
                                          onSurface: Color(0xFF333333),
                                        ),
                                        dialogBackgroundColor: Colors.white,
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  setDlg(() => selectedDate = picked);
                                }
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9F9F9),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFFE0E0E0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        formattedSelectedDate,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF333333),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4CAF50)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.calendar_month_rounded,
                                        size: 18,
                                        color: Color(0xFF4CAF50),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Se asigna la fecha de hoy automáticamente. Toque para cambiarla.',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF999999),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 16),

                          const Text(
                            'FOTO ADJUNTADA',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF555555),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: urlCtrl,
                            style: const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Foto',
                              hintStyle: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFFBBBBBB),
                              ),
                              suffixIcon: const Icon(
                                Icons.link,
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
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          const Text(
                            'DESCRIPCIÓN',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF555555),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: descCtrl,
                            maxLines: 4,
                            style: const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Descripción de la evidencia...',
                              hintStyle: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFFBBBBBB),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF9F9F9),
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

                    // Actions
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
                              if (descCtrl.text.trim().isNotEmpty) {
                                final dateStr =
                                    '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                                final data = {
                                  'id_alumno': student['id_alumno'],
                                  'id_maestro': widget.user?['id_maestro'],
                                  'fecha_evidencia': dateStr,
                                  'url_foto': urlCtrl.text.trim().isEmpty
                                      ? 'https://ejemplo.com/fotos/evidencia.jpg'
                                      : urlCtrl.text.trim(),
                                  'descripcion': descCtrl.text.trim(),
                                };

                                final success = await EvidenciasApiService().agregarEvidencia(
                                  data,
                                  widget.user?['id_usuario'] ?? 0,
                                );
                                if (success) {
                                  _loadData();
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Evidencia agregada exitosamente')),
                                    );
                                  }
                                }
                              }
                              Navigator.pop(ctx);
                            },
                            icon: const Icon(
                              Icons.cloud_upload_outlined,
                              size: 18,
                            ),
                            label: const Text('Subir Evidencia'),
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

  // ═══════════════════════════════════════════════════════════════
  // WIDGETS COMPARTIDOS
  // ═══════════════════════════════════════════════════════════════

  Widget _buildBreadcrumb(bool isMobile, List<String> paths) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _currentLevel = 0;
                  _selectedGroup = null;
                });
              },
              borderRadius: BorderRadius.circular(12),
              splashColor: const Color(0xFF4CAF50).withValues(alpha: 0.15),
              highlightColor: const Color(0xFF4CAF50).withValues(alpha: 0.08),
              child: Tooltip(
                message: 'Regresar a la vista anterior',
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4CAF50).withValues(alpha: 0.10),
                        const Color(0xFF388E3C).withValues(alpha: 0.06),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: Color(0xFF388E3C),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Regresar',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF388E3C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 28, color: const Color(0xFFE0E0E0)),
          const SizedBox(width: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _currentLevel = 0;
                          _selectedGroup = null;
                        });
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.folder_outlined,
                              size: 15,
                              color:
                                  const Color(0xFF4CAF50).withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Evidencias',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ...paths.asMap().entries.map((entry) {
                    final i = entry.key;
                    final p = entry.value;
                    final isLast = i == paths.length - 1;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: Color(0xFFBBBBBB),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: isLast
                              ? BoxDecoration(
                                  color: const Color(0xFF333333)
                                      .withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(6),
                                )
                              : null,
                          child: Text(
                            p,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  isLast ? FontWeight.w700 : FontWeight.w500,
                              color: isLast
                                  ? const Color(0xFF333333)
                                  : const Color(0xFF4CAF50),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(String hint) {
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
                hintText: hint,
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

  Widget _statChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
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
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // UTILIDADES
  // ═══════════════════════════════════════════════════════════════

  String _getInitials(String name) {
    final clean = name.trim();
    if (clean.isEmpty) return '??';
    final parts = clean.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return clean.substring(0, clean.length >= 2 ? 2 : 1).toUpperCase();
  }



  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      final months = [
        '',
        'Ene',
        'Feb',
        'Mar',
        'Abr',
        'May',
        'Jun',
        'Jul',
        'Ago',
        'Sep',
        'Oct',
        'Nov',
        'Dic',
      ];
      return '${parts[2]} ${months[int.parse(parts[1])]} ${parts[0]}';
    } catch (_) {
      return dateStr;
    }
  }
}

