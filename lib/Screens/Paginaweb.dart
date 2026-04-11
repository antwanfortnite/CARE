import 'package:flutter/material.dart';
import 'InicioSesion.dart';

// ══════════════════════════════════════════════════════
//  Paleta de colores CARE
// ══════════════════════════════════════════════════════
const _kGreen = Color(0xFF2E7D32);
const _kGreenLight = Color(0xFF4CAF50);
const _kGreenPale = Color(0xFFE8F5E9);
const _kGreenCard = Color(0xFFD7EED9);
const _kBg = Color(0xFFF0F4F0);
const _kText = Color(0xFF1B1B1B);
const _kTextMuted = Color(0xFF5C5C5C);
const _kTeal = Color(0xFF009688);
const _kPink = Color(0xFFE91E8C);
const _kWhite = Colors.white;

// ══════════════════════════════════════════════════════
//  Secciones de la página
// ══════════════════════════════════════════════════════
enum _Section { inicio, conocenos, encuentranos, planes }

// ══════════════════════════════════════════════════════
//  PaginaWeb — root widget
// ══════════════════════════════════════════════════════
class PaginaWeb extends StatefulWidget {
  const PaginaWeb({super.key});

  @override
  State<PaginaWeb> createState() => _PaginaWebState();
}

class _PaginaWebState extends State<PaginaWeb> {
  _Section _current = _Section.inicio;

  void _navigate(_Section s) => setState(() => _current = s);

  // Abre el modal de Inicio de Sesión
  void _showLogin() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => const _LoginDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Column(
        children: [
          _NavBar(
            current: _current,
            onNavigate: _navigate,
            onLogin: _showLogin,
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_current) {
      case _Section.inicio:
        return _InicioSection(
          onIniciar: _showLogin,
          onMasInfo: () => _navigate(_Section.planes),
          onEmpiezaYa: _showLogin,
        );
      case _Section.conocenos:
        return _PlaceholderSection(titulo: 'Conócenos', icon: Icons.people_alt_outlined);
      case _Section.encuentranos:
        return _PlaceholderSection(titulo: 'Encuéntranos', icon: Icons.location_on_outlined);
      case _Section.planes:
        return _PlaceholderSection(titulo: 'Planes', icon: Icons.workspace_premium_outlined);
    }
  }
}

// ══════════════════════════════════════════════════════
//  NavBar
// ══════════════════════════════════════════════════════
class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.current,
    required this.onNavigate,
    required this.onLogin,
  });

  final _Section current;
  final void Function(_Section) onNavigate;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: _kWhite,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          // Logo
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/logoCARE.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'CARE',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _kText,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Tabs
          _NavTab('Inicio', _Section.inicio, current, onNavigate),
          _NavTab('Conócenos', _Section.conocenos, current, onNavigate),
          _NavTab('Encuéntranos', _Section.encuentranos, current, onNavigate),
          _NavTab('Planes', _Section.planes, current, onNavigate),

          const Spacer(),

          // Botón Iniciar sesión
          ElevatedButton(
            onPressed: onLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: _kGreen,
              foregroundColor: _kWhite,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Iniciar sesión',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab(this.label, this.section, this.current, this.onTap);

  final String label;
  final _Section section;
  final _Section current;
  final void Function(_Section) onTap;

  @override
  Widget build(BuildContext context) {
    final bool active = current == section;
    return GestureDetector(
      onTap: () => onTap(section),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: active
            ? const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: _kGreen, width: 2.5),
                ),
              )
            : null,
        child: Text(
          label,
          style: TextStyle(
            color: active ? _kGreen : _kTextMuted,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  SECCIÓN INICIO
// ══════════════════════════════════════════════════════
class _InicioSection extends StatelessWidget {
  const _InicioSection({
    required this.onIniciar,
    required this.onMasInfo,
    required this.onEmpiezaYa,
  });

  final VoidCallback onIniciar;
  final VoidCallback onMasInfo;
  final VoidCallback onEmpiezaYa;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _HeroPanel(onIniciar: onIniciar, onMasInfo: onMasInfo),
          _StatsBar(),
          _FeaturesPanel(onEmpiezaYa: onEmpiezaYa),
        ],
      ),
    );
  }
}

