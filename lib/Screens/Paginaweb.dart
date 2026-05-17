import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';

import '../BD/Alumnos.dart';
import '../BD/Maestros.dart';
import '../BD/Administradores.dart';
import 'Administrador/DashboardAdmin.dart';
import 'Profesor/DashboardProfesor.dart';
import 'Alumno/DashboardAlumno.dart';

const _kGreen = Color(0xFF2E7D32);
const _kGreenLight = Color(0xFF4CAF50);
const _kGreenPale = Color(0xFFE8F5E9);
const _kBg = Color(0xFFF0F4F0);
const _kText = Color(0xFF1B1B1B);
const _kTextMuted = Color(0xFF5C5C5C);
const _kWhite = Colors.white;

enum _Section { inicio, conocenos, planes, padre }

class PaginaWeb extends StatefulWidget {
  const PaginaWeb({super.key});

  @override
  State<PaginaWeb> createState() => _PaginaWebState();
}

class _PaginaWebState extends State<PaginaWeb> {
  _Section _current = _Section.inicio;

  int? _loggedInRole; // 0 = Padre, 1 = Maestro, 2 = Administrador
  Map<String, dynamic>? _loggedInUser;

  final ImagePicker _picker = ImagePicker();

  int _currentCarouselIndex = 0;

  String _direccionLinea1 = 'Blvd. Academia del Saber # 452, Col. Valle Verde,';
  String _direccionLinea2 = 'C.P. 83000, Hermosillo, Sonora.';
  String _correoCentro = 'atencion@care-refuerzo.edu.mx';
  String _telefonoCentro = '(662) 214-5566';
  String _cctCentro = '26PJN0415W';

  final List<_CarouselItem> _carouselItems = [
    _CarouselItem(
      imagen:
          'https://images.unsplash.com/photo-1507842217343-583bb7270b66?q=80&w=1400',
      texto:
          '"El aprendizaje es un tesoro que\nsigue a su propietario durante toda la\nvida"',
    ),
    _CarouselItem(
      imagen:
          'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?q=80&w=1400',
      texto: '"Leer abre puertas que ninguna llave\npuede cerrar"',
    ),
    _CarouselItem(
      imagen:
          'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?q=80&w=1400',
      texto: '"Cada día es una nueva oportunidad\npara aprender algo valioso"',
    ),
    _CarouselItem(
      imagen:
          'https://images.unsplash.com/photo-1519682337058-a94d519337bc?q=80&w=1400',
      texto: '"La educación transforma el presente\ny construye el futuro"',
    ),
  ];

  void _navigate(_Section s) {
    setState(() {
      _current = s;
    });
  }

