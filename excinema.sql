-- Active: 1678458057865@@127.0.0.1@3306@excinema

/*DELETE & CREATE DATABASE*/

--DROP DATABASE IF EXISTS excinema;

--CREATE DATABASE IF NOT EXISTS excinema;

/*EXEMPLE OF CREATING THE PERMISSION FOR A CINEMA MANAGER*/

CREATE USER 'cinema_admin1'@'localhost' IDENTIFIED BY 'password';

CREATE VIEW CINEMA_MOVIE_VIEW AS 
	SELECT c.name, m.title
	FROM cinema_movie cm
	    INNER JOIN cinema c ON c.id = cm.cinema_id
	    INNER JOIN movie m ON m.id = cm.movie_id
	WHERE c.id =
2; 
GRANT ALTER,
SELECT ON CINEMA_MOVIE_VIEW TO 'cinema_admin1' @'localhost';

/*CREATE, MODIFY CINEMA TABLE & TESTING SOME FUNCTIONS TO MAKE SURE IT WORKS*/

CREATE TABLE
    cinema (
        id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        name VARCHAR(255) NOT NULL,
        address VARCHAR(255) NOT NULL,
        phone VARCHAR(50) NOT NULL,
        PRIMARY KEY (id)
    );

ALTER TABLE cinema 
RENAME COLUMN address TO adress;

INSERT INTO
    cinema (name, adress, phone)
VALUES (
        'Cinéma 1',
        '1 rue de la paix',
        '01 23 45 67 89'
    );

DELETE FROM cinema WHERE id='1';

CREATE INDEX idx_cinema ON cinema (name);

SHOW INDEX FROM cinema;

DROP INDEX idx_cinema ON cinema;

CREATE UNIQUE INDEX idx_adress_cin ON cinema (adress);

SELECT COUNT(*) FROM cinema;

SELECT * FROM cinema ORDER BY name asc LIMIT 100;

/*CREATE, MODIFY MOVIE TABLE & TESTING SOME FUNCTIONS TO MAKE SURE IT WORKS*/

CREATE TABLE
    movie (
        id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        title VARCHAR(50) NOT NULL,
        duration VARCHAR(10),
        type VARCHAR(255),
        PRIMARY KEY (id)
    );

SELECT SUM(duration) FROM movie;

SELECT AVG(duration) FROM movie;

ALTER TABLE movie 
MODIFY COLUMN title VARCHAR(100) NOT NULL;

CREATE TABLE
    session (
        id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        date DATETIME NOT NULL,
        hour TIME NOT NULL,
        spots INT UNSIGNED NOT NULL,
        PRIMARY KEY (id)
    );

/*CREATE SESSION TABLE & CHANGE THE DATE FORMAT TO CORRESPOND TO EUROPEAN FORMAT*/

ALTER TABLE session 
MODIFY COLUMN date DATE NOT NULL;

SELECT id, DATE_FORMAT(date,'%d/%m/%Y'), hour, spots FROM session;

/*CREATE ROOM TABLE*/

CREATE TABLE
    room (
        id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        number INT NOT NULL,
        capacity INT NOT NULL,
        PRIMARY KEY (id)
    );

/*CREATE RATE TABLE*/

CREATE TABLE
    rate (
        id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        type VARCHAR(50) NOT NULL,
        price FLOAT NOT NULL,
        discount VARCHAR(50),
        PRIMARY KEY (id)
    );

/*CREATE, MODIFY USER TABLE & HASH PASSWORD TO IMPROVE SECURITY*/

DROP TABLE user;

CREATE TABLE
    user (
        id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        name VARCHAR(50) NOT NULL,
        surname VARCHAR(50) NOT NULL,
        email VARCHAR(180) NOT NULL,
        phone VARCHAR(50) NOT NULL,
        PRIMARY KEY (id)
    );

ALTER TABLE user 
ADD role JSON NOT NULL;

ALTER TABLE user 
ADD password VARCHAR(256) NOT NULL;

INSERT INTO
    user (
        name,
        surname,
        email,
        phone,
        role,
        password
    )
VALUES (
        'Dupont',
        'Jean',
        'jean.dupont@gmail,com',
        '0123456789',
        '[{"role":"user"}]',
        SHA2('password', 256)
    ), (
        'Durand',
        'Pierre',
        'pierre.durand@gmail.com',
        '0123456789',
        '[{"role":"user"}]',
        SHA2('password', 256)
    ), (
        'Martin',
        'Paul',
        'martin.paul@gmail.com',
        '0123456789',
        '[{"role":"user"}]',
        SHA2('password', 256)
    );

SELECT SHA2('password', 256);

/*INTERMEDIARIES TABLES FOR MANY TO MANY RELATIONS*/

DROP TABLE cinema_movie;

CREATE TABLE
    cinema_movie (
        cinema_id INT UNSIGNED NOT NULL,
        movie_id INT UNSIGNED NOT NULL,
        PRIMARY KEY (cinema_id, movie_id),
        FOREIGN KEY (cinema_id) REFERENCES cinema(id),
        FOREIGN KEY (movie_id) REFERENCES movie(id)
    );

SHOW CREATE TABLE cinema_movie;

INSERT INTO cinema_movie (cinema_id, movie_id) 
VALUES ('1', '1');

INSERT INTO cinema_movie (cinema_id, movie_id)
VALUES ('2', '2'), ('3', '3');

INSERT INTO cinema_movie (cinema_id, movie_id)
VALUES ('2', '3'), ('2', '4');

CREATE TABLE
    movie_session (
        movie_id INT UNSIGNED NOT NULL,
        session_id INT UNSIGNED NOT NULL,
        PRIMARY KEY (movie_id, session_id),
        FOREIGN KEY (movie_id) REFERENCES movie(id),
        FOREIGN KEY (session_id) REFERENCES session(id)
    );

CREATE TABLE
    session_room (
        session_id INT UNSIGNED NOT NULL,
        room_id INT UNSIGNED NOT NULL,
        PRIMARY KEY (session_id, room_id),
        FOREIGN KEY (session_id) REFERENCES session(id),
        FOREIGN KEY (room_id) REFERENCES room(id)
    );

CREATE TABLE
    session_rate (
        session_id INT UNSIGNED NOT NULL,
        rate_id INT UNSIGNED NOT NULL,
        PRIMARY KEY (session_id, rate_id),
        FOREIGN KEY (session_id) REFERENCES session(id),
        FOREIGN KEY (rate_id) REFERENCES rate(id)
    );

DROP TABLE user_session;

