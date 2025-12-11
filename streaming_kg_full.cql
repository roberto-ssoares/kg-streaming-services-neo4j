// ----------------------------------------------------
// 0. LIMPAR TODOS OS NÓS E RELACIONAMENTOS (OPCIONAL)
// ----------------------------------------------------

MATCH (n) DETACH DELETE n;

// ----------------------------------------------------
// 1. Constraints (esquema do grafo)
// Garantem unicidade lógica (IDs de negócio)
// ----------------------------------------------------

CREATE CONSTRAINT user_id IF NOT EXISTS
FOR (u:User) REQUIRE u.userId IS UNIQUE;

CREATE CONSTRAINT movie_id IF NOT EXISTS
FOR (m:Movie) REQUIRE m.movieId IS UNIQUE;

CREATE CONSTRAINT serie_id IF NOT EXISTS
FOR (s:Serie) REQUIRE s.serieId IS UNIQUE;

CREATE CONSTRAINT genre_name IF NOT EXISTS
FOR (g:Genre) REQUIRE g.name IS UNIQUE;

CREATE CONSTRAINT actor_name IF NOT EXISTS
FOR (a:Actor) REQUIRE a.name IS UNIQUE;

CREATE CONSTRAINT director_name IF NOT EXISTS
FOR (d:Director) REQUIRE d.name IS UNIQUE;

// ------------------------------------------------------------------------
// 2. Dimensões básicas (Genres, Users, Movies, Series, Actors, Directors)
// ------------------------------------------------------------------------
//
// ----------------------------------------------------
// 2.1. Gêneros
// ----------------------------------------------------

UNWIND [
  'Drama',
  'War',
  'Action',
  'Science Fiction',
  'Comedy',
  'Thriller',
  'Romance',
  'Animation',
  'Documentary',
  'Crime'
] AS genreName
MERGE (:Genre {name: genreName});

// ----------------------------------------------------
// 2.2. Usuários (10)
// ----------------------------------------------------

UNWIND [
  {id: 1, name: 'Roberto'},
  {id: 2, name: 'Ana'},
  {id: 3, name: 'Carlos'},
  {id: 4, name: 'Juliana'},
  {id: 5, name: 'Marcos'},
  {id: 6, name: 'Fernanda'},
  {id: 7, name: 'Paulo'},
  {id: 8, name: 'Luciana'},
  {id: 9, name: 'Sergio'},
  {id:10, name: 'Patricia'}
] AS u
MERGE (user:User {userId: u.id})
SET user.name = u.name;

// ----------------------------------------------------
// 2.3. Filmes (10) + IN_GENRE
// ----------------------------------------------------

UNWIND [
  {
    id: 1,
    name: 'Transformers',
    release: date('2007-07-03'),
    duration: '2h24m',
    budget: '147M-USD',
    imdb: 7.1,
    genres: ['Action','Science Fiction']
  },
  {
    id: 2,
    name: 'Inception',
    release: date('2010-07-16'),
    duration: '2h28m',
    budget: '160M-USD',
    imdb: 8.8,
    genres: ['Action','Science Fiction','Thriller']
  },
  {
    id: 3,
    name: 'The Matrix',
    release: date('1999-03-31'),
    duration: '2h16m',
    budget: '63M-USD',
    imdb: 8.7,
    genres: ['Action','Science Fiction']
  },
  {
    id: 4,
    name: 'Interstellar',
    release: date('2014-11-07'),
    duration: '2h49m',
    budget: '165M-USD',
    imdb: 8.6,
    genres: ['Drama','Science Fiction']
  },
  {
    id: 5,
    name: 'The Dark Knight',
    release: date('2008-07-18'),
    duration: '2h32m',
    budget: '185M-USD',
    imdb: 9.0,
    genres: ['Action','Crime','Drama']
  },
  {
    id: 6,
    name: 'Toy Story',
    release: date('1995-11-22'),
    duration: '1h21m',
    budget: '30M-USD',
    imdb: 8.3,
    genres: ['Animation','Comedy']
  },
  {
    id: 7,
    name: 'Titanic',
    release: date('1997-12-19'),
    duration: '3h14m',
    budget: '200M-USD',
    imdb: 7.9,
    genres: ['Drama','Romance']
  },
  {
    id: 8,
    name: 'The Godfather',
    release: date('1972-03-24'),
    duration: '2h55m',
    budget: '7M-USD',
    imdb: 9.2,
    genres: ['Crime','Drama']
  },
  {
    id: 9,
    name: 'Avengers',
    release: date('2012-05-04'),
    duration: '2h23m',
    budget: '220M-USD',
    imdb: 8.0,
    genres: ['Action','Science Fiction']
  },
  {
    id:10,
    name: 'Finding Nemo',
    release: date('2003-05-30'),
    duration: '1h40m',
    budget: '94M-USD',
    imdb: 8.2,
    genres: ['Animation','Comedy']
  }
] AS m
MERGE (movie:Movie {movieId: m.id})
SET movie.name     = m.name,
    movie.release  = m.release,
    movie.duration = m.duration,
    movie.budget   = m.budget,
    movie.imdb     = m.imdb
