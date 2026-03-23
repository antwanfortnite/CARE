import 'package:flutter/material.dart';

class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  State<InicioSesion> createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 194, 194, 194),
      body: SafeArea(child: isMobile ? _buildMobile() : _buildDesktop()),
    );
  }

  // ================= MOBILE =================
  Widget _buildMobile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 🔹 HEADER VERDE (FULL WIDTH)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.green, Colors.teal]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: const Column(
              children: [
                Icon(Icons.school, color: Colors.white, size: 60),
                SizedBox(height: 10),
                Text(
                  "CARE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Bienvenido al sistema académico",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // 🔹 FORMULARIO
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),

                const Text(
                  "Inicio de sesión",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                // 🔸 Tabs
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: "Alumno"),
                      Tab(text: "Profesor"),
                      Tab(text: "Administrativo"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔸 Campo dinámico
                AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, _) {
                    String label = _tabController.index == 0
                        ? "CURP"
                        : "Usuario";

                    return TextField(
                      controller: _userController,
                      decoration: InputDecoration(
                        labelText: label,
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 15),

                // 🔸 Contraseña
                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🔸 Botón
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white, // 🔥 FIX TEXTO
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("Iniciar sesión"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= DESKTOP =================
  Widget _buildDesktop() {
    return Center(
      child: Container(
        width: 900,
        height: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          children: [
            // 🔹 IZQUIERDA
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.green, Colors.teal]),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(15),
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.school, color: Colors.white, size: 60),
                      SizedBox(height: 10),
                      Text(
                        "CARE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Bienvenido al sistema académico",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 🔹 DERECHA
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: _buildForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 FORM REUTILIZABLE
  Widget _buildForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Inicio de sesión",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        // Tabs
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(25),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: "Alumno"),
              Tab(text: "Profesor"),
              Tab(text: "Administrativo"),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Campo dinámico
        AnimatedBuilder(
          animation: _tabController,
          builder: (context, _) {
            String label = _tabController.index == 0 ? "CURP" : "Usuario";

            return TextField(
              controller: _userController,
              decoration: InputDecoration(
                labelText: label,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 15),

        TextField(
          controller: _passController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Contraseña",
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: const Color.fromARGB(
                255,
                255,
                255,
                255,
              ), // 🔥 FIX
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: const Text("Iniciar sesión"),
          ),
        ),
      ],
    );
  }
}
