# Marmuz — complete launch-ready prototype

This repository contains the approved Marmuz landing artwork plus functional CUET/Regulatory/Economy/Schemes/Resources navigation, public lecture display, Supabase-ready configuration, admin login and admin content dashboard.

## Files
- `index.html` — Marmuz public website. The supplied landing artwork is preserved.
- `config.js` — Supabase URL + publishable/anon key placeholders.
- `login.html` — admin email/password login.
- `admin.html` — protected admin dashboard for lectures/resources.
- `supabase/schema.sql` — database tables + RLS policies.

## Supabase setup
1. Create a Supabase project.
2. Open SQL Editor and run `supabase/schema.sql`.
3. In Authentication > Users, create the admin user with email/password.
4. Run the final `insert into public.profiles...` statement from the SQL file after replacing the email.
5. Copy the project URL and publishable/anon key into `config.js`.
6. Commit the change to GitHub.

Never put the Supabase `service_role`/secret key in the website.

## GitHub Pages test
Settings → Pages → Deploy from branch → `main` → `/ (root)`.

## Cloudflare Pages
Connect this GitHub repository. No build command is needed for this static version. Publish directory is the repository root.