FOREACH (gName IN m.genres |
  MERGE (g:Genre {name: gName})
  MERGE (movie)-[:IN_GENRE]->(g)
);

// ----------------------------------------------------
// 2.4. Séries (10) + IN_GENRE
// ----------------------------------------------------

UNWIND [
  { id: 1, name: 'Seal Team',       genres: ['Drama','War','Action'] },
  { id: 2, name: 'Breaking Bad',    genres: ['Crime','Drama'] },
  { id: 3, name: 'Stranger Things', genres: ['Drama','Science Fiction'] },
  { id: 4, name: 'The Office',      genres: ['Comedy'] },
  { id: 5, name: 'Game of Thrones', genres: ['Drama','Action'] },
  { id: 6, name: 'Friends',         genres: ['Comedy','Romance'] },
  { id: 7, name: 'The Crown',       genres: ['Drama'] },
  { id: 8, name: 'The Mandalorian', genres: ['Action','Science Fiction'] },
  { id: 9, name: 'Sherlock',        genres: ['Crime','Drama'] },
  { id:10, name: 'Planet Earth',    genres: ['Documentary'] }
] AS s
MERGE (serie:Serie {serieId: s.id})
SET serie.name = s.name
FOREACH (gName IN s.genres |
  MERGE (g:Genre {name: gName})
  MERGE (serie)-[:IN_GENRE]->(g)
);

// ----------------------------------------------------
// 2.5. Atores
// ----------------------------------------------------

UNWIND [
  {name: 'Shia LaBeouf',          protagonist: true},
  {name: 'Leonardo DiCaprio',     protagonist: true},
  {name: 'Keanu Reeves',          protagonist: true},
  {name: 'Matthew McConaughey',   protagonist: true},
  {name: 'Christian Bale',        protagonist: true},
  {name: 'Tom Hanks',             protagonist: true},
  {name: 'Al Pacino',             protagonist: true},
  {name: 'Robert Downey Jr',      protagonist: true},
  {name: 'Albert Brooks',         protagonist: true},
  {name: 'David Boreanaz',        protagonist: true},
  {name: 'Bryan Cranston',        protagonist: true},
  {name: 'Millie Bobby Brown',    protagonist: true},
  {name: 'Steve Carell',          protagonist: true},
  {name: 'Emilia Clarke',         protagonist: true},
  {name: 'Jennifer Aniston',      protagonist: true},
  {name: 'Olivia Colman',         protagonist: true},
  {name: 'Pedro Pascal',          protagonist: true},
  {name: 'Benedict Cumberbatch',  protagonist: true},
  {name: 'David Attenborough',    protagonist: true}
] AS a
MERGE (actor:Actor {name: a.name})
SET actor.protagonist = a.protagonist;

// ----------------------------------------------------
// 2.6. Diretores
// ----------------------------------------------------

UNWIND [
  {name: 'Michael Bay'},
  {name: 'Christopher Nolan'},
  {name: 'Lana Wachowski'},
  {name: 'Lilly Wachowski'},
  {name: 'James Cameron'},
  {name: 'Francis Ford Coppola'},
  {name: 'Joss Whedon'},
  {name: 'Andrew Stanton'},
  {name: 'Vince Gilligan'}
] AS d
MERGE (dir:Director {name: d.name});

// ----------------------------------------------------
// 3. Relações DIRECTED (diretor → filme/série)
// ----------------------------------------------------

// Transformers
MATCH (m:Movie {name: 'Transformers'})
MATCH (d:Director {name: 'Michael Bay'})
MERGE (d)-[:DIRECTED]->(m);

// Inception / Interstellar / The Dark Knight (Christopher Nolan)
MATCH (dN:Director {name: 'Christopher Nolan'})
MATCH (mInc:Movie {name: 'Inception'})
MATCH (mInt:Movie {name: 'Interstellar'})
MATCH (mTDK:Movie {name: 'The Dark Knight'})
MERGE (dN)-[:DIRECTED]->(mInc)
MERGE (dN)-[:DIRECTED]->(mInt)
MERGE (dN)-[:DIRECTED]->(mTDK);

// The Matrix (Wachowski)
MATCH (dL:Director {name: 'Lana Wachowski'})
MATCH (dLi:Director {name: 'Lilly Wachowski'})
MATCH (mMat:Movie {name: 'The Matrix'})
MERGE (dL)-[:DIRECTED]->(mMat)
MERGE (dLi)-[:DIRECTED]->(mMat);

