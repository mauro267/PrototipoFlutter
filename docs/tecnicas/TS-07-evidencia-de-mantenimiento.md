---
id: TS-07
titulo: Evidencia de mantenimiento
version: 1.0.0
fecha: 2026-11-26
estado: aprobada
funcional: F-07 1.0.0
responsable: Mauricio Marín
---

# TS-07 · Evidencia de mantenimiento

## Resumen

Cada fila del historial de mantenimientos tiene el botón *Evidencia*, que abre
`EvidenciasScreen` (ruta `/evidencias`). La foto se elige de la galería, sube como
bytes al bucket público `evidencias` con un nombre nuevo y su ruta y URL quedan en
`evidencia_mantenimiento`.

## Preparación en Supabase

1. Migración `initial_schema` subida (crea `evidencia_mantenimiento`).
2. *Storage → New bucket*: `evidencias`, con **Public bucket** encendido.
3. *Storage → Policies*, sobre `evidencias`, para el rol `authenticated`: una policy
   de **INSERT** (subir) y una de **SELECT** (listar). Equivale a correr en el SQL Editor:

   ```sql
   insert into storage.buckets (id, name, public) values ('evidencias', 'evidencias', true);
   create policy "evidencias_insert" on storage.objects for insert to authenticated
     with check (bucket_id = 'evidencias');
   create policy "evidencias_select" on storage.objects for select to authenticated
     using (bucket_id = 'evidencias');
   ```

## Piezas

- `pubspec.yaml` · **cambia** (T-20) · `image_picker: ^1.1.2`.
- `lib/models/models.dart` · **cambia** (T-20) · `Evidencia` (`id`, `idMantenimiento`, `ruta`, `url`, `fechaSubida`) con `fromMap`.
- `lib/services/foto_service.dart` · **nueva** (T-20) · `elegirDeGaleria() → Future<Uint8List?>` con `image_picker` (`maxWidth: 1600`, `imageQuality: 80`); `null` si se cancela.
- `lib/services/storage_service.dart` · **nueva** (T-20) · `subirEvidencia(int idMantenimiento, Uint8List bytes) → Future<({String ruta, String url})>`: `uploadBinary` a `<id>/<milisegundos>.jpg` con `contentType: 'image/jpeg'` y `getPublicUrl`.
- `lib/services/evidencia_service.dart` · **nueva** (T-20) · `getEvidencias(int idMantenimiento) → Future<List<Evidencia>>` (más reciente primero) y `crearEvidencia(idMantenimiento, ruta, url) → Future<Evidencia>` (con `auth_uuid_subida` del usuario actual).
- `lib/screens/evidencias_screen.dart` · **nueva** (T-21) · Screen de la ruta `/evidencias`; recibe el `Mantenimiento` en `arguments`. Botón *Adjuntar foto*; cargando, vacío, error con *Reintentar*; al tocar una foto, diálogo con `InteractiveViewer`.
- `lib/components/galeria_evidencias.dart` · **nueva** (T-21) · cuadrícula; recibe `evidencias` y `onVer(Evidencia)`.
- `lib/components/fila_mantenimiento.dart` · **cambia** (T-21) · `onEvidencia` opcional (`Function()?`): ícono de fotos.
- `lib/pages/maintenance_page.dart`, `lib/pages/vehicle_detail_page.dart` · **cambian** (T-21) · `onEvidencia` opcional (`Function(Mantenimiento)?`) que pasan a cada fila.
- `lib/screens/maintenance_screen.dart`, `lib/screens/vehicle_detail_screen.dart` · **cambian** (T-21) · `onEvidencia: (m) => Navigator.pushNamed(context, '/evidencias', arguments: m)`.
- `lib/main.dart` · **cambia** (T-21) · la ruta `/evidencias` (ya registrada en T-01).

## Estado

- `EvidenciasScreen`: `_evidencias` (`List<Evidencia>?`, `null` mientras carga), `_error` (String?), `_subiendo` (bool: deshabilita *Adjuntar foto* y muestra un indicador).

## Datos

- Bucket público `evidencias`, archivos en `<id_mantenimiento>/<milisegundos>.jpg`. Nunca se sobrescriben (AD-07).
- Tabla `evidencia_mantenimiento`: `id_mantenimiento`, `ruta`, `url`, `fecha_subida`, `auth_uuid_subida`.

## Paquetes y plataformas

- `image_picker` · web y Android sin configuración extra para la galería. Es código
  nativo: después de agregarlo hay que detener la app y volver a correrla.
- En web puede llegar PNG; se sube igual como `image/jpeg` y el navegador lo muestra.

## Tareas

- **T-20** Servicios de foto, Storage y evidencia, y el modelo `Evidencia` · CA-2, CA-3, CA-5, CA-6 · depende de: T-05
  - Prueba: `flutter analyze` sin errores.
- **T-21** `EvidenciasScreen` con galería, adjuntar y ver en grande, y el botón *Evidencia* en el historial · CA-1, CA-2, CA-4, CA-7 · depende de: T-20, T-06
  - Prueba: en Mantenimiento, *Evidencia* del mantenimiento de BOG-452 → «Aún no hay evidencia»; *Adjuntar foto* → la foto aparece; en *Storage → evidencias/1/* hay un archivo; cerrar y abrir → sigue; cancelar la galería → nada cambia.

## Preguntas abiertas

- Ninguna.

## Historial

- 1.0.0 · 2026-11-26 · Primera versión, con la skill `sdd-tecnicas`; aprobada.
