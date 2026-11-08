# Lumaré Maldives (fictional resort)

Static site: `index.html` (home) and `booking.html` (reservation request). No build step. Host on GitHub Pages as-is.

## Turn on the booking backend (Supabase)
1. Create a Supabase project, open **SQL editor**, paste and run `supabase/schema.sql`.
2. Put the project URL and the **anon/publishable** key in `config.js`. Never use the service_role key here.
3. Requests then appear in **Table editor > booking_requests**. Visitors can only insert; they cannot read, edit or delete anything (Row Level Security).

Until `config.js` is filled in, the booking page says online booking is not connected and offers an email fallback. It never shows a success message unless the database accepts the request.

## What it is not (yet)
There is no live availability or payment. Requests are confirmed by a person, who then sends a payment link. Add a payments provider and an availability check when ready.
