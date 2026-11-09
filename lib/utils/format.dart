// Formato es-CO (RNF-03): punto para miles, coma para decimales.

String _miles(String digitos) {
  final b = StringBuffer();
  for (var i = 0; i < digitos.length; i++) {
    final restantes = digitos.length - i;
    b.write(digitos[i]);
    if (restantes > 1 && restantes % 3 == 1) b.write('.');
  }
  return b.toString();
}

String fmtEntero(num v) {
  final s = v.abs().round().toString();
  return '${v < 0 ? '-' : ''}${_miles(s)}';
}

String fmtDec(num v, [int decimales = 1]) {
  final fijo = v.abs().toStringAsFixed(decimales);
  final partes = fijo.split('.');
  final ent = _miles(partes[0]);
  final dec = decimales > 0 ? ',${partes[1]}' : '';
  return '${v < 0 ? '-' : ''}$ent$dec';
}

/// [fraccion] entre 0 y 1.
String fmtPct(double fraccion, [int decimales = 1]) =>
    '${fmtDec(fraccion * 100, decimales)} %';

String fmtCop(num v) => '\$ ${fmtEntero(v)}';

String fmtKm(num v) => '${fmtEntero(v)} km';

String _dos(int n) => n.toString().padLeft(2, '0');

String fmtFecha(DateTime d) => '${_dos(d.day)}/${_dos(d.month)}/${d.year}';

String fmtFechaHora(DateTime d) =>
    '${fmtFecha(d)} ${_dos(d.hour)}:${_dos(d.minute)}';

String etiquetaEstadoVehiculo(String e) {
  switch (e) {
    case 'en_ruta':
      return 'En ruta';
    case 'disponible':
      return 'Disponible';
    case 'alerta':
      return 'En alerta';
    case 'varado':
      return 'Varado';
    case 'mantenimiento':
      return 'En taller';
    default:
      return e;
  }
}

String etiquetaEstadoOrden(String e) {
  switch (e) {
    case 'a_tiempo':
      return 'A tiempo';
    case 'en_camino':
      return 'En camino';
    case 'en_riesgo':
      return 'En riesgo';
    case 'retrasada':
      return 'Retrasada';
    case 'pendiente':
      return 'Pendiente';
    default:
      return e;
  }
}
