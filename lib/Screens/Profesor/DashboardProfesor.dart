import 'package:flutter/material.dart';
import 'ProfesorScaffold.dart';
import 'GruposProfesor.dart';
import 'EvidenciasProfesor.dart';
import '../../BD/Dashboard.dart';
import 'package:intl/intl.dart';

class DashboardProfesor extends StatefulWidget {
  final Map<String, dynamic>? user;
  const DashboardProfesor({super.key, this.user});

  @override
  State<DashboardProfesor> createState() => _DashboardProfesorState();
}

class _DashboardProfesorState extends State<DashboardProfesor> {
  final DashboardApiService _apiService = DashboardApiService();
  Map<String, dynamic>? _resumen;
  List<dynamic> _bitacora = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final int idMaestro = widget.user?['id_maestro'] ?? 0;
    if (idMaestro == 0) return;

    setState(() => _isLoading = true);
    try {
      final res = await _apiService.getResumenMaestro(idMaestro);
      final bit = await _apiService.getBitacoraMaestroEvidencias(idMaestro);

      if (mounted) {
        setState(() {
          _resumen = res;
          _bitacora = bit;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 700;

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);

    return ProfesorScaffold(
      user: widget.user,
      selectedIndex: 0,
      destinations: {
        1: (_) => GruposProfesor(user: widget.user),
        2: (_) => EvidenciasProfesor(user: widget.user),
      },
      body: RefreshIndicator(
        onRefresh: _fetchData,
        color: const Color(0xFF4CAF50),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeBanner(mobile),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Color(0xFF4CAF50)))
                  : _buildStatCards(mobile),
              const SizedBox(height: 24),
              _buildMiddleSection(mobile),
              const SizedBox(height: 24),
              _buildCalendarSection(mobile),
            ],
          ),
        ),
      ),
    );
  }

  // ──────── BANNER DE BIENVENIDA ────────
  Widget _buildWelcomeBanner(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF388E3C), Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¡Buen día, ${widget.user?['nombre_completo'] ?? 'Profesor'}!',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 18 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isMobile
                ? 'Bienvenido al sistema CARE. Resumen de tu actividad docente.'
                : 'Bienvenido al sistema CARE. Aquí tienes un resumen de tu actividad\ndocente y el avance de tus grupos.',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ──────── TARJETAS DE ESTADÍSTICAS ────────
  Widget _buildStatCards(bool isMobile) {
    final stats = [
      _StatData(
        Icons.group_outlined,
        'Mis Grupos',
        '${_resumen?['mis_grupos'] ?? 0}',
        'Activos',
        const Color(0xFF4CAF50),
      ),
      _StatData(
        Icons.people_outline,
        'Total Alumnos',
        '${_resumen?['total_alumnos'] ?? 0}',
        'Inscritos',
        const Color(0xFF26A69A),
      ),
      _StatData(
        Icons.folder_shared_outlined,
        'Evidencias Subidas',
        '${_resumen?['evidencias_subidas'] ?? 0}',
        'Total',
        const Color(0xFF7E57C2),
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

  // ──────── SECCIÓN MEDIA ────────
  Widget _buildMiddleSection(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _buildActivitySection(),
          const SizedBox(height: 20),
          _buildQuickActionsSection(),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _buildActivitySection()),
        const SizedBox(width: 20),
        Expanded(flex: 2, child: _buildQuickActionsSection()),
      ],
    );
  }

  Widget _buildActivitySection() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'Actividad Reciente',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Ver todo',
                  style: TextStyle(color: Color(0xFF4CAF50), fontSize: 13),
                ),
              ),
            ],
          ),
          const Text(
            'Últimas actividades de evidencias',
            style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: LinearProgressIndicator(color: Color(0xFF4CAF50)))
          else if (_bitacora.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text('Sin actividad reciente', style: TextStyle(color: Colors.grey))),
            )
          else
            ..._bitacora.map((item) {
              String dateStr = 'Reciente';
              try {
                DateTime dt = DateTime.parse(item['fecha']);
                dateStr = DateFormat('dd/MM HH:mm').format(dt);
              } catch (_) {}

              return _activityTile(
                Icons.history_edu_outlined,
                const Color(0xFF4CAF50),
                item['accion'] ?? 'Acción',
                item['detalle'] ?? '',
                dateStr,
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Acciones Rápidas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Accesos directos a funciones frecuentes',
            style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
          ),
          const SizedBox(height: 20),
          _quickActionBtn(
            Icons.add_photo_alternate,
            'Subir Evidencia',
            'Agregar evidencia a un alumno',
            const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 12),
          _quickActionBtn(
            Icons.group_outlined,
            'Ver Mis Grupos',
            'Consultar alumnos y grupos',
            const Color(0xFF42A5F5),
          ),
          const SizedBox(height: 12),
          _quickActionBtn(
            Icons.folder_shared_outlined,
            'Gestión de Evidencias',
            'Administrar todas las evidencias',
            const Color(0xFF7E57C2),
          ),
        ],
      ),
    );
  }

  Widget _quickActionBtn(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
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
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: color.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _activityTile(
    IconData icon,
    Color color,
    String title,
    String subtitle,
    String time,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  // ──────── CALENDARIO / PRÓXIMOS EVENTOS ────────
  Widget _buildCalendarSection(bool isMobile) {
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
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Próximos Eventos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Fechas importantes para tus grupos',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Próximos Eventos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Fechas importantes para tus grupos',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          const SizedBox(height: 20),
          isMobile
              ? Column(
                  children: [
                    _eventCardMobile(
                      '20',
                      'ABR',
                      'Entrega de Evidencias',
                      'Límite para subir evidencias del mes de abril.',
                      const Color(0xFFEF5350),
                    ),
                    const SizedBox(height: 12),
                    _eventCardMobile(
                      '25',
                      'ABR',
                      'Junta de Maestros',
                      'Reunión de coordinación académica con dirección.',
                      const Color(0xFF4CAF50),
                    ),
                    const SizedBox(height: 12),
                    _eventCardMobile(
                      '01',
                      'MAY',
                      'Día del Trabajo',
                      'Suspensión de labores académicas.',
                      const Color(0xFF333333),
                    ),
                  ],
                )
              : Row(
                  children: [
                    _eventCard(
                      '20',
                      'ABR',
                      'Entrega de Evidencias',
                      'Límite para subir evidencias del mes de abril.',
                      const Color(0xFFEF5350),
                    ),
                    const SizedBox(width: 16),
                    _eventCard(
                      '25',
                      'ABR',
                      'Junta de Maestros',
                      'Reunión de coordinación académica con dirección.',
                      const Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 16),
                    _eventCard(
                      '01',
                      'MAY',
                      'Día del Trabajo',
                      'Suspensión de labores académicas.',
                      const Color(0xFF333333),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _eventCard(
    String day,
    String month,
    String title,
    String desc,
    Color accentColor,
  ) {
    return Expanded(
      child: _eventCardMobile(day, month, title, desc, accentColor),
    );
  }

  Widget _eventCardMobile(
    String day,
    String month,
    String title,
    String desc,
    Color accentColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: accentColor, width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                day,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
              Text(
                month,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF999999),
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
