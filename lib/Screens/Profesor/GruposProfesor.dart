import 'package:flutter/material.dart';
import 'ProfesorScaffold.dart';
import 'DashboardProfesor.dart';
import 'EvidenciasProfesor.dart';
import '../../BD/Alumnos.dart';
import '../../BD/Grupos.dart';

class GruposProfesor extends StatefulWidget {
  final Map<String, dynamic>? user;
  const GruposProfesor({super.key, this.user});
  @override
  State<GruposProfesor> createState() => _GruposProfesorState();
}

class _GruposProfesorState extends State<GruposProfesor> {
  int _currentLevel = 0;
  Map<String, dynamic>? _selectedGroup;
  List<dynamic> _selectedGroupStudents = [];

  bool _isLoading = true;
  List<dynamic> _groups = [];
  List<dynamic> _allAlumnos = [];

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

      if (mounted) {
        setState(() {
          _groups = idMaestro != null
              ? allGrupos.where((g) => g['id_maestro'] == idMaestro).toList()
              : allGrupos;
          _allAlumnos = alumnos;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error cargando grupos del maestro: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<dynamic> _getStudentsForGroup(dynamic grupo) {
    final idGrupo = grupo['id_grupo'];
    return _allAlumnos.where((a) => a['id_grupo'] == idGrupo).toList();
  }

  Color _getAccentColor(int index) => _accentColors[index % _accentColors.length];

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 1050;

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);

    return ProfesorScaffold(
      user: widget.user,
      selectedIndex: 1,
      destinations: {
        0: (_) => DashboardProfesor(user: widget.user),
        2: (_) => EvidenciasProfesor(user: widget.user),
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
            'Mis Grupos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Grupos asignados para el ciclo escolar actual.',
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
                'Mis Grupos',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Grupos asignados para el ciclo escolar actual.',
                style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGroupCardsList(bool isMobile) {
    if (_groups.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: const Column(
          children: [
            Icon(Icons.group_off_outlined, size: 48, color: Color(0xFFCCCCCC)),
            SizedBox(height: 16),
            Text('No tiene grupos asignados',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF888888))),
          ],
        ),
      );
    }

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
    final initials = name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();

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
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(initials,
                            style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF333333)),
                              overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(turno,
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: accentColor)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.arrow_forward_ios, size: 14, color: accentColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _statChip(Icons.people_outline,
                        '${students.length} ${students.length == 1 ? 'Alumno' : 'Alumnos'}',
                        const Color(0xFF26A69A)),
                      const SizedBox(width: 8),
                      _statChip(Icons.schedule, turno, const Color(0xFF42A5F5)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.people_outline, size: 16, color: Color(0xFF888888)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 32,
                          child: Stack(
                            children: [
                              ...List.generate(
                                students.length > 5 ? 5 : students.length,
                                (i) {
                                  final sColor = _accentColors[i % _accentColors.length];
                                  final sName = students[i]['nombre_completo'] ?? 'A';
                                  return Positioned(
                                    left: i * 22.0,
                                    child: Container(
                                      width: 32, height: 32,
                                      decoration: BoxDecoration(
                                        color: sColor.withOpacity(0.15),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                      child: Center(
                                        child: Text(_getInitials(sName),
                                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: sColor)),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (students.length > 5)
                                Positioned(
                                  left: 5 * 22.0,
                                  child: Container(
                                    width: 32, height: 32,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E8E8),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: Center(
                                      child: Text('+${students.length - 5}',
                                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF555555))),
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
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF4CAF50)),
                          SizedBox(width: 6),
                          Text('Ver Alumnos',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF4CAF50))),
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
  // NIVEL 1: ALUMNOS DEL GRUPO
  // ═══════════════════════════════════════════════════════════════

  Widget _buildStudentsLevel(bool isMobile) {
    final group = _selectedGroup!;
    final groupName = group['nombre_grupo'] ?? 'Grupo';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBreadcrumb(isMobile, [groupName]),
        const SizedBox(height: 20),
        _buildStudentsHeader(isMobile, group),
        const SizedBox(height: 24),
        ..._selectedGroupStudents.map(
          (s) => _buildStudentCard(s, group, isMobile),
        ),
      ],
    );
  }

  Widget _buildStudentsHeader(bool isMobile, dynamic group) {
    final groupName = group['nombre_grupo'] ?? 'Grupo';
    final turno = group['turno'] ?? 'N/A';
    final idx = _groups.indexOf(group);
    final accentColor = _getAccentColor(idx >= 0 ? idx : 0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accentColor.withOpacity(0.9), accentColor],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(groupName,
            style: TextStyle(fontSize: isMobile ? 20 : 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.schedule, size: 14, color: Colors.white.withOpacity(0.8)),
              const SizedBox(width: 4),
              Text(turno, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.85))),
              const SizedBox(width: 16),
              Icon(Icons.people_outline, size: 14, color: Colors.white.withOpacity(0.8)),
              const SizedBox(width: 4),
              Text('${_selectedGroupStudents.length} alumnos',
                style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.85))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(dynamic student, dynamic group, bool isMobile) {
    final sName = student['nombre_completo']?.toString() ?? 'Alumno';
    final curp = student['curp']?.toString() ?? 'N/A';
    final estado = student['estado']?.toString() ?? 'Cursando';
    final sIdx = _selectedGroupStudents.indexOf(student);
    final sColor = _accentColors[sIdx % _accentColors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: sColor.withOpacity(0.15),
              child: Text(_getInitials(sName),
                style: TextStyle(color: sColor, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sName,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
                  const SizedBox(height: 4),
                  Text(curp, style: const TextStyle(fontSize: 11, color: Color(0xFF999999))),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF42A5F5).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(estado,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF42A5F5))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Tooltip(
              message: 'Ver información',
              child: InkWell(
                onTap: () => _showStudentInfoDialog(student, group),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7E57C2).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF7E57C2)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStudentInfoDialog(dynamic student, dynamic group) {
    final mobile = _isMobile(context);
    final sName = student['nombre_completo']?.toString() ?? 'Alumno';
    final curp = student['curp']?.toString() ?? 'N/A';
    final estado = student['estado']?.toString() ?? 'Cursando';
    final groupName = group['nombre_grupo']?.toString() ?? 'Grupo';
    final turno = group['turno']?.toString() ?? 'N/A';

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 40, vertical: 24),
        child: Container(
          width: mobile ? double.infinity : 480,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF388E3C)]),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white24,
                        child: Text(_getInitials(sName),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      const SizedBox(height: 12),
                      Text(sName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(groupName,
                          style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow('CURP', curp),
                      const SizedBox(height: 12),
                      _infoRow('Estatus', estado),
                      const SizedBox(height: 12),
                      _infoRow('Turno', turno),
                      const SizedBox(height: 12),
                      _infoRow('Grupo', groupName),
                    ],
                  ),
                ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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

  Widget _infoRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        children: [
          Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF888888))),
          const SizedBox(width: 12),
          Expanded(
            child: Text(value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF333333)),
              textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  // ──────── WIDGETS COMPARTIDOS ────────

  Widget _buildBreadcrumb(bool isMobile, List<String> paths) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() { _currentLevel = 0; _selectedGroup = null; });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    const Color(0xFF4CAF50).withOpacity(0.10),
                    const Color(0xFF388E3C).withOpacity(0.06),
                  ]),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.2)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_rounded, size: 20, color: Color(0xFF388E3C)),
                    SizedBox(width: 8),
                    Text('Regresar',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF388E3C))),
                  ],
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
                  const Text('Mis Grupos',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4CAF50))),
                  ...paths.map((p) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFFBBBBBB)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF333333).withOpacity(0.06),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(p,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
                      ),
                    ],
                  )),
                ],
              ),
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
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(label,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color),
              overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _groupInfoChip(IconData icon, String label, Color color) {
    return _statChip(icon, label, color);
  }

  String _getInitials(String name) {
    final clean = name.trim();
    if (clean.isEmpty) return '??';
    final parts = clean.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return clean.substring(0, clean.length >= 2 ? 2 : 1).toUpperCase();
  }
}
