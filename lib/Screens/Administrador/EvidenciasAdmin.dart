import 'package:flutter/material.dart';
import 'AdminScaffold.dart';
import 'DashboardAdmin.dart';
import 'MaestrosAdmin.dart';
import 'AlumnosAdmin.dart';
import 'GruposAdmin.dart';

class EvidenciasAdmin extends StatefulWidget {
  const EvidenciasAdmin({super.key});
  @override
  State<EvidenciasAdmin> createState() => _EvidenciasAdminState();
}

class _EvidenciasAdminState extends State<EvidenciasAdmin> {
  final TextEditingController _searchController = TextEditingController();

  // ──────── NIVEL DE NAVEGACIÓN ────────
  // 0 = lista de maestros, 1 = grupos del maestro, 2 = alumnos del grupo con evidencias
  int _currentLevel = 0;
  _TeacherPlan? _selectedTeacher;
  _GroupInfo? _selectedGroup;

  // ──────── DATOS MOCK DE MAESTROS DISPONIBLES ────────
  final List<_TeacherOption> _allTeachers = [
    _TeacherOption('Julián Sánchez', 'julian.sanchez@care.edu.mx', const Color(0xFF7E57C2)),
    _TeacherOption('Rosa María Moreno', 'rosa.moreno@care.edu.mx', const Color(0xFF4CAF50)),
    _TeacherOption('Alberto González', 'alberto.gonz@care.edu.mx', const Color(0xFF26A69A)),
    _TeacherOption('Elena Ledesma', 'elena.l@care.edu.mx', const Color(0xFFE91E63)),
  ];

  // ──────── PLANES DE SEGUIMIENTO (maestros agregados) ────────
  final List<_TeacherPlan> _teacherPlans = [];

  // ──────── DATOS MOCK DE GRUPOS POR MAESTRO ────────
  final Map<String, List<_GroupInfo>> _teacherGroups = {
    'Julián Sánchez': [
      _GroupInfo('Grupo 3A', 'Matutino', const Color(0xFF7E57C2), [
        _StudentInfo('Carlos Méndez', 'MECC080515HDHNRL01', const Color(0xFF7E57C2)),
        _StudentInfo('Ana Sofía Rivera', 'RIAA090320MDFVNN02', const Color(0xFF4CAF50)),
        _StudentInfo('Diego Hernández', 'HEAD071205HDFRGL03', const Color(0xFF26A69A)),
      ]),
      _GroupInfo('Grupo 3B', 'Vespertino', const Color(0xFF42A5F5), [
        _StudentInfo('Diego Hernández', 'HEAD071205HDFRGL03', const Color(0xFF26A69A)),
        _StudentInfo('Miguel Ángel Ruiz', 'RUIM060714HDFRGL05', const Color(0xFFFFA726)),
        _StudentInfo('Andrés Martínez', 'MARA080730HDFNRD09', const Color(0xFF29B6F6)),
      ]),
    ],
    'Rosa María Moreno': [
      _GroupInfo('Grupo 1B', 'Vespertino', const Color(0xFF4CAF50), [
        _StudentInfo('Valentina Torres', 'TORV100810MDFRLR04', const Color(0xFFE91E63)),
        _StudentInfo('Miguel Ángel Ruiz', 'RUIM060714HDFRGL05', const Color(0xFFFFA726)),
        _StudentInfo('Fernanda López', 'LOPF080922MDFPZR06', const Color(0xFF42A5F5)),
        _StudentInfo('Emilio Castro', 'CASE091130HDFSML07', const Color(0xFF66BB6A)),
      ]),
      _GroupInfo('Grupo 2B', 'Vespertino', const Color(0xFFFFA726), [
        _StudentInfo('Fernanda López', 'LOPF080922MDFPZR06', const Color(0xFF42A5F5)),
        _StudentInfo('Sofía Ramírez', 'RAMS100215MDFMFR08', const Color(0xFFAB47BC)),
        _StudentInfo('Camila Delgado', 'DELC090412MDFMLC10', const Color(0xFFEF5350)),
      ]),
    ],
    'Alberto González': [
      _GroupInfo('Grupo 2A', 'Matutino', const Color(0xFF26A69A), [
        _StudentInfo('Sofía Ramírez', 'RAMS100215MDFMFR08', const Color(0xFFAB47BC)),
        _StudentInfo('Andrés Martínez', 'MARA080730HDFNRD09', const Color(0xFF29B6F6)),
      ]),
    ],
    'Elena Ledesma': [
      _GroupInfo('Grupo 1A', 'Matutino', const Color(0xFFE91E63), [
        _StudentInfo('Camila Delgado', 'DELC090412MDFMLC10', const Color(0xFFEF5350)),
        _StudentInfo('Carlos Méndez', 'MECC080515HDHNRL01', const Color(0xFF7E57C2)),
        _StudentInfo('Ana Sofía Rivera', 'RIAA090320MDFVNN02', const Color(0xFF4CAF50)),
        _StudentInfo('Valentina Torres', 'TORV100810MDFRLR04', const Color(0xFFE91E63)),
        _StudentInfo('Emilio Castro', 'CASE091130HDFSML07', const Color(0xFF66BB6A)),
      ]),
    ],
  };

