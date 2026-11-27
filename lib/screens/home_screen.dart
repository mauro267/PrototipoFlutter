import 'package:flutter/material.dart';

import '../components/estados_carga.dart';
import '../components/menu_lateral.dart';
import '../models/models.dart';
import '../services/auth_service.dart';
import '../services/carga_inicial.dart';
import '../services/usuario_service.dart';
import '../state/app_store.dart';
import '../theme.dart';
import '../utils/errores.dart';
import 'fleet_screen.dart';
import 'maintenance_screen.dart';
import 'orders_screen.dart';

const _destinos = [
  DestinoMenu('Panel de flota', 'Flota', Icons.dashboard_outlined),
  DestinoMenu('Mantenimiento predictivo', 'Mantenimiento', Icons.build_circle_outlined),
  DestinoMenu('Órdenes y entregas', 'Entregas', Icons.inventory_2_outlined),
];

/// Screen anfitriona de la app: trae de Supabase el usuario de la sesión y los
/// datos de la flota, crea y posee el AppStore y se lo entrega a cada pestaña.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _usuarioService = UsuarioService();
  AppStore? _store;
  bool _cargando = true;
  String? _error;
  int _indice = 0;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _store?.dispose();
    super.dispose();
  }

  /// F-02: trae el usuario y todas las tablas; si algo falla, muestra el error con Reintentar.
  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final usuario = await _usuarioService.miUsuario();
      final datos = await cargarDatosIniciales();
      if (!mounted) return;
      final anterior = _store;
      setState(() {
        _store = AppStore(datos, usuario);
        _cargando = false;
      });
      anterior?.dispose();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _error = mensajeDeError(e);
      });
    }
  }

  /// F-01 A5: cierra la sesión y deja el login como única pantalla de la pila.
  Future<void> _salir() async {
    try {
      await _authService.cerrarSesion();
    } catch (_) {
      // Sin conexión la sesión local se borra igual; se vuelve al login.
    }
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final store = _store;
    if (store == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('RutaViva'),
          actions: [
            IconButton(tooltip: 'Cerrar sesión', icon: const Icon(Icons.logout), onPressed: _salir),
          ],
        ),
        body: _cargando
            ? const EstadoCarga(mensaje: 'Cargando la flota…')
            : EstadoError(
                mensaje: _error ?? 'No fue posible cargar el panel.',
                onReintentar: _cargar,
                textoSecundario: 'Cerrar sesión',
                onSecundario: _salir,
              ),
      );
    }

    final Usuario usuario = store.usuario;
    final ancha = MediaQuery.of(context).size.width >= 900;
    final contenido = IndexedStack(
      index: _indice,
      children: [
        FleetScreen(store: store),
        MaintenanceScreen(store: store),
        OrdersScreen(store: store),
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
                nombre: usuario.nombre,
                correo: usuario.email,
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
