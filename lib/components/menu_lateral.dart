import 'package:flutter/material.dart';

import '../theme.dart';
import 'app_button.dart';

class DestinoMenu {
  final String titulo;
  final String corto;
  final IconData icono;
  const DestinoMenu(this.titulo, this.corto, this.icono);
}

/// Menú lateral para pantallas anchas (en móvil se usa la barra inferior).
class MenuLateral extends StatelessWidget {
  final List<DestinoMenu> destinos;
  final int indice;
  final String nombre;
  final String correo;
  final ValueChanged<int> onSeleccion;
  final VoidCallback onSalir;
  const MenuLateral({
    super.key,
    required this.destinos,
    required this.indice,
    required this.nombre,
    required this.correo,
    required this.onSeleccion,
    required this.onSalir,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(color: Pal.azul, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.local_shipping, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RutaViva', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  Text('Operaciones', style: TextStyle(fontSize: 11, color: Pal.suave)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          for (var i = 0; i < destinos.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Material(
                color: i == indice ? Pal.azul : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => onSeleccion(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: [
                        Icon(destinos[i].icono, size: 20, color: i == indice ? Colors.white : Pal.suave),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            destinos[i].titulo,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: i == indice ? Colors.white : Pal.texto,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const Spacer(),
          const Divider(color: Pal.borde),
          Row(
            children: [
              const CircleAvatar(radius: 18, backgroundColor: Pal.azulBg, child: Icon(Icons.person, color: Pal.azul)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nombre,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    Text(correo,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11.5, color: Pal.suave)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppButton('Cerrar sesión', tipo: TipoBoton.texto, icono: Icons.logout, onPressed: onSalir),
        ],
      ),
    );
  }
}