// ══ Hero ══
class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.onIniciar, required this.onMasInfo});

  final VoidCallback onIniciar;
  final VoidCallback onMasInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _kBg,
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 56),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final bool wide = constraints.maxWidth > 700;
          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: _HeroText(onIniciar: onIniciar, onMasInfo: onMasInfo)),
                    const SizedBox(width: 48),
                    Expanded(flex: 5, child: _HeroImages()),
                  ],
                )
              : Column(
                  children: [
                    _HeroText(onIniciar: onIniciar, onMasInfo: onMasInfo),
                    const SizedBox(height: 32),
                    _HeroImages(),
                  ],
                );
        },
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText({required this.onIniciar, required this.onMasInfo});

  final VoidCallback onIniciar;
  final VoidCallback onMasInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _kGreenPale,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kGreenLight.withOpacity(0.4)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school, color: _kGreen, size: 15),
              SizedBox(width: 6),
              Text(
                'INNOVACIÓN EDUCATIVA',
                style: TextStyle(
                  fontSize: 11,
                  color: _kGreen,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Título
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: _kText,
              height: 1.15,
            ),
            children: [
              TextSpan(text: 'La plataforma\n'),
              TextSpan(
                text: 'definitiva',
                style: TextStyle(
                  color: _kGreen,
                  fontStyle: FontStyle.italic,
                ),
              ),
              TextSpan(text: ' para la\ngestión de\nrefuerzo escolar'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Descripción
        const Text(
          'Potencia el aprendizaje y simplifica la administración.\n'
          'CARE ofrece herramientas inteligentes para que docentes\n'
          'y alumnos alcancen su máximo potencial académico.',
          style: TextStyle(
            fontSize: 14,
            color: _kTextMuted,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),

        // Botones
        Row(
          children: [
            ElevatedButton(
              onPressed: onIniciar,
              style: ElevatedButton.styleFrom(
                backgroundColor: _kGreen,
                foregroundColor: _kWhite,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 2,
              ),
              child: const Text('Iniciar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
            const SizedBox(width: 16),
            OutlinedButton(
              onPressed: onMasInfo,
              style: OutlinedButton.styleFrom(
                foregroundColor: _kText,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                side: const BorderSide(color: Color(0xFFBDBDBD), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text('Más información', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroImages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Imagen principal (teacher)
          Positioned(
            top: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/hero_teacher.png',
                width: 300,
                height: 260,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Imagen secundaria (student)
          Positioned(
            bottom: 0,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/hero_student.png',
                  width: 190,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Efecto decorativo rosa/salmón
          Positioned(
            top: 30,
            left: 80,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pinkAccent.withOpacity(0.12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══ Stats Bar ══
class _StatsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _kWhite,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 48),
      child: LayoutBuilder(builder: (_, c) {
        final bool wide = c.maxWidth > 500;
        return wide
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _StatItem('1,284', 'ESTUDIANTES', _kGreen),
                  _StatDivider(),
                  _StatItem('86', 'MAESTROS', _kTeal),
                  _StatDivider(),
                  _StatItem('15+', 'CENTROS', _kPink),
                  _StatDivider(),
                  _StatItem('98%', 'ÉXITO', _kGreenLight),
                ],
              )
            : Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 24,
                runSpacing: 24,
                children: const [
                  _StatItem('1,284', 'ESTUDIANTES', _kGreen),
                  _StatItem('86', 'MAESTROS', _kTeal),
                  _StatItem('15+', 'CENTROS', _kPink),
                  _StatItem('98%', 'ÉXITO', _kGreenLight),
                ],
              );
      }),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem(this.value, this.label, this.color);

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _kTextMuted,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      color: const Color(0xFFE0E0E0),
    );
  }
}

// ══ Features Panel ══
class _FeaturesPanel extends StatelessWidget {
  const _FeaturesPanel({required this.onEmpiezaYa});

  final VoidCallback onEmpiezaYa;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _kBg,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Potencia tu Institución',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: _kText,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Diseñado para la excelencia académica con un enfoque en la simplicidad\ny el análisis de datos.',
            style: TextStyle(fontSize: 14, color: _kTextMuted, height: 1.6),
          ),
          const SizedBox(height: 36),

          // Grid de tarjetas
          LayoutBuilder(builder: (_, c) {
            final bool wide = c.maxWidth > 700;
            if (wide) {
              return Column(
                children: [
                  // Fila superior
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _FeatureCard(
                          icon: Icons.bar_chart,
                          iconColor: _kGreen,
                          iconBg: _kGreenPale,
                          title: 'Digital Grades',
                          description:
                              'Sistema avanzado de gestión de calificaciones con reportes automáticos y analítica predictiva del rendimiento escolar.',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _GradesMockCard(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _FeatureCard(
                          icon: Icons.people,
                          iconColor: _kTeal,
                          iconBg: const Color(0xFFE0F2F1),
                          title: 'Teacher Management',
                          description:
                              'Centraliza la planificación, asistencia y comunicación de tu equipo docente en un solo lugar.',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Fila inferior
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _FeatureCard(
                          icon: Icons.person_add_alt_1,
                          iconColor: Colors.pink,
                          iconBg: const Color(0xFFFCE4EC),
                          title: 'Clases a tu medida',
                          description:
                              'Seguimiento personalizado de cada alumno, identificando áreas de mejora y celebrando sus logros.',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: _CTACard(onEmpiezaYa: onEmpiezaYa),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  _FeatureCard(
                    icon: Icons.bar_chart,
                    iconColor: _kGreen,
                    iconBg: _kGreenPale,
                    title: 'Digital Grades',
                    description: 'Sistema avanzado de gestión de calificaciones con reportes automáticos.',
                  ),
                  const SizedBox(height: 16),
                  _FeatureCard(
                    icon: Icons.people,
                    iconColor: _kTeal,
                    iconBg: const Color(0xFFE0F2F1),
                    title: 'Teacher Management',
                    description: 'Centraliza la planificación, asistencia y comunicación del equipo docente.',
                  ),
                  const SizedBox(height: 16),
                  _FeatureCard(
                    icon: Icons.person_add_alt_1,
                    iconColor: Colors.pink,
                    iconBg: const Color(0xFFFCE4EC),
                    title: 'Clases a tu medida',
                    description: 'Seguimiento personalizado de cada alumno.',
                  ),
                  const SizedBox(height: 16),
                  _CTACard(onEmpiezaYa: onEmpiezaYa),
                ],
              );
            }
          }),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _kText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: _kTextMuted,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

// Tarjeta mock de calificaciones (la del centro en las imágenes)
class _GradesMockCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Barra simulada de encabezado
          Container(
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
          // Grid de bloques
          Row(
            children: [
              _MockBlock(_kGreenCard, 40),
              const SizedBox(width: 8),
              _MockBlock(_kGreenLight.withOpacity(0.5), 50),
              const SizedBox(width: 8),
              _MockBlock(const Color(0xFF80CBC4), 45),
            ],
          ),
        ],
      ),
    );
  }
}

class _MockBlock extends StatelessWidget {
  const _MockBlock(this.color, this.height);

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// Tarjeta CTA verde
class _CTACard extends StatelessWidget {
  const _CTACard({required this.onEmpiezaYa});

  final VoidCallback onEmpiezaYa;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Estrellas decorativas
          Positioned(
            right: 16,
            top: 8,
            child: Icon(Icons.auto_awesome, color: _kWhite.withValues(alpha: 0.18), size: 64),
          ),
          Positioned(
            right: 70,
            bottom: 16,
            child: Icon(Icons.auto_awesome, color: _kWhite.withValues(alpha: 0.12), size: 40),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '¿Listo para mejorar?',
                style: TextStyle(
                  color: _kWhite,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Únete a cientos de instituciones que ya están\ntransformando la educación con CARE.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: onEmpiezaYa,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _kText,
                  backgroundColor: _kWhite,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Empieza ya',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  Placeholder para secciones futuras
// ══════════════════════════════════════════════════════
class _PlaceholderSection extends StatelessWidget {
  const _PlaceholderSection({required this.titulo, required this.icon});

  final String titulo;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _kGreenPale,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 56, color: _kGreen),
          ),
          const SizedBox(height: 24),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: _kText,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Esta sección estará disponible próximamente.',
            style: TextStyle(fontSize: 15, color: _kTextMuted),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
//  DIALOG — Inicio de Sesión (ventana emergente)
// ══════════════════════════════════════════════════════
class _LoginDialog extends StatefulWidget {
  const _LoginDialog();

  @override
  State<_LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<_LoginDialog> {
  int _selectedRole = 0;
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  final List<String> _roles = ['Alumno', 'Profesor', 'Administrativo'];
  String get _fieldLabel => _selectedRole == 0 ? 'CURP' : 'Usuario';

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _onLogin() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const InicioSesion()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Container(
          decoration: BoxDecoration(
            color: _kWhite,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header verde
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/logoCARE.png',
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Bienvenido a CARE',
                      style: TextStyle(
                        color: _kWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Accede a tu plataforma educativa',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),

              // Formulario
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Selector de rol
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: List.generate(_roles.length, (i) {
                          final bool sel = _selectedRole == i;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _selectedRole = i;
                                _userCtrl.clear();
                              }),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: sel ? _kGreen : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _roles[i],
                                  style: TextStyle(
                                    color: sel ? _kWhite : _kTextMuted,
                                    fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildField(
                      controller: _userCtrl,
                      label: _fieldLabel,
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 14),

                    _buildField(
                      controller: _passCtrl,
                      label: 'Contraseña',
                      icon: Icons.lock_outline,
                      obscure: _obscure,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 20,
                          color: _kTextMuted,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _onLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kGreen,
                          foregroundColor: _kWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Iniciar sesión',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: _kTextMuted, fontSize: 13),
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
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontSize: 14, color: _kText),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _kTextMuted, fontSize: 14),
        prefixIcon: Icon(icon, color: _kTextMuted, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kGreen, width: 1.5),
        ),
      ),
    );
  }
}
