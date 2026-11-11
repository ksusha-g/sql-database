DROP TABLE IF EXISTS planet CASCADE;
DROP TABLE IF EXISTS player CASCADE;
DROP TABLE IF EXISTS resource CASCADE;
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS player_species CASCADE;
DROP TABLE IF EXISTS species CASCADE;
DROP TABLE IF EXISTS mutagen CASCADE;
DROP TABLE IF EXISTS mutagen_effect CASCADE;
DROP TABLE IF EXISTS player_mutagen CASCADE;
DROP TABLE IF EXISTS upgrade CASCADE;
DROP TABLE IF EXISTS upgrade_resource_price CASCADE;
DROP TABLE IF EXISTS player_upgrade CASCADE;
DROP TABLE IF EXISTS mutagen_upgrade CASCADE;
DROP TABLE IF EXISTS player_mutagen_upgrade CASCADE;


CREATE TYPE water_level AS ENUM ('drought', 'low', 'normal', 'high', 'flood');

CREATE TABLE planet (
	id text PRIMARY KEY,
    name text NOT NULL,
    description text NOT NULL,
    biome text NOT NULL,
    stability numeric(3,2) NOT NULL DEFAULT 1
    	CHECK (stability BETWEEN 0 and 2),
    water_level water_level NOT NULL DEFAULT 'normal',
    production_speed numeric(3,2) NOT NULL DEFAULT 1
      	CHECK (production_speed BETWEEN 0 AND 2)
); 

CREATE TABLE player (
	id serial PRIMARY KEY,
	planet_id text NOT NULL REFERENCES planet (id),
	level smallint NOT NULL DEFAULT 1
    	CHECK (level BETWEEN 1 and 30),
	level_points smallint DEFAULT 0
    	CHECK (level_points BETWEEN 0 AND 1000),
	money_amount int NOT NULL DEFAULT 100 -- в норме начинаем со 100, int т.к. могут быть более большие значения
    	CHECK (money_amount >= 0),
	CONSTRAINT player_id_planet_unique UNIQUE (id, planet_id) --кусок проверки соответствия ресурсов в инвентаре с планетой
);

CREATE TYPE resource_type AS ENUM ('food', 'upgrade_material');

--айди обычный, тк ресурсов много
CREATE TABLE resource (
    id serial PRIMARY KEY,
    planet_id text NOT NULL REFERENCES planet (id),
    name text NOT NULL,
    type resource_type NOT NULL,
    extraction_time smallint NOT NULL
        CHECK (extraction_time >= 0),
    CONSTRAINT resource_id_planet_unique UNIQUE (id, planet_id)
);

CREATE TABLE inventory ( --ресурсы игрока
    player_id int NOT NULL,
    resource_id int NOT NULL,
    planet_id text NOT NULL,
    count smallint NOT NULL CHECK (count >= 0),

    PRIMARY KEY (player_id, resource_id),
    FOREIGN KEY (player_id, planet_id)
        REFERENCES player (id, planet_id),
    FOREIGN KEY (resource_id, planet_id)
        REFERENCES resource (id, planet_id)
);

CREATE TYPE diet AS ENUM ('herbivorous', 'carnivorous', 'omnivorous');
CREATE TYPE immunity AS ENUM ('victorian child', 'bad', 'normal', 'high', 'the healthiest');
CREATE TYPE communication AS ENUM ('hostile', 'unfriendly', 'indifferent', 'neutral', 'curios', 'friendly', 'charming');

CREATE TABLE player_species (
	id serial PRIMARY KEY,
  	player_id int NOT NULL REFERENCES player (id) UNIQUE,
  	name text NOT NULL,
  	diet diet NOT NULL,
  	birthrate numeric(3,2) NOT NULL DEFAULT 1.00
    	CHECK (birthrate BETWEEN 0 AND 2),
  	lifespan smallint NOT NULL DEFAULT 1, -- в годах
  	food_count smallint NOT NULL DEFAULT 100,
  	immunity immunity NOT NULL,
  	intelligence smallint NOT NULL DEFAULT 10,
  	strength smallint NOT NULL DEFAULT 10,
  	communication communication NOT NULL
);

CREATE TYPE species_type AS ENUM ('neutral', 'prey', 'predator', 'simbiote', 'parasite');

CREATE TABLE species ( -- другие виды
	id serial PRIMARY KEY,
	planet_id text NOT NULL REFERENCES planet (id),
	name text NOT NULL,
    description text NOT NULL,
    type species_type NOT NULL,
    danger_level smallint DEFAULT NULL
    	CHECK (danger_level >= 1),
    diet diet NOT NULL,
    birthrate numeric(3,2) NOT NULL DEFAULT 1.00
    	CHECK (birthrate BETWEEN 0 AND 2),
    lifespan smallint NOT NULL DEFAULT 1, -- в годах
    immunity immunity NOT NULL,
    intelligence smallint NOT NULL DEFAULT 10,
    strength smallint NOT NULL DEFAULT 10,
    communication communication NOT NULL
);

-- у вида игрока и других слишком много одинаковых статов, подумать над тем, чтобы их вынести

CREATE TYPE effect AS ENUM ('bad', 'neutral', 'good');

