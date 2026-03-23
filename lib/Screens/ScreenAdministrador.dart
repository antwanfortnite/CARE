import 'package:flutter/material.dart';
import 'InicioSesion.dart'; // 👈 IMPORTANTE

class ScreenAdministrador extends StatefulWidget {
  const ScreenAdministrador({super.key});

  @override
  State<ScreenAdministrador> createState() => _ScreenAdministradorState();
}

class _ScreenAdministradorState extends State<ScreenAdministrador> {
  int _selectedIndex = 0;

  final _nombreMaestro = TextEditingController();
  final _correoMaestro = TextEditingController();
  final _nombreAlumno = TextEditingController();
  final _curpAlumno = TextEditingController();
  final _mesController = TextEditingController();

  @override
  void dispose() {
    _nombreMaestro.dispose();
    _correoMaestro.dispose();
    _nombreAlumno.dispose();
    _curpAlumno.dispose();
    _mesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: isMobile
          ? AppBar(
              backgroundColor: Colors.green[700],
              title: const Text(
                "Administrador CARE",
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
            )
          : null,
      drawer: isMobile ? _buildDrawer() : null,
      body: isMobile ? _buildMobile() : _buildDesktop(),
    );
  }

  // ================= DESKTOP =================
  Widget _buildDesktop() {
    return Row(
      children: [
        Container(
          width: 260,
          decoration: BoxDecoration(color: Colors.green[800]),
          child: Column(
            children: [
              _buildSidebarHeader(),
              const SizedBox(height: 20),

              _sideItem("Maestros", Icons.assignment_ind_rounded, 0),
              _sideItem("Alumnos", Icons.school_rounded, 1),
              _sideItem("Meses", Icons.calendar_month_rounded, 2),

              const Spacer(),

              // 🔴 BOTÓN CERRAR SESIÓN
              ListTile(
                onTap: _confirmarCerrarSesion,
                leading: const Icon(Icons.logout, color: Colors.white70),
                title: const Text(
                  "Cerrar sesión",
                  style: TextStyle(color: Colors.white70),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              _header(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _getSelectedView(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: const Column(
        children: [
          Icon(Icons.admin_panel_settings, color: Colors.white, size: 50),
          SizedBox(height: 10),
          Text(
            "CARE ADMIN",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _sideItem(String text, IconData icon, int index) {
    final isSelected = _selectedIndex == index;

    return ListTile(
      onTap: () => setState(() => _selectedIndex = index),
      leading: Icon(icon, color: isSelected ? Colors.white : Colors.white70),
      title: Text(
        text,
        style: TextStyle(color: isSelected ? Colors.white : Colors.white70),
      ),
    );
  }

  // ================= MOBILE =================
  Widget _buildMobile() {
    return Column(
      children: [
        _header(),
        Expanded(child: _getSelectedView()),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green[700]),
            child: const Center(
              child: Text(
                "Panel Administrativo",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          ListTile(
            title: const Text("Maestros"),
            onTap: () {
              setState(() => _selectedIndex = 0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Alumnos"),
            onTap: () {
              setState(() => _selectedIndex = 1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Meses"),
            onTap: () {
              setState(() => _selectedIndex = 2);
              Navigator.pop(context);
            },
          ),

          const Divider(),

          // 🔴 CERRAR SESIÓN EN MOBILE
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Cerrar sesión"),
            onTap: _confirmarCerrarSesion,
          ),
        ],
      ),
    );
  }

  // 🔥 FUNCIÓN DE CONFIRMACIÓN
  void _confirmarCerrarSesion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Quieres cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              // 🔥 REGRESAR A LOGIN Y BORRAR HISTORIAL
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const InicioSesion()),
                (route) => false,
              );
            },
            child: const Text("Sí"),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text(
        "Panel de Administración",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _getSelectedView() {
    switch (_selectedIndex) {
      case 0:
        return _formMaestro();
      case 1:
        return _formAlumno();
      default:
        return _formMes();
    }
  }

  Widget _formMaestro() {
    return const Center(child: Text("Formulario Maestro"));
  }

  Widget _formAlumno() {
    return const Center(child: Text("Formulario Alumno"));
  }

  Widget _formMes() {
    return const Center(child: Text("Formulario Mes"));
  }
}
