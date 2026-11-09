import 'package:flutter/material.dart';

import '../theme.dart';

// Colores e íconos por estado: un solo lugar para toda la app.

Color colorEstadoVehiculo(String e) {
  switch (e) {
    case 'en_ruta':
      return Pal.azul;
    case 'disponible':
      return Pal.verde;
    case 'alerta':
      return Pal.ambar;
    case 'varado':
      return Pal.rojo;
    default:
      return Pal.gris;
  }
}

Color fondoEstadoVehiculo(String e) {
  switch (e) {
    case 'en_ruta':
      return Pal.azulBg;
    case 'disponible':
      return Pal.verdeBg;
    case 'alerta':
      return Pal.ambarBg;
    case 'varado':
      return Pal.rojoBg;
    default:
      return Pal.grisBg;
  }
}

IconData iconoVehiculo(String tipo) =>
    tipo == 'moto' ? Icons.two_wheeler : Icons.local_shipping_outlined;

Color colorEstadoOrden(String e) {
  switch (e) {
    case 'a_tiempo':
      return Pal.verde;
    case 'en_camino':
      return Pal.azul;
    case 'en_riesgo':
      return Pal.ambar;
    case 'retrasada':
      return Pal.rojo;
    default:
      return Pal.gris;
  }
}

Color fondoEstadoOrden(String e) {
  switch (e) {
    case 'a_tiempo':
      return Pal.verdeBg;
    case 'en_camino':
      return Pal.azulBg;
    case 'en_riesgo':
      return Pal.ambarBg;
    case 'retrasada':
      return Pal.rojoBg;
    default:
      return Pal.grisBg;
  }
}

Color colorProbabilidad(double p) => p >= 0.8 ? Pal.rojo : (p >= 0.5 ? Pal.ambar : Pal.azul);
