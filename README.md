# FiltroCV

App web (PC y celular) para **analizar** y **crear** CVs pensados para los filtros ATS. Tema naranja y negro. Sin build: es un solo `index.html`.

## Qué hace
- **Login**: mail + contraseña o cuenta de Google (Supabase Auth).
- **Analizar CV**: subís PDF, Word o TXT. Devuelve un puntaje 0–100, qué sacar, qué agregar y qué mejorar. Si pegás una oferta laboral, mide la coincidencia de palabras clave.
- **Crear CV**: asistente paso a paso. Descarga en **PDF** (texto real, legible por ATS) y **Word**, y guarda los CVs en tu cuenta.
- **Modo demo**: si no configurás Supabase, todo funciona guardando en el navegador (sin Google ni sincronización).

## 1. Subir a GitHub y publicarlo gratis
1. Creá un repositorio nuevo en GitHub (por ejemplo `filtrocv`).
2. Subí `index.html`, `supabase.sql` y este `README.md`.
3. En el repo: **Settings → Pages → Build and deployment → Source: Deploy from a branch → Branch: `main` / `(root)` → Save**.
4. En 1–2 minutos queda en `https://TU-USUARIO.github.io/filtrocv/`.

## 2. Conectar la base de datos gratuita (Supabase)
1. Entrá a https://supabase.com, creá una cuenta y un **New project** (plan Free).
2. **SQL Editor → New query**: pegá el contenido de `supabase.sql` y ejecutá (**Run**).
3. **Project Settings → API**: copiá la **Project URL** y la clave **anon public**.
4. Abrí `index.html` y pegalas arriba de todo, en `CFG`:
   ```js
   const CFG={SUPABASE_URL:"https://xxxx.supabase.co",SUPABASE_ANON_KEY:"eyJ..."};
   ```
   La clave `anon` es pública por diseño; la seguridad la dan las reglas por usuario (RLS) del SQL. **Nunca pongas la clave `service_role`.**
5. **Authentication → URL Configuration**: en *Site URL* poné la URL de tu GitHub Pages.

### Activar el login con Google
1. En https://console.cloud.google.com creá un proyecto → **APIs y servicios → Credenciales → Crear credenciales → ID de cliente de OAuth** (tipo *Aplicación web*).
2. En *URI de redireccionamiento autorizados* poné la que te muestra Supabase en **Authentication → Providers → Google** (`https://xxxx.supabase.co/auth/v1/callback`).
3. Copiá *Client ID* y *Client Secret* a ese mismo panel de Supabase y activá Google.
4. El login con mail funciona sin pasos extra (Supabase envía un mail de confirmación).

## 3. IA más adelante (opcional)
El análisis actual usa reglas propias y es gratis. Para sumar IA sin exponer tu API key, creá una **Supabase Edge Function** que reciba el texto del CV y llame a la API de Claude con la clave guardada como *secret*. El front solo llamaría a esa función. No pongas la API key en `index.html`.

## Criterios que usa el analizador
Texto legible (no escaneado), email y teléfono, LinkedIn, secciones con títulos estándar (Experiencia, Educación, Habilidades, Perfil, Idiomas), fechas, extensión (1–2 páginas), logros con números, verbos de acción, ausencia de datos innecesarios (DNI, edad, estado civil, foto, dirección completa, pretensión salarial), símbolos que los ATS no leen y coincidencia con las palabras clave de la oferta.

> Los puntajes son una estimación orientativa: cada empresa configura su ATS de forma distinta.

## Qué se investigó y cómo se aplicó

**Cómo funcionan los ATS**
- Organizan y filtran CVs por palabras clave, habilidades, experiencia, ubicación y nivel educativo. Algunos sistemas buscan coincidencia exacta de términos, por eso la app recomienda escribir la sigla y el nombre completo.
- Sobre el "rechazo automático": las fuentes relevadas discrepan en las cifras, y varias aclaran que el ATS ordena y filtra pero no siempre descarta. Por eso el informe habla de probabilidad y no de aprobado o rechazado.
- Recomendaciones comunes: una sola columna, sin gráficos ni encabezados decorativos, PDF con texto seleccionable o DOCX, y perfil de 3 a 4 líneas (formato tipo Harvard).

**Qué poner y qué no (Argentina)**
- Sacar: DNI, estado civil, hijos, edad, dirección exacta, referencias "a disposición".
- La ley de Currículum Equitativo de CABA (2021) excluye del CV datos como estado civil, dirección o lugar de residencia e hijos. Ciudad y provincia se mantienen porque los ATS filtran por ubicación.
- La foto es opcional en Argentina; el ATS no la lee, así que la app recomienda omitirla en postulaciones por portal.
- Nota: algunos sitios oficiales y notas antiguas todavía listan DNI y estado civil como datos del CV. La app sigue el criterio actual de no incluirlos.

**Mercado y postulaciones**
- Computrabajo es el portal con más avisos; Bumeran y ZonaJobs pertenecen al mismo grupo y comparten gran parte de sus publicaciones; LinkedIn es la principal vidriera profesional; Portal Empleo (Gobierno) concentra primer empleo y puestos operativos.
- Según Randstad Employer Brand Research 2026, la búsqueda es multicanal y el 26% de quienes consiguieron trabajo lo hizo por referidos.
- Cada vez se piden más habilidades por aviso, y la demanda de competencias en IA creció en los portales argentinos.

**Fuentes consultadas**
- iProfesional: plataformas para buscar trabajo en Argentina (2026).
- iProUP: plataformas más allá de LinkedIn; cómo consiguen trabajo los argentinos en 2026 (Randstad).
- Derecho en Zapatillas: ley de Currículum Equitativo de CABA.
- InfoNegocios: currículum ciego en Argentina.
- La Capital: cómo armar un CV (datos personales y foto).
- Platzi: optimización de CV para filtros ATS.
- Gurusup y JobMentis: funcionamiento y mitos de los ATS.
- Jobseeker: CV para Argentina.
