INSERT INTO player(planet_id, level, level_points, money_amount) VALUES (1, 1, 0, 2000);
INSERT INTO player(planet_id, level, level_points, money_amount) VALUES (2, 3, 626, 1);
INSERT INTO player(planet_id, level, level_points, money_amount) VALUES (4, 20, 999, 25838);

INSERT INTO planet(name, description, biome, stability, water_level, production_speed) VALUES ('avrora', 'cool planet for newers', 'blooming valley', 100, 'normal', 1.0);
INSERT INTO planet(name, description, biome, stability, water_level, production_speed) VALUES ('atlantis', 'a lot of water', 'underwater kingdom', 65, 'flood', 1.3);
INSERT INTO planet(name, description, biome, stability, water_level, production_speed) VALUES ('volcanium', 'hard planet. you will die!!!!!', 'volcanoes', 30, 'low', 2.0);
INSERT INTO planet(name, description, biome, stability, water_level, production_speed) VALUES ('solaris', 'a lot of rocks', 'rocky plains', 100, 'drought', 0.5);


INSERT INTO resource(planet_id, name, description, type, extraction_time) VALUES (1, 'pink fruit', 'text', 'food', 3);
INSERT INTO resource(planet_id, name, description, type, extraction_time) VALUES (1, 'pink quartz', 'text', 'upgrade_material', 15);

INSERT INTO resource(planet_id, name, description, type, extraction_time) VALUES (2, 'long algae', 'text', 'food', 5);
INSERT INTO resource(planet_id, name, description, type, extraction_time) VALUES (2, 'pearl', 'text', 'upgrade_material', 20);

INSERT INTO resource(planet_id, name, description, type, extraction_time) VALUES (3, 'grass', 'text', 'food', 7);
INSERT INTO resource(planet_id, name, description, type, extraction_time) VALUES (3, 'lava fish', 'text', 'food', 20);
INSERT INTO resource(planet_id, name, description, type, extraction_time) VALUES (3, 'obsidian', 'text', 'upgrade_material', 40);

INSERT INTO resource(planet_id, name, description, type, extraction_time) VALUES (4, 'dry moss', 'text', 'food', 5);
INSERT INTO resource(planet_id, name, description, type, extraction_time) VALUES (4, 'ugly stone', 'text', 'upgrade_material', 10);

INSERT INTO inventory(player_id, resource_id, planet_id, count) VALUES (1, 2, 1, 10);
INSERT INTO inventory(player_id, resource_id, planet_id, count) VALUES (1, 1, 1, 5);
INSERT INTO inventory(player_id, resource_id, planet_id, count) VALUES (2, 3, 2, 1);
INSERT INTO inventory(player_id, resource_id, planet_id, count) VALUES (2, 4, 2, 3);
INSERT INTO inventory(player_id, resource_id, planet_id, count) VALUES (3, 8, 4, 15);
INSERT INTO inventory(player_id, resource_id, planet_id, count) VALUES (3, 9, 4, 99);


INSERT INTO player_species(player_id, name, description, diet, birthrate, lifespan, food_count, immunity, intelligence, strength, communication) 
VALUES (1, 'мой вид', 'yt', 'herbivorous', 1, 6, 100, 'normal', 10, 10, 'neutral');

INSERT INTO player_species(player_id, name, description, diet, birthrate, lifespan, food_count, immunity, intelligence, strength, communication) 
VALUES (2, 'крысы', 'злые', 'carnivorous', 0.5, 1, 2, 'victorian child', 1, 1, 'hostile');

INSERT INTO player_species(player_id, name, description, diet, birthrate, lifespan, food_count, immunity, intelligence, strength, communication) 
VALUES (3, 'големы', 'лутающие', 'omnivorous', 2, 1000, 5000, 'the healthiest', 100, 100, 'charming');


INSERT INTO species(planet_id, name, description, type, diet, birthrate, lifespan, immunity, intelligence, strength, communication)
VALUES (1, 'bird', 'not dangerous', 'neutral', 'herbivorous', 1, 1, 'normal', 1, 1, 'curios');

INSERT INTO species(planet_id, name, description, type, danger_type, danger_level, diet, birthrate, lifespan, immunity, intelligence, strength, communication)
VALUES (1, 'tiger', 'evil cat', 'predator', 'predator', 5, 'carnivorous', 0.5, 15, 'high', 5, 15, 'unfriendly');

