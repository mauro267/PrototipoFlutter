import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme.dart';
import '../utils/format.dart';

/// Cuadrícula de fotos de evidencia con su fecha; avisa con [onVer] la foto tocada.
class GaleriaEvidencias extends StatelessWidget {
  final List<Evidencia> evidencias;
  final Function(Evidencia) onVer;
  const GaleriaEvidencias({super.key, required this.evidencias, required this.onVer});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: evidencias.length,
      itemBuilder: (context, i) {
        final e = evidencias[i];
        return InkWell(
          onTap: () => onVer(e),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Pal.borde),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(
                    e.url,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progreso) =>
                        progreso == null ? child : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    errorBuilder: (context, error, stack) =>
                        const Center(child: Icon(Icons.broken_image_outlined, color: Pal.gris)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(fmtFechaHora(e.fechaSubida),
                      style: const TextStyle(fontSize: 12, color: Pal.suave)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
