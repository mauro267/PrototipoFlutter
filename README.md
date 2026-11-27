# RutaViva · Torre de control de Operaciones

App Flutter (web y Android) para el área de Operaciones de RutaViva Logística: panel de
flota por zona, alertas predictivas de mantenimiento, registro de mantenimientos con
evidencia fotográfica y cumplimiento de entregas (OTD) frente a los cinco retailers.
Backend en Supabase (Auth, base de datos y Storage), sin servidor propio.

Entrega 3 del Seminario de Ingeniería de Software (ICESI, 2026-2). Equipo: Mauricio
Marín, Elías Saldarriaga, Juan Felipe Martínez y Daniel Cabal.

## Requisitos

- Flutter 3.x (Dart 3.3 o superior) y Chrome o un dispositivo Android.
- Node.js (para `npx supabase`, el CLI de Supabase).
- Acceso al proyecto de Supabase del equipo.

## 1. Clonar y crear las carpetas de plataforma

```bash
git clone https://github.com/mauro267/PrototipoFlutter.git
cd PrototipoFlutter
flutter create . --platforms=web,android --project-name rutaviva   # solo la primera vez
flutter pub get
```

En Android, la versión *release* necesita el permiso de internet en
`android/app/src/main/AndroidManifest.xml`:
`<uses-permission android:name="android.permission.INTERNET"/>`.

## 2. Preparar Supabase (una sola persona del equipo, una sola vez)

1. Crear el proyecto en [supabase.com](https://supabase.com) e invitar al equipo
   (*Team › Invite*). Guardar la **Database password**.
2. Subir el esquema y los datos de ejemplo con las migraciones de `supabase/migrations/`:

   ```bash
   npx supabase init            # si pregunta por VS Code/Deno, responder n
   npx supabase login
   npx supabase link --project-ref TU_PROJECT_REF
   npx supabase db push --remote
   ```

   `initial_schema` crea las 15 tablas del modelo (`docs/modelo.md`) con sus llaves,
   restricciones y `grant`; `datos_ejemplo` carga la flota, la telemetría, las
   predicciones y las órdenes de ejemplo.
3. *Authentication › Sign In / Providers › Email*: apagar **Confirm email**.
4. *Storage*: crear el bucket **público** `evidencias` y, en *Policies*, una policy de
   INSERT y una de SELECT para `authenticated`. Equivale a correr en el *SQL Editor*:

   ```sql
   insert into storage.buckets (id, name, public) values ('evidencias', 'evidencias', true);
   create policy "evidencias_insert" on storage.objects for insert to authenticated
     with check (bucket_id = 'evidencias');
   create policy "evidencias_select" on storage.objects for select to authenticated
     using (bucket_id = 'evidencias');
   ```

## 3. Variables de entorno

La app lee la URL y la publishable key de `env.json`, que **no** se sube al repositorio
(está en `.gitignore`). Cópialo desde la plantilla:

```bash
cp env.example.json env.json
```

| Variable | Dónde se encuentra |
| --- | --- |
| `SUPABASE_URL` | *Project Settings › General* (Project ID) → `https://<project-ref>.supabase.co` |
| `SUPABASE_PUBLISHABLE_KEY` | *Project Settings › API Keys*, la que empieza por `sb_publishable_` |

La **secret key** (`sb_secret_...`) nunca se usa en la app ni se sube.

## 4. Ejecutar

```bash
flutter run -d chrome --dart-define-from-file=env.json   # web
flutter run --dart-define-from-file=env.json             # Android
flutter analyze
flutter test
```

Sin `env.json` la app arranca con una pantalla que explica cómo configurarla.
La primera vez, usa *¿No tienes cuenta? Crea una* para crear tu usuario coordinador.

## Cómo está organizado

- `docs/`: el proceso de Spec Driven Development. `prd.md` → `requisitos.md` →
  `architectural_spine.md` → `specs/` (funcionales, `F-xx`) → `tecnicas/` (planes,
  `TS-xx`) → `impl_progress.md` (tareas `T-xx`, quién las tiene y cuáles están hechas).
  `modelo.md` es el modelo de datos y `standard_code.md` las reglas del código.
- `supabase/migrations/`: el esquema de la base de datos, versionado.
- `lib/`: `screens/` (con estado y navegación), `pages/` (vistas), `components/`
  (widgets reutilizables), `services/` (lo único que habla con Supabase), `state/`
  (`AppStore`), `models/` y `utils/`.
- `.agents/skills/` y `.claude/skills/`: las skills del curso que se usan con el agente;
  `AGENTS.md`/`CLAUDE.md` es su archivo de contexto.
