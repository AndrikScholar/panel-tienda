# Panel de la tienda

Panel interno para una tienda de manualidades: pedidos, clientes, cotizaciones, catálogo, calculadora de precios y finanzas, en pesos mexicanos. Los datos se guardan en Supabase y se entra con correo y contraseña.

## Puesta en marcha

### 1. Base de datos
1. Crea una cuenta y un proyecto en [supabase.com](https://supabase.com).
2. Abre **SQL Editor**, pega todo el contenido de `supabase/esquema.sql` y presiona **Run**.
3. En **Authentication > Users > Add user > Create new user**, crea la cuenta de la dueña con su correo y una contraseña temporal. Marca **Auto Confirm User**.
4. En la configuración de **Authentication**, desactiva **Allow new users to sign up** para que nadie más pueda registrarse.

### 2. Conexión
En **Project Settings**, busca la URL del proyecto y la clave pública (`publishable` o `anon`). Pégalas en `config.js`.

Nunca uses la clave `secret` ni la `service_role` en este proyecto.

### 3. Publicación
En el repositorio de GitHub, entra a **Settings > Pages**, elige **Deploy from a branch**, la rama `main` y la carpeta `/ (root)`, y guarda. En unos minutos GitHub muestra el enlace del panel.

## Si se olvida la contraseña
Ejecuta esto en **SQL Editor**, con el correo y una contraseña temporal de al menos 8 caracteres. Después se puede cambiar desde **Configuración** en el panel.

```sql
update auth.users
set encrypted_password = extensions.crypt('CONTRASEÑA_TEMPORAL', extensions.gen_salt('bf'))
where email = 'correo@ejemplo.com';
```

## Plan gratuito de Supabase
El plan gratuito pausa los proyectos después de una semana sin actividad. Se reactivan desde el panel de Supabase sin perder los datos. No incluye copias de seguridad descargables, así que conviene revisar los planes si el negocio llega a depender por completo de este panel.