  Future<void> _showLogin() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => const _LoginDialog(),
    );

    if (result != null) {
      setState(() {
        _loggedInRole = result['role'];
        _loggedInUser = result['user'];

        if (_loggedInRole == 0) {
          _current = _Section.padre;
        }
      });
    }
  }

  void _logout() {
    setState(() {
      _loggedInRole = null;
      _loggedInUser = null;

      if (_current == _Section.padre) {
        _current = _Section.inicio;
      }
    });
  }

  void _goToDashboard() {
    if (_loggedInRole == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DashboardAdmin(user: _loggedInUser)),
      );
    } else if (_loggedInRole == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardProfesor(user: _loggedInUser),
        ),
      );
    }
  }

  Future<void> _seleccionarImagenCarrusel() async {
    final XFile? imagenSeleccionada = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (imagenSeleccionada != null) {
      final Uint8List imageBytes = await imagenSeleccionada.readAsBytes();

      setState(() {
        _carouselItems.add(
          _CarouselItem(
            imagen: imageBytes,
            texto: '"Nuevo mensaje del carrusel"',
          ),
        );

        _currentCarouselIndex = _carouselItems.length - 1;
      });
    }
  }

  void _eliminarImagenCarrusel(int index) {
    if (_carouselItems.length <= 1) return;

    setState(() {
      _carouselItems.removeAt(index);

      if (_currentCarouselIndex >= _carouselItems.length) {
        _currentCarouselIndex = _carouselItems.length - 1;
      }

      if (_currentCarouselIndex < 0) {
        _currentCarouselIndex = 0;
      }
    });
  }

  void _editarTextoCarrusel(int index, String newText) {
    setState(() {
      _carouselItems[index].texto = newText.trim().isEmpty
          ? '"Nuevo mensaje del carrusel"'
          : newText;
    });
  }

  void _editarDatosGenerales({
    required String direccionLinea1,
    required String direccionLinea2,
    required String correo,
    required String telefono,
    required String cct,
  }) {
    setState(() {
      _direccionLinea1 = direccionLinea1.trim().isEmpty
          ? 'Sin dirección'
          : direccionLinea1.trim();

      _direccionLinea2 = direccionLinea2.trim();

      _correoCentro = correo.trim().isEmpty
          ? 'Sin correo electrónico'
          : correo.trim();

      _telefonoCentro = telefono.trim().isEmpty
          ? 'Sin teléfono'
          : telefono.trim();

      _cctCentro = cct.trim().isEmpty ? 'Sin CCT' : cct.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      drawer: _MobileDrawer(
        current: _current,
        loggedInRole: _loggedInRole,
        onNavigate: _navigate,
        onLogin: _showLogin,
        onLogout: _logout,
        onGoToDashboard: _goToDashboard,
      ),
      body: Column(
        children: [
          _NavBar(
            current: _current,
            onNavigate: _navigate,
            onLogin: _showLogin,
            loggedInRole: _loggedInRole,
            onLogout: _logout,
            onGoToDashboard: _goToDashboard,
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_current) {
      case _Section.inicio:
        return _InicioRedisenadoSection(
          isAdmin: _loggedInRole == 2,
          direccionLinea1: _direccionLinea1,
          direccionLinea2: _direccionLinea2,
          correo: _correoCentro,
          telefono: _telefonoCentro,
          cct: _cctCentro,
          carouselItems: _carouselItems,
          currentIndex: _currentCarouselIndex,
          onCarouselPageChanged: (index) {
            setState(() {
              _currentCarouselIndex = index;
            });
          },
          onAddCarouselImage: _seleccionarImagenCarrusel,
          onDeleteCarouselImage: _eliminarImagenCarrusel,
          onEditCarouselText: _editarTextoCarrusel,
          onEditDatosGenerales: _editarDatosGenerales,
        );

      case _Section.conocenos:
        return _PlaceholderSection(
          titulo: 'Conócenos',
          icon: Icons.people_alt_outlined,
        );

      case _Section.planes:
        return _PlaceholderSection(
          titulo: 'Planes',
          icon: Icons.workspace_premium_outlined,
        );

      case _Section.padre:
        return DashboardAlumno(user: _loggedInUser);
    }
  }
}

class _CarouselItem {
  dynamic imagen;
  String texto;

  _CarouselItem({required this.imagen, required this.texto});
}

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.current,
    required this.onNavigate,
    required this.onLogin,
    this.loggedInRole,
    this.onLogout,
    this.onGoToDashboard,
  });

  final _Section current;
  final void Function(_Section) onNavigate;
  final VoidCallback onLogin;
  final int? loggedInRole;
  final VoidCallback? onLogout;
  final VoidCallback? onGoToDashboard;

  String _titleBySection() {
    switch (current) {
      case _Section.inicio:
        return 'Inicio';
      case _Section.conocenos:
        return 'Conócenos';
      case _Section.planes:
        return 'Planes';
      case _Section.padre:
        return 'Portal padre';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 820;

    if (!isDesktop) {
      return Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Builder(
              builder: (drawerContext) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(drawerContext).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Color(0xFF4A4E5A),
                    size: 28,
                  ),
                );
              },
            ),
            const SizedBox(width: 4),
            Text(
              _titleBySection(),
              style: const TextStyle(
                color: Color(0xFF1B1B1B),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            if (loggedInRole == null)
              ElevatedButton(
                onPressed: onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kGreenLight,
                  foregroundColor: _kWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              )
            else ...[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E6E2)),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF4A4E5A),
                    size: 21,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: _kGreenLight,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: loggedInRole == 0 ? onLogout : onGoToDashboard,
                  icon: Icon(
                    loggedInRole == 0
                        ? Icons.logout_rounded
                        : Icons.admin_panel_settings_rounded,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Container(
      height: 78,
      color: _kWhite,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/logoCARE.png',
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARE',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: _kGreenLight,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'SANCTUARI ACADÉMICO',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8D96A3),
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          _NavTab('Inicio', _Section.inicio, current, onNavigate),
          _NavTab('Conócenos', _Section.conocenos, current, onNavigate),
          _NavTab('Planes', _Section.planes, current, onNavigate),
          if (loggedInRole == 0)
            _NavTab('Padre', _Section.padre, current, onNavigate),
          const Spacer(),
          if (loggedInRole == null)
            ElevatedButton(
              onPressed: onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: _kGreenLight,
                foregroundColor: _kWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                elevation: 5,
                shadowColor: _kGreenLight.withOpacity(0.35),
              ),
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            )
          else if (loggedInRole == 0)
            ElevatedButton(
              onPressed: onLogout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: _kWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Cerrar sesión',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            )
          else
            IconButton(
              onPressed: onGoToDashboard,
              icon: const Icon(Icons.person, color: _kGreen, size: 28),
            ),
        ],
      ),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer({
    required this.current,
    required this.loggedInRole,
    required this.onNavigate,
    required this.onLogin,
    this.onLogout,
    this.onGoToDashboard,
  });

  final _Section current;
  final int? loggedInRole;
  final void Function(_Section) onNavigate;
  final VoidCallback onLogin;
  final VoidCallback? onLogout;
  final VoidCallback? onGoToDashboard;

  void _goTo(BuildContext context, _Section section) {
    Navigator.pop(context);
    onNavigate(section);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF9FBF9),
      elevation: 0,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/logoCARE.png',
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CARE',
                      style: TextStyle(
                        color: _kText,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Portal Educativo',
                      style: TextStyle(
                        color: Color(0xFF8D96A3),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            _DrawerOption(
              icon: Icons.dashboard_outlined,
              text: 'Inicio',
              active: current == _Section.inicio,
              onTap: () => _goTo(context, _Section.inicio),
            ),
            _DrawerOption(
              icon: Icons.people_alt_outlined,
              text: 'Conócenos',
              active: current == _Section.conocenos,
              onTap: () => _goTo(context, _Section.conocenos),
            ),
            _DrawerOption(
              icon: Icons.workspace_premium_outlined,
              text: 'Planes',
              active: current == _Section.planes,
              onTap: () => _goTo(context, _Section.planes),
            ),
            if (loggedInRole == 0)
              _DrawerOption(
                icon: Icons.school_outlined,
                text: 'Portal padre',
                active: current == _Section.padre,
                onTap: () => _goTo(context, _Section.padre),
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Column(
                children: [
                  if (loggedInRole == null)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          onLogin();
                        },
                        icon: const Icon(Icons.login_rounded),
                        label: const Text('Iniciar sesión'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kGreenLight,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    )
                  else if (loggedInRole == 0)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          onLogout?.call();
                        },
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text('Cerrar sesión'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          onGoToDashboard?.call();
                        },
                        icon: const Icon(Icons.admin_panel_settings_rounded),
                        label: const Text('Ir al dashboard'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kGreenLight,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
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
}

class _DrawerOption extends StatelessWidget {
  const _DrawerOption({
    required this.icon,
    required this.text,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: active ? _kGreenLight : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: active ? Colors.white : const Color(0xFF4A4E5A),
                size: 23,
              ),
              const SizedBox(width: 14),
              Text(
                text,
                style: TextStyle(
                  color: active ? Colors.white : const Color(0xFF4A4E5A),
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
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
        margin: const EdgeInsets.symmetric(horizontal: 13),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: active
            ? const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: _kGreenLight, width: 2.5),
                ),
              )
            : null,
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: active ? _kGreenLight : const Color(0xFF4F5562),
            fontWeight: active ? FontWeight.w800 : FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.45,
          ),
        ),
      ),
    );
  }
}