// Titanic
MATCH (dJC:Director {name: 'James Cameron'})
MATCH (mTit:Movie {name: 'Titanic'})
MERGE (dJC)-[:DIRECTED]->(mTit);

// The Godfather
MATCH (dFFC:Director {name: 'Francis Ford Coppola'})
MATCH (mGF:Movie {name: 'The Godfather'})
MERGE (dFFC)-[:DIRECTED]->(mGF);

// Avengers
MATCH (dJW:Director {name: 'Joss Whedon'})
MATCH (mAv:Movie {name: 'Avengers'})
MERGE (dJW)-[:DIRECTED]->(mAv);

// Finding Nemo
MATCH (dAS:Director {name: 'Andrew Stanton'})
MATCH (mFN:Movie {name: 'Finding Nemo'})
MERGE (dAS)-[:DIRECTED]->(mFN);

// Breaking Bad (série)
MATCH (dVG:Director {name: 'Vince Gilligan'})
MATCH (sBB:Serie {name: 'Breaking Bad'})
MERGE (dVG)-[:DIRECTED]->(sBB);

// ----------------------------------------------------------------------
// 4. Relações ACTED_IN (actor → movie/serie) com personagem + protagonista
// ----------------------------------------------------------------------

// FILMES
MATCH (a1:Actor {name: 'Shia LaBeouf'})
MATCH (m1:Movie {name: 'Transformers'})
MERGE (a1)-[r1:ACTED_IN]->(m1)
SET r1.character   = 'Sam Witwicky',
    r1.protagonist = true;

MATCH (a2:Actor {name: 'Leonardo DiCaprio'})
MATCH (m2:Movie {name: 'Inception'})
MERGE (a2)-[r2:ACTED_IN]->(m2)
SET r2.character   = 'Dom Cobb',
    r2.protagonist = true;

MATCH (a3:Actor {name: 'Keanu Reeves'})
MATCH (m3:Movie {name: 'The Matrix'})
MERGE (a3)-[r3:ACTED_IN]->(m3)
SET r3.character   = 'Neo (Thomas Anderson)',
    r3.protagonist = true;

MATCH (a4:Actor {name: 'Matthew McConaughey'})
MATCH (m4:Movie {name: 'Interstellar'})
MERGE (a4)-[r4:ACTED_IN]->(m4)
SET r4.character   = 'Joseph Cooper',
    r4.protagonist = true;

MATCH (a5:Actor {name: 'Christian Bale'})
MATCH (m5:Movie {name: 'The Dark Knight'})
MERGE (a5)-[r5:ACTED_IN]->(m5)
SET r5.character   = 'Bruce Wayne / Batman',
    r5.protagonist = true;

MATCH (a6:Actor {name: 'Tom Hanks'})
MATCH (m6:Movie {name: 'Toy Story'})
MERGE (a6)-[r6:ACTED_IN]->(m6)
SET r6.character   = 'Woody',
    r6.protagonist = true;

MATCH (a7:Actor {name: 'Leonardo DiCaprio'})
MATCH (m7:Movie {name: 'Titanic'})
MERGE (a7)-[r7:ACTED_IN]->(m7)
SET r7.character   = 'Jack Dawson',
    r7.protagonist = true;

MATCH (a8:Actor {name: 'Al Pacino'})
MATCH (m8:Movie {name: 'The Godfather'})
MERGE (a8)-[r8:ACTED_IN]->(m8)
SET r8.character   = 'Michael Corleone',
    r8.protagonist = true;

MATCH (a9:Actor {name: 'Robert Downey Jr'})
MATCH (m9:Movie {name: 'Avengers'})
MERGE (a9)-[r9:ACTED_IN]->(m9)
SET r9.character   = 'Tony Stark / Iron Man',
    r9.protagonist = true;

MATCH (a10:Actor {name: 'Albert Brooks'})
MATCH (m10:Movie {name: 'Finding Nemo'})
MERGE (a10)-[r10:ACTED_IN]->(m10)
SET r10.character   = 'Marlin',
    r10.protagonist = true;

// SÉRIES
MATCH (a11:Actor {name: 'David Boreanaz'})
MATCH (s1:Serie {name: 'Seal Team'})
MERGE (a11)-[r11:ACTED_IN]->(s1)
SET r11.character   = 'Jason Hayes',
    r11.protagonist = true;

MATCH (a12:Actor {name: 'Bryan Cranston'})
MATCH (s2:Serie {name: 'Breaking Bad'})
MERGE (a12)-[r12:ACTED_IN]->(s2)
SET r12.character   = 'Walter White',
    r12.protagonist = true;

