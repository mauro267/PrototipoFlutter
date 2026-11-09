import 'package:flutter/material.dart';

import '../components/menu_lateral.dart';
import '../models/models.dart';
import '../services/simulated_data.dart';
import '../state/app_store.dart';
import '../theme.dart';
import 'fleet_screen.dart';
import 'login_screen.dart';
import 'maintenance_screen.dart';
import 'orders_screen.dart';

const _destinos = [
  DestinoMenu('Panel de flota', 'Flota', Icons.dashboard_outlined),
  DestinoMenu('Mantenimiento predictivo', 'Mantenimiento', Icons.build_circle_outlined),
  DestinoMenu('Órdenes y entregas', 'Entregas', Icons.inventory_2_outlined),
];

/// Screen anfitriona de la app: crea y posee el AppStore (los datos en memoria)
/// y se los entrega a las pantallas de cada pestaña.
class HomeScreen extends StatefulWidget {
  final Usuario usuario;
  const HomeScreen({super.key, required this.usuario});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AppStore _store = AppStore(DatosSimulados.cargar(), widget.usuario);
  int _indice = 0;

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  void _salir() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ancha = MediaQuery.of(context).size.width >= 900;
    final contenido = IndexedStack(
      index: _indice,
      children: [
        FleetScreen(store: _store),
        MaintenanceScreen(store: _store),
        OrdersScreen(store: _store),
      ],
    );

    if (ancha) {
      return Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: 250,
              child: MenuLateral(
                destinos: _destinos,
                indice: _indice,
                nombre: widget.usuario.nombre,
                correo: widget.usuario.email,
                onSeleccion: (i) => setState(() => _indice = i),
                onSalir: _salir,
              ),
            ),
            const VerticalDivider(width: 1, color: Pal.borde),
            Expanded(child: contenido),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_destinos[_indice].titulo),
        actions: [
          IconButton(tooltip: 'Cerrar sesión', icon: const Icon(Icons.logout), onPressed: _salir),
        ],
      ),
      body: contenido,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: [
          for (final d in _destinos) NavigationDestination(icon: Icon(d.icono), label: d.corto),
        ],
      ),
    );
  }
}