class _InicioRedisenadoSection extends StatelessWidget {
  final bool isAdmin;

  final String direccionLinea1;
  final String direccionLinea2;
  final String correo;
  final String telefono;
  final String cct;

  final List<_CarouselItem> carouselItems;
  final int currentIndex;

  final ValueChanged<int> onCarouselPageChanged;
  final VoidCallback onAddCarouselImage;
  final void Function(int index) onDeleteCarouselImage;
  final void Function(int index, String newText) onEditCarouselText;

  final void Function({
    required String direccionLinea1,
    required String direccionLinea2,
    required String correo,
    required String telefono,
    required String cct,
  })
  onEditDatosGenerales;

  const _InicioRedisenadoSection({
    required this.isAdmin,
    required this.direccionLinea1,
    required this.direccionLinea2,
    required this.correo,
    required this.telefono,
    required this.cct,
    required this.carouselItems,
    required this.currentIndex,
    required this.onCarouselPageChanged,
    required this.onAddCarouselImage,
    required this.onDeleteCarouselImage,
    required this.onEditCarouselText,
    required this.onEditDatosGenerales,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 950;

    return Stack(
      children: [
        Positioned(
          top: 120,
          left: -90,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              color: _kGreenLight.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          right: -100,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: _kGreen.withOpacity(0.055),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 260,
          right: 160,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: _kGreenLight.withOpacity(0.035),
              shape: BoxShape.circle,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 34),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 26 : 18),
                child: Column(
                  children: [
                    Text(
                      'CARE- Centro de Apoyo y Refuerzo Escolar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isDesktop ? 38 : 28,
                        fontWeight: FontWeight.w900,
                        color: _kGreen,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 96,
                      height: 5,
                      decoration: BoxDecoration(
                        color: _kGreenLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(height: 44),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1280),
                      child: isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 38,
                                  child: _DatosGeneralesCard(
                                    canEdit: isAdmin,
                                    direccionLinea1: direccionLinea1,
                                    direccionLinea2: direccionLinea2,
                                    correo: correo,
                                    telefono: telefono,
                                    cct: cct,
                                    onEdit: onEditDatosGenerales,
                                  ),
                                ),
                                const SizedBox(width: 38),
                                Expanded(
                                  flex: 62,
                                  child: _CarouselSection(
                                    canManage: isAdmin,
                                    imagenes: carouselItems,
                                    currentIndex: currentIndex,
                                    onPageChanged: onCarouselPageChanged,
                                    onAddImage: onAddCarouselImage,
                                    onDeleteImage: onDeleteCarouselImage,
                                    onEditText: onEditCarouselText,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _DatosGeneralesCard(
                                  canEdit: isAdmin,
                                  direccionLinea1: direccionLinea1,
                                  direccionLinea2: direccionLinea2,
                                  correo: correo,
                                  telefono: telefono,
                                  cct: cct,
                                  onEdit: onEditDatosGenerales,
                                ),
                                const SizedBox(height: 28),
                                _CarouselSection(
                                  canManage: isAdmin,
                                  imagenes: carouselItems,
                                  currentIndex: currentIndex,
                                  onPageChanged: onCarouselPageChanged,
                                  onAddImage: onAddCarouselImage,
                                  onDeleteImage: onDeleteCarouselImage,
                                  onEditText: onEditCarouselText,
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 90),
              const _Footer(),
            ],
          ),
        ),
      ],
    );
  }
}

class _DatosGeneralesCard extends StatelessWidget {
  final bool canEdit;

