# RutaViva · Torre de control de Operaciones

Prototipo navegable en Flutter (Entrega 2) con datos simulados en memoria.
Ver `docs/` y `AGENTS.md`.

## Cómo ejecutarlo

```bash
flutter create . --platforms=web,android --project-name rutaviva   # solo la primera vez
flutter pub get
flutter run -d chrome          # web
flutter run                    # Android
flutter test
```

Usuario de prueba: `coordinador@rutaviva.com` · contraseña `123456` (vienen prellenados).

## Recorrido sugerido para el video

1. Iniciar sesión.
2. Panel de flota: indicadores, filtro por zona, abrir un vehículo con telemetría y uno sin ella.
3. Mantenimiento: programar una alerta, registrar, editar y eliminar un mantenimiento.
4. Órdenes: filtrar, crear una orden, marcarla como entregada (cambia el OTD), eliminarla.
