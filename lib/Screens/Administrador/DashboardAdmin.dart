import 'package:flutter/material.dart';
import '../InicioSesion.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  int _selectedNavIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(Icons.dashboard, 'Dashboard'),
    _NavItem(Icons.person_outline, 'Maestros'),
    _NavItem(Icons.school_outlined, 'Alumnos'),
    _NavItem(Icons.group_outlined, 'Grupos'),
    _NavItem(Icons.menu_book_outlined, 'Materias'),
    _NavItem(Icons.admin_panel_settings_outlined, 'Administradores'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F3),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeBanner(),
                        const SizedBox(height: 24),
                        _buildStatCards(),
                        const SizedBox(height: 24),
                        _buildMiddleSection(),
                        const SizedBox(height: 24),
                        _buildCalendarSection(),
                      ],
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

  // ──────── SIDEBAR ────────
  Widget _buildSidebar() {
    return Container(
      width: 200,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE8E8E8))),
      ),
      child: Column(
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Color(0xFF4CAF50),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CARE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      'Santuario Académico',
                      style: TextStyle(fontSize: 10, color: Color(0xFF999999)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Nav items
          ...List.generate(_navItems.length, (i) {
            final item = _navItems[i];
            final isSelected = _selectedNavIndex == i;
            return InkWell(
              onTap: () => setState(() => _selectedNavIndex = i),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4CAF50).withOpacity(0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 20,
                      color: isSelected
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF888888),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFF555555),
                      ),
                    ),
                    if (isSelected) ...[
                      const Spacer(),
                      const Text(')',
                          style: TextStyle(
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.bold)),
                    ],
                  ],
                ),
              ),
            );
          }),

          const Spacer(),

          // Ajustes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined,
                        size: 20, color: Color(0xFF888888)),
                    SizedBox(width: 12),
                    Text('Ajustes',
                        style:
                            TextStyle(fontSize: 13, color: Color(0xFF555555))),
                  ],
                ),
              ),
            ),
          ),

          // Cerrar sesión
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InicioSesion()),
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: Color(0xFFE53935)),
                    SizedBox(width: 12),
                    Text('Cerrar Sesión',
                        style:
                            TextStyle(fontSize: 13, color: Color(0xFFE53935))),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────── TOP BAR ────────
  Widget _buildTopBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE8E8E8))),
      ),
      child: Row(
        children: [
          // Barra de búsqueda
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, size: 20, color: Color(0xFF999999)),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar alumnos, maestros o reportes...',
                        hintStyle:
                            TextStyle(fontSize: 13, color: Color(0xFF999999)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Iconos de notificación
          _iconBtn(Icons.chat_bubble_outline),
          _iconBtn(Icons.notifications_outlined),
          const SizedBox(width: 12),
          // Perfil admin
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Text(
                  'Admin Principal',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 4),
                Text('SUPERUSUARIO',
                    style: TextStyle(fontSize: 9, color: Color(0xFF999999))),
                SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF4CAF50),
                  child: Icon(Icons.person, size: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, size: 22, color: const Color(0xFF555555)),
        splashRadius: 20,
      ),
    );
  }

  // ──────── BANNER DE BIENVENIDA ────────
  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF388E3C), Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¡Buen día, Administrador!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Bienvenido al sistema CARE. Aquí tienes un resumen de la actividad escolar y el\nrendimiento institucional de hoy.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ──────── TARJETAS DE ESTADÍSTICAS ────────
  Widget _buildStatCards() {
    final stats = [
      _StatData(Icons.people_outline, 'Total Alumnos', '1,284',
          '+12%', const Color(0xFF4CAF50)),
      _StatData(Icons.person_outline, 'Total Maestros', '86',
          'Estable', const Color(0xFF26A69A)),
      _StatData(Icons.grid_view, 'Grupos Activos', '42',
          'Activos', const Color(0xFF4CAF50)),
      _StatData(Icons.calendar_today_outlined, 'Próximas Clases', '12',
          'Próximas', const Color(0xFF66BB6A)),
    ];

    return Row(
      children: stats.map((s) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(20),
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
                      child: Icon(s.icon, color: s.color, size: 22),
                    ),
                    const Spacer(),
                    Text(
                      s.badge,
                      style: TextStyle(
                          fontSize: 11,
                          color: s.color,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  s.label,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF888888)),
                ),
                const SizedBox(height: 4),
                Text(
                  s.value,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333)),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ──────── SECCIÓN MEDIA (Actividad + Estado del Sistema) ────────
  Widget _buildMiddleSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Actividad Reciente
        Expanded(
          flex: 3,
          child: Container(
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
                    const Text(
                      'Actividad Reciente',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Ver todo',
                          style: TextStyle(
                              color: Color(0xFF4CAF50), fontSize: 13)),
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
          ),
        ),
        const SizedBox(width: 20),

        // Estado del Sistema
        Expanded(
          flex: 2,
          child: Container(
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
                      color: Color(0xFF333333)),
                ),
                const SizedBox(height: 20),
                _systemBar('Capacidad Alumnos', 0.82, '82%',
                    const Color(0xFF4CAF50)),
                const SizedBox(height: 16),
                _systemBar('Uso de Servidores', 0.45, '45%',
                    const Color(0xFF4CAF50)),
                const SizedBox(height: 16),
                _systemBar('Documentación Digital', 0.96, '96%',
                    const Color(0xFF4CAF50)),
                const SizedBox(height: 24),
                // Imagen placeholder del servidor
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
                        Icon(Icons.dns_outlined,
                            size: 40, color: Color(0xFF4CAF50)),
                        SizedBox(height: 8),
                        Text(
                          'Servidor Norte 4WS-2 (CDMX)',
                          style:
                              TextStyle(fontSize: 11, color: Color(0xFF666666)),
                        ),
                        Text(
                          'Último respaldo 04:00 AM',
                          style:
                              TextStyle(fontSize: 10, color: Color(0xFF999999)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _activityTile(IconData icon, Color color, String title,
      String subtitle, String time) {
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
                Text(title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF999999))),
              ],
            ),
          ),
          Text(time,
              style:
                  const TextStyle(fontSize: 11, color: Color(0xFF999999))),
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
            Text(label,
                style:
                    const TextStyle(fontSize: 12, color: Color(0xFF666666))),
            Text(percent,
                style: TextStyle(
                    fontSize: 12, color: color, fontWeight: FontWeight.w600)),
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
  Widget _buildCalendarSection() {
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calendario Institucional',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Eventos y fechas críticas próximas',
                    style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Nuevo Evento',
                    style: TextStyle(fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
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

  Widget _eventCard(String day, String month, String title, String desc,
      Color accentColor) {
    return Expanded(
      child: Container(
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
                Text(day,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: accentColor)),
                Text(month,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accentColor)),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(desc,
                      style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF999999),
                          height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

class _StatData {
  final IconData icon;
  final String label;
  final String value;
  final String badge;
  final Color color;
  const _StatData(this.icon, this.label, this.value, this.badge, this.color);
}
