The Dataset
===========

matches.csv
-----------

- ID
- Match ID
- Platform ID aka the server on which the game was played
- Queue ID (it's always 420, i.e. ranked solo)
- Season ID
- Duration (in seconds)
- Creation (timestamp in milliseconds)
- Version (the patch on which the game was played)

participants.csv
----------------

- ID (cross-references the Stats table)
- Match ID (cross-references the Matches table)
- Player (1-5 blue team, 6-10 red team)
- Champion ID (Check the data dragon)
- SS1: summoner spell on D (should be Flash)
- SS2: summoner spell on F (should not be Flash)
- Role (SOLO for top and mid, NONE for jungle, DUO_CARRY or DUO_SUPPORT for botlane)
- Position (bot/jungle/top/mid)

teambans.csv
------------

- Match ID
- Team ID (either 100 or 200)
- Champion ID
- Ban turn

teamstats.csv
-------------

- Match ID
- Team ID (either 100 or 200)
- First blood
- First turret
- First inhibitor
- First inhibitor
- First baron
- First dragon
- First herald
- Tower kills
- Inhibitor kills
- Baron kills
- Dragon kills
- Herald kills

stats.csv
---------

- ID (cross-references the Participants table)
- Win - did the player win? (bool)
- Item 1 ... item 6 (check DDragon)
- Trinket (check DDragon)
- Kills
- Deaths
- Assists
- Largest killing spree
- Largest multi kill
- Killing sprees
- Longest time spent living
- Double kills
- Triple kills
- Quadra kills
- Pentakills
- Legendary kills (> penta)
- Total damage
- Magic damage
- Physical damage
- True damage
- Larget crit
- Total damage to champs
- Magic dmg to champs
- Physical dmg to champs
- True dmg to champs
- Total amount healed
- Total units healed
- Damage self mitigated
- Damage to objectives
- Damage to turrets
- Vision score
- Time CCing others
- Total damage taken
- Magic dmg taken
- Physical dmg taken
- True dmg taken
- Gold earned
- Gold spent
- Turrets killed
- Inhibitors destroyed
- Total minions/monsters killed
- Neutral minions killed
- Own jungle monsters killed
- Enemy jungle monsters killed
- Total CC time dealt
- Champion level
- Pinks bought
- Wards bought
- Wards placed
- Wards killed
- First blood (boolean)
