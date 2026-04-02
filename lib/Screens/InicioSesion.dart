import 'package:flutter/material.dart';
import 'Administrador/DashboardAdmin.dart';

class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  State<InicioSesion> createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  int _selectedRole = 0;
  final TextEditingController _curpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<String> _roles = ['Alumno', 'Profesor', 'Administrativo'];

  String get _userFieldLabel => _selectedRole == 0 ? 'CURP' : 'Usuario';

  @override
  void dispose() {
    _curpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBDBDBD),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              clipBehavior: Clip.antiAlias,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isMobile = constraints.maxWidth < 600;

                  return isMobile
                      ? Column(
                          children: [
                            _buildLeftPanel(isMobile),
                            _buildRightPanel(isMobile),
                          ],
                        )
                      : IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildLeftPanel(isMobile),
                              _buildRightPanel(isMobile),
                            ],
                          ),
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ──────── PANEL IZQUIERDO ────────
  Widget _buildLeftPanel(bool isMobile) {
    return Expanded(
      flex: isMobile ? 0 : 5,
      child: Container(
        width: double.infinity,
        height: isMobile ? 160 : null,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4CAF50), Color(0xFF26A69A)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: isMobile ? 48 : 64,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            const Text(
              'CARE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            if (!isMobile) ...[
              const SizedBox(height: 8),
              const Text(
                'Bienvenido al sistema digital académico',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ──────── PANEL DERECHO ────────
  Widget _buildRightPanel(bool isMobile) {
    return Expanded(
      flex: 6,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 36,
          vertical: isMobile ? 20 : 30,
        ),
        child: isMobile
            ? SingleChildScrollView(child: _buildFormContent())
            : _buildFormContent(),
      ),
    );
  }

  // ──────── CONTENIDO DEL FORMULARIO ────────
  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Inicio de sesión',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 20),

        _buildRoleSelector(),
        const SizedBox(height: 20),

        _buildTextField(controller: _curpController, label: _userFieldLabel),
        const SizedBox(height: 12),

        _buildTextField(
          controller: _passwordController,
          label: 'Contraseña',
          obscure: true,
        ),
        const SizedBox(height: 20),

        SizedBox(
          height: 44,
          child: ElevatedButton(
            onPressed: _onLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Iniciar sesión'),
          ),
        ),
      ],
    );
  }

  // ──────── Selector de Rol ────────
  Widget _buildRoleSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: List.generate(_roles.length, (index) {
          final bool isSelected = _selectedRole == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRole = index;
                  _curpController.clear();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4CAF50)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  _roles[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF666666),
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ──────── Campo de texto ────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF999999), fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1.5),
        ),
      ),
    );
  }

  // ──────── Login ────────
  void _onLogin() {
    // Administrativo -> navegar directamente al Dashboard
    if (_selectedRole == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardAdmin()),
      );
      return;
    }

    final String identifier = _curpController.text.trim();
    final String password = _passwordController.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    debugPrint(
      'Rol: ${_roles[_selectedRole]}, ${_userFieldLabel}: $identifier, Contraseña: $password',
    );
  }
}
