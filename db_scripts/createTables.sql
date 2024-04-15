USE projetGlo_bd;
CREATE TABLE IF NOT EXISTS utilisateurs (nomUtilisateur varchar(50), motDePasse varchar(300), roleUtilisateur enum('admin', 'user'));
INSERT INTO utilisateurs VALUES ('zackdev97', "b'$2b$12$UWxQEAVpBm1VTbRuRsVxN.YugcYgclVSRPt.h.iYyta3AaipWBDKe'", 'admin');
INSERT INTO utilisateurs VALUES ('agingras2', "b'$2b$12$uvvkhJV4tx7Av1aZaj1qLuWiO7dl2100kz5j.HLPeIU8VnD88QkDy'", 'admin');
CREATE TABLE IF NOT EXISTS genres (nomGenre varchar(50), PRIMARY KEY(nomGenre));
ALTER TABLE utilisateurs ADD CONSTRAINT pk_utilisateur PRIMARY KEY (nomUtilisateur);
INSERT INTO `genres` VALUES ('action'),('animation'),('aventure'),('comédie'),('comédie musicale'),('documentaire'),('drame'),('fantaisie'),('horreur'),('policier'),('psychologique'),('romance'),('science-fiction'),('super-hero'),('suspense');
CREATE TABLE IF NOT EXISTS films (idFilm integer, nomFilm varchar(100), annee YEAR, genre varchar(50), sousGenre varchar(50), acteurs longtext, nbVotes integer, noteTotale integer, noteGlobale integer, PRIMARY KEY(idFilm), FOREIGN KEY (genre) REFERENCES genres(nomGenre) ON DELETE SET NULL, FOREIGN KEY (sousGenre) REFERENCES genres(nomGenre) ON DELETE SET NULL);
CREATE TABLE IF NOT EXISTS series (idSerie integer, nomSerie varchar(100), annee YEAR, genre varchar(50), sousGenre varchar(50), acteurs longtext, nbVotes integer, noteTotale integer, noteGlobale integer, saison integer, PRIMARY KEY(idSerie), FOREIGN KEY (genre) REFERENCES genres(nomGenre) ON DELETE SET NULL, FOREIGN KEY (sousGenre) REFERENCES genres(nomGenre) ON DELETE SET NULL);
CREATE TABLE IF NOT EXISTS commentairesFilms (id integer, contenu longtext, PRIMARY KEY(id));
CREATE TABLE IF NOT EXISTS commentairesSeries (id integer, contenu longtext, PRIMARY KEY(id));
CREATE TABLE IF NOT EXISTS votesFilms (id integer, nomUtilisateur varchar(50), idFilm integer, note integer, PRIMARY KEY(id), UNIQUE(nomUtilisateur, idFilm), FOREIGN KEY (nomUtilisateur) REFERENCES utilisateurs(nomUtilisateur) ON DELETE CASCADE, FOREIGN KEY (idFilm) REFERENCES films(idFilm) ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS votesSeries (id integer, nomUtilisateur varchar(50), idSerie integer, note integer, PRIMARY KEY(id), UNIQUE(nomUtilisateur, idSerie), FOREIGN KEY (nomUtilisateur) REFERENCES utilisateurs(nomUtilisateur) ON DELETE CASCADE, FOREIGN KEY (idSerie) REFERENCES series(idSerie) ON DELETE CASCADE);
CREATE TABLE IF NOT EXISTS acteurs (id integer, prenom varchar(100), nom varchar(100), ddn DATE, sexe enum('masculin', 'feminin', 'non-binaire'), nationnalite varchar(100), PRIMARY KEY(id));
ALTER TABLE films MODIFY COLUMN noteTotale double;
ALTER TABLE films MODIFY COLUMN noteGlobale double;
ALTER TABLE series MODIFY COLUMN noteTotale double;
ALTER TABLE series MODIFY COLUMN noteGlobale double;
ALTER TABLE votesFilms MODIFY COLUMN note double;
ALTER TABLE votesSeries MODIFY COLUMN note double;
INSERT INTO `films` VALUES (1,'Prisoners',2013,'policier','suspense','Hugh Jackman, Jake Gyllenhaal, Viola Davis, Maria Bello, Terrence Howard, Melissa Leo',1,7.8,7.8),(2,'Girl in the basement',2021,'policier','drame','Stefanie Scott, Judd Nelson, Joely Fisher, Emily Topper, Emma Myers, Braxton Bjerken',1,9.2,9.2),(3,'Guardians of the galaxy vol. 3',2023,'super-hero','science-fiction','Chris Pratt, Zoe Saldana, Dave Bautista, Karen Gillan, Pom Klementieff, Vin Diesel',1,9,9),(4,'Turning red',2022,'animation','comédie','Rosalie Chiang, Sandra Oh, Ava Morse, Hyein Park, Maitreyi Ramakrishnan, Orion Lee',1,8.3,8.3),(5,'Room',2015,'drame','policier','Brie Larson, Jacob Tremblay, Joan Allen, Sean Bridgers, Tom McCamus, William H. Macy',1,8.4,8.4),(6,'Things heard & seen',2021,'suspense','horreur','Amanda Seyfried, James Norton, Natalia Dyer, Karen Allen, Rhea Seehorn, Michael O\'Keefe',1,2,2),(7,'Baywatch',2017,'comédie','action','Dwayne Johnson, Zac Efron, Priyanka Chopra Jonas, Alexandra Daddario, Kelly Rohrbach, Jon Bass',1,8.5,8.5),(8,'Shutter island',2010,'suspense','psychologique','Leonardo DiCaprio, Mark Ruffalo, Ben Kingsley, Max von Sydow, Michelle Williams, Emily Mortimer',1,8,8),(9,'Arrival',2016,'science-fiction','psychologique','Amy Adams, Jeremy Renner, Forest Whitaker, Michael Stuhlbarg, Mark O\'Brien, Tzi Ma',1,8.1,8.1),(10,'After',2019,'romance','drame','Josephine Langford, Hero Fiennes Tiffin, Pia Mia, Inanna Sarkis, Samuel Larsen, Dylan Arnold',1,3,3),(11,'Skyscraper',2018,'action','suspense','Dwayne Johnson, Neve Campbell, Chin Han, Roland Moller, Noah Taylor, Byron Mann',1,8.7,8.7),(12,'Jobs',2013,'documentaire','science-fiction','Ashton Kutcher, Dermot Mulroney, Josh Gad, Lukas Haas, J.K. Simmons, Lesley Ann Warren',1,8.2,8.2),(13,'The Social Network',2010,'Documentaire','Drame','Jesse Eisenberg, Andrew Garfield, Justin Timberlake, Armie Hammer, Max Minghella, Josh Pence',1,9,9),(14,'San Andreas',2015,'Action','Suspense','Dwayne Johnson, Carla Gugino, Alexandra Daddario, Ioan Gruffudd, Archie Panjabi, Paul Giamatti',1,8.5,8.5),(15,'Upside Down',2012,'romance','science-fiction','Kirsten Dust, Jim Sturgess, Timothy Spall, James Kidnie, Jayne Heitmeyer, Holly O Brien',1,7.3,7.3),(16,'Orphan',2009,'suspense','horreur','Vera Farmiga, Peter Sarsgaard, Isabelle Fuhrman, CCH Pounder, Aryana Engineer, Jimmy Bennett',1,9,9),(17,'Men In Black',1997,'action','comédie','Tommy Lee Jones, Will Smith, Linda Fiorentino, Vincent D\'Onofrio, Rip Torn, Tony Shalhoub',1,8.2,8.2),(18,'A beautiful mind',2001,'documentaire','drame','Russell Crowe, Ed Harris, Jennifer Connelly, Paul Bettany, Adam Goldberg, Judd Hirsch',1,7.6,7.6),(19,'Blade Runner 2049',2017,'science-fiction','action','Ryan Gosling, Harrison Ford, Ana de Armas, Sylvia Hoeks, Robin Wright, Jared Leto',1,8,8),(20,'The invisible man',2020,'horreur','suspense','Elisabeth Moss, Oliver Jackson-Cohen, Aldis Hodge, Storm Reid, Harriet Dyer, Michael Dorman',1,8.6,8.6),(21,'The vault',2021,'action','suspense','Freddie Highmore, Astrid Berges Firsbey, Sam Riley, Liam Cunningham, José Coronado, Luis Tosar',1,8.2,8.2),(22,'Child\'s play',1988,'horreur','comédie','Catherine Hicks, Chris Sarandon, Alex Vincent, Brad Dourif, Dinah Manoff, Tommy Swerdlow',1,8.1,8.1),(23,'Happy Death Day',2017,'horreur','comédie','Jessica Rothe, Israel Broussard, Ruby Modine, Rachel Matthews, Charles Aitken, Jason Bayle',0,0,0),(24,'Countdown',2019,'horreur','suspense','Elizabeth Lail, Jordan Calloway, Talitha Eliana Bateman, Tichina Arnold, P.J. Byrne, Peter Facinelli',1,8.7,8.7),(25,'Gifted',2017,'drame','drame','Chris Evans, Mckenna Grace, Lindsay Duncan, Octavia Spencer, Jenny Slate, Michael Kendall Kaplan',1,7.5,7.5),(26,'Ghosted',2023,'action','romance','Chris Evans, Ana de Armas, Adrien Brody, Mike Moh, Amy Sedaris, Tate Donovan',1,7.9,7.9),(27,'Odd Thomas',2013,'fantaisie','comédie','Anton Yelchin, Addison Timlin, Willem Dafoe, Gugu Mbatha Raw, Shuler Hensley, Leonor Varela',1,8.5,8.5),(28,'Elemental',2023,'animation','romance','Leah Lewis, Mamoudou Athie, Ronnie Del Carmen, Shila Ommi, Wendi McLendon Covey, Catherine O\'Hara',1,9.2,9.2),(29,'Cars 3',2017,'animation','comédie','Owen Wilson, Cristela Alonzo, Armie Hammer, Chris Cooper, Nathan Fillion, Larry the Cable Guy',1,8.2,8.2),(30,'The Girl Who Escaped : The Kara Robinson Story',2023,'drame','drame','Katie Douglas, Cara Buono, Kristian Bruun, Brandon McEwan, Simone Stock, Haley Harris',1,8.2,8.2),(31,'Spider-Man : Across The Spider-Verse',2023,'animation','super-hero','Shameik Moore, Hailee Steinfeld, Oscar Isaac, Jake Johnson, Issa Rae, Daniel Kaluuya',1,8.3,8.3),(32,'The Artifice Girl',2022,'science-fiction','suspense','Tatum Matthews, David Girard, Sinda Nichols, Franklin Ritch, Lance Henriksen, Ivana Barnes',1,3,3),(33,'In Time',2011,'science-fiction','action','Justin Timberlake, Amanda Seyfried, Cillian Murphy, Vincent Kartheiser, Olivia Wilde, Matt Bomer',1,8.6,8.6),(34,'The First Time',2012,'romance','comédie','Dylan O\'Brien, Britt Robertson, Victoria Justice, Craig Roberts, James Frecheville, Lamarcus Tinker',1,7.8,7.8),(35,'21',2008,'comédie','action','Jim Sturgess, Kevin Spacey, Kate Bosworth, Aaron Yoo, Liza Lapira, Jacob Pitts',1,8.3,8.3),(36,'Barbie',2023,'comédie','aventure','Margot Robbie, Ryan Gosling, America Ferrera, Kate McKinnon, Issa Rae, Rhea Perlman',1,8.5,8.5),(37,'Bird Box Barcelona',2023,'horreur','science-fiction','Mario Casas, Georgina Campbell, Diego Calva, Michelle Jenner, Leonardo Sbaraglia, Naila Schuberth',1,8.7,8.7),(38,'Her',2013,'comédie','drame','Joaquin Phoenix, Amy Adams, Scarlett Johanson, Rooney Mara, Chris Pratt, Olivia Wilde',1,8.2,8.2),(39,'Inception',2010,'science-fiction','action','Leonardo DiCaprio, Joseph Gordon Levitt, Elliot Page, Tom Hardy, Ken Watanabe, Dileep Rao',1,9,9),(40,'Toy Story 4',2019,'animation','comédie','Tom Hanks, Tim Allen, Annie Potts, Tony Hale, Keegan-Michael Key, Madeleine McGraw',1,9,9),(41,'Inside Out',2015,'animation','comédie','Amy Poehler, Phyllis Smith, Richard Kind, Bill Hader, Lewis Black, Mindy Kaling',1,9.3,9.3),(42,'Oblivion',2013,'science-fiction','aventure','Tom Cruise, Morgan Freeman, Olga Kurylenko, Andrea Riseborough, Nikolaj Coster-Waldau, Melissa Leo',1,8.5,8.5),(43,'Happy Death Day 2U',2019,'horreur','comédie','Jessica Rothe, Israel Broussard, Phi Vu, Suraj Sharma, Sarah Yarkin, Rachel Matthews',1,7.9,7.9),(44,'Alita : Battle Angel',2019,'science-fiction','action','Rosa Salazar, Christoph Waltz, Keean Johnson, Mahershala Ali, Jennifer Connelly, Ed Skrein',1,8.8,8.8),(45,'Pokémon Detective Pikachu',2019,'comédie','action','Ryan Reynolds, Justice Smith, Kathryn Newton, Bill Nighty, Ken Watanabe, Chris Geere',1,8.5,8.5),(46,'The Boy',2016,'horreur','suspense','Lauren Cohan, Rupert Evans, Jim Norton, Diana Hardcastle, Ben Robson, James Russell',1,8.4,8.4),(47,'Scary Stories To Tell In The Dark',2019,'horreur','suspense','Zoe Margaret Colletti, Michael Garza, Gabriel Rush, Austin Abrams, Dean Norris, Gil Bellows',1,8.5,8.5),(48,'Meg 2 : The Trench',2023,'action','science-fiction','Jason Statham, Jing Wu, Shuya Sophia Cai, Page Kennedy, Sergio Peris-Mencheta, Skyler Samuels',1,8.4,8.4),(49,'9',2009,'animation','drame','Elijah Wood, Christopher Plummer, Martin Landau, John C. Reilly, Jennifer Connelly, Crispin Glover',1,8.3,8.3),(50,'The Cabin In The Woods',2011,'horreur','comédie','Kristen Connolly, Chris Hemsworth, Anna Hutchison, Fran Kranz, Jesse Williams, Richard Jenkins',1,8.5,8.5),(51,'No Hard Feelings',2023,'comédie','romance','Jennifer Lawrence, Andrew Barth Feldman, Laura Benanti, Natalie Morales, Matthew Broderick, Gene Stupnitsky',1,8.7,8.7),(52,'17 Again',2009,'comédie','science-fiction','Zac Efron, Leslie Mann, Thomas Lennon, Matthew Perry, Tyler Steelman, Allison Miller',1,7.8,7.8),(53,'Toy Story 2',1999,'animation','comédie','Tom Hanks, Tim Allen, Joan Cusack, Kelsey Grammer, Don Rickles, Jim Varney',1,8.4,8.4),(54,'Thor : Love And Thunder',2022,'super-hero','action','Chris Hemsworth, Natalie Portman, Christian Bale, Tessa Thompson, Taika Waititi, Russell Crowe',1,8.9,8.9),(55,'Source Code',2011,'science-fiction','suspense','Jake Gyllenhaal, Michelle Monaghan, Vera Farmiga, Jeffrey Wright, Brent Skagford, Cas Anvar',1,9.2,9.2),(56,'Major Junior',2017,'drame','action','Nicholas Canuel, Édith Cochrane, Normand Daneau, Rémi Goulet, Claude Legault, Alice Morel-Michaud',1,7.7,7.7),(57,'M3GAN',2022,'horreur','science-fiction','Allison Williams, Violet McGraw, Ronny Chieng, Brian Jordan Alvarez, Jen Van Epps, Lori Dungey',1,8.7,8.7),(58,'Deep Water',2022,'drame','suspense','Ben Affleck, Ana de Armas, Tracy Letts, Lil Rel Howery, Dash Mihok, Finn Wittrock',1,3,3),(59,'Big Hero 6',2014,'animation','aventure','Ryan Potter, Scott Adsit, T.J. Miller, Jamie Chung, Damon Wayans Jr., Genesis Rodriguez',1,8.5,8.5),(60,'The Visit',2015,'horreur','suspense','Olivia DeJonge, Ed Oxenbould, Deanna Dunagan, Peter McRobbie, Kathryn Hahn, Celia Keenan-Bolger',1,8.5,8.5),(61,'The Peanuts Movie',2015,'animation','comédie','Noah Schnapp, Hadley Belle Miller, Mariel Sheets, Alexander Garfin, Francesca Capaldi, Venus Schultheis',1,8.3,8.3),(62,'Scary Movie',2000,'comédie','comédie','Shawn Wayans, Marlon Wayans, Cheri Oteri, Shannon Elizabeth, Anna Faris, Jon Abrahams',1,8.4,8.4),(63,'Mr. Peabody & Sherman',2014,'animation','science-fiction','Ty Burrell, Max Charles, Ariel Winter, Stephen Colbert, Leslie Mann, Stanley Tucci',1,8.8,8.8),(64,'Bridge To Terabithia',2007,'aventure','drame','Josh Hutcherson, AnnaSophia Robb, Zooey Deschanel, Robert Patrick, Lauren Clinton, Kate Butler',1,8.4,8.4),(65,'Harry Potter And The Sorcerer\'s Stone',2001,'fantaisie','aventure','Daniel Radcliffe, Rupert Grint, Emma Watson, John Cleese, Robbie Coltrane, Warwick Davis',1,8.8,8.8),(66,'Chicken Little',2005,'animation','comédie','Zach Braff, Joan Cusack, Don Knotts, Harry Shearer, Patrick Stewart, Garry Marshall',1,8.3,8.3),(67,'Harry Potter And The Chamber Of Secrets',2002,'fantaisie','aventure','Daniel Radcliffe, Rupert Grint, Emma Watson, Kenneth Branagh, John Cleese, Robbie Coltrane',1,9,9),(68,'Harry Potter And The Prisoner Of Azkaban',2004,'fantaisie','aventure','Daniel Radcliffe, Rupert Grint, Emma Watson, Gary Oldman, David Thewlis, Michael Gambon',1,8.8,8.8),(69,'Harry Potter And The Goblet Of Fire',2005,'fantaisie','aventure','Daniel Radcliffe, Rupert Grint, Emma Watson, Robbie Coltrane, Ralph Fiennes, Michael Gambon',1,8.9,8.9),(70,'Harry Potter And The Order Of The Phoenix',2007,'fantaisie','aventure','Daniel Radcliffe, Rupert Grint, Emma Watson, Helena Bonham Carter, Robbie Coltrane, Michael Gambon',1,8.8,8.8),(71,'Harry Potter And The Half-Blood Prince',2009,'fantaisie','aventure','Daniel Radcliffe, Rupert Grint, Emma Watson, Helena Bonham Carter, Jim Broadbent, Robbie Coltrane',1,8.9,8.9),(72,'Daddy\'s Home',2015,'comédie','comédie','Will Ferrell, Mark Wahlberg, Linda Cardellini, Thomas Haden Church, Scarlett Estevez, Owen Vaccaro',1,8.8,8.8),(73,'Finding Nemo',2003,'animation','aventure','Albert Brooks, Ellen DeGeneres, Alexander Gould, Willem Dafoe, Brad Garrett, Allison Janney',1,8.5,8.5),(74,'Harry Potter And The Deathly Hallows : Part 1',2010,'fantaisie','aventure','Daniel Radcliffe, Rupert Grint, Emma Watson, Ralph Fiennes, Alan Rickman, Robbie Coltrane',1,8.3,8.3),(75,'Harry Potter And The Deathly Hallows : Part 2',2011,'fantaisie','aventure','Daniel Radcliffe, Rupert Grint, Emma Watson, Ralph Fiennes, Alan Rickman, Robbie Coltrane',1,9.1,9.1),(76,'The Incredibles',2004,'animation','super-hero','Craig T. Nelson, Holly Hunter, Samuel L. Jackson, Jason Lee, Wallace Shawn, Sarah Vowell',1,8.3,8.3),(77,'It',2017,'horreur','suspense','Jaeden Martell, Jeremy Ray Taylor, Sophia Lillis, Finn Wolfhard, Chosen Jacobs, Jack Dylan Grazer',1,8.5,8.5),(78,'Knights Of The Zodiac',2023,'fantaisie','aventure','Mackenyu, Famke Janssen, Madison Iseman, Diego Tinoco, Mark Dacascos, Nick Stahl',1,7.8,7.8),(79,'Five Nights At Freddy\'s',2023,'horreur','suspense','Josh Hutcherson, Elizabeth Lail, Kat Conner Sterling, Piper Rubio, Mary Stuart Masterson, Matthew Lillard',1,8.6,8.6),(80,'Cars',2006,'animation','comédie','Owen Wilson, Paul Newman, Bonnie Hunt, Larry The Cable Guy, Katherine Helmond, Cheech Marin',1,8.8,8.8),(81,'Zootopia',2016,'animation','comédie','Ginnifer Goodwin, Jason Bateman, Shakira, Idris Elba, J.K. Simmons, Nate Torrence',1,8.8,8.8),(82,'Madagascar',2005,'animation','comédie','Ben Stiller, Chris Rock, David Schwimmer, Jada Pinkett Smith, Sacha Baron Cohen, Cedric The Entertainer',1,7,7),(83,'The Greatest Showman',2017,'comédie','aventure','Hugh Jackman, Zac Efron, Michelle Williams, Rebecca Ferguson, Zendaya, Keala Settle',1,9.4,9.4),(84,'The Butterfly Effect',2004,'science-fiction','romance','Ashton Kutcher, Amy Smart, Eric Stoltz, William Lee Scott, Elden Henson, Logan Lerman',1,8.7,8.7),(85,'The Marvels',2023,'super-hero','aventure','Brie Larson, Teyonah Parris, Iman Vellani, Samuel L. Jackson, Zawe Ashton, Park Seo-joon',1,8.3,8.3),(86,'The Creator',2023,'science-fiction','action','John David Washington, Gemma Chan, Ken Watanabe, Sturgill Simpson, Madeleine Yuna Voyles, Allison Janney',1,9,9),(87,'Doctor Strange In The Multiverse Of Madness',2022,'super-hero','fantaisie','Benedict Cumberbatch, Elizabeth Olsen, Chiwetel Ejiofor, Rachel McAdams, Benedict Wong, Xochitl Gomez',1,9,9),(88,'Family Switch',2023,'comédie','comédie','Jennifer Garner, Ed Helms, Emma Myers, Matthias Schweighofer, Rita Moreno, Fortune Feimster',1,8,8),(89,'Ender\'s Game',2013,'science-fiction','aventure','Harrison Ford, Asa Butterfield, Hailee Steinfeld, Abigail Breslin, Ben Kingsley, Viola Davis',1,8.4,8.4),(90,'WALL-E',2008,'animation','science-fiction','Ben Burtt, Elissa Knight, Jeff Garlin, Fred Willard, John Ratzenberger, Kathy Najimy',1,8.5,8.5),(91,'All The Bright Places',2020,'drame','romance','Elle Fanning, Alexandra Shipp, Virginia Gardner, Keegan-Michael Key, Justice Smith, Luke Wilson',1,8.4,8.4),(92,'Why Him?',2016,'comédie','comédie','James Franco, Bryan Cranston, Zoey Deutch, Megan Mullally, Griffin Gluck, Keegan-Michael Key',1,8.4,8.4),(93,'Daddy\'s Home 2',2017,'comédie','comédie','Will Ferrell, Mark Wahlberg, Mel Gibson, John Lithgow, Linda Cardellini, John Cena',1,8.6,8.6),(94,'Eli',2019,'horreur','suspense','Charlie Shotwell, Lili Taylor, Max Martini, Sadie Sink, Kelly Reilly, Ciaran Foy',1,8.5,8.5),(95,'Talk To Me',2023,'horreur','suspense','Sophie Wilde, Miranda Otto, Otis Dhanji, Alexandra Jensen, Joe Bird, Marcus Johnson',1,8.5,8.5),(96,'The Black Demon',2023,'action','science-fiction','Josh Lucas, Fernanda Urrejola, Venus Ariel, Carlos Solorzano, Julio Cedillo, Jorge A. Jimenez',1,7.7,7.7),(97,'The Gift',2016,'suspense','romance','Jason Bateman, Rebecca Hall, Joel Edgerton, Allison Tolman, Busy Philipps, Beau Knapp',1,9,9),(98,'I Came By',2022,'suspense','drame','Kelly MacDonald, George MacKay, Percelle Ascott, Varada Sethu, Hugh Bonneville, Gabriel Bisset-Smith',1,7.9,7.9),(99,'Love At First Sight',2023,'romance','comédie','Haley Lu Richardson, Ben Hardy, Sally Phillips, Jameela Jamil, Dexter Fletcher, Rob Delaney',1,8.5,8.5),(100,'Soul',2020,'animation','science-fiction','Jamie Foxx, Tina Fey, Phylicia Rashad, Ahmir Questlove Thompson, Angela Bassett, Daveed Diggs',1,8.7,8.7),(101,'Doctor Strange',2016,'super-hero','fantaisie','Benedict Cumberbatch, Chiwetel Ejifor, Rachel McAdams, Benedict Wong, Mads Mikkelsen, Tilda Swinton',1,8.8,8.8),(102,'Ready Player One',2018,'science-fiction','aventure','Tye Sheridan, Olivie Cooke, Ben Mendelsohn, Lena Waithe, T.J. Miller, Simon Pegg',1,9,9),(103,'Along For The Ride',2022,'romance','comédie','Emma Pasarow, Belmont Cameli, Andie MacDowell, Dermot Mulroney, Kate Bosworth, Genevieve Hannelius',1,7.8,7.8),(104,'The Menu',2022,'horreur','comédie','Ralph Fiennes, Anya Taylor Joy, Nicholas Hoult, Hong Chau, Janet McTeer, Judith Light',1,8.8,8.8),(105,'Norbit',2007,'comédie','romance','Eddie Murphy, Thandiwe Newton, Cuba Gooding Jr., Eddie Griffin, Terry Crews, Clifton Powell',1,8,8),(106,'Paul Blart : Mall Cop',2009,'comédie','action','Kevin James, Jayma Mays, Keir O\'Donnell, Bobby Cannavale, Steve Rannazzisi, Shirley Knight',1,8.4,8.4),(107,'Ticket To Paradise',2022,'romance','comédie','George Clooney, Julia Roberts, Kaitlyn Dever, Billie Lourd, Maxime Bouttier, Ol Parker',1,7,7),(108,'The Other Zoey',2023,'romance','comédie','Josephine Langford, Drew Starkey, Archie Renaux, Mallori Johnson, Patrick Fabian, Heather Graham',1,8.3,8.3),(109,'Night Swim',2024,'horreur','suspense','Wyatt Russell, Kerry Condon, Amelie Hoeferle, Gavin Warren, Nancy Lenehan, Jodi Long',1,8,8),(110,'Lil Nas X : Long Live Montero',2024,'documentaire','documentaire','Lil Nas X, Saul Levitz, Adam Leber, Hodo Musa, Sean Bankhead, Christian Owens',1,8.2,8.2),(111,'Don\'t Breathe',2016,'horreur','suspense','Jane Levy, Dylan Minnette, Daniel Zovatto, Stephen Lang, Emma Bercovici, Franciska Torocsik',1,8.7,8.7),(112,'Watcher',2022,'suspense','policier','Maika Monroe, Karl Glusman, Burn Gorman, Tudor Petrut, Gabriela Butuc, Madalina Anea',1,7,7),(113,'Wonka',2024,'fantaisie','comédie','Timothée Chalamet, Hugh Grant, Calah Lane, Keegan-Michael Key, Paterson Joseph, Matt Lucas',1,8.5,8.5),(114,'Moana',2016,'animation','aventure','Dwayne Johnson, Auli\'i Cravalho, Rachel House, Temura Morrison, Jemaine Clement, Nicole Scherzinger',1,8.9,8.9),(115,'Sonic The Hedgehog',2020,'comédie','aventure','James Marsden, Jim Carrey, Ben Schwartz, Tika Sumpter, Natasha Rothwell, Adam Pally',1,8.7,8.7),(116,'The Black Phone',2021,'horreur','policier','Ethan Hawke, Mason Thames, Madeleine McGraw, Jeremy Davies, James Ransone, E. Roger Mitchell',1,8.7,8.7),(117,'Through My Window',2022,'romance','comédie','Clara Galle, Pilar Castro, Hugo Arbues, Eric Masip, Julio Pena, Guillermo Lasheras',1,8,8),(118,'No Exit',2022,'suspense','policier','Dale Dickey, Dennis Haysbert, Danny Ramirez, David Rysdahl, Mila Harris, Benedict Wall',1,8.6,8.6),(119,'Noise',2023,'suspense','psychologique','Ward Kerremans, Sallie Harmsen, Johan Leysen, Jennifer Heylen, Daphne Wellens, Lize Feryn',1,5,5),(120,'Gran Turismo : Based On A True Story',2023,'action','drame','David Harbour, Orlando Bloom, Archie Madekwe, Darren Barnet, Geri Halliwell, Djimon Hounsou',1,9,9),(121,'Anyone But You',2023,'romance','comédie','Sydney Sweeney, Glen Powell, Alexandra Shipp, GaTa, Hadley Robinson, Michelle Hurd',1,8.3,8.3),(122,'Hacksaw Ridge',2016,'action','drame','Andrew Garfield, Sam Worthington, Luke Bracey, Teresa Palmer, Hugo Weaving, Rachel Griffiths',1,8.4,8.4),(123,'Grown Ups 2',2013,'comédie','comédie','Adam Sandler, Kevin James, Chris Rock, David Spade, Salma Hayek, Maya Rudolph',1,8.3,8.3),(124,'Avengers : Infinity War',2018,'super-hero','aventure','Robert Downey Jr., Chris Hemsworth, Josh Brolin, Chadwick Boseman, Mark Ruffalo, Zoe Saldana',1,9.5,9.5),(125,'Five Feet Apart',2019,'romance','drame','Haley Lu Richardson, Cole Sprouse, Moises Arias, Kimberly Hebert Gregory, Parminder Nagra, Claire Forlani',1,9.2,9.2),(126,'The Internship',2013,'comédie','comédie','Vince Vaughn, Owen Wilson, Rose Byrne, Max Minghella, Josh Brener, Josh Gad',1,8.5,8.5),(127,'Kids Are Growing Up : A Story About A Kid Named Laroi',2024,'documentaire','documentaire','The Kid Laroi, Michael D. Ratner',1,8.5,8.5),(128,'Set It Up',2018,'romance','comédie','Zoey Deutch, Glen Powell, Lucy Liu, Taye Diggs, Joan Smalls, Meredith Hagner',1,8.4,8.4),(129,'Thor : Ragnarok',2017,'super-hero','action','Chris Hemsworth, Tom Hiddleston, Cate Blanchett, Idris Elba, Jeff Goldblum, Tessa Thompson',1,8.7,8.7),(130,'Hush',2016,'horreur','suspense','John Gallagher, Kate Siegel, Michael Trucco, Samantha Sloyan, Emma Graves, Mike Flanagan',1,8.6,8.6),(131,'The Dark Tower',2017,'fantaisie','action','Idris Elba, Matthew McConaughey, Tom Taylor, Claudia Kim, Fran Kranz, Jackie Earle Haley',1,8.5,8.5),(132,'Christopher Robin',2018,'drame','aventure','Ewan McGregor, Hayley Atwell, Bronte Carmichael, Mark Gatiss, Jim Cummings, Brad Garrett',1,8.5,8.5),(133,'Damsel',2024,'fantaisie','action','Millie Bobby Brown, Ray Winstone, Nick Robinson, Shoreh Aghdashloo, Brooke Carter, Milo Twomey',1,8.5,8.5),(134,'Orphan : First Kill',2022,'horreur','suspense','Isabelle Fuhrman, Julia Stiles, Rossif Sutherland, Matthew Finlan, Hiro Kanagawa, Samantha Walkes',1,8.8,8.8),(135,'Freaks',2018,'science-fiction','suspense','Emile Hirsch, Bruce Dern, Lexy Kolker, Amanda Crew, Grace Park, Matty Finochio',1,8.8,8.8),(136,'Wedding Crashers',2005,'comédie','romance','Owen Wilson, Vince Vaughn, Christopher Walken, Rachel McAdams, Isla Fisher, Jane Seymour',1,8.2,8.2),(137,'The Gray Man',2022,'action','action','Ryan Gosling, Chris Evans, Ana de Armas, Regé-Jean Page, Billy Bob Thornton, Wagner Moura',1,8.3,8.3),(138,'The Tomorrow War',2021,'science-fiction','action','Chris Pratt, Yvonne Strahovski, J.K. Simmons, Betty Gilpin, Sam Richardson, Edwin Hodge',1,8.6,8.6),(139,'Ready Or Not',2019,'horreur','comédie','Samara Weaving, Adam Brody, Mark O\'Brien, Henry Czerny, Andie MacDowell, Melanie Scrofano',1,8.6,8.6),(140,'Edge Of Tomorrow',2014,'science-fiction','action','Tom Cruise, Emily Blunt, Brendan Gleeson, Bill Paxton, Jonas Armstrong, Tony Way',1,8.5,8.5),(141,'Words On Bathroom Walls',2020,'drame','romance','Charlie Plummer, Taylor Russell, Andy Garcia, AnnaSophia Robb, Beth Grant, Devon Bostick',1,8.9,8.9),(142,'The Hating Game',2021,'romance','comédie','Lucy Hale, Corbin Bernsen, Austin Stowell, Yasha Jackson, Brock Yurich, Sakina Jaffrey',1,7.8,7.8);
INSERT INTO `series` VALUES (1,'Percy Jackson and the Olympians',2023,'fantaisie','aventure','Walker Scobell, Leah Jeffries, Aryan Simhardi',1,9,8.8,1),(2,'Ted',2024,'comédie','comédie','Seth MacFarlane, Max Burkholder, Alanna Ubach, Scott Grimes, Giorgia Wigham',1,9,8.6,1),(3,'Dark',2017,'suspense','science-fiction','Oliver Masucci, Karoline Eichhorn, Jordis Triebel, Louis Hofmann, Maja Schone, Stephan Kampwirth',1,10,9.5,1),(4,'Dark',2019,'suspense','science-fiction','Oliver Masucci, Karoline Eichhorn, Jordis Triebel, Louis Hofmann, Maja Schone, Stephan Kampwirth',1,9,9.4,2),(5,'Dark',2020,'suspense','science-fiction','Oliver Masucci, Karoline Eichhorn, Jordis Triebel, Louis Hofmann, Maja Schone, Stephan Kampwirth',1,10,9.5,3),(6,'Stranger Things',2016,'suspense','fantaisie','Winnona Ryder, David Harbour, Millie Bobby Brown, Finn Wolfhard, Gaten Matarazzo, Caleb McLaughlin',1,9,9.4,1),(7,'Stranger Things',2017,'suspense','fantaisie','Winnona Ryder, David Harbour, Millie Bobby Brown, Finn Wolfhard, Gaten Matarazzo, Caleb McLaughlin',1,9,9,2),(8,'Stranger Things',2019,'suspense','fantaisie','Winnona Ryder, David Harbour, Millie Bobby Brown, Finn Wolfhard, Gaten Matarazzo, Caleb McLaughlin',1,9,9.4,3),(9,'Stranger Things',2022,'suspense','fantaisie','Winnona Ryder, David Harbour, Millie Bobby Brown, Finn Wolfhard, Gaten Matarazzo, Caleb McLaughlin',1,10,9.5,4),(10,'Avatar: The Last Airbender',2024,'fantaisie','aventure','Gordon Cormier, Kiawentiio Tarbell, Ian Ousley, Dallas Liu, Paul Sun-Hyung Lee, Ken Leung',1,9,8.7,1),(11,'1899',2022,'science-fiction','suspense','Emily Beecham, Andreas Pietschmann, Aneurin Barnard, Miguel Bernardeau',1,9,9,1),(12,'The Sandman',2022,'fantaisie','aventure','Tom Sturridge, Gwendoline Christie, Vivienne Acheampong, Boyd Holbrook, Charles Dance, Asim Chaudhry',1,8.6,8.6,1),(13,'Ginny & Georgia',2021,'Drame','Comédie','Antonia Gentry, Brianne Howey, Diesel La Torraca, Jennifer Robertson, Felix Mallard, Sara Waisglass',1,8.8,8.8,1),(14,'Ginny & Georgia',2023,'Drame','Comédie','Antonia Gentry, Brianne Howey, Diesel La Torraca, Jennifer Robertson, Felix Mallard, Sara Waisglass',1,8.5,8.5,2),(15,'Lost In Space',2018,'science-fiction','aventure','Toby Stephens, Molly Parker, Maxwell Jenkins, Taylor Russell, Mina Sundwall, Ignacio Serricchio',1,8.6,8.6,1),(16,'Lost In Space',2019,'science-fiction','aventure','Toby Stephens, Molly Parker, Maxwell Jenkins, Taylor Russell, Mina Sundwall, Ignacio Serricchio',1,8.4,8.4,2),(17,'Lost In Space',2021,'science-fiction','aventure','Toby Stephens, Molly Parker, Maxwell Jenkins, Taylor Russell, Mina Sundwall, Ignacio Serricchio',1,8.6,8.6,3),(18,'You',2018,'romance','suspense','Penn Badgley, Elizabeth Lail, Luca Padovan, Zach Cherry, Shay Mitchell, Greg Berlanti',1,9.1,9.1,1),(19,'You',2019,'romance','suspense','Penn Badgley, Victoria Pedretti, James Sculty, Jenna Ortega, Ambyr Childers, Carmela Zumbado',1,9.3,9.3,2),(20,'You',2021,'romance','suspense','Penn Badgley, Victoria Pedretti, Saffron Burrows, Tati Gabrielle, Dylan Arnold, Shalita Grant',1,8.9,8.9,3),(21,'You',2023,'romance','suspense','Penn Badgley, Tati Gabrielle, Charlotte Ritchie, Lukas Gage, Tilly Keeper, Amy-Leigh Hickman',1,9.4,9.4,4),(22,'Money Heist',2017,'action','suspense','Pedro Alonso, Ursula Cprbero, Alvaro Morte, Itziar Ituno, Enrique Arce',1,8.6,8.6,1),(23,'Money Heist',2017,'action','suspense','Pedro Alonso, Ursula Cprbero, Alvaro Morte, Itziar Ituno, Enrique Arce',1,8.9,8.9,2),(24,'Money Heist',2019,'action','suspense','Pedro Alonso, Ursula Corbero, Alvaro Morte, Itziar Ituno, Enrique Arce',1,8.8,8.8,3),(25,'Money Heist',2020,'action','suspense','Pedro Alonso, Ursula Corbero, Alvaro Morte, Itziar Ituno, Enrique Arce',1,9,9,4),(26,'Money Heist',2021,'action','suspense','Pedro Alonso, Ursula Corbero, Alvaro Morte, Itziar Ituno, Enrique Arce',1,8.9,8.9,5),(27,'Chucky',2021,'horreur','comédie','Brad Dourif, Zackary Arthur, Jennifer Tilly, Devon Sawa, Teo Briones, Alyvia Alyn Lind',1,8.8,8.8,1),(28,'Chucky',2022,'horreur','comédie','Brad Dourif, Zackary Arthur, Jennifer Tilly, Devon Sawa, Teo Briones, Alyvia Alyn Lind',1,8.6,8.6,2),(29,'Locke & Key',2020,'fantaisie','suspense','Jackson Robert Scott, Connor Jessup, Emilia Jones, Sherri Saum, Griffin Gluck',1,8.6,8.6,1),(30,'Locke & Key',2021,'fantaisie','suspense','Darby Stanchfield, Connor Jessup, Emilia Jones, Jackson Robert Scott, Petrice Jones',1,8.6,8.6,2),(31,'Locke & Key',2022,'fantaisie','suspense','Darby Stanchfield, Connor Jessup, Emilia Jones, Jackson Robert Scott, Brendan Hines',1,8.5,8.5,3),(32,'Elite',2018,'romance','suspense','Jaime Lorente, Maria Pedraza, Miguel Herran, Aron Piper',1,8.7,8.7,1),(33,'Elite',2019,'romance','suspense','Jaime Lorente, Maria Pedraza, Miguel Herran, Aron Piper',1,8.7,8.7,2),(34,'Elite',2020,'romance','suspense','Jaime Lorente, Maria Pedraza, Miguel Herran, Aron Piper',1,8.8,8.8,3),(35,'Elite',2021,'romance','suspense','Aron Piper, Miguel Bernadeau, Ester Exposito, Itzan Escamilla',1,7.8,7.8,4),(36,'Moon Knight',2022,'super-hero','aventure','Oscar Isaac, May Calamawy, Ethan Hawke, Gaspard Ulliel',1,8.6,8.6,1),(37,'WandaVision',2021,'super-hero','comédie','Elizabeth Olsen, Paul Bettany, Teyonah Paris, Kathryn Hahn, Kat Dennings, Randall Park',1,8.4,8.4,1),(38,'The Umbrella Academy',2019,'fantaisie','action','Elliot Page, Tom Hopper, David Castaneda',1,8.5,8.5,1),(39,'The Umbrella Academy',2020,'fantaisie','action','Elliot Page, Tom Hopper, David Castaneda',1,8.7,8.7,2),(40,'The Umbrella Academy',2022,'fantaisie','action','Elliot Page, Tom Hopper, David Castaneda',1,8.4,8.4,3),(41,'Altered Carbon',2018,'science-fiction','action','Anthony Mackie, Renée Elise Goldsberry, Lela Loren, Simone Missick, Chris Conner',1,8.3,8.3,1),(42,'Altered Carbon',2020,'science-fiction','action','Anthony Mackie, Renée Elise Goldsberry, Lela Loren, Simone Missick, Chris Conner',1,8.3,8.3,2),(43,'Zoo',2015,'science-fiction','action','James Wolk, Kristen Connolly, Billy Burke, Nonso Anozie, Alyssa Diaz, Josh Salatin',1,8.6,8.6,1),(44,'Zoo',2016,'science-fiction','action','James Wolk, Kristen Connolly, Billy Burke, Nonso Anozie, Alyssa Diaz, Josh Salatin',1,8.8,8.8,2),(45,'Zoo',2017,'science-fiction','action','James Wolk, Kristen Connolly, Billy Burke, Nonso Anozie, Alyssa Diaz, Josh Salatin',1,8.7,8.7,3),(46,'Unbelievable',2019,'policier','drame','Kaitlyn Dever, Toni Collette, Merritt Wever ',1,8.3,8.3,1),(47,'3 Body Problem',2024,'science-fiction','suspense','Jess Hong, Liam Cunningham, Eiza Gonzalez, Jovan Adepo, Jonathan Pryce, Benedict Wong',1,8.4,8.4,1);
INSERT INTO `votesfilms` VALUES (1,'zackdev97',1,7.8),(2,'zackdev97',2,9.2),(3,'zackdev97',3,9),(4,'zackdev97',4,8.3),(5,'zackdev97',5,8.4),(6,'zackdev97',6,2),(7,'zackdev97',7,8.5),(8,'zackdev97',8,8),(9,'zackdev97',9,8.1),(10,'zackdev97',10,3),(11,'zackdev97',11,8.7),(12,'zackdev97',12,8.2),(13,'zackdev97',14,8.5),(14,'zackdev97',13,9),(15,'zackdev97',15,7.3),(16,'zackdev97',16,9),(17,'zackdev97',17,8.2),(18,'zackdev97',18,7.6),(19,'zackdev97',19,8),(20,'zackdev97',20,8.6),(21,'zackdev97',21,8.2),(22,'zackdev97',22,8.1),(23,'zackdev97',43,7.9),(24,'zackdev97',24,8.7),(25,'zackdev97',25,7.5),(26,'zackdev97',26,7.9),(27,'zackdev97',27,8.5),(28,'zackdev97',28,9.2),(29,'zackdev97',29,8.2),(30,'zackdev97',30,8.2),(31,'zackdev97',31,8.3),(32,'zackdev97',32,3),(33,'zackdev97',34,7.8),(34,'zackdev97',33,8.6),(35,'zackdev97',35,8.3),(36,'zackdev97',36,8.5),(37,'zackdev97',37,8.7),(38,'zackdev97',39,9),(39,'zackdev97',40,9),(40,'zackdev97',41,9.3),(41,'zackdev97',42,8.5),(42,'zackdev97',38,8.2),(43,'zackdev97',44,8.8),(44,'zackdev97',45,8.5),(45,'zackdev97',46,8.4),(46,'zackdev97',47,8.5),(47,'zackdev97',48,8.4),(48,'zackdev97',49,8.3),(49,'zackdev97',50,8.5),(50,'zackdev97',51,8.7),(51,'zackdev97',52,7.8),(52,'zackdev97',53,8.4),(53,'zackdev97',54,8.9),(54,'zackdev97',55,9.2),(55,'zackdev97',56,7.7),(56,'zackdev97',57,8.7),(57,'zackdev97',58,3),(58,'zackdev97',59,8.5),(59,'zackdev97',60,8.5),(60,'zackdev97',61,8.3),(61,'zackdev97',62,8.4),(62,'zackdev97',63,8.8),(63,'zackdev97',64,8.4),(64,'zackdev97',65,8.8),(65,'zackdev97',66,8.3),(66,'zackdev97',67,9),(67,'zackdev97',68,8.8),(68,'zackdev97',69,8.9),(69,'zackdev97',70,8.8),(70,'zackdev97',71,8.9),(71,'zackdev97',72,8.8),(72,'zackdev97',73,8.5),(73,'zackdev97',74,8.3),(74,'zackdev97',75,9.1),(75,'zackdev97',76,8.3),(76,'zackdev97',77,8.5),(77,'zackdev97',78,7.8),(78,'zackdev97',80,8.8),(79,'zackdev97',81,8.8),(80,'zackdev97',79,8.6),(81,'zackdev97',82,7),(82,'zackdev97',83,9.4),(83,'zackdev97',84,8.7),(84,'zackdev97',85,8.3),(85,'zackdev97',86,9),(86,'zackdev97',87,9),(87,'zackdev97',88,8),(88,'zackdev97',89,8.4),(89,'zackdev97',90,8.5),(90,'zackdev97',91,8.4),(91,'zackdev97',92,8.4),(92,'zackdev97',93,8.6),(93,'zackdev97',94,8.5),(94,'zackdev97',95,8.5),(95,'zackdev97',96,7.7),(96,'zackdev97',97,9),(97,'zackdev97',98,7.9),(98,'zackdev97',99,8.5),(99,'zackdev97',100,8.7),(100,'zackdev97',101,8.8),(101,'zackdev97',102,9),(102,'zackdev97',103,7.8),(103,'zackdev97',104,8.8),(104,'zackdev97',105,8),(105,'zackdev97',106,8.4),(106,'zackdev97',107,7),(107,'zackdev97',108,8.3),(108,'zackdev97',109,8),(109,'zackdev97',110,8.2),(110,'zackdev97',111,8.7),(111,'zackdev97',112,7),(112,'zackdev97',113,8.5),(113,'zackdev97',114,8.9),(114,'zackdev97',115,8.7),(115,'zackdev97',116,8.7),(116,'zackdev97',117,8),(117,'zackdev97',142,7.8),(118,'zackdev97',118,8.6),(119,'zackdev97',119,5),(120,'zackdev97',120,9),(121,'zackdev97',121,8.3),(122,'zackdev97',122,8.4),(123,'zackdev97',123,8.3),(124,'zackdev97',124,9.5),(125,'zackdev97',125,9.2),(126,'zackdev97',126,8.5),(127,'zackdev97',127,8.5),(128,'zackdev97',128,8.4),(129,'zackdev97',129,8.7),(130,'zackdev97',130,8.6),(131,'zackdev97',131,8.5),(132,'zackdev97',132,8.5),(133,'zackdev97',133,8.5),(134,'zackdev97',134,8.8),(135,'zackdev97',135,8.8),(136,'zackdev97',136,8.2),(137,'zackdev97',137,8.3),(138,'zackdev97',138,8.6),(139,'zackdev97',139,8.6),(140,'zackdev97',140,8.5),(141,'zackdev97',141,8.9);
INSERT INTO `votesseries` VALUES (1,'zackdev97',1,8.8),(2,'zackdev97',2,8.6),(3,'zackdev97',3,9.5),(4,'zackdev97',4,9.4),(5,'zackdev97',5,9.5),(6,'zackdev97',6,9.4),(7,'zackdev97',7,9),(8,'zackdev97',8,9.4),(9,'zackdev97',9,9.5),(10,'zackdev97',10,8.7),(11,'zackdev97',11,8.6),(12,'zackdev97',12,8.6),(13,'zackdev97',13,8.8),(14,'zackdev97',14,8.5),(15,'zackdev97',15,8.6),(16,'zackdev97',16,8.4),(17,'zackdev97',17,8.6),(18,'zackdev97',18,9.1),(19,'zackdev97',19,9.3),(20,'zackdev97',20,8.9),(21,'zackdev97',21,9.4),(22,'zackdev97',22,8.6),(23,'zackdev97',23,8.9),(24,'zackdev97',24,8.8),(25,'zackdev97',25,9),(26,'zackdev97',26,8.9),(27,'zackdev97',27,8.8),(28,'zackdev97',28,8.6),(29,'zackdev97',29,8.6),(30,'zackdev97',30,8.6),(31,'zackdev97',31,8.5),(32,'zackdev97',32,8.7),(33,'zackdev97',33,8.7),(34,'zackdev97',34,8.8),(35,'zackdev97',35,7.8),(36,'zackdev97',36,8.6),(37,'zackdev97',37,8.4),(38,'zackdev97',38,8.5),(39,'zackdev97',39,8.7),(40,'zackdev97',40,8.4),(41,'zackdev97',41,8.3),(42,'zackdev97',42,8.3),(43,'zackdev97',43,8.6),(44,'zackdev97',44,8.8),(45,'zackdev97',45,8.7),(46,'zackdev97',46,8.3),(47,'zackdev97',47,8.4);
ALTER TABLE commentairesFilms ADD CONSTRAINT fk_id FOREIGN KEY (id) REFERENCES votesFilms(id) ON DELETE CASCADE;
ALTER TABLE commentairesSeries ADD CONSTRAINT fk_sid FOREIGN KEY (id) REFERENCES votesSeries(id) ON DELETE CASCADE;
INSERT INTO `acteurs` VALUES (1,'Adam','Sandler','1966-09-09','masculin','États-Unis'),(2,'Emma','Myers','2002-04-02','feminin','États-Unis'),(3,'Jenna','Ortega','2002-09-27','feminin','États-Unis');
INSERT INTO `commentairesseries` VALUES (11,'Pas aussi bon que Dark, mais série très mystérieuse et très captivante'),(14,'Légèrement moins bon que la première saison, mais tout de même divertissant');