  final String direccionLinea1;
  final String direccionLinea2;
  final String correo;
  final String telefono;
  final String cct;

  final void Function({
    required String direccionLinea1,
    required String direccionLinea2,
    required String correo,
    required String telefono,
    required String cct,
  })
  onEdit;

  const _DatosGeneralesCard({
    required this.canEdit,
    required this.direccionLinea1,
    required this.direccionLinea2,
    required this.correo,
    required this.telefono,
    required this.cct,
    required this.onEdit,
  });

  void _abrirMenuEditarDatos(BuildContext context) {
    final TextEditingController direccion1Controller = TextEditingController(
      text: direccionLinea1,
    );

    final TextEditingController direccion2Controller = TextEditingController(
      text: direccionLinea2,
    );

    final TextEditingController correoController = TextEditingController(
      text: correo,
    );

    final TextEditingController telefonoController = TextEditingController(
      text: telefono,
    );

    final TextEditingController cctController = TextEditingController(
      text: cct,
    );

    final bool isDesktop = MediaQuery.of(context).size.width >= 850;

    if (isDesktop) {
      showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.55),
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 80,
              vertical: 40,
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 820),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x44000000),
                    blurRadius: 40,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: _EditarDatosContent(
                direccion1Controller: direccion1Controller,
                direccion2Controller: direccion2Controller,
                correoController: correoController,
                telefonoController: telefonoController,
                cctController: cctController,
                onCancel: () => Navigator.pop(context),
                onSave: () {
                  onEdit(
                    direccionLinea1: direccion1Controller.text,
                    direccionLinea2: direccion2Controller.text,
                    correo: correoController.text,
                    telefono: telefonoController.text,
                    cct: cctController.text,
                  );

                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 25,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: _EditarDatosContent(
                  direccion1Controller: direccion1Controller,
                  direccion2Controller: direccion2Controller,
                  correoController: correoController,
                  telefonoController: telefonoController,
                  cctController: cctController,
                  onCancel: () => Navigator.pop(context),
                  onSave: () {
                    onEdit(
                      direccionLinea1: direccion1Controller.text,
                      direccionLinea2: direccion2Controller.text,
                      correo: correoController.text,
                      telefono: telefonoController.text,
                      cct: cctController.text,
                    );

                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmall = MediaQuery.of(context).size.width < 700;

    return Container(
      height: isSmall ? null : 565,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EFE8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 34, 32, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Datos Generales',
                        style: TextStyle(
                          color: _kGreen,
                          fontWeight: FontWeight.w800,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    if (canEdit)
                      InkWell(
                        onTap: () => _abrirMenuEditarDatos(context),
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: _kGreenPale,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFD9ECD9)),
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            color: _kGreenLight,
                            size: 21,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFE3F0E2),
                      width: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 34),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  title: 'Dirección:',
                  lines: [
                    direccionLinea1,
                    if (direccionLinea2.trim().isNotEmpty) direccionLinea2,
                  ],
                ),
                const SizedBox(height: 34),
                _InfoRow(
                  icon: Icons.mail_outline,
                  title: 'Correo electrónico:',
                  lines: [correo],
                  highlight: true,
                ),
                const SizedBox(height: 34),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  title: 'Teléfono:',
                  lines: [telefono],
                ),
                const SizedBox(height: 34),
                _InfoRow(
                  icon: Icons.business_outlined,
                  title: 'Clave del Centro de Trabajo (CCT):',
                  lines: [cct],
                ),
              ],
            ),
          ),
          if (!isSmall) const Spacer(),
          Container(
            height: 74,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: _kGreenLight,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.facebook, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Flexible(
                  child: Text(
                    'Sigue a tu centro en Facebook',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
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
}

class _EditarDatosContent extends StatelessWidget {
  final TextEditingController direccion1Controller;
  final TextEditingController direccion2Controller;
  final TextEditingController correoController;
  final TextEditingController telefonoController;
  final TextEditingController cctController;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _EditarDatosContent({
    required this.direccion1Controller,
    required this.direccion2Controller,
    required this.correoController,
    required this.telefonoController,
    required this.cctController,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 850;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isDesktop) ...[
          Container(
            width: 54,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFDDE3DD),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          const SizedBox(height: 22),
        ],
        Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: _kGreenPale,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.edit_location_alt_rounded,
                color: _kGreenLight,
                size: 31,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Editar datos generales',
                    style: TextStyle(
                      color: _kGreen,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Actualiza la información visible en la tarjeta.',
                    style: TextStyle(
                      color: Color(0xFF7A808A),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        if (isDesktop)
          Row(
            children: [
              Expanded(
                child: _CampoEditor(
                  controller: direccion1Controller,
                  label: 'Dirección línea 1',
                  icon: Icons.location_on_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _CampoEditor(
                  controller: direccion2Controller,
                  label: 'Dirección línea 2',
                  icon: Icons.map_outlined,
                ),
              ),
            ],
          )
        else ...[
          _CampoEditor(
            controller: direccion1Controller,
            label: 'Dirección línea 1',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 16),
          _CampoEditor(
            controller: direccion2Controller,
            label: 'Dirección línea 2',
            icon: Icons.map_outlined,
          ),
        ],
        const SizedBox(height: 16),
        if (isDesktop)
          Row(
            children: [
              Expanded(
                child: _CampoEditor(
                  controller: correoController,
                  label: 'Correo electrónico',
                  icon: Icons.mail_outline,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _CampoEditor(
                  controller: telefonoController,
                  label: 'Teléfono',
                  icon: Icons.phone_outlined,
                ),
              ),
            ],
          )
        else ...[
          _CampoEditor(
            controller: correoController,
            label: 'Correo electrónico',
            icon: Icons.mail_outline,
          ),
          const SizedBox(height: 16),
          _CampoEditor(
            controller: telefonoController,
            label: 'Teléfono',
            icon: Icons.phone_outlined,
          ),
        ],
        const SizedBox(height: 16),
        _CampoEditor(
          controller: cctController,
          label: 'Clave del Centro de Trabajo (CCT)',
          icon: Icons.business_outlined,
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: _BotonEditorDatos(
                icon: Icons.close_rounded,
                text: 'Cancelar',
                background: const Color(0xFFF1F3F1),
                foreground: const Color(0xFF4A4E5A),
                onTap: onCancel,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _BotonEditorDatos(
                icon: Icons.save_rounded,
                text: 'Guardar cambios',
                background: _kGreenLight,
                foreground: Colors.white,
                onTap: onSave,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CampoEditor extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _CampoEditor({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: _kGreenLight),
        filled: true,
        fillColor: const Color(0xFFF8FAF8),
        labelStyle: const TextStyle(
          color: _kGreenLight,
          fontWeight: FontWeight.w700,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFE0EAE0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: _kGreenLight, width: 2),
        ),
      ),
    );
  }
}

class _BotonEditorDatos extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  const _BotonEditorDatos({
    required this.icon,
    required this.text,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: foreground.withOpacity(0.12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: foreground, size: 22),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> lines;
  final bool highlight;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.lines,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
            color: _kGreenPale,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF64BE69), size: 23),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF4A4E5A),
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              ...lines.map(
                (line) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    line,
                    style: TextStyle(
                      color: highlight ? _kGreenLight : const Color(0xFF7A808A),
                      fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 15,
                      height: 1.25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CarouselSection extends StatelessWidget {
  final bool canManage;

  final List<_CarouselItem> imagenes;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onAddImage;
  final void Function(int index) onDeleteImage;
  final void Function(int index, String newText) onEditText;

  const _CarouselSection({
    required this.canManage,
    required this.imagenes,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onAddImage,
    required this.onDeleteImage,
    required this.onEditText,
  });

  void _abrirMenuGestion(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 850;

    if (isDesktop) {
      _abrirDialogGestionPc(context);
    } else {
      _abrirBottomSheetGestion(context);
    }
  }

  void _abrirDialogGestionPc(BuildContext context) {
    final TextEditingController textoController = TextEditingController(
      text: imagenes[currentIndex].texto.replaceAll('\n', ' '),
    );

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 70,
            vertical: 40,
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 980, minHeight: 520),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x44000000),
                  blurRadius: 40,
                  offset: Offset(0, 20),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 55,
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: _buildImagen(imagenes[currentIndex].imagen),
                          ),
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.12),
                            ),
                          ),
                          Positioned(
                            left: 24,
                            right: 24,
                            bottom: 24,
                            child: Container(
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.94),
                                borderRadius: BorderRadius.circular(18),
                                border: const Border(
                                  left: BorderSide(
                                    color: _kGreenLight,
                                    width: 7,
                                  ),
                                ),
                              ),
                              child: Text(
                                imagenes[currentIndex].texto,
                                style: const TextStyle(
                                  color: _kGreen,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 17,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 45,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 34, 34, 34),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                color: _kGreenPale,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.view_carousel_rounded,
                                color: _kGreenLight,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Gestión del carrusel',
                                    style: TextStyle(
                                      color: _kGreen,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Administra la imagen y el mensaje actual.',
                                    style: TextStyle(
                                      color: Color(0xFF7A808A),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F8F4),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2ECE2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.image_outlined,
                                color: _kGreenLight,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Imagen ${currentIndex + 1} de ${imagenes.length}',
                                style: const TextStyle(
                                  color: Color(0xFF4A4E5A),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        TextField(
                          controller: textoController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Texto del card',
                            alignLabelWithHint: true,
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 82),
                              child: Icon(
                                Icons.format_quote_rounded,
                                color: _kGreenLight,
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAF8),
                            labelStyle: const TextStyle(
                              color: _kGreenLight,
                              fontWeight: FontWeight.w700,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0EAE0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: _kGreenLight,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: _MenuActionButton(
                                icon: Icons.add_photo_alternate_rounded,
                                text: 'Agregar',
                                background: _kGreenPale,
                                foreground: _kGreen,
                                onTap: () {
                                  Navigator.pop(context);
                                  onAddImage();
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _MenuActionButton(
                                icon: Icons.save_rounded,
                                text: 'Guardar',
                                background: _kGreenLight,
                                foreground: Colors.white,
                                onTap: () {
                                  onEditText(
                                    currentIndex,
                                    textoController.text.trim(),
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _MenuActionButton(
                                icon: Icons.delete_outline_rounded,
                                text: 'Quitar',
                                background: const Color(0xFFFFECEC),
                                foreground: const Color(0xFFD32F2F),
                                onTap: imagenes.length <= 1
                                    ? null
                                    : () {
                                        Navigator.pop(context);
                                        onDeleteImage(currentIndex);
                                      },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _MenuActionButton(
                                icon: Icons.close_rounded,
                                text: 'Cerrar',
                                background: const Color(0xFFF1F3F1),
                                foreground: const Color(0xFF4A4E5A),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        if (imagenes.length <= 1) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'Debe quedar al menos una imagen en el carrusel.',
                            style: TextStyle(
                              color: Color(0xFFD32F2F),
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _abrirBottomSheetGestion(BuildContext context) {
    final TextEditingController textoController = TextEditingController(
      text: imagenes[currentIndex].texto.replaceAll('\n', ' '),
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 25,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 54,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDE3DD),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: _kGreenPale,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.view_carousel_rounded,
                          color: _kGreenLight,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gestión del carrusel',
                              style: TextStyle(
                                color: _kGreen,
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Agrega, elimina o edita el texto.',
                              style: TextStyle(
                                color: Color(0xFF7A808A),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: _buildImagen(imagenes[currentIndex].imagen),
                    ),
                  ),
                  const SizedBox(height: 22),
                  TextField(
                    controller: textoController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Texto del card',
                      prefixIcon: const Icon(
                        Icons.format_quote_rounded,
                        color: _kGreenLight,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F8F5),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: Color(0xFFE0EAE0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                          color: _kGreenLight,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _MenuActionButton(
                          icon: Icons.add_photo_alternate_rounded,
                          text: 'Agregar',
                          background: _kGreenPale,
                          foreground: _kGreen,
                          onTap: () {
                            Navigator.pop(context);
                            onAddImage();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MenuActionButton(
                          icon: Icons.save_rounded,
                          text: 'Guardar',
                          background: _kGreenLight,
                          foreground: Colors.white,
                          onTap: () {
                            onEditText(
                              currentIndex,
                              textoController.text.trim(),
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _MenuActionButton(
                          icon: Icons.delete_outline_rounded,
                          text: 'Quitar',
                          background: const Color(0xFFFFECEC),
                          foreground: const Color(0xFFD32F2F),
                          onTap: imagenes.length <= 1
                              ? null
                              : () {
                                  Navigator.pop(context);
                                  onDeleteImage(currentIndex);
                                },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MenuActionButton(
                          icon: Icons.close_rounded,
                          text: 'Cerrar',
                          background: const Color(0xFFF1F3F1),
                          foreground: const Color(0xFF4A4E5A),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildImagen(dynamic item) {
    if (item is Uint8List) {
      return Image.memory(item, fit: BoxFit.cover);
    }

    return Image.network(item as String, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmall = MediaQuery.of(context).size.width < 700;

    return Column(
      children: [
        Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: isSmall ? 300 : 430,
                viewportFraction: 1,
                enlargeCenterPage: false,
                enableInfiniteScroll: true,
                autoPlay: false,
                initialPage: currentIndex,
                onPageChanged: (index, reason) {
                  onPageChanged(index);
                },
              ),
              items: imagenes.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x24000000),
                            blurRadius: 30,
                            offset: Offset(0, 16),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            Positioned.fill(child: _buildImagen(item.imagen)),
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.12),
                              ),
                            ),
                            Positioned(
                              right: isSmall ? 20 : 28,
                              bottom: isSmall ? 28 : 34,
                              child: Container(
                                width: isSmall ? 260 : 390,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmall ? 18 : 28,
                                  vertical: isSmall ? 18 : 24,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.96),
                                  borderRadius: BorderRadius.circular(12),
                                  border: const Border(
                                    left: BorderSide(
                                      color: _kGreenLight,
                                      width: 8,
                                    ),
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x18000000),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  item.texto,
                                  style: const TextStyle(
                                    color: _kGreen,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 17,
                                    height: 1.55,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            if (canManage)
              Positioned(
                top: 18,
                right: 18,
                child: InkWell(
                  onTap: () => _abrirMenuGestion(context),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.94),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x25000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '＋',
                        style: TextStyle(
                          color: _kGreenLight,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imagenes.asMap().entries.map((entry) {
            final bool active = currentIndex == entry.key;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: active ? 31 : 13,
              height: 13,
              margin: const EdgeInsets.symmetric(horizontal: 7),
              decoration: BoxDecoration(
                color: active ? _kGreenLight : const Color(0xFFD8DDE1),
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _MenuActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color background;
  final Color foreground;
  final VoidCallback? onTap;

  const _MenuActionButton({
    required this.icon,
    required this.text,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Opacity(
        opacity: disabled ? 0.45 : 1,
        child: Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: foreground.withOpacity(0.12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foreground, size: 22),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foreground,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: double.infinity,
      color: const Color(0xFF0F2B18),
      child: const Center(
        child: Text(
          '© 2023 CARE - Centro de Apoyo y Refuerzo Escolar. Todos los derechos reservados.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFB9C7BC),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

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
            decoration: const BoxDecoration(
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
  bool _isLoading = false;

  final List<String> _roles = ['Padre', 'Maestro', 'Administrador'];

  String get _fieldLabel {
    if (_selectedRole == 0) return 'Correo o Teléfono';
    if (_selectedRole == 1) return 'Correo Electrónico';
    return 'Usuario';
  }

  String get _passLabel {
    return _selectedRole == 2 ? 'Contraseña' : 'PIN de acceso';
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final identifier = _userCtrl.text.trim();
    final password = _passCtrl.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_selectedRole == 0) {
        final api = ApiService();
        final padres = await api.getPadres();

        final parent = padres.firstWhere(
          (p) =>
              (p['email'] == identifier || p['contacto'] == identifier) &&
              p['pin_acceso'] == password,
          orElse: () => <String, dynamic>{},
        );

        if (parent.isNotEmpty) {
          Navigator.of(context).pop({'role': 0, 'user': parent});
          return;
        }
      } else if (_selectedRole == 1) {
        final api = MaestrosApiService();
        final maestros = await api.getMaestros();

        final maestro = maestros.firstWhere(
          (m) =>
              m['correo_electronico'] == identifier &&
              m['pin_acceso'] == password,
          orElse: () => <String, dynamic>{},
        );

        if (maestro.isNotEmpty) {
          Navigator.of(context).pop({'role': 1, 'user': maestro});
          return;
        }
      } else if (_selectedRole == 2) {
        final api = AdministradoresApiService();
        final admins = await api.getAdministradores();

        final admin = admins.firstWhere(
          (a) => a['usuario'] == identifier && a['password'] == password,
          orElse: () => <String, dynamic>{},
        );

        if (admin.isNotEmpty) {
          Navigator.of(context).pop({'role': 2, 'user': admin});
          return;
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Credenciales incorrectas. Verifique e intente nuevamente.',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 32,
                ),
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
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                              onTap: () {
                                setState(() {
                                  _selectedRole = i;
                                  _userCtrl.clear();
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: sel ? _kGreen : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _roles[i],
                                  style: TextStyle(
                                    color: sel ? _kWhite : _kTextMuted,
                                    fontWeight: sel
                                        ? FontWeight.w600
                                        : FontWeight.w400,
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
                      label: _passLabel,
                      icon: Icons.lock_outline,
                      obscure: _obscure,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: _kTextMuted,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _onLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kGreen,
                          foregroundColor: _kWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Iniciar sesión',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
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