CREATE TABLE
    user_session (
        user_id INT UNSIGNED NOT NULL,
        session_id INT UNSIGNED NOT NULL,
        PRIMARY KEY (user_id, session_id),
        FOREIGN KEY (user_id) REFERENCES user(id),
        FOREIGN KEY (session_id) REFERENCES session(id)
    );

/*INSERT FAKE DATA INTO TABLES THANKS TO MOCKAROO.COM*/

INSERT INTO cinema (id, name, adress, phone)
VALUES (
        1,
        'Bogan, Lesch and Collins',
        '53013 Lakewood Lane',
        '3997308107'
    ), (
        2,
        'Schuppe Group',
        '048 Talmadge Alley',
        '4032156284'
    ), (
        3,
        'McKenzie, Smith and Kub',
        '04 Haas Lane',
        '8623074664'
    ), (
        4,
        'Gleichner and Sons',
        '59 Everett Point',
        '9617273546'
    ), (
        5,
        'Crooks, Bergstrom and Doyle',
        '16 Westend Pass',
        '6915285094'
    ), (
        6,
        'Marquardt, Grimes and Barrows',
        '41 Ohio Pass',
        '6466642545'
    ), (
        7,
        'Mante, Schneider and Purdy',
        '9 Graceland Street',
        '6371777377'
    ), (
        8,
        'Grant-Kohler',
        '61735 Northfield Point',
        '8184167540'
    ), (
        9,
        'Weber-Bartoletti',
        '43 Golf View Pass',
        '8095212867'
    ), (
        10,
        'Wilderman-Gaylord',
        '2 Elka Avenue',
        '6131769941'
    ), (
        11,
        'Windler Inc',
        '45 Old Shore Hill',
        '6167928357'
    ), (
        12,
        'Upton LLC',
        '390 Laurel Circle',
        '6295144181'
    ), (
        13,
        'Daniel-Purdy',
        '9083 Fuller Crossing',
        '6086665595'
    ), (
        14,
        'Rutherford, Yundt and O''Kon',
        '1 Kensington Court',
        '1556257184'
    ), (
        15,
        'Howe-Cruickshank',
        '051 7th Way',
        '4315315288'
    ), (
        16,
        'Little, Littel and Murazik',
        '86957 Jana Pass',
        '3429076803'
    ), (
        17,
        'Kiehn, Ernser and Schmitt',
        '52 Packers Parkway',
        '7497812690'
    ), (
        18,
        'Ritchie, Ryan and Denesik',
        '596 Sugar Way',
        '9825678368'
    ), (
        19,
        'Rosenbaum, Harris and Pagac',
        '64678 Commercial Avenue',
        '8867865979'
    ), (
        20,
        'Reynolds-Hoeger',
        '4 Hayes Circle',
        '6137529412'
    ), (
        21,
        'Raynor and Sons',
        '21 Cordelia Parkway',
        '3158627857'
    ), (
        22,
        'Grant-Christiansen',
        '9 Orin Street',
        '2297658684'
    ), (
        23,
        'Bergstrom Group',
        '3 Northport Drive',
        '9491477789'
    ), (
        24,
        'Vandervort Group',
        '9324 Granby Center',
        '2789489705'
    ), (
        25,
        'Lynch and Sons',
        '37921 Duke Drive',
        '5231791170'
    ), (
        26,
        'Erdman Group',
        '121 Hauk Lane',
        '8763894685'
    ), (
        27,
        'Lebsack Inc',
        '657 Carioca Parkway',
        '7353205834'
    ), (
        28,
        'Hermann-Bins',
        '197 Main Place',
        '8878658797'
    ), (
        29,
        'Treutel-Beer',
        '1 Elgar Hill',
        '8006544853'
    ), (
        30,
        'Berge-Klein',
        '876 Laurel Avenue',
        '8431971532'
    ), (
        31,
        'Cassin, Rippin and Mayer',
        '352 Anzinger Plaza',
        '3406337653'
    ), (
        32,
        'Parker, Schimmel and Weimann',
        '2 Upham Point',
        '5432768790'
    ), (
        33,
        'Borer, Erdman and Gutmann',
        '76 Stoughton Place',
        '6393621265'
    ), (
        34,
        'Padberg, Konopelski and Willms',
        '33685 Independence Place',
        '8871882759'
    ), (
        35,
        'Koepp, Abbott and Schumm',
        '6 Delladonna Place',
        '9303843512'
    ), (
        36,
        'Kilback LLC',
        '3 East Road',
        '6886286293'
    ), (
        37,
        'Hilpert and Sons',
        '1753 Oak Center',
        '6287351772'
    ), (
        38,
        'Marquardt-Fritsch',
        '9 Marquette Park',
        '9877047309'
    ), (
        39,
        'Pouros Inc',
        '6 Tony Street',
        '8209689150'
    ), (
        40,
        'Sauer and Sons',
        '24 David Road',
        '7739335100'
    ), (
        41,
        'Heathcote-Halvorson',
        '726 Reinke Drive',
        '8971415000'
    ), (
        42,
        'Renner, Welch and Champlin',
        '9699 Grayhawk Way',
        '2212012271'
    ), (
        43,
        'Glover Inc',
        '853 Debra Circle',
        '1721595025'
    ), (
        44,
        'Dare, Rosenbaum and Swift',
        '55 Blackbird Park',
        '7748703253'
    ), (
        45,
        'Robel-Weimann',
        '72 Namekagon Plaza',
        '4802213117'
    ), (
        46,
        'Denesik and Sons',
        '57 Sunbrook Court',
        '2119934975'
    ), (
        47,
        'Franecki and Sons',
        '26150 Melby Drive',
        '7529743521'
    ), (
        48,
        'Robel-Schoen',
        '07 Eastwood Alley',
        '7026671793'
    ), (
        49,
        'Beahan Inc',
        '945 Saint Paul Street',
        '6977857460'
    ), (
        50,
        'Marks-Bashirian',
        '487 Loomis Park',
        '4321622883'
    );

