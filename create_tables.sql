DROP TABLE IF EXISTS player CASCADE;
DROP TABLE IF EXISTS planet CASCADE;
DROP TABLE IF EXISTS resource CASCADE;
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS mutagen CASCADE;
DROP TABLE IF EXISTS upgrade CASCADE;
DROP TABLE IF EXISTS upgradeResource CASCADE;
DROP TABLE IF EXISTS upgradeMutagen CASCADE;
DROP TABLE IF EXISTS specimen CASCADE;
DROP TABLE IF EXISTS playableKind CASCADE;
DROP TABLE IF EXISTS event CASCADE;
DROP TABLE IF EXISTS eventInstance CASCADE;
DROP TABLE IF EXISTS eventEffect CASCADE;
DROP TABLE IF EXISTS effectApplied CASCADE;
DROP TABLE IF EXISTS player_species CASCADE;


CREATE TYPE resource_type AS ENUM ('food', 'upgrade_material');
CREATE TYPE effect_type AS ENUM ('numeric','ability');
CREATE TYPE mod_operation AS ENUM ('add','mul', 'sub', 'div', 'set');
CREATE TYPE water_level AS ENUM ('drought', 'low', 'normal', 'high', 'flood');
CREATE TYPE diet AS ENUM ('herbivorous', 'carnivorous', 'omnivorous');
CREATE TYPE immunity AS ENUM ('victorian child', 'bad', 'normal', 'high', 'the healthiest');
CREATE TYPE communication AS ENUM ('hostile', 'unfriendly', 'indifferent',
                   'neutral', 'curios', 'friendly', 'charming');
CREATE TYPE effect AS ENUM ('bad', 'neutral', 'good');
CREATE TYPE species_type AS ENUM ('neutral', 'prey', 'predator', 'simbiote', 'parasite');
CREATE TYPE danger_type AS ENUM ('competitor', 'predator', 'parasite');
CREATE TYPE ability AS ENUM ('flight', 'night_vision', 'regeneration');
CREATE TYPE upgrade_type AS ENUM ('random_mutagen', 'mutagen_chance', 'mutagen_upgrade',
                        'species_stat_upgrade', 'planet_stat_upgrade');

CREATE TABLE player (
 id serial PRIMARY KEY,
 level smallint NOT NULL DEFAULT 1
    CHECK (level > 0 and level < 30),
 level_points smallint DEFAULT 0
    CHECK (level_points BETWEEN 0 AND 1000),
 money_amount smallint NOT NULL DEFAULT 100 -- в норме начинаем со 100
    CHECK (money_amount >= 0),
 planet_id int references planet (id),
 player_id_planet_unique int NOT NULL 
 	UNIQUE (id, planet_id) --кусок проверки соответствия ресурсов в инвентаре с планетой
);

CREATE TABLE planet (
  id serial PRIMARY KEY,
  name text NOT NULL,
  description text NOT NULL,
  biome text NOT NULL,
  stability smallint NOT NULL DEFAULT 100
    CHECK (stability >= 0 AND stability <= 200),
  water_level water_level NOT NULL DEFAULT 'normal',
  production_speed numeric(3,2) NOT NULL DEFAULT 1.00
      CHECK (production_speed BETWEEN 0 AND 2)
);

CREATE TABLE resource (
  id serial PRIMARY KEY,
  planet_id smallint NOT NULL REFERENCES planet (id),
  name text NOT NULL,
  description text NOT NULL,
  type resource_type NOT NULL,
  extraction_time smallint NOT NULL
    CHECK (extraction_time >= 0)
  resource_id_planet_unique int NOT NULL
  	UNIQUE (id, planet_id) --кусок проверки соответствия ресурсов в инвентаре с планетой
);

CREATE TABLE inventory ( --ресурсы игрока
    player_id int NOT NULL,
    resource_id int NOT NULL,
    planet_id int NOT NULL,
    count smallint NOT NULL CHECK (count >= 0),

    PRIMARY KEY (player_id, resource_id),

    FOREIGN KEY (player_id, planet_id)
        REFERENCES player (id, planet_id),

    FOREIGN KEY (resource_id, planet_id)
        REFERENCES resource (id, planet_id)
);

