import 'package:flutter/material.dart';
import 'AlumnoScaffold.dart';
import 'DashboardAlumno.dart';

/// Pantalla de Evidencias para el Padre de Familia.
/// Solo puede VER las evidencias de su hijo(a), no puede agregar ni eliminar.
class EvidenciasAlumno extends StatefulWidget {
  const EvidenciasAlumno({super.key});
  @override
  State<EvidenciasAlumno> createState() => _EvidenciasAlumnoState();
}

class _EvidenciasAlumnoState extends State<EvidenciasAlumno> {
  final TextEditingController _searchController = TextEditingController();

  // Nombre del alumno (hijo del padre)
  final String _studentName = 'Carlos Méndez López';
  final String _studentCurp = 'MECC080515HDHNRL01';
  final String _groupName = 'Grupo 3A';
  final String _groupTurno = 'Matutino';

  // ──────── EVIDENCIAS MOCK DEL ALUMNO ────────
  final List<_EvidenciaData> _evidencias = [
    _EvidenciaData(
      1,
      'https://ejemplo.com/fotos/carlos_act1.jpg',
      'Participación en clase de ciencias. El alumno demostró excelente comprensión del tema.',
      '2026-03-15',
      'Prof. Julián Sánchez',
    ),
    _EvidenciaData(
      2,
      'https://ejemplo.com/fotos/carlos_act2.jpg',
      'Trabajo práctico: maqueta del sistema solar completada satisfactoriamente.',
      '2026-03-22',
      'Prof. Julián Sánchez',
    ),
    _EvidenciaData(
      3,
      'https://ejemplo.com/fotos/carlos_act3.jpg',
      'Evaluación diagnóstica - resultado aprobatorio.',
      '2026-04-01',
      'Prof. Julián Sánchez',
    ),
  ];

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