INSERT INTO movie (id, title, duration, type)
VALUES (1, 'Pine Flat', 1, 'Drama'), (
        2,
        'Hot Spot, The',
        2,
        'Crime|Drama|Romance'
    ), (
        3,
        'Destination Moon',
        3,
        'Sci-Fi'
    ), (
        4,
        'Sometimes They Come Back... for More',
        4,
        'Horror'
    ), (
        5,
        'French Fried Vacation (Les Bronzés)',
        5,
        'Comedy'
    ), (
        6,
        'Shadow of the Thin Man',
        6,
        'Comedy|Crime|Mystery'
    ), (
        7,
        'Wild Things',
        7,
        'Crime|Drama|Mystery|Thriller'
    ), (
        8,
        'There Will Be No Leave Today (Segodnya uvolneniya ne budet)',
        8,
        'Drama|Thriller'
    ), (
        9,
        'Chinatown',
        9,
        'Crime|Film-Noir|Mystery|Thriller'
    ), (
        10,
        'Man of the House',
        10,
        'Comedy'
    ), (
        11,
        'Brotherhood of the Wolf (Pacte des loups, Le)',
        11,
        'Action|Mystery|Thriller'
    ), (
        12,
        'Classe Tous Risques (Big Risk, The)',
        12,
        'Crime|Drama|Film-Noir|Romance|Thriller'
    ), (
        13,
        'First Wives Club, The',
        13,
        'Comedy'
    ), (
        14,
        'Someone Like You',
        14,
        'Comedy|Romance'
    ), (
        15,
        'Nine Ways to Approach Helsinki (Yhdeksän tapaa lähestyä Helsinkiä)',
        15,
        'Documentary'
    ), (
        16,
        'Out of the Ashes',
        16,
        'Drama'
    ), (
        17,
        'Assassination Tango',
        17,
        'Drama|Thriller'
    ), (
        18,
        'Bomber',
        18,
        'Comedy|Drama'
    ), (
        19,
        'Turin Horse, The (A Torinói ló)',
        19,
        'Drama'
    ), (
        20,
        'Côte d''Azur (Crustacés et coquillages)',
        20,
        'Comedy|Musical|Romance'
    ), (
        21,
        'Brothers in Trouble',
        21,
        'Drama'
    ), (22, 'Ararat', 22, 'Drama|War'), (
        23,
        'Inside the Twin Towers',
        23,
        'Drama'
    ), (
        24,
        'To Encourage the Others',
        24,
        'Drama'
    ), (
        25,
        'About Face: Supermodels Then and Now',
        25,
        'Comedy|Documentary'
    ), (26, 'Schizopolis', 26, 'Comedy'), (
        27,
        'Three Steps Above Heaven (Tres metros sobre el cielo)',
        27,
        'Drama|Romance'
    ), (
        28,
        'Rage',
        28,
        'Action|Crime|Thriller'
    ), (
        29,
        'Cremator, The (Spalovac mrtvol)',
        29,
        'Comedy|Drama|Horror|Thriller'
    ), (
        30,
        'Going Straight',
        30,
        'Crime|Drama'
    ), (
        31,
        'Electric House, The',
        31,
        'Comedy'
    ), (
        32,
        'History Is Made at Night',
        32,
        'Drama|Romance'
    ), (
        33,
        'Invisible, The',
        33,
        'Crime|Drama|Fantasy|Mystery|Thriller'
    ), (
        34,
        'If You Are the One',
        34,
        'Comedy|Romance'
    ), (
        35,
        'Silent Action',
        35,
        'Action|Crime|Drama'
    ), (
        36,
        'Drunken Master (Jui kuen)',
        36,
        'Action|Comedy'
    ), (
        37,
        'Making ''The New World''',
        37,
        'Documentary'
    ), (
        38,
        'Spaghetti West, The',
        38,
        'Documentary'
    ), (39, 'Civil Brand', 39, 'Drama'), (
        40,
        'Sketches of Frank Gehry',
        40,
        'Documentary'
    ), (
        41,
        'Satan''s Brew (Satansbraten)',
        41,
        'Comedy|Drama'
    ), (
        42,
        'Double Trouble',
        42,
        'Action|Comedy'
    ), (
        43,
        'Rocket Science',
        43,
        'Comedy|Drama'
    ), (
        44,
        'Czech Dream (Ceský sen)',
        44,
        'Documentary'
    ), (
        45,
        'Gestapo''s Last Orgy, The (L''ultima orgia del III Reich)',
        45,
        'Thriller|War'
    ), (
        46,
        'Love''s Kitchen',
        46,
        'Comedy|Drama|Romance'
    ), (
        47,
        'Back Door to Hell',
        47,
        'Drama|War'
    ), (
        48,
        'Angel in My Pocket',
        48,
        'Comedy'
    ), (
        49,
        'It Started with Eve',
        49,
        'Comedy|Musical|Romance'
    ), (50, 'Roots', 50, 'Drama|War'), (
        51,
        'Skyscraper (Skyskraber)',
        51,
        'Comedy|Drama'
    ), (
        52,
        'ATF ',
        52,
        'Drama|Thriller'
    ), (
        53,
        'Peck on the Cheek, A (Kannathil Muthamittal)',
        53,
        'Drama|War'
    ), (54, 'Back Street', 54, 'Drama'), (
        55,
        'July Rhapsody (Laam yan sei sap)',
        55,
        'Drama'
    ), (
        56,
        'British Intelligence',
        56,
        'Drama'
    ), (
        57,
        'Bombay Beach',
        57,
        'Documentary|Drama|Musical'
    ), (
        58,
        'Repast (Meshi)',
        58,
        'Drama'
    ), (
        59,
        'Sinbad: Legend of the Seven Seas',
        59,
        'Adventure|Animation|Children|Fantasy'
    ), (
        60,
        'Two Escobars, The',
        60,
        'Crime|Documentary'
    ), (
        61,
        'Crank: High Voltage',
        61,
        'Action|Comedy|Crime'
    ), (
        62,
        'Bully',
        62,
        'Crime|Drama|Thriller'
    ), (
        63,
        'Truman Show, The',
        63,
        'Comedy|Drama|Sci-Fi'
    ), (
        64,
        'Assault, The (Aanslag, De)',
        64,
        'Drama|Romance|War'
    ), (
        65,
        'Oyster Farmer',
        65,
        'Drama'
    ), (
        66,
        'Steel Trap, The',
        66,
        'Crime|Drama'
    ), (
        67,
        'Murder Party',
        67,
        'Comedy|Drama|Horror|Thriller'
    ), (
        68,
        'Nora''s Will (Cinco días sin Nora)',
        68,
        'Comedy|Drama'
    ), (
        69,
        'Senso',
        69,
        'Drama|Romance|War'
    ), (
        70,
        'English Teacher, The',
        70,
        'Comedy|Drama'
    ), (
        71,
        'Cult of the Cobra',
        71,
        'Horror'
    ), (
        72,
        'Eden Lake',
        72,
        'Horror|Thriller'
    ), (
        73,
        'Horse Soldiers, The',
        73,
        'Adventure|War|Western'
    ), (
        74,
        'Blob, The',
        74,
        'Horror|Sci-Fi'
    ), (
        75,
        'Young Guns II',
        75,
        'Action|Western'
    ), (
        76,
        'Broadway Rhythm',
        76,
        'Musical'
    ), (
        77,
        '1939: Hollywood''s Greatest Year',
        77,
        'Documentary'
    ), (
        78,
        'Age of Innocence, The',
        78,
        'Drama'
    ), (
        79,
        'Love Crime (Crime d''amour)',
        79,
        'Crime|Mystery|Thriller'
    ), (
        80,
        'Pyaar Impossible',
        80,
        'Comedy|Romance'
    ), (
        81,
        'Myth, The (San wa)',
        81,
        'Action|Adventure|Comedy|Fantasy'
    ), (
        82,
        'Voices from the List',
        82,
        'Documentary'
    ), (
        83,
        'Thief and the Cobbler, The (a.k.a. Arabian Knight)',
        83,
        'Adventure|Animation|Comedy|Fantasy'
    ), (84, 'My Family', 84, 'Drama'), (
        85,
        '3 Extremes (Three... Extremes) (Saam gaang yi)',
        85,
        'Horror'
    ), (
        86,
        'Guy and a Gal, A (En kille och en tjej)',
        86,
        'Comedy|Drama'
    ), (
        87,
        'Strange Cargo',
        87,
        'Drama'
    ), (
        88,
        'Zus & Zo',
        88,
        'Comedy|Drama|Romance'
    ), (
        89,
        'Holy Guests (Ha-Ushpizin)',
        89,
        'Drama'
    ), (
        90,
        'Japan''s Longest Day (Nihon no ichiban nagai hi)',
        90,
        'Drama|War'
    ), (
        91,
        'Jumpin'' Jack Flash',
        91,
        'Action|Comedy|Romance|Thriller'
    ), (
        92,
        'Santa''s Pocket Watch',
        92,
        '(no genres listed)'
    ), (
        93,
        'Blue Collar',
        93,
        'Crime|Drama'
    ), (
        94,
        'Deal of the Century',
        94,
        'Comedy'
    ), (
        95,
        'Simple Simon (I rymden finns inga känslor)',
        95,
        'Comedy|Drama'
    ), (
        96,
        'Caddy, The',
        96,
        'Comedy|Musical'
    ), (
        97,
        'Tiptoes',
        97,
        'Comedy|Drama|Romance'
    ), (
        98,
        'Jack the Bear',
        98,
        'Comedy|Drama'
    ), (
        99,
        'I''m a Cyborg, But That''s OK (Saibogujiman kwenchana)',
        99,
        'Comedy|Drama|Romance|Sci-Fi'
    ), (
        100,
        'Ganes',
        100,
        'Drama|Musical'
    ), (
        101,
        'Leila',
        101,
        'Drama|Romance'
    ), (
        102,
        'Old Man and the Sea, The',
        102,
        'Drama'
    ), (
        103,
        'Whistleblower, The',
        103,
        'Drama|Thriller'
    ), (
        104,
        'League of Gentlemen, The',
        104,
        'Adventure|Comedy|Crime|Drama'
    ), (
        105,
        'Goodbye, South, Goodbye (Nan guo zai jian, nan guo)',
        105,
        'Crime|Drama'
    ), (
        106,
        'Sky Fighters (Les Chevaliers Du Ciel)',
        106,
        'Action|Adventure'
    ), (
        107,
        'Live Free or Die',
        107,
        'Comedy|Crime'
    ), (
        108,
        'Playing with Love (Puppy Love) (Maladolescenza)',
        108,
        'Drama'
    ), (
        109,
        'Akira Kurosawa''s Dreams (Dreams)',
        109,
        'Drama|Fantasy'
    ), (
        110,
        'Rainy Dog (Gokudô kuroshakai)',
        110,
        'Crime|Drama'
    ), (
        111,
        'All Quiet on the Western Front',
        111,
        'Action|Drama|War'
    ), (
        112,
        'Ferocious',
        112,
        'Crime|Thriller'
    ), (
        113,
        'My Left Eye Sees Ghosts (Ngo joh aan gin diy gwai)',
        113,
        'Comedy|Fantasy|Romance'
    ), (
        114,
        'Fortune Cookie, The',
        114,
        'Comedy|Drama|Romance'
    ), (
        115,
        'Eternity and a Day (Mia aoniotita kai mia mera)',
        115,
        'Drama'
    ), (
        116,
        'Blame (6 Films to Keep You Awake) (Películas para no dormir: La culpa)',
        116,
        'Drama|Horror|Mystery'
    ), (
        117,
        'Tapped',
        117,
        'Documentary'
    ), (
        118,
        'Killers, The',
        118,
        'Crime|Film-Noir'
    ), (
        119,
        '21 Hours at Munich',
        119,
        'Drama'
    ), (
        120,
        'Better Than Sex',
        120,
        'Comedy|Romance'
    ), (
        121,
        'Phar Lap',
        121,
        'Children|Drama'
    ), (122, 'Accepted', 122, 'Comedy'), (
        123,
        'High Strung',
        123,
        'Comedy'
    ), (
        124,
        '8 Diagram Pole Fighter, The (a.k.a. Invincible Pole Fighter) (Wu Lang ba gua gun)',
        124,
        'Action|Drama'
    ), (
        125,
        'Truth About Charlie, The',
        125,
        'Mystery|Thriller'
    ), (
        126,
        'Thale',
        126,
        'Action|Drama|Horror|Mystery'
    ), (
        127,
        '7 Khoon Maaf',
        127,
        'Drama|Mystery|Thriller'
    ), (
        128,
        'Destroy All Monsters (Kaijû sôshingeki)',
        128,
        'Action|Sci-Fi|Thriller'
    ), (
        129,
        'Some Girl',
        129,
        'Comedy|Drama'
    ), (130, 'Tied', 130, 'Drama'), (
        131,
        'Dreams of  a Life',
        131,
        'Documentary'
    ), (
        132,
        'Let Me In',
        132,
        'Drama|Horror|Mystery'
    ), (
        133,
        'Disconnect',
        133,
        'Drama|Thriller'
    ), (
        134,
        'Grotesque (Gurotesuku)',
        134,
        'Horror|Thriller'
    ), (
        135,
        'Little Mermaid, The',
        135,
        'Animation|Children|Comedy|Musical|Romance'
    ), (
        136,
        'Warren Oates: Across the Border',
        136,
        'Documentary'
    ), (
        137,
        'In Praise of Older Women',
        137,
        'Drama'
    ), (
        138,
        'Jetsons: The Movie',
        138,
        'Animation|Children|Comedy|Musical|Sci-Fi'
    ), (
        139,
        'Air Force',
        139,
        'Action|Drama|War'
    ), (
        140,
        'Ballet Shoes',
        140,
        'Children|Drama'
    ), (
        141,
        'Jack Strong',
        141,
        'Action|Crime|Thriller'
    ), (
        142,
        'The Lazarus Effect',
        142,
        'Horror|Thriller'
    ), (
        143,
        'Country Girl, The',
        143,
        'Drama'
    ), (
        144,
        'Killer at Large',
        144,
        'Documentary'
    ), (
        145,
        'Battlestar Galactica: The Plan',
        145,
        'Action|Adventure|Drama|Sci-Fi'
    ), (
        146,
        'First Strike',
        146,
        'Documentary'
    ), (
        147,
        'Swindle',
        147,
        'Action|Comedy'
    ), (
        148,
        'Darby''s Rangers',
        148,
        'Action|Drama|War'
    ), (
        149,
        'Garden Party',
        149,
        'Drama|Romance'
    ), (
        150,
        'Freaks',
        150,
        'Crime|Drama|Horror'
    ), (
        151,
        'Guardian, The',
        151,
        'Action|Adventure|Drama'
    ), (
        152,
        'Killers, The',
        152,
        'Crime|Film-Noir'
    ), (
        153,
        'Love in Bloom',
        153,
        'Romance'
    ), (
        154,
        'Father Goose',
        154,
        'Adventure|Comedy|Romance|War'
    ), (
        155,
        'Armstrong Lie, The',
        155,
        'Documentary'
    ), (
        156,
        'Two for the Seesaw',
        156,
        'Drama|Romance'
    ), (
        157,
        'Too Tough to Die: A Tribute to Johnny Ramone',
        157,
        'Documentary'
    ), (
        158,
        'Bright Lights, Big City',
        158,
        'Drama'
    ), (
        159,
        'A Husband of Round Trip',
        159,
        'Comedy|Fantasy'
    ), (
        160,
        'Dark Circles ',
        160,
        'Horror'
    ), (
        161,
        'Great Gatsby, The',
        161,
        'Drama'
    ), (
        162,
        'Eichmann',
        162,
        'Drama|War'
    ), (
        163,
        'Dance Flick',
        163,
        'Comedy|Musical'
    ), (
        164,
        'Friends with Money',
        164,
        'Comedy|Drama|Romance'
    ), (
        165,
        'Princess Mononoke (Mononoke-hime)',
        165,
        'Action|Adventure|Animation|Drama|Fantasy'
    ), (166, 'Cosmopolis', 166, 'Drama'), (
        167,
        'Age of Ice',
        167,
        'Adventure|Sci-Fi'
    ), (
        168,
        'There Be Dragons',
        168,
        'Drama|War'
    ), (
        169,
        'Adam Had Four Sons',
        169,
        'Drama|Romance'
    ), (
        170,
        'Late George Apley, The',
        170,
        'Comedy'
    ), (
        171,
        'Salvage',
        171,
        'Horror|Mystery|Thriller'
    ), (
        172,
        'Rocker, The',
        172,
        'Comedy'
    ), (
        173,
        'It Came from Outer Space',
        173,
        'Sci-Fi'
    ), (
        174,
        'Gas, Food, Lodging',
        174,
        'Drama|Romance'
    ), (
        175,
        'Beauty and the Beast: The Enchanted Christmas',
        175,
        'Animation|Children|Fantasy|Musical'
    ), (176, 'Boom!', 176, 'Drama'), (
        177,
        'Trilogy of Terror II',
        177,
        'Horror'
    ), (
        178,
        'Gold Diggers of 1935',
        178,
        'Comedy|Musical'
    ), (
        179,
        'Big Bang Love, Juvenile A (46-okunen no koi)',
        179,
        'Drama'
    ), (
        180,
        'Brassed Off',
        180,
        'Comedy|Drama|Romance'
    ), (
        181,
        'Love Hina Spring Special',
        181,
        'Animation|Comedy|Musical|Romance'
    ), (
        182,
        'Three Brothers 2, The (Les trois frères, le retour)',
        182,
        'Comedy'
    ), (
        183,
        'Passage to Marseille',
        183,
        'Adventure|Drama|War'
    ), (
        184,
        'On Our Merry Way',
        184,
        'Comedy|Drama'
    ), (
        185,
        'Patty Hearst',
        185,
        '(no genres listed)'
    ), (
        186,
        'American Loser (Trainwreck: My Life as an Idiot)',
        186,
        'Comedy|Drama'
    ), (
        187,
        'And Nobody Weeps for Me (Und keiner weint mir nach)',
        187,
        'Drama|Romance'
    ), (
        188,
        'Eminem AKA ',
        188,
        'Documentary'
    ), (
        189,
        'Tom at the Farm (Tom à la ferme)',
        189,
        'Drama'
    ), (
        190,
        'Afflicted, The',
        190,
        'Horror|Thriller'
    ), (
        191,
        'Dead Man''s Bluff',
        191,
        'Action|Comedy|Crime'
    ), (
        192,
        'Mustalaishurmaaja',
        192,
        'Drama|Romance'
    ), (
        193,
        'Are You Here',
        193,
        'Comedy'
    ), (
        194,
        'The Inhabited Island',
        194,
        'Fantasy|Sci-Fi'
    ), (
        195,
        'Niko & the Way to the Stars (a.k.a. The Flight Before Christmas) (Niko - Lentäjän poika)',
        195,
        'Adventure|Animation|Children|Drama|Fantasy'
    ), (
        196,
        'Face of Terror',
        196,
        'Action|Drama|Thriller'
    ), (
        197,
        'Pursuit of Happiness, The',
        197,
        'Drama'
    ), (
        198,
        'Green Hornet, The',
        198,
        'Action|Comedy|Crime|Fantasy|Thriller|IMAX'
    ), (
        199,
        'Soldier',
        199,
        'Action|Sci-Fi|War'
    ), (
        200,
        'Transformers',
        200,
        'Action|Sci-Fi|Thriller|IMAX'
    );