MATCH (a13:Actor {name: 'Millie Bobby Brown'})
MATCH (s3:Serie {name: 'Stranger Things'})
MERGE (a13)-[r13:ACTED_IN]->(s3)
SET r13.character   = 'Eleven',
    r13.protagonist = true;

MATCH (a14:Actor {name: 'Steve Carell'})
MATCH (s4:Serie {name: 'The Office'})
MERGE (a14)-[r14:ACTED_IN]->(s4)
SET r14.character   = 'Michael Scott',
    r14.protagonist = true;

MATCH (a15:Actor {name: 'Emilia Clarke'})
MATCH (s5:Serie {name: 'Game of Thrones'})
MERGE (a15)-[r15:ACTED_IN]->(s5)
SET r15.character   = 'Daenerys Targaryen',
    r15.protagonist = true;

MATCH (a16:Actor {name: 'Jennifer Aniston'})
MATCH (s6:Serie {name: 'Friends'})
MERGE (a16)-[r16:ACTED_IN]->(s6)
SET r16.character   = 'Rachel Green',
    r16.protagonist = true;

MATCH (a17:Actor {name: 'Olivia Colman'})
MATCH (s7:Serie {name: 'The Crown'})
MERGE (a17)-[r17:ACTED_IN]->(s7)
SET r17.character   = 'Queen Elizabeth II',
    r17.protagonist = true;

MATCH (a18:Actor {name: 'Pedro Pascal'})
MATCH (s8:Serie {name: 'The Mandalorian'})
MERGE (a18)-[r18:ACTED_IN]->(s8)
SET r18.character   = 'Din Djarin (The Mandalorian)',
    r18.protagonist = true;

MATCH (a19:Actor {name: 'Benedict Cumberbatch'})
MATCH (s9:Serie {name: 'Sherlock'})
MERGE (a19)-[r19:ACTED_IN]->(s9)
SET r19.character   = 'Sherlock Holmes',
    r19.protagonist = true;

MATCH (a20:Actor {name: 'David Attenborough'})
MATCH (s10:Serie {name: 'Planet Earth'})
MERGE (a20)-[r20:ACTED_IN]->(s10)
SET r20.character   = 'Narrator',
    r20.protagonist = true;

// ----------------------------------------------------
// 5. Relações WATCHED (histórico dos usuários)
// ----------------------------------------------------

// Roberto vê Transformers e Seal Team 
MATCH (rob:User {userId: 1})
MATCH (mTrans:Movie {name: 'Transformers'})
MATCH (sSeal:Serie {name: 'Seal Team'})
MERGE (rob)-[:WATCHED]->(mTrans)
MERGE (rob)-[:WATCHED]->(sSeal);

// Regra genérica: user i vê movie i e movie ((i % 10) + 1)
WITH range(1,10) AS ids
UNWIND ids AS uId
MATCH (u:User  {userId: uId})
MATCH (mA:Movie {movieId: uId})
MATCH (mB:Movie {movieId: (uId % 10) + 1})
MERGE (u)-[:WATCHED]->(mA)
MERGE (u)-[:WATCHED]->(mB);

// Regra genérica: user i vê serie i e serie ((i+1 % 10) + 1)
WITH range(1,10) AS ids
UNWIND ids AS uId
MATCH (u:User   {userId: uId})
MATCH (sA:Serie {serieId: uId})
MATCH (sB:Serie {serieId: ((uId + 1) % 10) + 1})
MERGE (u)-[:WATCHED]->(sA)
MERGE (u)-[:WATCHED]->(sB);

// ----------------------------------------------------
// 6. Consultas de exemplo (para documentação / testes)
// ----------------------------------------------------

CALL db.schema.visualization();

// ----------------------------------------------------
// 6.2. Filmes e séries que Roberto assistiu
// ----------------------------------------------------

MATCH (u:User {name:'Roberto'})-[:WATCHED]->(c)
RETURN u.name, labels(c) AS tipo, c.name, c.movieId, c.serieId;


// ----------------------------------------------------
// 6.3. Personagens e papéis de Leonardo DiCaprio
// ----------------------------------------------------

MATCH (a:Actor {name:'Leonardo DiCaprio'})-[r:ACTED_IN]->(m:Movie)
RETURN m.name AS filme, r.character AS personagem, r.protagonist AS protagonista;

// ----------------------------------------------------
// 6.4. Todos os protagonistas de séries de ficção científica
// ----------------------------------------------------

MATCH (a:Actor)-[r:ACTED_IN {protagonist:true}]->(s:Serie)-[:IN_GENRE]->(g:Genre {name:'Science Fiction'})
RETURN a.name AS ator, s.name AS serie, r.character AS personagem;

