import 'package:flutter/material.dart';
import 'ProfesorScaffold.dart';
import 'DashboardProfesor.dart';
import 'EvidenciasProfesor.dart';

class GruposProfesor extends StatefulWidget {
  const GruposProfesor({super.key});
  @override
  State<GruposProfesor> createState() => _GruposProfesorState();
}

class _GruposProfesorState extends State<GruposProfesor> {
  // ──────── NIVEL DE NAVEGACIÓN ────────
  // 0 = lista de grupos, 1 = alumnos del grupo
  int _currentLevel = 0;
  _GroupInfo? _selectedGroup;

  // ──────── DATOS MOCK DE GRUPOS DEL PROFESOR ────────
  final List<_GroupInfo> _groups = [
    _GroupInfo('Grupo 3A', 'Matutino', const Color(0xFF7E57C2), [
      _StudentInfo('Carlos Méndez', 'MECC080515HDHNRL01', 15, 'Cursando',
          const Color(0xFF7E57C2)),
      _StudentInfo('Ana Sofía Rivera', 'RIAA090320MDFVNN02', 14, 'Cursando',
          const Color(0xFF4CAF50)),
      _StudentInfo('Diego Hernández', 'HEAD071205HDFRGL03', 16, 'Cursando',
          const Color(0xFF26A69A)),
    ]),
    _GroupInfo('Grupo 3B', 'Vespertino', const Color(0xFF42A5F5), [
      _StudentInfo('Diego Hernández', 'HEAD071205HDFRGL03', 16, 'Cursando',
          const Color(0xFF26A69A)),
      _StudentInfo('Miguel Ángel Ruiz', 'RUIM060714HDFRGL05', 17, 'Cursando',
          const Color(0xFFFFA726)),
      _StudentInfo('Andrés Martínez', 'MARA080730HDFNRD09', 15, 'Cursando',
          const Color(0xFF29B6F6)),
    ]),
    _GroupInfo('Grupo 2A', 'Matutino', const Color(0xFF26A69A), [
      _StudentInfo('Sofía Ramírez', 'RAMS100215MDFMFR08', 13, 'Cursando',
          const Color(0xFFAB47BC)),
      _StudentInfo('Andrés Martínez', 'MARA080730HDFNRD09', 15, 'Cursando',
          const Color(0xFF29B6F6)),
    ]),
    _GroupInfo('Grupo 1A', 'Matutino', const Color(0xFFE91E63), [
      _StudentInfo('Camila Delgado', 'DELC090412MDFMLC10', 14, 'Cursando',
          const Color(0xFFEF5350)),
      _StudentInfo('Carlos Méndez', 'MECC080515HDHNRL01', 15, 'Cursando',
          const Color(0xFF7E57C2)),
      _StudentInfo('Ana Sofía Rivera', 'RIAA090320MDFVNN02', 14, 'Cursando',
          const Color(0xFF4CAF50)),
      _StudentInfo('Valentina Torres', 'TORV100810MDFRLR04', 13, 'Cursando',
          const Color(0xFFE91E63)),
      _StudentInfo('Emilio Castro', 'CASE091130HDFSML07', 14, 'Cursando',
          const Color(0xFF66BB6A)),
    ]),
  ];

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 1050;

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);

    return ProfesorScaffold(
      selectedIndex: 1,
      destinations: {
        0: (_) => const DashboardProfesor(),
        2: (_) => const EvidenciasProfesor(),
      },
      bodyPadding: EdgeInsets.all(mobile ? 16 : 28),
      body: _buildBody(mobile),
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
    if (isMobile) {
      return Column(
        children: _groups.map((g) => _buildGroupCard(g)).toList(),
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
            Expanded(child: _buildGroupCard(_groups[i + j])),
          );
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
    }

    return Column(children: rows);
  }

  Widget _buildGroupCard(_GroupInfo g) {
    final initials = g.name.length >= 2
        ? g.name.substring(0, 2).toUpperCase()
        : g.name.toUpperCase();

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGroup = g;
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
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: g.accentColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              color: g.accentColor,
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
                              g.name,
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
                                    color: g.accentColor.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    g.turno,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: g.accentColor,
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
                          color: g.accentColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: g.accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _statChip(
                        Icons.people_outline,
                        '${g.students.length} ${g.students.length == 1 ? 'Alumno' : 'Alumnos'}',
                        const Color(0xFF26A69A),
                      ),
                      const SizedBox(width: 8),
                      _statChip(
                        Icons.schedule,
                        g.turno,
                        const Color(0xFF42A5F5),
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
                                  return Positioned(
                                    left: i * 22.0,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: g.students[i].color
                                            .withOpacity(0.15),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _getInitials(g.students[i].name),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: g.students[i].color,
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
                  const SizedBox(height: 14),
                  const Divider(color: Color(0xFFF0F0F0), height: 1),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedGroup = g;
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
                        color: const Color(0xFF4CAF50).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            size: 16,
                            color: Color(0xFF4CAF50),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Ver Alumnos',
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
  // NIVEL 1: ALUMNOS DEL GRUPO
  // ═══════════════════════════════════════════════════════════════

  Widget _buildStudentsLevel(bool isMobile) {
    final group = _selectedGroup!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBreadcrumb(isMobile, [group.name]),
        const SizedBox(height: 20),
        _buildStudentsHeader(isMobile, group),
        const SizedBox(height: 24),
        ...group.students.map(
          (s) => _buildStudentCard(s, group, isMobile),
        ),
      ],
    );
  }

  Widget _buildStudentsHeader(bool isMobile, _GroupInfo group) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [group.accentColor.withOpacity(0.9), group.accentColor],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.name,
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
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(width: 4),
              Text(
                group.turno,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.people_outline,
                size: 14,
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(width: 4),
              Text(
                '${group.students.length} alumnos',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(
    _StudentInfo student,
    _GroupInfo group,
    bool isMobile,
  ) {
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
              backgroundColor: student.color.withOpacity(0.15),
              child: Text(
                _getInitials(student.name),
                style: TextStyle(
                  color: student.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        student.curp,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${student.edad} años',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF42A5F5).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          student.estatus,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF42A5F5),
                          ),
                        ),
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
                  child: const Icon(
                    Icons.visibility_outlined,
                    size: 18,
                    color: Color(0xFF7E57C2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────── VER ALUMNO DIALOG ────────
  void _showStudentInfoDialog(_StudentInfo student, _GroupInfo group) {
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
          width: mobile ? double.infinity : 480,
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
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white24,
                        child: Text(
                          _getInitials(student.name),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          group.name,
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
                // Info
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow('CURP', student.curp),
                      const SizedBox(height: 12),
                      _infoRow('Edad', '${student.edad} años'),
                      const SizedBox(height: 12),
                      _infoRow('Estatus', student.estatus),
                      const SizedBox(height: 12),
                      _infoRow('Turno', group.turno),
                      const SizedBox(height: 12),
                      _infoRow('Grupo', group.name),
                    ],
                  ),
                ),
                // Close
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
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF888888),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.right,
            ),
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
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
              splashColor: const Color(0xFF4CAF50).withOpacity(0.15),
              highlightColor: const Color(0xFF4CAF50).withOpacity(0.08),
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
                        const Color(0xFF4CAF50).withOpacity(0.10),
                        const Color(0xFF388E3C).withOpacity(0.06),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF4CAF50).withOpacity(0.2),
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
                              Icons.group_outlined,
                              size: 15,
                              color:
                                  const Color(0xFF4CAF50).withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Mis Grupos',
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
                                      .withOpacity(0.06),
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

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }
}

// ═══════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════

class _GroupInfo {
  final String name;
  final String turno;
  final Color accentColor;
  final List<_StudentInfo> students;
  const _GroupInfo(this.name, this.turno, this.accentColor, this.students);
}

class _StudentInfo {
  final String name;
  final String curp;
  final int edad;
  final String estatus;
  final Color color;
  const _StudentInfo(this.name, this.curp, this.edad, this.estatus, this.color);
}