  // ──────── EVIDENCIAS MOCK ────────
  final Map<String, List<_EvidenciaData>> _evidencias = {
    // key: "maestro|grupo|alumno"
    'Julián Sánchez|Grupo 3A|Carlos Méndez': [
      _EvidenciaData(1, 'https://ejemplo.com/fotos/carlos_act1.jpg', 'Participación en clase de ciencias. El alumno demostró excelente comprensión del tema.', '2026-03-15'),
      _EvidenciaData(2, 'https://ejemplo.com/fotos/carlos_act2.jpg', 'Trabajo práctico: maqueta del sistema solar completada satisfactoriamente.', '2026-03-22'),
      _EvidenciaData(3, 'https://ejemplo.com/fotos/carlos_act3.jpg', 'Evaluación diagnóstica - resultado aprobatorio.', '2026-04-01'),
    ],
    'Julián Sánchez|Grupo 3A|Ana Sofía Rivera': [
      _EvidenciaData(4, 'https://ejemplo.com/fotos/ana_act1.jpg', 'Exposición oral sobre ecosistemas. Excelente presentación visual.', '2026-03-18'),
      _EvidenciaData(5, 'https://ejemplo.com/fotos/ana_act2.jpg', 'Trabajo en equipo: proyecto de reciclaje escolar.', '2026-04-05'),
    ],
    'Julián Sánchez|Grupo 3A|Diego Hernández': [
      _EvidenciaData(6, 'https://ejemplo.com/fotos/diego_act1.jpg', 'Actividad de laboratorio: mezclas homogéneas y heterogéneas.', '2026-03-20'),
    ],
    'Rosa María Moreno|Grupo 1B|Valentina Torres': [
      _EvidenciaData(7, 'https://ejemplo.com/fotos/val_act1.jpg', 'Lectura comprensiva: resumen del capítulo 3 del libro de texto.', '2026-03-12'),
      _EvidenciaData(8, 'https://ejemplo.com/fotos/val_act2.jpg', 'Actividad artística: pintura sobre valores sociales.', '2026-03-28'),
    ],
    'Rosa María Moreno|Grupo 1B|Emilio Castro': [
      _EvidenciaData(9, 'https://ejemplo.com/fotos/emilio_act1.jpg', 'Ejercicio de escritura creativa - cuento corto original.', '2026-04-02'),
    ],
    'Elena Ledesma|Grupo 1A|Camila Delgado': [
      _EvidenciaData(10, 'https://ejemplo.com/fotos/camila_act1.jpg', 'Resolución de problemas matemáticos: fracciones y decimales.', '2026-03-10'),
      _EvidenciaData(11, 'https://ejemplo.com/fotos/camila_act2.jpg', 'Proyecto integrador: poster informativo sobre alimentación saludable.', '2026-03-25'),
      _EvidenciaData(12, 'https://ejemplo.com/fotos/camila_act3.jpg', 'Trabajo de investigación sobre la historia de México.', '2026-04-08'),
    ],
  };

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
      selectedIndex: 4,
      destinations: {
        0: (_) => const DashboardAdmin(),
        1: (_) => const MaestrosAdmin(),
        2: (_) => const AlumnosAdmin(),
        3: (_) => const GruposAdmin(),
      },
      bodyPadding: EdgeInsets.all(mobile ? 16 : 28),
      body: _buildBody(mobile),
    );
  }

  Widget _buildBody(bool isMobile) {
    switch (_currentLevel) {
      case 0:
        return _buildTeachersLevel(isMobile);
      case 1:
        return _buildGroupsLevel(isMobile);
      case 2:
        return _buildStudentsLevel(isMobile);
      default:
        return _buildTeachersLevel(isMobile);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // NIVEL 0: LISTA DE MAESTROS (Planes de Seguimiento)
  // ═══════════════════════════════════════════════════════════════

  Widget _buildTeachersLevel(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTeachersHeader(isMobile),
        const SizedBox(height: 24),
        _buildFilterBar('Filtrar por nombre de maestro...'),
        const SizedBox(height: 24),
        if (_teacherPlans.isEmpty)
          _buildEmptyState(
            Icons.folder_shared_outlined,
            'Sin planes de seguimiento',
            'Agrega un maestro para comenzar a gestionar las evidencias de sus alumnos.',
          )
        else
          _buildTeacherCards(isMobile),
      ],
    );
  }

  Widget _buildTeachersHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestión de Evidencias',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Seguimiento de evidencias por maestro, grupo y alumno.',
            style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddTeacherPlanDialog(),
              icon: const Icon(Icons.person_add_alt_1, size: 18),
              label: const Text('Asignar Seguimiento'),
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
                'Gestión de Evidencias',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Seguimiento de evidencias por maestro, grupo y alumno.',
                style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => _showAddTeacherPlanDialog(),
          icon: const Icon(Icons.person_add_alt_1, size: 18),
          label: const Text('Asignar Seguimiento'),
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

  Widget _buildTeacherCards(bool isMobile) {
    if (isMobile) {
      return Column(
        children: _teacherPlans.map((t) => _buildTeacherCard(t)).toList(),
      );
    }

    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1400 ? 3 : 2;

    List<Widget> rows = [];
    for (int i = 0; i < _teacherPlans.length; i += crossAxisCount) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < crossAxisCount; j++) {
        if (i + j < _teacherPlans.length) {
          rowChildren.add(Expanded(child: _buildTeacherCard(_teacherPlans[i + j])));
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
    }

    return Column(children: rows);
  }

  Widget _buildTeacherCard(_TeacherPlan t) {
    final groups = _teacherGroups[t.name] ?? [];
    final totalStudents = groups.fold<int>(0, (sum, g) => sum + g.students.length);
    final totalEvidencias = _countEvidenciasForTeacher(t.name);
    final initials = _getInitials(t.name);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTeacher = t;
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
            // ── Color accent bar ──
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: t.color,
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
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: t.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              color: t.color,
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
                              t.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF333333),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
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
                      // Arrow indicator
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: t.color.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: t.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // ── Stats row ──
                  Row(
                    children: [
                      _statChip(
                        Icons.group_outlined,
                        '${groups.length} ${groups.length == 1 ? 'Grupo' : 'Grupos'}',
                        const Color(0xFF42A5F5),
                      ),
                      const SizedBox(width: 8),
                      _statChip(
                        Icons.people_outline,
                        '$totalStudents ${totalStudents == 1 ? 'Alumno' : 'Alumnos'}',
                        const Color(0xFF26A69A),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _statChip(
                          Icons.folder_outlined,
                          '$totalEvidencias ${totalEvidencias == 1 ? 'Evidencia' : 'Evidencias'}',
                          const Color(0xFFFFA726),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFF0F0F0), height: 1),
                  const SizedBox(height: 14),
                  // ── Action buttons ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedTeacher = t;
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
                              Text(
                                'Ver Grupos',
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
                      _actionBtn(
                        Icons.delete_outline,
                        const Color(0xFFEF5350),
                        'Eliminar',
                        () => _showDeleteTeacherPlanDialog(t),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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

  // ═══════════════════════════════════════════════════════════════
  // NIVEL 1: GRUPOS DEL MAESTRO
  // ═══════════════════════════════════════════════════════════════

  Widget _buildGroupsLevel(bool isMobile) {
    final teacher = _selectedTeacher!;
    final groups = _teacherGroups[teacher.name] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBreadcrumb(isMobile, [teacher.name]),
        const SizedBox(height: 20),
        _buildGroupsHeader(isMobile, teacher),
        const SizedBox(height: 24),
        if (groups.isEmpty)
          _buildEmptyState(
            Icons.group_outlined,
            'Sin grupos asignados',
            'Este maestro no tiene grupos asignados actualmente.',
          )
        else
          _buildGroupCardsList(isMobile, groups, teacher),
      ],
    );
  }

  Widget _buildGroupsHeader(bool isMobile, _TeacherPlan teacher) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [teacher.color.withOpacity(0.9), teacher.color],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                _getInitials(teacher.name),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teacher.name,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  teacher.email,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCardsList(bool isMobile, List<_GroupInfo> groups, _TeacherPlan teacher) {
    if (isMobile) {
      return Column(
        children: groups.map((g) => _buildGroupInfoCard(g, teacher)).toList(),
      );
    }

    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1400 ? 3 : 2;

    List<Widget> rows = [];
    for (int i = 0; i < groups.length; i += crossAxisCount) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < crossAxisCount; j++) {
        if (i + j < groups.length) {
          rowChildren.add(Expanded(child: _buildGroupInfoCard(groups[i + j], teacher)));
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
    }

    return Column(children: rows);
  }

  Widget _buildGroupInfoCard(_GroupInfo g, _TeacherPlan teacher) {
    final evidCount = _countEvidenciasForGroup(teacher.name, g.name);
    final initials = g.name.length >= 2
        ? g.name.substring(0, 2).toUpperCase()
        : g.name.toUpperCase();

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGroup = g;
          _currentLevel = 2;
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
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _statChip(
                        Icons.schedule,
                        g.turno,
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
                  // ── Student avatars preview ──
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
                                g.students.length > 5 ? 5 : g.students.length,
                                (i) {
                                  return Positioned(
                                    left: i * 22.0,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: g.students[i].color.withOpacity(0.15),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
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
                                      border: Border.all(color: Colors.white, width: 2),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // NIVEL 2: ALUMNOS DEL GRUPO CON EVIDENCIAS
  // ═══════════════════════════════════════════════════════════════

  Widget _buildStudentsLevel(bool isMobile) {
    final teacher = _selectedTeacher!;
    final group = _selectedGroup!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBreadcrumb(isMobile, [teacher.name, group.name]),
        const SizedBox(height: 20),
        _buildStudentsHeader(isMobile, teacher, group),
        const SizedBox(height: 24),
        ...group.students.map((s) => _buildStudentEvidenceCard(s, teacher, group, isMobile)),
      ],
    );
  }

  Widget _buildStudentsHeader(bool isMobile, _TeacherPlan teacher, _GroupInfo group) {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      teacher.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
              Icon(Icons.schedule, size: 14, color: Colors.white.withOpacity(0.8)),
              const SizedBox(width: 4),
              Text(
                group.turno,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.people_outline, size: 14, color: Colors.white.withOpacity(0.8)),
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

  Widget _buildStudentEvidenceCard(_StudentInfo student, _TeacherPlan teacher, _GroupInfo group, bool isMobile) {
    final key = '${teacher.name}|${group.name}|${student.name}';
    final evids = _evidencias[key] ?? [];

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
          childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: student.color.withOpacity(0.15),
            child: Text(
              _getInitials(student.name),
              style: TextStyle(
                color: student.color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          title: Text(
            student.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                student.curp,
                style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: evids.isEmpty
                      ? const Color(0xFFEF5350).withOpacity(0.1)
                      : const Color(0xFF4CAF50).withOpacity(0.1),
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
                  onTap: () => _showAddEvidenciaDialog(teacher, group, student),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_photo_alternate, size: 16, color: Color(0xFF4CAF50)),
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
                    Icon(Icons.photo_library_outlined, size: 32, color: Color(0xFFCCCCCC)),
                    SizedBox(height: 8),
                    Text(
                      'Sin evidencias registradas',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                  ],
                ),
              )
            else
              ...evids.map((e) => _buildEvidenciaItem(e, isMobile)),
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenciaItem(_EvidenciaData e, bool isMobile) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo thumbnail placeholder
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF42A5F5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF42A5F5).withOpacity(0.2)),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_outlined, size: 22, color: Color(0xFF42A5F5)),
                SizedBox(height: 2),
                Text(
                  'Foto',
                  style: TextStyle(fontSize: 8, color: Color(0xFF42A5F5), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.descripcion,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF444444),
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF999999)),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(e.fechaSubida),
                      style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'ID: ${e.idEvidencia}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
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

  // ═══════════════════════════════════════════════════════════════
  // WIDGETS COMPARTIDOS
  // ═══════════════════════════════════════════════════════════════

  Widget _buildBreadcrumb(bool isMobile, List<String> paths) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (_currentLevel == 2) {
                  _currentLevel = 1;
                  _selectedGroup = null;
                } else {
                  _currentLevel = 0;
                  _selectedTeacher = null;
                }
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_back, size: 18, color: Color(0xFF4CAF50)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _currentLevel = 0;
                        _selectedTeacher = null;
                        _selectedGroup = null;
                      });
                    },
                    child: const Text(
                      'Evidencias',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4CAF50),
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
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.chevron_right, size: 16, color: Color(0xFF999999)),
                        ),
                        InkWell(
                          onTap: isLast ? null : () {
                            setState(() {
                              _currentLevel = i + 1;
                              if (i == 0) {
                                _selectedGroup = null;
                              }
                            });
                          },
                          child: Text(
                            p,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isLast ? FontWeight.w600 : FontWeight.w500,
                              color: isLast ? const Color(0xFF333333) : const Color(0xFF4CAF50),
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
                prefixIcon: const Icon(Icons.filter_list, color: Color(0xFF999999)),
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF999999)),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: const Color(0xFF4CAF50).withOpacity(0.4)),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Color(0xFF999999)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, Color color, String tooltip, VoidCallback onTap) {
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

  // ═══════════════════════════════════════════════════════════════
  // DIALOGS
  // ═══════════════════════════════════════════════════════════════

  void _showAddTeacherPlanDialog() {
    final mobile = _isMobile(context);
    String? selectedTeacherName;

    // Filtrar maestros que ya están agregados
    final available = _allTeachers.where(
      (t) => !_teacherPlans.any((p) => p.name == t.name),
    ).toList();

    if (available.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA726).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.info_outline, color: Color(0xFFFFA726), size: 24),
              ),
              const SizedBox(width: 12),
              const Flexible(
                child: Text(
                  'Sin maestros disponibles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: const Text(
            'Todos los maestros ya han sido asignados a un plan de seguimiento.',
            style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 40, vertical: 24),
          child: Container(
            width: mobile ? double.infinity : 480,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
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
                          const Icon(Icons.person_add_alt_1, size: 16, color: Colors.white70),
                          const SizedBox(width: 6),
                          Text(
                            'GESTIÓN DE EVIDENCIAS',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Asignar Seguimiento',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Body
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SELECCIONAR MAESTRO',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF555555),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Selecciona un maestro para crear su plan de seguimiento de evidencias.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedTeacherName,
                            isExpanded: true,
                            hint: const Text(
                              'Seleccionar maestro...',
                              style: TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
                            ),
                            icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: Color(0xFF999999)),
                            style: const TextStyle(fontSize: 13, color: Color(0xFF333333)),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            items: available.map((t) => DropdownMenuItem<String>(
                              value: t.name,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: t.color.withOpacity(0.15),
                                    child: Text(
                                      _getInitials(t.name),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: t.color,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(t.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                        Text(
                                          t.email,
                                          style: const TextStyle(fontSize: 10, color: Color(0xFF999999)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )).toList(),
                            onChanged: (val) => setDlg(() => selectedTeacherName = val),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Actions
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Color(0xFF888888), fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: selectedTeacherName == null ? null : () {
                          final teacher = _allTeachers.firstWhere((t) => t.name == selectedTeacherName);
                          setState(() {
                            _teacherPlans.add(_TeacherPlan(
                              teacher.name,
                              teacher.email,
                              teacher.color,
                            ));
                          });
                          Navigator.pop(ctx);
                        },
                        icon: const Icon(Icons.check_circle_outline, size: 18),
                        label: const Text('Asignar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFFCCCCCC),
                          disabledForegroundColor: Colors.white70,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
    );
  }

  void _showDeleteTeacherPlanDialog(_TeacherPlan t) {
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
              child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF5350), size: 24),
            ),
            const SizedBox(width: 12),
            const Flexible(
              child: Text(
                'Quitar Seguimiento',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: Color(0xFF555555), height: 1.5),
            children: [
              const TextSpan(text: '¿Está seguro de que desea quitar el seguimiento de '),
              TextSpan(
                text: t.name,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333)),
              ),
              const TextSpan(text: '? Las evidencias registradas se conservarán en la base de datos.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Color(0xFF888888))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _teacherPlans.remove(t));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Sí, quitar'),
          ),
        ],
      ),
    );
  }

  void _showAddEvidenciaDialog(_TeacherPlan teacher, _GroupInfo group, _StudentInfo student) {
    final mobile = _isMobile(context);
    final urlCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 40, vertical: 24),
          child: Container(
            width: mobile ? double.infinity : 520,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
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
                            const Icon(Icons.add_photo_alternate, size: 16, color: Colors.white70),
                            const SizedBox(width: 6),
                            Text(
                              'NUEVA EVIDENCIA',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Agregar Evidencia',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Alumno: ${student.name}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
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
                        // Teacher & Group info
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, size: 16, color: Color(0xFF888888)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${teacher.name}  •  ${group.name}',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Text(
                          'URL DE LA FOTO',
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
                            hintText: 'https://ejemplo.com/foto.jpg',
                            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
                            suffixIcon: const Icon(Icons.link, size: 18, color: Color(0xFF999999)),
                            filled: true,
                            fillColor: const Color(0xFFF9F9F9),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
                            filled: true,
                            fillColor: const Color(0xFFF9F9F9),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                      ],
                    ),
                  ),

                  // Actions
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(color: Color(0xFF888888), fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (descCtrl.text.trim().isNotEmpty) {
                              final key = '${teacher.name}|${group.name}|${student.name}';
                              final nextId = _evidencias.values.fold<int>(
                                0,
                                (max, list) => list.fold<int>(max, (m, e) => e.idEvidencia > m ? e.idEvidencia : m),
                              ) + 1;
                              setState(() {
                                _evidencias.putIfAbsent(key, () => []);
                                _evidencias[key]!.add(_EvidenciaData(
                                  nextId,
                                  urlCtrl.text.trim().isEmpty
                                      ? 'https://ejemplo.com/fotos/evidencia_$nextId.jpg'
                                      : urlCtrl.text.trim(),
                                  descCtrl.text.trim(),
                                  '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
                                ));
                              });
                            }
                            Navigator.pop(ctx);
                          },
                          icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                          label: const Text('Subir Evidencia'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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

  // ═══════════════════════════════════════════════════════════════
  // UTILIDADES
  // ═══════════════════════════════════════════════════════════════

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  int _countEvidenciasForTeacher(String teacherName) {
    int count = 0;
    _evidencias.forEach((key, list) {
      if (key.startsWith('$teacherName|')) {
        count += list.length;
      }
    });
    return count;
  }

  int _countEvidenciasForGroup(String teacherName, String groupName) {
    int count = 0;
    _evidencias.forEach((key, list) {
      if (key.startsWith('$teacherName|$groupName|')) {
        count += list.length;
      }
    });
    return count;
  }

  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      final months = [
        '', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
      ];
      return '${parts[2]} ${months[int.parse(parts[1])]} ${parts[0]}';
    } catch (_) {
      return dateStr;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════

class _TeacherOption {
  final String name;
  final String email;
  final Color color;
  const _TeacherOption(this.name, this.email, this.color);
}

class _TeacherPlan {
  final String name;
  final String email;
  final Color color;
  const _TeacherPlan(this.name, this.email, this.color);
}

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
  final Color color;
  const _StudentInfo(this.name, this.curp, this.color);
}

class _EvidenciaData {
  final int idEvidencia;
  final String urlFoto;
  final String descripcion;
  final String fechaSubida;
  const _EvidenciaData(this.idEvidencia, this.urlFoto, this.descripcion, this.fechaSubida);
}
