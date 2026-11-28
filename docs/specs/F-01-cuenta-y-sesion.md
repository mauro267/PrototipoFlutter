---
id: F-01
titulo: Cuenta y sesión
version: 1.0.0
fecha: 2026-11-26
estado: implementada
autores: [Mauricio Marín, Elías Saldarriaga, Juan Felipe Martínez, Daniel Cabal]
requisitos: [RF-14, RNF-04]
depende_de: []
---

# F-01 · Cuenta y sesión

## Objetivo

El coordinador de operaciones necesita una cuenta propia para entrar a la aplicación antes de ver cualquier información de la flota, y poder salir cuando termina.

## Flujo principal

1. El coordinador abre la aplicación y ve la pantalla de inicio de sesión.
2. El coordinador escribe su correo y su contraseña y confirma.
3. El sistema valida las credenciales y, si son correctas, muestra el panel de flota con su nombre.

## Flujos alternos

- **A1 · Credenciales incorrectas:** el sistema avisa que el correo o la contraseña no son correctos y deja los campos listos para intentar de nuevo.
- **A2 · Sesión ya iniciada:** si el coordinador ya había iniciado sesión antes, la aplicación lo lleva directo al panel de flota sin pedir las credenciales otra vez.
- **A3 · Crear cuenta:** desde el inicio de sesión, una persona sin cuenta elige crearla, escribe su nombre, su correo y una contraseña, y confirma. El sistema crea la cuenta como coordinador y la lleva al panel de flota.
- **A4 · Correo ya registrado:** si el correo de la cuenta nueva ya tiene cuenta, el sistema lo avisa y no crea otra.
- **A5 · Cerrar sesión:** desde cualquier sección, el coordinador cierra sesión y vuelve al inicio de sesión; con el botón atrás no puede volver a la información de la flota.

## Reglas

- Solo se puede ver el panel de flota y el resto de la información si hay una sesión iniciada.
- Toda cuenta nueva queda con el rol de coordinador de operaciones.
- El nombre, el correo y la contraseña son obligatorios para crear una cuenta; la contraseña tiene al menos 6 caracteres.
- Solo entra una cuenta activa con el rol de coordinador.

## Estados

- **Cargando:** mientras el sistema valida las credenciales o crea la cuenta, el coordinador ve que se está procesando y no puede confirmar dos veces.
- **Vacío:** no aplica.
- **Error:** si no hay conexión, las credenciales son incorrectas o el correo ya existe, el coordinador ve un mensaje explicando qué pasó y puede volver a intentarlo.

## Datos

- Nombre, correo y contraseña del coordinador.

## Criterios de aceptación

- **CA-1** Dado que el coordinador escribe un correo y contraseña válidos, cuando confirma, entonces entra al panel de flota.
- **CA-2** Dado que el coordinador escribe una contraseña incorrecta, cuando confirma, entonces ve un mensaje de error y permanece en la pantalla de inicio de sesión.
- **CA-3** Dado que no hay conexión, cuando el coordinador confirma, entonces ve un mensaje de que no se pudo validar y puede reintentar.
- **CA-4** Dado que el coordinador ya tiene una sesión iniciada, cuando abre la aplicación, entonces entra directo al panel de flota sin ver la pantalla de inicio de sesión.
- **CA-5** Dado que una persona sin cuenta escribe nombre, correo y una contraseña de al menos 6 caracteres, cuando confirma, entonces entra al panel de flota y su nombre aparece en el menú.
- **CA-6** Dado que el correo de la cuenta nueva ya está registrado, cuando la persona confirma, entonces ve un aviso de que ese correo ya tiene cuenta y permanece en el formulario.
- **CA-7** Dado que el coordinador tiene una sesión iniciada, cuando cierra sesión, entonces vuelve al inicio de sesión, y al abrir de nuevo la aplicación se le piden las credenciales.

## Fuera de alcance

- Recuperar contraseña olvidada.
- Confirmar el correo de la cuenta nueva.
- Roles distintos al de coordinador de operaciones.

## Preguntas abiertas

- Ninguna.

## Historial

- 1.0.0 · 2026-11-27 · Implementada.
- 1.0.0 · 2026-11-26 · Aprobada para la Entrega 3. Pasa de «Iniciar sesión» a «Cuenta y sesión»: se agregan crear cuenta (A3, A4) y cerrar sesión (A5), con CA-5 a CA-7, por RF-14. Se quita la regla de que las cuentas las crea administración y se cierra la pregunta abierta (recuperar contraseña queda fuera de alcance).
- 0.2.0 · 2026-11-06 · Se agregó CA-4 para cubrir el flujo alterno A2 (sesión ya iniciada).
- 0.1.0 · 2026-11-06 · Primera versión.
