-- SkillSwap Schema
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard/project/cowwlpiatpyiadrllkzr/sql

-- 1. PROFILES (extends Supabase auth.users)
create table if not exists profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  full_name text,
  email text,
  role text check (role in ('client','freelancer')) default 'client',
  avatar_url text,
  bio text,
  skills text[],
  hourly_rate numeric(10,2),
  location text,
  stripe_customer_id text,
  created_at timestamp with time zone default now()
);

-- Auto-create profile on signup
create or replace function handle_new_user()
returns trigger as $$
begin
  insert into profiles (id, email, full_name)
  values (new.id, new.email, new.raw_user_meta_data->>'full_name');
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure handle_new_user();

-- 2. JOBS
create table if not exists jobs (
  id uuid default gen_random_uuid() primary key,
  client_id uuid references profiles(id) on delete cascade,
  title text not null,
  description text,
  category text,
  budget numeric(10,2),
  deadline date,
  status text check (status in ('open','in_progress','completed','cancelled')) default 'open',
  urgent boolean default false,
  created_at timestamp with time zone default now()
);

-- 3. BIDS
create table if not exists bids (
  id uuid default gen_random_uuid() primary key,
  job_id uuid references jobs(id) on delete cascade,
  freelancer_id uuid references profiles(id) on delete cascade,
  amount numeric(10,2) not null,
  cover_letter text,
  status text check (status in ('pending','accepted','rejected')) default 'pending',
  created_at timestamp with time zone default now(),
  unique(job_id, freelancer_id)
);

-- 4. PAYMENTS
create table if not exists payments (
  id uuid default gen_random_uuid() primary key,
  job_id uuid references jobs(id),
  client_id uuid references profiles(id),
  freelancer_id uuid references profiles(id),
  amount numeric(10,2),
  platform_fee numeric(10,2),
  stripe_payment_intent_id text,
  status text check (status in ('pending','escrowed','released','refunded')) default 'pending',
  created_at timestamp with time zone default now()
);

-- 5. ROW LEVEL SECURITY
alter table profiles enable row level security;
alter table jobs enable row level security;
alter table bids enable row level security;
alter table payments enable row level security;

-- Profiles: anyone can read, only owner can write
create policy "Public profiles readable" on profiles for select using (true);
create policy "Users update own profile" on profiles for update using (auth.uid() = id);

-- Jobs: anyone can read open jobs, only owner can insert/update
create policy "Anyone can read jobs" on jobs for select using (true);
create policy "Clients can post jobs" on jobs for insert with check (auth.uid() = client_id);
create policy "Clients can update own jobs" on jobs for update using (auth.uid() = client_id);

-- Bids: freelancers can insert, job owner + bidder can read
create policy "Anyone can read bids" on bids for select using (true);
create policy "Freelancers can bid" on bids for insert with check (auth.uid() = freelancer_id);
create policy "Freelancers update own bids" on bids for update using (auth.uid() = freelancer_id);

-- Payments: only parties involved can read
create policy "Parties can view payments" on payments for select
  using (auth.uid() = client_id or auth.uid() = freelancer_id);
create policy "System inserts payments" on payments for insert with check (true);
