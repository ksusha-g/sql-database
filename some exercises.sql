-----просто селектит с псевдонимом-----
select 
	id as "player_id",
	planet_id as "planet name"
from player


-----выводим ресурсы у которых extraction_time > 5 и это еда-------
select 
	name,
	type,
	extraction_time
from resource 
where (type = 'food' and extraction_time>5)


------in-----
select 
	name,
	water_level
from planet
where water_level in ('flood', 'normal')



----like------
select 
	name
from resource
where name like 'pink%'


----- выводит сумму ресурсов у игроков------
select 
	player_id as "игрок",
	SUM(count) as "сумма ресурсов"
from inventory
group by player_id
having sum(count) > 10
order by sum(count)


select 
	type,
	avg(extraction_time) as "ср знач"
from resource
group by type
having avg(extraction_time) < 26
order by "ср знач"