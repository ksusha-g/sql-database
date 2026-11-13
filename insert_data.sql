INSERT INTO planet(id, name, description, stability, water_level, production_speed) VALUES
(1, 'avrora', 'blooming valley. cool planet for newers', 1, 'normal', 1),
(2, 'atlantis', 'underwater kingdom. a lot of water', 0.65, 'flood', 1.3),
(3,'volcanium','volcanoes. hard planet. you will die!!!!!', 0.3, 'low', 2),
(4, 'solaris', 'rocky plains. a lot of rocks', 0.1, 'drought', 0.5);

INSERT INTO player(planet_id, level, level_points, money_amount) VALUES
(1, 1, 0, 2000),
(2, 3, 626, 1),
(4, 20, 999, 25838);



INSERT INTO resource(planet_id, name, type, extraction_time) VALUES
(1, 'pink fruit', 'food', 3),
(1, 'pink quartz', 'upgrade_material', 15),

(2, 'long algae', 'food', 5),
(2, 'pearl', 'upgrade_material', 20),

(3, 'grass', 'food', 7),
(3, 'lava fish', 'food', 20),
(3, 'obsidian', 'upgrade_material', 40),

(4, 'dry moss', 'food', 5),
(4, 'ugly stone', 'upgrade_material', 10);



INSERT INTO inventory(player_id, resource_id, planet_id, count) VALUES
(1, 2, 1, 10),
(1, 1, 1, 5),

(2, 3, 2, 1),
(2, 4, 2, 3),

(3, 8, 4, 15),
(3, 9, 4, 99);


INSERT INTO player_species(player_id, name, diet, birthrate, lifespan, food_count, immunity, intelligence, strength, communication) VALUES 
(1, 'мой вид', 'herbivorous', 1, 6, 100, 'normal', 10, 10, 'neutral'),
(2, 'злые крысы', 'carnivorous', 0.5, 1, 2, 'victorian child', 1, 1, 'hostile'),
(3, 'големы', 'omnivorous', 2, 1000, 5000, 'the healthiest', 100, 100, 'charming');



INSERT INTO species(planet_id, name, description, type, danger_level, diet, birthrate, lifespan, immunity, intelligence, strength, communication) VALUES
(1, 'bird', 'not dangerous', 'neutral', NULL, 'herbivorous', 1, 1, 'normal', 1, 1, 'curious'),
(1, 'tiger', 'evil cat', 'predator', 5, 'carnivorous', 0.5, 15, 'high', 5, 15, 'unfriendly'),

(2, 'fish', 'stupid', 'parasite', 20, 'omnivorous', 0.3, 2, 'victorian child', 0, 1, 'hostile'),

(3, 'wise big snake', 'lava snake', 'neutral', NULL, 'carnivorous', 0.1, 120, 'the healthiest', 100, 10, 'charming'),

(4, 'rock lobster', 'playful and funny...', 'neutral', 1, 'omnivorous', 1, 5, 'high', 1, 5, 'unfriendly');



INSERT INTO mutagen(name, description, type, development_chance) VALUES
('жабры', 'помогают дышать под водой', 'good', 0.1),
('крылья', 'для ауры', 'good', 0.6),
('лишняя нога', 'запинаешься', 'bad', 0.2),
('слепота', 'нет глаз', 'bad', 0.07),
('вонючка', 'ты воняешь', 'neutral', 0.3),
('электрошок', 'ты бьешь током', 'good', 0.01),
('болеющий', 'подвержен болезням', 'bad', 0.067);



INSERT INTO mutagen_effect(mutagen_id, type, attribute_name, modifier_value, mod_operation) VALUES
(3, 'numeric', 'strength', 3, 'sub'),
(4, 'numeric', 'strength', 10, 'sub'),
(5, 'numeric', 'lifespan', 2, 'add'),
(6, 'numeric', 'lifespan', 5, 'add'),
(6, 'numeric', 'strength', 15, 'add');

INSERT INTO mutagen_effect(mutagen_id, type, attribute_name, enum_delta) VALUES
(5, 'enum_shift', 'communication', -1);

INSERT INTO mutagen_effect(mutagen_id, type, attribute_name, enum_value) VALUES
(7, 'set_enum', 'immunity', 'victorian child');

INSERT INTO mutagen_effect(mutagen_id, type, ability_code) VALUES
(1, 'ability', 'underwater breathing'),
(2, 'ability', 'fly');



INSERT INTO player_mutagen (player_id, mutagen_id) VALUES
(1, 3),
(2, 4),
(2, 5),
(2, 7),
(3, 2);

INSERT INTO upgrade ()




select * from planet;
select * from player;
select * from resource;
select * from inventory;
select * from player_species;

delete from resource;

----ВАЖНО НЕ УДАЛЯТЬ. обнуляет счетчик serial
alter sequence resource_id_seq restart with 1; 
