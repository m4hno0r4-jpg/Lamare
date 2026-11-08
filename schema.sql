-- Lumaré booking requests. Run once in the Supabase SQL editor.
create table if not exists public.booking_requests (
  id            uuid primary key default gen_random_uuid(),
  reference     text not null unique check (reference ~ '^LM-[A-Z0-9]{6}$'),
  status        text not null default 'new' check (status in ('new','confirmed','declined','cancelled')),
  villa         text not null check (villa in ('beach','water','sunset')),
  check_in      date not null,
  check_out     date not null,
  guests        int  not null check (guests between 1 and 4),
  extras        jsonb not null default '[]'::jsonb,
  offer         text,
  estimated_total numeric(10,2) not null check (estimated_total >= 0),
  guest_name    text not null check (char_length(guest_name) between 2 and 120),
  guest_email   text not null check (guest_email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$' and char_length(guest_email) <= 200),
  guest_phone   text check (char_length(guest_phone) <= 40),
  arrival_info  text check (char_length(arrival_info) <= 200),
  requests      text check (char_length(requests) <= 2000),
  created_at    timestamptz not null default now(),
  constraint dates_ok check (check_out > check_in and check_in >= current_date - 1)
);
create index if not exists booking_requests_created_idx on public.booking_requests (created_at desc);

alter table public.booking_requests enable row level security;

-- Website visitors (anon) may ONLY add a request in its initial state. They cannot read, edit or delete anything.
drop policy if exists "anon can submit a request" on public.booking_requests;
create policy "anon can submit a request" on public.booking_requests
  for insert to anon with check (status = 'new');
-- Reading and managing requests is done by the team from the Supabase dashboard (service role), never from the website.
