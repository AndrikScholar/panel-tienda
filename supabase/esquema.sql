-- Copia todo este archivo en Supabase > SQL Editor y presiona Run.

create table if not exists public.documentos (
  owner uuid not null default auth.uid() references auth.users(id) on delete cascade,
  coleccion text not null check (coleccion in ('clientes','productos','pedidos','cotizaciones','movimientos','config')),
  id text not null,
  data jsonb not null,
  updated_at timestamptz not null default now(),
  primary key (owner, coleccion, id)
);

alter table public.documentos enable row level security;
grant select, insert, update, delete on public.documentos to authenticated;

drop policy if exists "leer lo propio" on public.documentos;
drop policy if exists "crear lo propio" on public.documentos;
drop policy if exists "editar lo propio" on public.documentos;
drop policy if exists "borrar lo propio" on public.documentos;

create policy "leer lo propio" on public.documentos
  for select to authenticated using (owner = (select auth.uid()));
create policy "crear lo propio" on public.documentos
  for insert to authenticated with check (owner = (select auth.uid()));
create policy "editar lo propio" on public.documentos
  for update to authenticated using (owner = (select auth.uid())) with check (owner = (select auth.uid()));
create policy "borrar lo propio" on public.documentos
  for delete to authenticated using (owner = (select auth.uid()));

-- Fotos del catálogo y logo. Quien tenga el enlace exacto de una foto puede verla.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('fotos', 'fotos', true, 5242880, array['image/jpeg'])
on conflict (id) do update
  set public = true, file_size_limit = 5242880, allowed_mime_types = array['image/jpeg'];

drop policy if exists "subir fotos propias" on storage.objects;
drop policy if exists "ver fotos propias" on storage.objects;
drop policy if exists "borrar fotos propias" on storage.objects;

create policy "subir fotos propias" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'fotos' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "ver fotos propias" on storage.objects
  for select to authenticated
  using (bucket_id = 'fotos' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "borrar fotos propias" on storage.objects
  for delete to authenticated
  using (bucket_id = 'fotos' and (storage.foldername(name))[1] = (select auth.uid())::text);