    return AlumnoScaffold(
      selectedIndex: 1,
      destinations: {
        0: (_) => const DashboardAlumno(),
      },
      bodyPadding: EdgeInsets.all(mobile ? 16 : 28),
      body: _buildBody(mobile),
    );
  }

  Widget _buildBody(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(isMobile),
        const SizedBox(height: 20),
        _buildStudentBanner(isMobile),
        const SizedBox(height: 20),
        _buildFilterBar(isMobile),
        const SizedBox(height: 20),
        if (_evidencias.isEmpty)
          _buildEmptyState()
        else
          ..._filteredEvidencias().map(
            (e) => _buildEvidenciaCard(e, isMobile),
          ),
      ],
    );
  }

  List<_EvidenciaData> _filteredEvidencias() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _evidencias;
    return _evidencias
        .where((e) =>
            e.descripcion.toLowerCase().contains(query) ||
            e.fechaSubida.contains(query) ||
            e.maestro.toLowerCase().contains(query))
        .toList();
  }

  // ──────── HEADER ────────
  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Evidencias de su hijo(a)',
          style: TextStyle(
            fontSize: isMobile ? 22 : 26,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Consulte las evidencias de trabajo y actividades registradas por los maestros.',
          style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
        ),
      ],
    );
  }

  // ──────── BANNER INFORMACIÓN DEL ALUMNO ────────
  Widget _buildStudentBanner(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF388E3C), Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: isMobile ? 24 : 28,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(
              Icons.school,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _studentName,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _bannerChip(Icons.group_outlined, _groupName),
                    _bannerChip(Icons.schedule, _groupTurno),
                    _bannerChip(Icons.badge_outlined, _studentCurp),
                    _bannerChip(
                      Icons.folder_outlined,
                      '${_evidencias.length} ${_evidencias.length == 1 ? 'evidencia' : 'evidencias'}',
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

  Widget _bannerChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white.withOpacity(0.7)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.85),
          ),
        ),
      ],
    );
  }

  // ──────── BARRA DE FILTRO ────────
  Widget _buildFilterBar(bool isMobile) {
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
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF999999),
                ),
                hintText: 'Buscar evidencia por descripción o fecha...',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF999999),
                ),
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
              icon: const Icon(Icons.refresh, color: Color(0xFF888888)),
            ),
          ),
        ],
      ),
    );
  }

  // ──────── ESTADO VACÍO ────────
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 48,
            color: Color(0xFFCCCCCC),
          ),
          SizedBox(height: 16),
          Text(
            'Sin evidencias registradas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF888888),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Aún no se han subido evidencias para su hijo(a).\nRevise más adelante.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF999999),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ──────── TARJETA DE EVIDENCIA ────────
  Widget _buildEvidenciaCard(_EvidenciaData e, bool isMobile) {
    // Format date for header label
    String dateHeader = '';
    try {
      final parts = e.fechaSubida.split('-');
      final months = [
        '',
        'ENERO',
        'FEBRERO',
        'MARZO',
        'ABRIL',
        'MAYO',
        'JUNIO',
        'JULIO',
        'AGOSTO',
        'SEPTIEMBRE',
        'OCTUBRE',
        'NOVIEMBRE',
        'DICIEMBRE',
      ];
      dateHeader =
          '${parts[2]} DE ${months[int.parse(parts[1])]}, ${parts[0]}';
    } catch (_) {
      dateHeader = e.fechaSubida;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header above the card
        Padding(
          padding: const EdgeInsets.only(bottom: 6, top: 4),
          child: Text(
            dateHeader,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4CAF50),
              letterSpacing: 0.5,
            ),
          ),
        ),
        // Evidence card
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(isMobile ? 14 : 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: isMobile ? _buildCardContentMobile(e) : _buildCardContentDesktop(e),
        ),
      ],
    );
  }

  Widget _buildCardContentMobile(_EvidenciaData e) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F0EC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 22,
                color: Color(0xFFCBBEB5),
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
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 12, color: Color(0xFF999999)),
                      const SizedBox(width: 4),
                      Text(
                        e.maestro,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showViewEvidenciaDialog(e),
            icon: const Icon(Icons.visibility_outlined, size: 16),
            label: const Text('Ver Detalle'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
              foregroundColor: const Color(0xFF4CAF50),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardContentDesktop(_EvidenciaData e) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F0EC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.camera_alt_outlined,
            size: 26,
            color: Color(0xFFCBBEB5),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.descripcion,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 13, color: Color(0xFF999999)),
                  const SizedBox(width: 4),
                  Text(
                    e.maestro,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.calendar_today_outlined, size: 13, color: Color(0xFF999999)),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(e.fechaSubida),
                    style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Tooltip(
          message: 'Ver detalle de la evidencia',
          child: InkWell(
            onTap: () => _showViewEvidenciaDialog(e),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF4CAF50).withOpacity(0.2),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    size: 16,
                    color: Color(0xFF4CAF50),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Ver Detalle',
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
        ),
      ],
    );
  }

  // ──────── VER EVIDENCIA (read-only dialog) ────────
  void _showViewEvidenciaDialog(_EvidenciaData e) {
    final mobile = _isMobile(context);

    String formattedDate = '';
    try {
      final parts = e.fechaSubida.split('-');
      formattedDate = '${parts[2]}/${parts[1]}/${parts[0]}';
    } catch (_) {
      formattedDate = e.fechaSubida;
    }

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        insetPadding: EdgeInsets.symmetric(
          horizontal: mobile ? 16 : 40,
          vertical: 24,
        ),
        child: Container(
          width: mobile ? double.infinity : 520,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
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
                          const Icon(
                            Icons.photo_library_outlined,
                            size: 16,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'DETALLE DE EVIDENCIA',
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
                        'Información de Evidencia',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Alumno: $_studentName',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Form (read-only)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Group & Teacher info
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.group_outlined,
                                  size: 16,
                                  color: Color(0xFF888888),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '$_groupName  •  $_groupTurno',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.person_outline,
                                  size: 16,
                                  color: Color(0xFF888888),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Registrada por: ${e.maestro}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // FECHA
                      _readOnlyLabel('FECHA DE LA EVIDENCIA'),
                      const SizedBox(height: 6),
                      _readOnlyField(formattedDate, Icons.calendar_month_rounded),
                      const SizedBox(height: 16),

                      // FOTO
                      _readOnlyLabel('FOTO ADJUNTADA'),
                      const SizedBox(height: 6),
                      _readOnlyField(e.urlFoto, Icons.link),
                      const SizedBox(height: 16),

                      // DESCRIPCIÓN
                      _readOnlyLabel('DESCRIPCIÓN'),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Text(
                          e.descripcion,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF555555),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Close button
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text('Cerrar'),
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

  Widget _readOnlyLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Color(0xFF555555),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _readOnlyField(String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF555555),
              ),
            ),
          ),
          Icon(icon, size: 18, color: const Color(0xFF999999)),
        ],
      ),
    );
  }

  // ──────── UTILIDADES ────────
  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      final months = [
        '',
        'Ene',
        'Feb',
        'Mar',
        'Abr',
        'May',
        'Jun',
        'Jul',
        'Ago',
        'Sep',
        'Oct',
        'Nov',
        'Dic',
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

class _EvidenciaData {
  final int idEvidencia;
  final String urlFoto;
  final String descripcion;
  final String fechaSubida;
  final String maestro;
  const _EvidenciaData(
    this.idEvidencia,
    this.urlFoto,
    this.descripcion,
    this.fechaSubida,
    this.maestro,
  );
}