CREATE TABLE player_species (
  id serial PRIMARY KEY,
  player_id int NOT NULL REFERENCES player (id) UNIQUE,
  name text NOT NULL,
  description text NOT NULL,
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

CREATE TABLE species ( -- другие виды
  id serial PRIMARY KEY,
  planet_id int NOT NULL REFERENCES planet (id),
  name text NOT NULL,
  description text NOT NULL,
  type species_type NOT NULL, -- вычисляется в коде через диеты
  danger_type danger_type, -- соперник влияет на производство еды
  danger_level smallint
    CHECK (danger_level >= 1),
  diet diet NOT NULL,
  birthrate numeric(3,2) NOT NULL DEFAULT 1.00
    CHECK (birthrate BETWEEN 0 AND 1),
  lifespan smallint NOT NULL DEFAULT 1, -- в годах
  immunity immunity NOT NULL,
  intelligence smallint NOT NULL DEFAULT 10,
  strength smallint NOT NULL DEFAULT 10,
  communication communication NOT NULL
);

-- у вида игрока и других слишком много одинаковых статов, подумать над тем, чтобы их вынести

CREATE TABLE mutagen ( -- жабры, крылья, ...
  id serial PRIMARY KEY,
  name text NOT NULL,
  description text NOT NULL,
  type effect NOT NULL,
  development_chance numeric(3,2) NOT NULL
    CHECK (development_chance BETWEEN 0 AND 1)
);

CREATE TABLE mutagen_effect ( -- конкретно эффект мутагена, не апгрейд
    id serial PRIMARY KEY,
    mutagen_id int NOT NULL REFERENCES mutagen(id),
    effect_type effect_type NOT NULL,-- для numeric (меняет знач. сущ. характеристики)
    attribute_name text DEFAULT NULL, -- birthrate, strength...
    modifier_value numeric(5,2) DEFAULT NULL, -- сколько прибавляет/отнимает, тд
    mod_operation mod_operation DEFAULT NULL, -- какая операция между нашим value и изнач. значением

    -- для ability (дает абилку: полет, ночное видение, ...)
    ability_code ability DEFAULT NULL
);

CREATE TABLE player_mutagen (
  player_id int NOT NULL REFERENCES player (id),
  mutagen_id int NOT NULL REFERENCES mutagen (id),
  PRIMARY KEY (player_id, mutagen_id)
);

CREATE TABLE upgrade ( -- список улучшений
 id serial PRIMARY KEY,
 name text NOT NULL,
 description text NOT NULL,
 price_money smallint NOT NULL
    CHECK (price_money >= 0),
 upgrade_type upgrade_type NOT NULL,
 target_mutagen_id int REFERENCES mutagen (id) DEFAULT NULL, -- добавить проверку
 target_type effect DEFAULT NULL, -- имеет смысл при мутаген_шанс, потом добавить проверку
 modifier_value numeric(5,2) DEFAULT NULL -- сколько прибавляет/отнимает, тд
    CHECK (modifier_value >= 0),
 mod_operation mod_operation DEFAULT NULL -- какая операция между нашим value и изнач. значением
);

CREATE TABLE upgrade_resource_price (
  upgrade_id int NOT NULL REFERENCES upgrade (id),
  resource_id int NOT NULL REFERENCES resource (id),
  count smallint
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
    level smallint NOT NULL CHECK (level >= 1),
    PRIMARY KEY (player_id, mutagen_id, upgrade_id, mutagen_effect_id),
    FOREIGN KEY (mutagen_id, upgrade_id, mutagen_effect_id)
        REFERENCES mutagen_upgrade(mutagen_id, upgrade_id, mutagen_effect_id), -- т.к. составной ключ
    FOREIGN KEY (player_id, mutagen_id)
        REFERENCES player_mutagen(player_id, mutagen_id) -- тоже
);

-----------------------------------------

CREATE TYPE event_type AS ENUM('disaster', 'miracle');
CREATE TYPE event_target AS ENUM('species', 'planet', 'resource', 'mutagen');
CREATE TYPE species_attribute_names AS ENUM('birthrate', 'lifespan', 'strength', 'intelligence');
CREATE TYPE planet_attribute_names AS ENUM ('stability', 'production_speed');
CREATE TYPE resource_attribute_names AS ENUM ('extraction_time');
CREATE TYPE mutagen_attribute_names AS ENUM ('development_chance');

CREATE TABLE event (
  id serial PRIMARY KEY,
  name text NOT NULL,
  type event_type NOT NULL,
  description text,
  event_chance smallint NOT NULL
    CHECK ((0 < event_chance) AND (event_chance <= 100))
);

CREATE TABLE event_instance (
  id serial PRIMARY KEY,
  event_id smallint REFERENCES event (id),
  date_started text NOT NULL,
  date_ended text
);

CREATE TABLE event_effect (
  id serial PRIMARY KEY,
  target_entity event_target,
  attribute_name attribute_names
    CHECK ((target_entity = 'species' AND attribute_name IN species_attribute_names)
    OR (target_entity = 'planet' AND attribute_name IN planet_attribute_names)
    OR (target_entity = 'resource' AND attribute_name IN resource_attribute_names)
    OR (target_entity = 'mutagen' AND attribute_name IN mutagen_attribute_names))
);

CREATE TABLE effectApplied (
	event_effect_id smallint,
	event_instance_id smallint,
	planet_id smallint,
	species_id smallint,
	resource_id smallint,
	mutagen_id smallint,
	value_delta smallint,
	FOREIGN KEY(event_effect_id) REFERENCES event_effect (id),
	FOREIGN KEY(event_instance_id) REFERENCES event_instance (id),
	FOREIGN KEY(planet_id) REFERENCES planet (id),
	FOREIGN KEY(species_id) REFERENCES species (id),
	FOREIGN KEY(resource_id) REFERENCES resource (id),
	FOREIGN KEY(mutagen_id) REFERENCES mutagen (id)
);

