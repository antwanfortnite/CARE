import 'package:flutter/material.dart';
import 'AlumnoScaffold.dart';
import 'EvidenciasAlumno.dart';
import '../../BD/Alumnos.dart';
import '../../BD/Grupos.dart';
import '../../BD/Evidencias.dart';

class DashboardAlumno extends StatefulWidget {
  final Map<String, dynamic>? user;
  const DashboardAlumno({super.key, this.user});

  @override
  State<DashboardAlumno> createState() => _DashboardAlumnoState();
}

class _DashboardAlumnoState extends State<DashboardAlumno> {
  int _selectedIndex = 0;
  bool _isLoading = true;

  List<dynamic> _hijos = [];
  List<dynamic> _grupos = [];
  List<dynamic> _evidencias = [];

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 700;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);
    try {
      final idPadre = widget.user?['id_padre'];
      final alumnos = await ApiService().getAlumnos();
      final grupos = await GruposApiService().getGrupos();
      final evidencias = await EvidenciasApiService().getEvidencias();

      if (mounted) {
        setState(() {
          _hijos = idPadre != null
              ? alumnos.where((a) => a['id_padre'] == idPadre).toList()
              : [];
          _grupos = grupos;
          _evidencias = evidencias;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error cargando datos del padre: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Obtener el grupo de un alumno
  Map<String, dynamic>? _getGrupoForAlumno(dynamic alumno) {
    final idGrupo = alumno['id_grupo'];
    if (idGrupo == null) return null;
    try {
      return _grupos.firstWhere((g) => g['id_grupo'] == idGrupo);
    } catch (_) {
      return null;
    }
  }

  // Obtener las evidencias de un alumno
  List<dynamic> _getEvidenciasForAlumno(dynamic alumno) {
    final idAlumno = alumno['id_alumno'];
    return _evidencias.where((e) => e['id_alumno'] == idAlumno).toList();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(dateStr);
      final months = [
        '', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
      ];
      return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month]} ${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);

    return AlumnoScaffold(
      selectedIndex: _selectedIndex,
      onNavTap: (i) {
        setState(() {
          _selectedIndex = i;
        });
      },
      body: _selectedIndex == 0
          ? _isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50)))
              : Padding(
                  padding: EdgeInsets.all(mobile ? 16 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeBanner(mobile),
                      const SizedBox(height: 24),
                      if (_hijos.isEmpty)
                        _buildEmptyState()
                      else ...[
                        ..._hijos.map((hijo) => Column(
                          children: [
                            _buildStudentInfoCard(mobile, hijo),
                            const SizedBox(height: 16),
                          ],
                        )),
                        const SizedBox(height: 8),
                        _buildStatCards(mobile),
                        const SizedBox(height: 24),
                        _buildRecentEvidences(mobile),
                        const SizedBox(height: 24),
                        _buildHelpSection(mobile),
                      ],
                    ],
                  ),
                )
          : EvidenciasAlumno(
              hijos: _hijos,
              grupos: _grupos,
              evidencias: _evidencias,
            ),
    );
  }

  Widget _buildEmptyState() {
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
          Icon(Icons.person_search_outlined, size: 48, color: Color(0xFFCCCCCC)),
          SizedBox(height: 16),
          Text(
            'No se encontraron alumnos registrados',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF888888)),
          ),
          SizedBox(height: 8),
          Text(
            'No tiene hijos registrados en el sistema. Contacte al administrador.',
            style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ──────── BANNER DE BIENVENIDA ────────
  Widget _buildWelcomeBanner(bool isMobile) {
    final nombrePadre = widget.user?['nombre_padre'] ?? 'Padre de Familia';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF388E3C), Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Buen día, $nombrePadre!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 18 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isMobile
                      ? 'Aquí podrá consultar las evidencias de trabajo de su${_hijos.length > 1 ? 's' : ''} hijo${_hijos.length > 1 ? 's' : ''}.'
                      : 'Bienvenido al sistema CARE. Aquí podrá consultar las evidencias\nde trabajo y actividades de su${_hijos.length > 1 ? 's' : ''} hijo${_hijos.length > 1 ? 's' : ''}.',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _selectedIndex = 1);
                  },
                  icon: const Icon(Icons.folder_shared_outlined, size: 18),
                  label: const Text('Ver Evidencias'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2E7D32),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.family_restroom,
                size: 64,
                color: Colors.white70,
              ),
            ),
        ],
      ),
    );
  }

  // ──────── INFORMACIÓN DEL ALUMNO ────────
  Widget _buildStudentInfoCard(bool isMobile, dynamic hijo) {
    final grupo = _getGrupoForAlumno(hijo);
    final nombreGrupo = grupo?['nombre_grupo'] ?? 'Sin grupo';
    final turno = grupo?['turno'] ?? 'N/A';
    final evidCount = _getEvidenciasForAlumno(hijo).length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 22),
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
              const Icon(
                Icons.school_outlined,
                size: 20,
                color: Color(0xFF4CAF50),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hijo['nombre_completo'] ?? 'Alumno',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$evidCount ${evidCount == 1 ? 'evidencia' : 'evidencias'}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isMobile)
            Column(
              children: [
                _infoRow(Icons.person_outline, 'Alumno', hijo['nombre_completo'] ?? 'N/A'),
                const SizedBox(height: 10),
                _infoRow(Icons.group_outlined, 'Grupo', nombreGrupo),
                const SizedBox(height: 10),
                _infoRow(Icons.schedule, 'Turno', turno),
                const SizedBox(height: 10),
                _infoRow(Icons.badge_outlined, 'CURP', hijo['curp'] ?? 'N/A'),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _infoRow(Icons.person_outline, 'Alumno', hijo['nombre_completo'] ?? 'N/A'),
                      const SizedBox(height: 10),
                      _infoRow(Icons.group_outlined, 'Grupo', nombreGrupo),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      _infoRow(Icons.schedule, 'Turno', turno),
                      const SizedBox(height: 10),
                      _infoRow(Icons.badge_outlined, 'CURP', hijo['curp'] ?? 'N/A'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF888888)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF999999),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────── TARJETAS DE ESTADÍSTICAS ────────
  Widget _buildStatCards(bool isMobile) {
    final totalEvidencias = _hijos.fold<int>(
      0, (sum, h) => sum + _getEvidenciasForAlumno(h).length);

    // Última evidencia global
    String ultimaEvidencia = 'N/A';
    DateTime? lastDate;
    for (final hijo in _hijos) {
      for (final ev in _getEvidenciasForAlumno(hijo)) {
        try {
          final dt = DateTime.parse(ev['fecha_subida']);
          if (lastDate == null || dt.isAfter(lastDate)) {
            lastDate = dt;
          }
        } catch (_) {}
      }
    }
    if (lastDate != null) {
      final months = ['', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
      ultimaEvidencia = '${lastDate.day.toString().padLeft(2,'0')}/${months[lastDate.month]}';
    }

    final stats = [
      _StatData(
        Icons.folder_shared_outlined,
        'Total de Evidencias',
        '$totalEvidencias',
        'Registradas',
        const Color(0xFF4CAF50),
      ),
      _StatData(
        Icons.calendar_today_outlined,
        'Última Evidencia',
        ultimaEvidencia,
        lastDate != null ? '${lastDate.year}' : '',
        const Color(0xFF7E57C2),
      ),
      _StatData(
        Icons.people_outline,
        _hijos.length == 1 ? 'Hijo Registrado' : 'Hijos Registrados',
        '${_hijos.length}',
        'En el sistema',
        const Color(0xFF42A5F5),
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard(stats[0])),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(stats[1])),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatCard(stats[2]),
        ],
      );
    }

    return Row(
      children: stats.map((s) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _buildStatCard(s),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard(_StatData s) {
    return Container(
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: s.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(s.icon, color: s.color, size: 20),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  s.badge,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: s.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            s.label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              s.value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────── EVIDENCIAS RECIENTES ────────
  Widget _buildRecentEvidences(bool isMobile) {
    // Recopilar todas las evidencias de todos los hijos
    final allEvids = <Map<String, dynamic>>[];
    for (final hijo in _hijos) {
      for (final ev in _getEvidenciasForAlumno(hijo)) {
        allEvids.add({
          ...ev,
          '_hijo_nombre': hijo['nombre_completo'] ?? 'Alumno',
        });
      }
    }
    // Ordenar por fecha descendente
    allEvids.sort((a, b) {
      try {
        final da = DateTime.parse(a['fecha_subida'] ?? '');
        final db = DateTime.parse(b['fecha_subida'] ?? '');
        return db.compareTo(da);
      } catch (_) {
        return 0;
      }
    });
    final recents = allEvids.take(3).toList();

    final colors = [
      const Color(0xFF4CAF50),
      const Color(0xFF7E57C2),
      const Color(0xFF42A5F5),
    ];

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.history,
                size: 20,
                color: Color(0xFF4CAF50),
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Últimas Evidencias Registradas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Aquí puede ver las evidencias más recientes de su(s) hijo(s)',
            style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
          ),
          const SizedBox(height: 16),
          if (recents.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                children: [
                  Icon(Icons.photo_library_outlined, size: 32, color: Color(0xFFCCCCCC)),
                  SizedBox(height: 8),
                  Text(
                    'Sin evidencias registradas',
                    style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
                  ),
                ],
              ),
            )
          else
            ...recents.asMap().entries.map((entry) {
              final ev = entry.value;
              final color = colors[entry.key % colors.length];
              final desc = ev['descripcion'] ?? 'Sin descripción';
              final fecha = _formatDate(ev['fecha_subida']?.toString());
              final hijoNombre = _hijos.length > 1 ? ' — ${ev['_hijo_nombre']}' : '';
              return _recentEvidenceTile('$desc$hijoNombre', fecha, color);
            }),
        ],
      ),
    );
  }

  Widget _recentEvidenceTile(String desc, String date, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.camera_alt_outlined,
              size: 20,
              color: color,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 12,
                      color: Color(0xFF999999),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
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
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.visibility_outlined,
              size: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ──────── SECCIÓN DE AYUDA ────────
  Widget _buildHelpSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.help_outline,
                size: 20,
                color: Color(0xFF42A5F5),
              ),
              SizedBox(width: 8),
              Text(
                '¿Cómo funciona?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _helpStep(
            '1',
            'Ir a Evidencias',
            'En el menú lateral, seleccione "Evidencias" para ver todas las evidencias de su hijo(a).',
            const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 10),
          _helpStep(
            '2',
            'Consultar detalles',
            'Haga clic en el botón de "ver" para consultar la información completa de cada evidencia.',
            const Color(0xFF7E57C2),
          ),
          const SizedBox(height: 10),
          _helpStep(
            '3',
            'Mantenerse informado',
            'Revise periódicamente para estar al tanto del progreso y trabajo de su hijo(a) en la escuela.',
            const Color(0xFF42A5F5),
          ),
        ],
      ),
    );
  }

  Widget _helpStep(String number, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF888888),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatData {
  final IconData icon;
  final String label;
  final String value;
  final String badge;
  final Color color;
  const _StatData(this.icon, this.label, this.value, this.badge, this.color);
}