CREATE TABLE mutagen ( -- жабры, крылья, ...
  	id serial PRIMARY KEY, -- тоже будет много, не знаю, насколько уместен текст
  	name text NOT NULL,
  	description text NOT NULL,
  	type effect NOT NULL,
  	development_chance numeric(3,2) NOT NULL
    	CHECK (development_chance BETWEEN 0 AND 1)
);

CREATE TYPE mutagen_effect_type AS ENUM ('numeric','ability');
CREATE TYPE mod_operation AS ENUM ('add','mul', 'sub', 'div', 'set');

CREATE TABLE mutagen_effect ( -- конкретно эффект мутагена, не апгрейд
	id serial PRIMARY KEY,
    mutagen_id int NOT NULL REFERENCES mutagen(id),
    effect_type mutagen_effect_type NOT NULL,-- для numeric (меняет знач. сущ. характеристики)
    attribute_name text DEFAULT NULL, -- birthrate, strength...
    modifier_value numeric(5,2) DEFAULT NULL, -- сколько прибавляет/отнимает, тд
    mod_operation mod_operation DEFAULT NULL, -- какая операция между нашим value и изнач. значением

    -- для ability (дает абилку: полет, ночное видение, ...)
    ability_code text DEFAULT NULL -- убрала ability AS ENUM ('flight', 'night_vision', 'regeneration') - у нас не огранич. список
    	CHECK (
		  (effect_type = 'numeric' AND attribute_name IS NOT NULL 
		   AND modifier_value IS NOT NULL AND mod_operation IS NOT NULL 
		   AND ability_code IS NULL)
		  OR
		  (effect_type = 'ability' AND ability_code IS NOT NULL 
		   AND attribute_name IS NULL AND modifier_value IS NULL 
		   AND mod_operation IS NULL)
		)
);

CREATE TABLE player_mutagen (
  	player_id int NOT NULL REFERENCES player (id),
  	mutagen_id int NOT NULL REFERENCES mutagen (id),
  	PRIMARY KEY (player_id, mutagen_id)
);

CREATE TYPE upgrade_type AS ENUM ('random_mutagen', 'mutagen_chance', 'mutagen_upgrade',
                        'species_stat_upgrade', 'planet_stat_upgrade');

CREATE TABLE upgrade ( -- список улучшений
 	id serial PRIMARY KEY,
 	name text NOT NULL,
 	description text NOT NULL, -- что делает
 	price_money smallint NOT NULL
    	CHECK (price_money >= 0),
 	upgrade_type upgrade_type NOT NULL,
 	-- для числового влияния
 	target_mutagen_id int REFERENCES mutagen (id) DEFAULT NULL, -- добавить проверку -- апдейт: там оч много, не надо
 	target_type effect DEFAULT NULL, -- имеет смысл при мутаген_шанс, потом добавить проверку -- тоже не помню...
 	modifier_value numeric(5,2) DEFAULT NULL -- сколько прибавляет/отнимает, тд
    	CHECK (modifier_value >= 0),
 	mod_operation mod_operation DEFAULT NULL -- какая операция между нашим value и изнач. значением
);

CREATE TABLE upgrade_resource_price (
  	upgrade_id int NOT NULL REFERENCES upgrade (id),
  	resource_id int NOT NULL REFERENCES resource (id),
  	count smallint NOT NULL
    	CHECK (count >= 0),
  	PRIMARY KEY (upgrade_id, resource_id)
);

CREATE TABLE player_upgrade ( -- какие апгрейды есть у игрока
  	player_id int NOT NULL REFERENCES player (id),
  	upgrade_id int NOT NULL REFERENCES upgrade (id),
  	level smallint NOT NULL
    	CHECK (level >= 1),
  	PRIMARY KEY (player_id, upgrade_id)
);

CREATE TABLE mutagen_upgrade ( -- справочник: какие апгрейды есть у мутагена (в целом)
    mutagen_id int NOT NULL REFERENCES mutagen(id),
    upgrade_id int NOT NULL REFERENCES upgrade(id),
    mutagen_effect_id int NOT NULL REFERENCES mutagen_effect(id),
    max_level  smallint NOT NULL DEFAULT 1
    	CHECK (max_level BETWEEN 1 AND 5),
    PRIMARY KEY (mutagen_id, upgrade_id, mutagen_effect_id)
);

CREATE TABLE player_mutagen_upgrade (
    player_id  int NOT NULL, -- не пишем референс тут, т.к. это часть составного ключа
    mutagen_id int NOT NULL,
    upgrade_id int NOT NULL,
    mutagen_effect_id int NOT NULL,
    level smallint NOT NULL 
		CHECK (level >= 1),
    PRIMARY KEY (player_id, mutagen_id, upgrade_id, mutagen_effect_id),
    FOREIGN KEY (mutagen_id, upgrade_id, mutagen_effect_id)
        REFERENCES mutagen_upgrade(mutagen_id, upgrade_id, mutagen_effect_id), -- т.к. составной ключ
    FOREIGN KEY (player_id, mutagen_id)
        REFERENCES player_mutagen(player_id, mutagen_id) -- тоже
);

-----------------------------------------

-- ивенты решили убрать
