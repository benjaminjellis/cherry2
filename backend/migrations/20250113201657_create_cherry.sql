create table coffees(
  id uuid primary key not null,
  user_id uuid not null,
  name text not null,
  roaster uuid not null,
  roast_date date not null,
  origins text not null,
  varetial text,
  process text,
  tasting_notes text,
  liked bool not null
) ;


create table roasters(
  id uuid primary key not null,
  name text not null
);

create table experiments(
	id uuid primary key not null,
  date date not null,
	coffee_id uuid not null,
	variant text not null,
	grinder text,
	grind_setting text,
	recipe text not null,
	liked bool not null,
	user_id uuid not null
);
