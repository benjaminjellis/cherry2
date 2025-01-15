create table coffees(
  id uuid primary key not null,
  user_id uuid not null,
  name text not null,
  roaster uuid not null,
  roast_date date not null,
  origin text not null,
  varetial text not null,
  process text not null,
  tasting_notes text not null,
  liked bool not null,
  in_current_rotation bool not null,
  added timestamp not null,
  last_updated timestamp not null
);

create table roasters(
  id uuid primary key not null,
  name text not null
);

create table experiments(
	id uuid primary key not null,
  date date not null,
	coffee_id uuid not null,
	variant text not null,
	grinder text not null,
	grind_setting text not null,
	recipe text not null,
	liked bool not null,
	user_id uuid not null,
  notes text not null,
  added timestamp not null,
  last_updated timestamp not null
);
