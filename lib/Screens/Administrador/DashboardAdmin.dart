import 'package:flutter/material.dart';
import 'AdminScaffold.dart';
import 'MaestrosAdmin.dart';

class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({super.key});

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 700;

  @override
  Widget build(BuildContext context) {
    final mobile = _isMobile(context);

    return AdminScaffold(
      selectedIndex: 0,
      destinations: {1: (_) => const MaestrosAdmin()},
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeBanner(mobile),
          const SizedBox(height: 24),
          _buildStatCards(mobile),
          const SizedBox(height: 24),
          _buildMiddleSection(mobile),
          const SizedBox(height: 24),
          _buildCalendarSection(mobile),
        ],
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
            '¡Buen día, Administrador!',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 18 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isMobile
                ? 'Bienvenido al sistema CARE. Resumen de actividad escolar.'
                : 'Bienvenido al sistema CARE. Aquí tienes un resumen de la actividad escolar y el\nrendimiento institucional de hoy.',
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
        Icons.people_outline,
        'Total Alumnos',
        '1,284',
        '+12%',
        const Color(0xFF4CAF50),
      ),
      _StatData(
        Icons.person_outline,
        'Total Maestros',
        '86',
        'Estable',
        const Color(0xFF26A69A),
      ),
      _StatData(
        Icons.grid_view,
        'Grupos Activos',
        '42',
        'Activos',
        const Color(0xFF4CAF50),
      ),
      _StatData(
        Icons.calendar_today_outlined,
        'Próximas Clases',
        '12',
        'Próximas',
        const Color(0xFF66BB6A),
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
          Row(
            children: [
              Expanded(child: _buildStatCard(stats[2])),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(stats[3])),
            ],
          ),
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
          _buildSystemStatusSection(),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _buildActivitySection()),
        const SizedBox(width: 20),
        Expanded(flex: 2, child: _buildSystemStatusSection()),
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
            'Últimos movimientos registrados en la plataforma',
            style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
          ),
          const SizedBox(height: 16),
          _activityTile(
            Icons.person_add_outlined,
            const Color(0xFF7E57C2),
            'Nuevo alumno inscrito',
            'Carlos Méndez se unió al grupo 3A de Ciencias',
            'Hace 15 min',
          ),
          _activityTile(
            Icons.description_outlined,
            const Color(0xFF42A5F5),
            'Reporte de calificaciones',
            'La Profesora Elena subió notas parciales - Matemáticas I',
            'Hace 2 horas',
          ),
          _activityTile(
            Icons.swap_horiz,
            const Color(0xFFFFA726),
            'Cambio de horario',
            'Aula 402 reasignada para el taller de Arte Digital',
            'Hace 5 horas',
          ),
          _activityTile(
            Icons.lock_outline,
            const Color(0xFFEF5350),
            'Seguridad',
            'Restablecimiento de contraseña solicitado por Admin #3',
            'Ayer, 18:30',
          ),
        ],
      ),
    );
  }

  Widget _buildSystemStatusSection() {
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
            'Estado del Sistema',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          _systemBar('Capacidad Alumnos', 0.82, '82%', const Color(0xFF4CAF50)),
          const SizedBox(height: 16),
          _systemBar('Uso de Servidores', 0.45, '45%', const Color(0xFF4CAF50)),
          const SizedBox(height: 16),
          _systemBar(
            'Documentación Digital',
            0.96,
            '96%',
            const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.dns_outlined, size: 40, color: Color(0xFF4CAF50)),
                  SizedBox(height: 8),
                  Text(
                    'Servidor Norte 4WS-2 (CDMX)',
                    style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
                  ),
                  Text(
                    'Último respaldo 04:00 AM',
                    style: TextStyle(fontSize: 10, color: Color(0xFF999999)),
                  ),
                ],
              ),
            ),
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

  Widget _systemBar(String label, double value, String percent, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              percent,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: const Color(0xFFE8E8E8),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }

  // ──────── CALENDARIO INSTITUCIONAL ────────
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
                      'Calendario Institucional',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Eventos y fechas críticas próximas',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text(
                          'Nuevo Evento',
                          style: TextStyle(fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                        ),
                      ),
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
                          'Calendario Institucional',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Eventos y fechas críticas próximas',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text(
                        'Nuevo Evento',
                        style: TextStyle(fontSize: 13),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 20),
          isMobile
              ? Column(
                  children: [
                    _eventCardMobile(
                      '15',
                      'OCT',
                      'Cierre de Actas',
                      'Límite para captura de calificaciones del primer parcial.',
                      const Color(0xFF4CAF50),
                    ),
                    const SizedBox(height: 12),
                    _eventCardMobile(
                      '22',
                      'OCT',
                      'Junta Académica',
                      'Reunión general de directivos y coordinadores de área.',
                      const Color(0xFFEF5350),
                    ),
                    const SizedBox(height: 12),
                    _eventCardMobile(
                      '01',
                      'NOV',
                      'Feriado Nacional',
                      'Suspensión de labores académicas y administrativas.',
                      const Color(0xFF333333),
                    ),
                  ],
                )
              : Row(
                  children: [
                    _eventCard(
                      '15',
                      'OCT',
                      'Cierre de Actas',
                      'Límite para captura de calificaciones del primer parcial.',
                      const Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 16),
                    _eventCard(
                      '22',
                      'OCT',
                      'Junta Académica',
                      'Reunión general de directivos y coordinadores de área.',
                      const Color(0xFFEF5350),
                    ),
                    const SizedBox(width: 16),
                    _eventCard(
                      '01',
                      'NOV',
                      'Feriado Nacional',
                      'Suspensión de labores académicas y administrativas.',
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