INSERT INTO session (id, date, hour, spots)
VALUES (1, '2023-01-27', '16:40', 1), (2, '2022-12-31', '18:25', 2), (3, '2022-12-07', '21:03', 3), (4, '2022-03-29', '20:08', 4), (5, '2022-07-20', '19:18', 5), (6, '2022-11-07', '19:01', 6), (7, '2022-05-29', '17:37', 7), (8, '2023-02-28', '19:20', 8), (9, '2023-02-26', '17:46', 9), (10, '2022-09-25', '19:37', 10), (11, '2022-07-30', '19:22', 11), (12, '2022-08-25', '17:50', 12), (13, '2022-08-03', '22:54', 13), (14, '2022-09-08', '18:04', 14), (15, '2022-03-16', '20:21', 15), (16, '2023-02-25', '21:17', 16), (17, '2022-06-20', '21:02', 17), (18, '2022-03-13', '17:44', 18), (19, '2023-01-25', '22:29', 19), (20, '2023-02-21', '16:38', 20), (21, '2022-05-01', '20:25', 21), (22, '2022-12-08', '18:47', 22), (23, '2022-05-10', '20:48', 23), (24, '2023-01-14', '21:44', 24), (25, '2023-01-14', '20:24', 25), (26, '2022-11-16', '22:42', 26), (27, '2023-02-11', '17:40', 27), (28, '2023-03-12', '19:24', 28), (29, '2023-03-16', '17:00', 29), (30, '2022-11-01', '20:36', 30), (31, '2022-03-26', '18:10', 31), (32, '2022-05-19', '18:50', 32), (33, '2022-08-28', '21:31', 33), (34, '2022-10-04', '16:32', 34), (35, '2023-01-27', '19:36', 35), (36, '2022-08-17', '22:37', 36), (37, '2023-02-04', '17:10', 37), (38, '2022-10-25', '19:33', 38), (39, '2022-10-22', '16:26', 39), (40, '2022-06-16', '21:51', 40), (41, '2022-06-27', '19:28', 41), (42, '2023-02-12', '22:19', 42), (43, '2022-08-11', '16:07', 43), (44, '2022-06-14', '17:03', 44), (45, '2022-06-28', '16:45', 45), (46, '2023-02-04', '17:38', 46), (47, '2023-01-14', '20:16', 47), (48, '2022-06-28', '20:15', 48), (49, '2023-02-14', '17:12', 49), (50, '2022-04-28', '22:42', 50), (51, '2022-10-23', '19:35', 51), (52, '2022-04-21', '22:40', 52), (53, '2022-11-03', '22:38', 53), (54, '2022-08-29', '17:18', 54), (55, '2022-10-01', '22:01', 55), (56, '2023-03-29', '16:15', 56), (57, '2022-03-30', '17:35', 57), (58, '2022-11-29', '17:04', 58), (59, '2023-03-27', '21:41', 59), (60, '2022-10-05', '17:05', 60), (61, '2022-04-03', '21:54', 61), (62, '2022-10-27', '21:52', 62), (63, '2022-11-28', '16:30', 63), (64, '2022-06-18', '19:50', 64), (65, '2022-06-26', '17:12', 65), (66, '2023-02-21', '16:56', 66), (67, '2022-10-20', '16:03', 67), (68, '2022-08-06', '20:24', 68), (69, '2023-01-07', '18:49', 69), (70, '2022-04-18', '18:02', 70), (71, '2022-07-09', '16:12', 71), (72, '2023-01-05', '21:39', 72), (73, '2022-04-12', '17:44', 73), (74, '2022-10-15', '19:50', 74), (75, '2022-07-29', '17:04', 75), (76, '2023-03-02', '22:52', 76), (77, '2023-03-21', '19:53', 77), (78, '2022-05-05', '21:37', 78), (79, '2023-02-07', '17:22', 79), (80, '2022-06-12', '21:13', 80), (81, '2022-07-22', '20:25', 81), (82, '2022-04-10', '19:33', 82), (83, '2022-03-14', '16:52', 83), (84, '2023-03-15', '19:06', 84), (85, '2023-02-27', '21:03', 85), (86, '2022-07-27', '16:44', 86), (87, '2022-10-21', '22:39', 87), (88, '2022-10-18', '16:08', 88), (89, '2022-12-21', '19:32', 89), (90, '2023-01-23', '16:06', 90), (91, '2023-02-24', '17:42', 91), (92, '2022-04-25', '18:39', 92), (93, '2022-09-23', '22:18', 93), (94, '2022-09-02', '19:12', 94), (95, '2023-02-24', '20:17', 95), (96, '2022-11-22', '18:52', 96), (97, '2022-10-18', '21:36', 97), (98, '2022-06-29', '18:04', 98), (99, '2022-08-22', '20:38', 99), (100, '2022-04-07', '17:51', 100), (101, '2023-02-21', '16:19', 101), (102, '2022-05-25', '19:41', 102), (103, '2023-02-28', '21:36', 103), (104, '2022-10-25', '21:50', 104), (105, '2022-07-01', '17:21', 105), (106, '2022-06-22', '18:07', 106), (107, '2022-11-18', '21:31', 107), (108, '2022-12-23', '20:58', 108), (109, '2022-10-08', '16:54', 109), (110, '2022-06-09', '17:42', 110), (111, '2022-10-12', '20:17', 111), (112, '2022-10-04', '19:38', 112), (113, '2023-02-15', '20:55', 113), (114, '2023-01-17', '16:17', 114), (115, '2022-05-05', '22:15', 115), (116, '2022-08-02', '18:49', 116), (117, '2022-08-22', '20:37', 117), (118, '2023-02-11', '21:31', 118), (119, '2022-04-01', '22:56', 119), (120, '2022-09-07', '16:34', 120), (121, '2022-12-23', '20:54', 121), (122, '2022-07-06', '22:38', 122), (123, '2023-01-01', '19:41', 123), (124, '2022-04-06', '21:20', 124), (125, '2022-09-13', '18:30', 125), (126, '2022-10-19', '16:38', 126), (127, '2022-04-05', '19:57', 127), (128, '2022-07-11', '20:40', 128), (129, '2022-06-12', '16:27', 129), (130, '2022-07-02', '22:37', 130), (131, '2022-05-03', '21:36', 131), (132, '2022-10-26', '16:54', 132), (133, '2022-12-02', '22:36', 133), (134, '2022-11-28', '21:41', 134), (135, '2022-05-01', '16:20', 135), (136, '2022-10-15', '22:28', 136), (137, '2022-12-31', '19:13', 137), (138, '2022-08-28', '16:37', 138), (139, '2022-12-10', '16:36', 139), (140, '2022-07-01', '21:47', 140), (141, '2022-04-19', '22:25', 141), (142, '2022-11-18', '22:25', 142), (143, '2022-08-02', '20:11', 143), (144, '2022-04-13', '19:55', 144), (145, '2022-10-14', '16:39', 145), (146, '2022-11-20', '22:39', 146), (147, '2022-07-31', '19:04', 147), (148, '2022-05-05', '17:05', 148), (149, '2022-05-17', '16:23', 149), (150, '2023-01-04', '19:10', 150), (151, '2022-11-27', '19:14', 151), (152, '2022-04-12', '19:06', 152), (153, '2023-01-10', '21:13', 153), (154, '2022-04-02', '22:51', 154), (155, '2022-06-07', '17:12', 155), (156, '2022-05-31', '21:04', 156), (157, '2022-10-02', '22:11', 157), (158, '2022-11-14', '19:03', 158), (159, '2022-09-26', '21:12', 159), (160, '2023-01-01', '21:45', 160), (161, '2022-07-19', '16:40', 161), (162, '2022-04-13', '22:44', 162), (163, '2022-05-21', '22:55', 163), (164, '2022-04-23', '21:49', 164), (165, '2022-09-06', '21:22', 165), (166, '2022-06-27', '18:25', 166), (167, '2022-05-04', '22:21', 167), (168, '2022-11-12', '18:11', 168), (169, '2022-11-07', '17:30', 169), (170, '2022-03-27', '19:56', 170), (171, '2022-11-13', '21:17', 171), (172, '2022-08-20', '18:35', 172), (173, '2022-03-19', '18:24', 173), (174, '2022-06-19', '22:25', 174), (175, '2022-11-08', '16:12', 175), (176, '2022-11-04', '22:28', 176), (177, '2023-02-05', '19:38', 177), (178, '2023-01-20', '22:30', 178), (179, '2022-08-20', '17:29', 179), (180, '2022-04-19', '19:24', 180), (181, '2023-01-19', '18:38', 181), (182, '2022-08-02', '19:31', 182), (183, '2023-01-11', '22:12', 183), (184, '2022-08-31', '19:19', 184), (185, '2022-07-31', '19:43', 185), (186, '2023-01-08', '16:15', 186), (187, '2022-09-28', '17:33', 187), (188, '2022-08-19', '20:04', 188), (189, '2022-10-28', '20:34', 189), (190, '2022-04-21', '22:00', 190), (191, '2022-07-10', '16:45', 191), (192, '2022-12-09', '16:30', 192), (193, '2022-11-20', '16:47', 193), (194, '2022-07-21', '18:21', 194), (195, '2023-03-01', '18:19', 195), (196, '2022-09-22', '20:09', 196), (197, '2022-07-17', '20:38', 197), (198, '2022-12-22', '17:27', 198), (199, '2022-06-19', '17:11', 199), (200, '2022-03-15', '19:18', 200), (201, '2022-06-25', '17:48', 201), (202, '2023-03-11', '17:05', 202), (203, '2022-12-08', '16:18', 203), (204, '2022-06-29', '16:47', 204), (205, '2023-01-13', '17:00', 205), (206, '2022-06-22', '22:34', 206), (207, '2022-12-15', '22:43', 207), (208, '2022-12-11', '22:02', 208), (209, '2023-01-28', '19:22', 209), (210, '2022-07-04', '17:26', 210), (211, '2022-03-26', '20:32', 211), (212, '2022-12-06', '18:58', 212), (213, '2022-08-24', '21:01', 213), (214, '2022-10-23', '21:51', 214), (215, '2023-01-25', '17:55', 215), (216, '2023-03-15', '20:43', 216), (217, '2022-07-26', '21:06', 217), (218, '2022-08-01', '18:52', 218), (219, '2022-09-20', '18:11', 219), (220, '2022-05-05', '21:34', 220), (221, '2022-06-26', '16:15', 221), (222, '2023-03-09', '21:44', 222), (223, '2022-05-10', '21:41', 223), (224, '2022-06-10', '16:20', 224), (225, '2022-08-18', '16:30', 225), (226, '2022-03-29', '20:30', 226), (227, '2022-10-19', '16:15', 227), (228, '2022-08-14', '16:46', 228), (229, '2022-11-15', '16:16', 229), (230, '2022-05-28', '21:18', 230), (231, '2022-09-06', '21:33', 231), (232, '2022-12-02', '19:22', 232), (233, '2023-02-12', '18:45', 233), (234, '2022-06-26', '22:03', 234), (235, '2022-09-15', '18:51', 235), (236, '2022-09-29', '22:21', 236), (237, '2022-06-04', '17:12', 237), (238, '2022-07-07', '19:45', 238), (239, '2022-11-30', '20:15', 239), (240, '2022-12-03', '21:28', 240), (241, '2022-05-28', '16:26', 241), (242, '2022-05-11', '19:40', 242), (243, '2022-10-26', '22:54', 243), (244, '2022-03-16', '21:22', 244), (245, '2022-04-05', '21:25', 245), (246, '2022-11-15', '17:10', 246), (247, '2022-05-31', '18:18', 247), (248, '2022-10-23', '16:39', 248), (249, '2022-05-05', '17:10', 249), (250, '2023-03-07', '17:57', 250), (251, '2023-02-23', '22:41', 251), (252, '2022-09-13', '19:21', 252), (253, '2023-01-14', '22:04', 253), (254, '2022-11-26', '20:39', 254), (255, '2022-04-18', '16:43', 255), (256, '2022-11-26', '16:36', 256), (257, '2022-07-16', '21:57', 257), (258, '2022-09-23', '21:10', 258), (259, '2022-03-30', '22:11', 259), (260, '2022-09-24', '22:29', 260), (261, '2022-09-16', '22:21', 261), (262, '2022-10-08', '22:23', 262), (263, '2022-03-29', '17:28', 263), (264, '2022-03-24', '19:46', 264), (265, '2022-11-03', '22:13', 265), (266, '2022-07-02', '17:48', 266), (267, '2022-10-09', '21:05', 267), (268, '2022-09-01', '16:31', 268), (269, '2022-06-03', '19:48', 269), (270, '2022-09-03', '19:49', 270), (271, '2022-05-25', '18:18', 271), (272, '2022-11-25', '17:39', 272), (273, '2022-09-11', '21:47', 273), (274, '2022-12-20', '16:44', 274), (275, '2022-10-27', '18:39', 275), (276, '2022-11-27', '18:51', 276), (277, '2023-03-05', '21:42', 277), (278, '2022-10-15', '17:09', 278), (279, '2023-03-04', '19:27', 279), (280, '2023-01-27', '22:39', 280), (281, '2022-05-02', '17:35', 281), (282, '2022-07-22', '20:24', 282), (283, '2022-12-09', '16:43', 283), (284, '2023-03-01', '18:13', 284), (285, '2022-05-06', '17:45', 285), (286, '2023-01-20', '17:06', 286), (287, '2023-02-24', '22:42', 287), (288, '2023-01-14', '19:43', 288), (289, '2023-03-12', '18:57', 289), (290, '2022-11-15', '22:50', 290), (291, '2023-03-12', '16:58', 291), (292, '2022-10-06', '21:19', 292), (293, '2023-03-03', '16:51', 293), (294, '2023-01-11', '22:29', 294), (295, '2022-08-09', '18:49', 295), (296, '2022-10-20', '17:37', 296), (297, '2023-03-18', '19:16', 297), (298, '2022-10-10', '22:44', 298), (299, '2022-08-09', '20:16', 299), (300, '2022-09-03', '20:52', 300);

