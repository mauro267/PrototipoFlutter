import 'package:flutter/material.dart';

import '../components/basicos.dart';
import '../components/estados_carga.dart';
import '../components/galeria_evidencias.dart';
import '../models/models.dart';
import '../services/evidencia_service.dart';
import '../services/foto_service.dart';
import '../services/storage_service.dart';
import '../utils/errores.dart';
import '../utils/format.dart';

/// Screen de la ruta /evidencias (F-07): las fotos de un mantenimiento y la
/// opción de adjuntar una nueva. Recibe el Mantenimiento en `arguments`.
class EvidenciasScreen extends StatefulWidget {
  const EvidenciasScreen({super.key});

  @override
  State<EvidenciasScreen> createState() => _EvidenciasScreenState();
}

class _EvidenciasScreenState extends State<EvidenciasScreen> {
  final _evidenciaService = EvidenciaService();
  final _storageService = StorageService();
  final _fotoService = FotoService();
  Mantenimiento? _mantenimiento;
  List<Evidencia>? _evidencias;
  String? _error;
  bool _subiendo = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_mantenimiento != null) return;
    _mantenimiento = ModalRoute.of(context)!.settings.arguments as Mantenimiento;
    _cargar(inicial: true);
  }

  Future<void> _cargar({bool inicial = false}) async {
    if (!inicial) {
      setState(() {
        _evidencias = null;
        _error = null;
      });
    }
    try {
      final lista = await _evidenciaService.getEvidencias(_mantenimiento!.id);
      if (!mounted) return;
      setState(() => _evidencias = lista);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = mensajeDeError(e));
    }
  }

  /// CA-2, CA-5, CA-6: elige la foto, la sube y solo entonces la agrega a la lista.
  Future<void> _adjuntar() async {
    final bytes = await _fotoService.elegirDeGaleria();
    if (bytes == null || !mounted) return;
    setState(() => _subiendo = true);
    try {
      final id = _mantenimiento!.id;
      final archivo = await _storageService.subirEvidencia(id, bytes);
      final nueva = await _evidenciaService.crearEvidencia(idMantenimiento: id, ruta: archivo.ruta, url: archivo.url);
      if (!mounted) return;
      setState(() {
        _evidencias = [nueva, ...?_evidencias];
        _subiendo = false;
      });
      _aviso('Foto agregada a la evidencia.');
    } catch (e) {
      if (!mounted) return;
      setState(() => _subiendo = false);
      _aviso(mensajeDeError(e));
    }
  }

  void _aviso(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  /// CA-7: la foto en grande, con zoom.
  void _ver(Evidencia e) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            InteractiveViewer(child: Image.network(e.url, fit: BoxFit.contain)),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton.filledTonal(
                tooltip: 'Cerrar',
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(dialogContext),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = _mantenimiento!;
    final evidencias = _evidencias;
    Widget cuerpo;
    if (_error != null) {
      cuerpo = EstadoError(mensaje: _error!, onReintentar: () => _cargar());
    } else if (evidencias == null) {
      cuerpo = const EstadoCarga(mensaje: 'Cargando la evidencia…');
    } else if (evidencias.isEmpty) {
      cuerpo = const Padding(
        padding: EdgeInsets.all(20),
        child: EstadoVacio('Aún no hay evidencia para este mantenimiento. Adjunta la primera foto.',
            icono: Icons.photo_library_outlined),
      );
    } else {
      cuerpo = GaleriaEvidencias(evidencias: evidencias, onVer: _ver);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Evidencia · ${m.tipoFalla}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('${fmtFecha(m.fecha)} · ${fmtKm(m.kilometraje)}'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _subiendo || evidencias == null ? null : _adjuntar,
        icon: _subiendo
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.add_a_photo_outlined),
        label: Text(_subiendo ? 'Subiendo…' : 'Adjuntar foto'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1100), child: cuerpo),
      ),
    );
  }
}