INSERT INTO species(planet_id, name, description, type, danger_type, danger_level, diet, birthrate, lifespan, immunity, intelligence, strength, communication)
VALUES (2, 'fish', 'stupid', 'parasite', 'parasite', 20, 'omnivorous', 0.3, 2, 'victorian child', 0, 1, 'hostile');

INSERT INTO species(planet_id, name, description, type, diet, birthrate, lifespan, immunity, intelligence, strength, communication)
VALUES (3, 'wise big snake', 'lava snake', 'neutral', 'carnivorous', 0.1, 120, 'the healthiest', 100, 10, 'charming');

INSERT INTO species(planet_id, name, description, type, danger_type, danger_level, diet, birthrate, lifespan, immunity, intelligence, strength, communication)
VALUES (4, 'rock lobster', 'playful and funny...', 'neutral', 'competitor', 1, 'omnivorous', 1, 5, 'high', 1, 5, 'unfriendly');


INSERT INTO mutagen(name, description, type, development_chance) 
VALUES ('жабры', 'помогают дышать под водой', 'good', 0.1);

INSERT INTO mutagen(name, description, type, development_chance) 
VALUES ('крылья', 'для ауры, нельзя летать', 'neutral', 0.6);

INSERT INTO mutagen(name, description, type, development_chance) 
VALUES ('лишняя нога', 'запинаешься', 'bad', 0.2);

INSERT INTO mutagen(name, description, type, development_chance) 
VALUES ('слепота', 'нет глаз', 'bad', 0.07);

INSERT INTO mutagen(name, description, type, development_chance) 
VALUES ('вонючка', 'ты воняешь', 'neutral', 0.3);

INSERT INTO mutagen(name, description, type, development_chance) 
VALUES ('электрошок', 'ты бьешь током', 'good', 0.01);




INSERT INTO event(name, type, description, event_chance) VALUES ('Exctinction', 'disaster', 'Some species goes extinct', 2);
INSERT INTO event(name, type, description, event_chance) VALUES ('Virus', 'disaster', 'Virus kills everyone', 5);
INSERT INTO event(name, type, description, event_chance) VALUES ('Earthquakes', 'disaster', 'A lot of earthquakes', 3);
INSERT INTO event(name, type, description, event_chance) VALUES ('Better environment', 'miracle', 'Better environmet improves production speed', 8);
INSERT INTO event(name, type, description, event_chance) VALUES ('Muscle and brain growth', 'miracle', 'More muscle and brain means more strength and intelligence', 6);

INSERT INTO event_effect(target_entity, attribute_name) VALUES ('species', 'birthrate');
INSERT INTO event_effect(target_entity, attribute_name) VALUES ('species', 'lifespan');
INSERT INTO event_effect(target_entity, attribute_name) VALUES ('species', 'strength');
INSERT INTO event_effect(target_entity, attribute_name) VALUES ('species', 'intelligence');

INSERT INTO event_instance(event_id, date_started) VALUES (1, '31st December 2012');
INSERT INTO event_instance(event_id, date_started) VALUES (2, '15th October 2019');
INSERT INTO event_instance(event_id, date_started, date_ended) VALUES (3, '31st December 2012', '1st January 2013');
INSERT INTO event_instance(event_id, date_started, date_ended) VALUES (4, '1st January 1', '1st January 2');
INSERT INTO event_instance(event_id, date_started) VALUES (5, '1st April 2000');

INSERT INTO effect_applied(event_effect_id, event_instance_id, species_id, value_delta) VALUES (1, 1, NULL, 1);
INSERT INTO effect_applied(event_effect_id, event_instance_id, species_id, value_delta) VALUES (1, 2, NULL, 0.5);
INSERT INTO effect_applied(event_effect_id, event_instance_id, species_id, value_delta) VALUES (2, 2, NULL, 10);
INSERT INTO effect_applied(event_effect_id, event_instance_id, species_id, value_delta) VALUES (3, 5, NULL, 15);
INSERT INTO effect_applied(event_effect_id, event_instance_id, species_id, value_delta) VALUES (4, 5, NULL, 5);


select * from planet;
select * from player;
select * from resource;
select * from inventory;
select * from player_species;

delete from resource;

----ВАЖНО НЕ УДАЛЯТЬ. обнуляет счетчик serial
alter sequence resource_id_seq restart with 1; 