INSERT INTO room (id, number, capacity)
VALUES (1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 4), (5, 5, 5), (6, 6, 6), (7, 7, 7), (8, 8, 8), (9, 9, 9), (10, 10, 10), (11, 11, 11), (12, 12, 12), (13, 13, 13), (14, 14, 14), (15, 15, 15), (16, 16, 16), (17, 17, 17), (18, 18, 18), (19, 19, 19), (20, 20, 20), (21, 21, 21), (22, 22, 22), (23, 23, 23), (24, 24, 24), (25, 25, 25), (26, 26, 26), (27, 27, 27), (28, 28, 28), (29, 29, 29), (30, 30, 30), (31, 31, 31), (32, 32, 32), (33, 33, 33), (34, 34, 34), (35, 35, 35), (36, 36, 36), (37, 37, 37), (38, 38, 38), (39, 39, 39), (40, 40, 40), (41, 41, 41), (42, 42, 42), (43, 43, 43), (44, 44, 44), (45, 45, 45), (46, 46, 46), (47, 47, 47), (48, 48, 48), (49, 49, 49), (50, 50, 50), (51, 51, 51), (52, 52, 52), (53, 53, 53), (54, 54, 54), (55, 55, 55), (56, 56, 56), (57, 57, 57), (58, 58, 58), (59, 59, 59), (60, 60, 60), (61, 61, 61), (62, 62, 62), (63, 63, 63), (64, 64, 64), (65, 65, 65), (66, 66, 66), (67, 67, 67), (68, 68, 68), (69, 69, 69), (70, 70, 70), (71, 71, 71), (72, 72, 72), (73, 73, 73), (74, 74, 74), (75, 75, 75), (76, 76, 76), (77, 77, 77), (78, 78, 78), (79, 79, 79), (80, 80, 80), (81, 81, 81), (82, 82, 82), (83, 83, 83), (84, 84, 84), (85, 85, 85), (86, 86, 86), (87, 87, 87), (88, 88, 88), (89, 89, 89), (90, 90, 90), (91, 91, 91), (92, 92, 92), (93, 93, 93), (94, 94, 94), (95, 95, 95), (96, 96, 96), (97, 97, 97), (98, 98, 98), (99, 99, 99), (100, 100, 100), (101, 101, 101), (102, 102, 102), (103, 103, 103), (104, 104, 104), (105, 105, 105), (106, 106, 106), (107, 107, 107), (108, 108, 108), (109, 109, 109), (110, 110, 110), (111, 111, 111), (112, 112, 112), (113, 113, 113), (114, 114, 114), (115, 115, 115), (116, 116, 116), (117, 117, 117), (118, 118, 118), (119, 119, 119), (120, 120, 120), (121, 121, 121), (122, 122, 122), (123, 123, 123), (124, 124, 124), (125, 125, 125), (126, 126, 126), (127, 127, 127), (128, 128, 128), (129, 129, 129), (130, 130, 130), (131, 131, 131), (132, 132, 132), (133, 133, 133), (134, 134, 134), (135, 135, 135), (136, 136, 136), (137, 137, 137), (138, 138, 138), (139, 139, 139), (140, 140, 140), (141, 141, 141), (142, 142, 142), (143, 143, 143), (144, 144, 144), (145, 145, 145), (146, 146, 146), (147, 147, 147), (148, 148, 148), (149, 149, 149), (150, 150, 150), (151, 151, 151), (152, 152, 152), (153, 153, 153), (154, 154, 154), (155, 155, 155), (156, 156, 156), (157, 157, 157), (158, 158, 158), (159, 159, 159), (160, 160, 160), (161, 161, 161), (162, 162, 162), (163, 163, 163), (164, 164, 164), (165, 165, 165), (166, 166, 166), (167, 167, 167), (168, 168, 168), (169, 169, 169), (170, 170, 170), (171, 171, 171), (172, 172, 172), (173, 173, 173), (174, 174, 174), (175, 175, 175), (176, 176, 176), (177, 177, 177), (178, 178, 178), (179, 179, 179), (180, 180, 180), (181, 181, 181), (182, 182, 182), (183, 183, 183), (184, 184, 184), (185, 185, 185), (186, 186, 186), (187, 187, 187), (188, 188, 188), (189, 189, 189), (190, 190, 190), (191, 191, 191), (192, 192, 192), (193, 193, 193), (194, 194, 194), (195, 195, 195), (196, 196, 196), (197, 197, 197), (198, 198, 198), (199, 199, 199), (200, 200, 200), (201, 201, 201), (202, 202, 202), (203, 203, 203), (204, 204, 204), (205, 205, 205), (206, 206, 206), (207, 207, 207), (208, 208, 208), (209, 209, 209), (210, 210, 210), (211, 211, 211), (212, 212, 212), (213, 213, 213), (214, 214, 214), (215, 215, 215), (216, 216, 216), (217, 217, 217), (218, 218, 218), (219, 219, 219), (220, 220, 220), (221, 221, 221), (222, 222, 222), (223, 223, 223), (224, 224, 224), (225, 225, 225), (226, 226, 226), (227, 227, 227), (228, 228, 228), (229, 229, 229), (230, 230, 230), (231, 231, 231), (232, 232, 232), (233, 233, 233), (234, 234, 234), (235, 235, 235), (236, 236, 236), (237, 237, 237), (238, 238, 238), (239, 239, 239), (240, 240, 240), (241, 241, 241), (242, 242, 242), (243, 243, 243), (244, 244, 244), (245, 245, 245), (246, 246, 246), (247, 247, 247), (248, 248, 248), (249, 249, 249), (250, 250, 250);

INSERT INTO rate (id, type, price, discount)
VALUES (
        1,
        'praesent lectus vestibulum',
        14,
        'lacinia'
    ), (2, 'lacus at', 14, 'tempus'), (3, 'ultrices posuere', 15, 'ac'), (4, 'curae nulla', 14, 'orci'), (
        5,
        'semper est quam',
        8,
        'faucibus'
    ), (
        6,
        'elit ac nulla',
        12,
        'maecenas'
    );