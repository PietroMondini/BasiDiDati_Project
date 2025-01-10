-- Gestione lettori

-- Restituisce un lettore dato il suo id
-- Input: id (UUID)
-- Output: Table(id, nome, cognome, categoria)
CREATE OR REPLACE FUNCTION get_lettore (
  _id uuid
)
RETURNS TABLE (
  id uuid,
  nome text,
  cognome text,
  categoria TIPO_LETTORE
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      u.id,
      u.nome,
      u.cognome,
      l.categoria
    FROM utenti u
    JOIN lettori l ON u.id = l.id
    WHERE u.id = _id;
  END;
$$;

-- Restituisce un lettore dato il suo codice fiscale
-- Input: codice fiscale (VARCHAR(16))
-- Output: Table(id, cf, nome, cognome, categoria, riconsegne_ritardo)
CREATE OR REPLACE FUNCTION get_lettore_cf (
  _cf VARCHAR(16)
)
RETURNS TABLE (
  id uuid,
  cf VARCHAR(16),
  nome text,
  cognome text,
  categoria TIPO_LETTORE,
  riconsegne_ritardo SMALLINT
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      u.id,
      u.cf,
      u.nome,
      u.cognome,
      l.categoria,
      l.riconsegne_ritardo
    FROM utenti u
    JOIN lettori l ON u.id = l.id
    WHERE u.cf = UPPER(_cf);
  END;
$$;

-- Gestione bibliotecari

-- Restituisce un bibliotecario dato il suo id
-- Input: id (UUID)
-- Output: Table(id, nome, cognome)
CREATE OR REPLACE FUNCTION get_bibliotecario (
  _id uuid
)
RETURNS TABLE (
  id uuid,
  nome text,
  cognome text
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      u.id,
      u.nome,
      u.cognome
    FROM utenti u
    JOIN bibliotecari b ON u.id = b.id
    WHERE u.id = _id;
  END;
$$;

-- Gestione autori

-- Chiama la procedura autore_new per aggiungere un nuovo autore
-- Restituisce (TRUE, 'Autore aggiunto con successo') se l'operazione è andata a buon fine
-- altrimenti restituisce (FALSE, 'Messaggio di errore')
-- Input: nome (text), cognome (text), dataNascita (DATE), dataMorte (DATE), biografia (TEXT)
-- Output: Table(successo, messaggio)
CREATE OR REPLACE FUNCTION autore_new_function (
  _nome text,
  _cognome text,
  _dataNascita DATE,
  _dataMorte DATE,
  _biografia TEXT
)
RETURNS TABLE (
  successo BOOLEAN,
  messaggio TEXT
)
LANGUAGE plpgsql
AS $$
  DECLARE
    _id uuid;
  BEGIN
  SET search_path TO biblioteca;
  BEGIN
    CALL autore_new(_nome, _cognome, _dataNascita, _dataMorte, _biografia);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN QUERY
        SELECT FALSE, SQLERRM;
      RETURN;
  END;
  RETURN QUERY
    SELECT TRUE, 'Autore aggiunto con successo.';
  END;
$$;

-- Restituisce tutti gli autori in ordine alfabetico di cognome e nome
-- Input: Nessuno
-- Output: Table(id, nome, cognome, dataNascita)
CREATE OR REPLACE FUNCTION get_autori ()
RETURNS TABLE (
  id INTEGER,
  nome text,
  cognome text,
  dataNascita DATE
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      a.id,
      a.nome,
      a.cognome,
      a.dataNascita
    FROM autori a
    ORDER BY a.cognome, a.nome, a.dataNascita, a.id;
  END;
$$;

-- Restituisce un autore dato il suo id
-- Input: id (UUID)
-- Output: Table(id, nome, cognome, dataNascita, dataMorte, biografia)
CREATE OR REPLACE FUNCTION get_autore (
  _id uuid
)
RETURNS TABLE (
  id uuid,
  nome text,
  cognome text,
  dataNascita DATE,
  dataMorte DATE,
  biografia TEXT
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      id,
      nome,
      cognome,
      dataNascita,
      dataMorte,
      biografia
    FROM autori
    WHERE id = _id;
  END;
$$;

-- Gestione sedi

-- Restituisce tutte le sedi della biblioteca
-- Input: Nessuno
-- Output: Table(id, città, indirizzo, civico)
CREATE OR REPLACE FUNCTION get_sedi ()
RETURNS TABLE (
  id INTEGER,
  città text,
  indirizzo text,
  civico SMALLINT
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      s.id,
      s.città,
      s.indirizzo,
      s.civico
    FROM sedi s
    ORDER BY s.città, s.indirizzo, s.civico, s.id;
  END;
$$;

-- Restituisce una sede dato il suo id
-- Input: id (UUID)
-- Output: Table(id, città, indirizzo, civico)
CREATE OR REPLACE FUNCTION get_sede (
  _id uuid
)
RETURNS TABLE (
  id uuid,
  città text,
  indirizzo text,
  civico SMALLINT
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      id,
      città,
      indirizzo,
      civico
    FROM sedi
    WHERE id = _id;
  END;
$$;

-- Gestione libri

-- Chiama la procedura libro_new per aggiungere un nuovo libro
-- Restituisce (TRUE, 'Libro aggiunto con successo') se l'operazione è andata a buon fine
-- altrimenti restituisce (FALSE, 'Messaggio di errore')
-- Input: isbn (VARCHAR(13)), titolo (TEXT), autore (INTEGER), trama (TEXT), casaEditrice (TEXT)
-- Output: Table(successo, messaggio)
CREATE OR REPLACE FUNCTION libro_new_function (
  _isbn VARCHAR(13),
  _titolo TEXT,
  _autore INTEGER,
  _trama TEXT,
  _casaEditrice TEXT
)
RETURNS TABLE (
  successo BOOLEAN,
  messaggio TEXT
)
LANGUAGE plpgsql
AS $$
  DECLARE
    _id uuid;
  BEGIN
  SET search_path TO biblioteca;
  BEGIN
    CALL libro_new(_isbn, _titolo, _autore, _trama, _casaEditrice);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN QUERY
        SELECT FALSE, SQLERRM;
      RETURN;
  END;
  RETURN QUERY
    SELECT TRUE, 'Libro aggiunto con successo.';
  END;
$$;

-- Restituisce un libro dato il suo ISBN
-- Input: ISBN (VARCHAR(13))
-- Output: Table(ISBN, titolo, autore, trama, casaEditrice)
CREATE OR REPLACE FUNCTION get_libro (
  _ISBN VARCHAR(13)
)
RETURNS TABLE (
  ISBN VARCHAR(13),
  titolo text,
  autore INTEGER,
  trama text,
  casaEditrice text
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      ISBN,
      titolo,
      autore,
      trama,
      casaEditrice
    FROM libri
    WHERE ISBN = _ISBN;
  END;
$$;

-- Restituisce tutti i libri della biblioteca
-- Input: Nessuno
-- Output: Table(ISBN, titolo)
CREATE OR REPLACE FUNCTION get_libri ()
RETURNS TABLE (
  ISBN VARCHAR(13),
  titolo text
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      l.ISBN,
      l.titolo
    FROM libri l
    ORDER BY l.titolo, l.ISBN;
  END;
$$;

-- Restituisce tutti i libri di un autore
-- Input: id autore (INTEGER)
-- Output: Table(ISBN, titolo, autore, trama, casaEditrice)
CREATE OR REPLACE FUNCTION get_libri_autore (
  _autore INTEGER
)
RETURNS TABLE (
  ISBN VARCHAR(13),
  titolo text,
  autore INTEGER,
  trama text,
  casaEditrice text
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      ISBN,
      titolo,
      autore,
      trama,
      casaEditrice
    FROM libri
    WHERE autore = _autore;
  END;
$$;

-- Restituisce tutti i libri presenti in una sede
-- Input: id sede (INTEGER)
-- Output: Table(ISBN, titolo, autore, trama, casaEditrice)
CREATE OR REPLACE FUNCTION get_libri_sede (
  _sede INTEGER
)
RETURNS TABLE (
  ISBN VARCHAR(13),
  titolo text,
  autore INTEGER,
  trama text,
  casaEditrice text
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      l.ISBN,
      l.titolo,
      l.autore,
      l.trama,
      l.casaEditrice
    FROM libri l
    JOIN copie c ON l.ISBN = c.libro
    WHERE c.sede = _sede;
  END;
$$;

-- Restituisce tutti i libri con un certo titolo
-- Input: titolo (text)
-- Output: Table(ISBN, titolo, autore, trama, casaEditrice)
CREATE OR REPLACE FUNCTION get_libri_titolo (
  _titolo text
)
RETURNS TABLE (
  ISBN VARCHAR(13),
  titolo text,
  autore INTEGER,
  trama text,
  casaEditrice text
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      ISBN,
      titolo,
      autore,
      trama,
      casaEditrice
    FROM libri
    WHERE titolo = _titolo;
  END;
$$;

-- Restituisce tutti i libri con almeno una copia disponibile con un certo isbn in una sede.
-- Per la sede restituisce la citta, indirizzo e civico.
-- Input: ISBN (VARCHAR(13)), id sede (INTEGER)
-- Output: Table(ISBN, titolo, autore, trama, casaEditrice, città, indirizzo, civico, sede_id)
CREATE OR REPLACE FUNCTION get_libri_disponibili_by_isbn_sede (
  _ISBN VARCHAR(13),
  _sede INTEGER
)
RETURNS TABLE (
  ISBN VARCHAR(13),
  titolo text,
  autore INTEGER,
  trama text,
  casaEditrice text,
  città text,
  indirizzo text,
  civico SMALLINT,
  sede_id INTEGER
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      l.ISBN,
      l.titolo,
      l.autore,
      l.trama,
      l.casaEditrice,
      s.città,
      s.indirizzo,
      s.civico,
      s.id AS sede_id
    FROM libri l
    JOIN copie c ON l.ISBN = c.libro
    JOIN sedi s ON c.sede = s.id
    WHERE l.ISBN = _ISBN AND c.disponibilità = TRUE AND c.sede = _sede
    GROUP BY l.ISBN, l.titolo, l.autore, l.trama, l.casaEditrice, s.città, s.indirizzo, s.civico, sede_id;
  END;
$$;

-- Restituisce tutti i libri con almeno una copia disponibile con un certo isbn in una qualsiasi sede.
-- Input: ISBN (VARCHAR(13))
-- Output: Table(ISBN, titolo, autore, trama, casaEditrice, città, indirizzo, civico, sede_id)
CREATE OR REPLACE FUNCTION get_libri_disponibili_by_isbn (
  _ISBN VARCHAR(13)
)
RETURNS TABLE (
  ISBN VARCHAR(13),
  titolo text,
  autore INTEGER,
  trama text,
  casaEditrice text,
  città text,
  indirizzo text,
  civico SMALLINT,
  sede_id INTEGER
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      l.ISBN,
      l.titolo,
      l.autore,
      l.trama,
      l.casaEditrice,
      s.città,
      s.indirizzo,
      s.civico,
      s.id AS sede_id
    FROM libri l
    JOIN copie c ON l.ISBN = c.libro
    JOIN sedi s ON c.sede = s.id
    WHERE l.ISBN = _ISBN AND c.disponibilità = TRUE
    GROUP BY l.ISBN, l.titolo, l.autore, l.trama, l.casaEditrice, s.città, s.indirizzo, s.civico, sede_id;
  END;
$$;

-- Restituisce tutti i libri con almeno una copia disponibile con un certo titolo in una sede.
-- Per la sede restituisce la citta, indirizzo e civico.
-- Input: titolo (text), id sede (INTEGER)
-- Output: Table(ISBN, titolo, autore, trama, casaEditrice, città, indirizzo, civico, sede_id)
CREATE OR REPLACE FUNCTION get_libri_disponibili_by_titolo_sede (
  _titolo text,
  _sede INTEGER
)
RETURNS TABLE (
  ISBN VARCHAR(13),
  titolo text,
  autore INTEGER,
  trama text,
  casaEditrice text,
  città text,
  indirizzo text,
  civico SMALLINT,
  sede_id INTEGER
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      l.ISBN,
      l.titolo,
      l.autore,
      l.trama,
      l.casaEditrice,
      s.città,
      s.indirizzo,
      s.civico,
      s.id AS sede_id
    FROM libri l
    JOIN copie c ON l.ISBN = c.libro
    JOIN sedi s ON c.sede = s.id
    WHERE l.titolo = _titolo AND c.disponibilità = TRUE AND c.sede = _sede
    GROUP BY l.ISBN, l.titolo, l.autore, l.trama, l.casaEditrice, s.città, s.indirizzo, s.civico, sede_id;
  END;
$$;

-- Restituisce tutti i libri con almeno una copia disponibile con un certo titolo in una qualsiasi sede.
-- Input: titolo (text)
-- Output: Table(ISBN, titolo, autore, trama, casaEditrice, città, indirizzo, civico, sede_id)
CREATE OR REPLACE FUNCTION get_libri_disponibili_by_titolo (
  _titolo text
)
RETURNS TABLE (
  ISBN VARCHAR(13),
  titolo text,
  autore INTEGER,
  trama text,
  casaEditrice text,
  città text,
  indirizzo text,
  civico SMALLINT,
  sede_id INTEGER
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      l.ISBN,
      l.titolo,
      l.autore,
      l.trama,
      l.casaEditrice,
      s.città,
      s.indirizzo,
      s.civico,
      s.id AS sede_id
    FROM libri l
    JOIN copie c ON l.ISBN = c.libro
    JOIN sedi s ON c.sede = s.id
    WHERE l.titolo = _titolo AND c.disponibilità = TRUE
    GROUP BY l.ISBN, l.titolo, l.autore, l.trama, l.casaEditrice, s.città, s.indirizzo, s.civico, sede_id;
  END;
$$;

-- Gestione copie

-- Restituisce tutte le copie senza prestiti attivi di un libro in una sede, se presenti.
-- Input: ISBN (VARCHAR(13)), id sede (INTEGER)
-- Output: Table(id, libro, sede)
CREATE OR REPLACE FUNCTION get_copie_disponibili (
  _libro VARCHAR(13),
  _sede INTEGER
)
RETURNS TABLE (
  id INTEGER,
  libro VARCHAR(13),
  sede INTEGER
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      c.id,
      c.libro,
      c.sede
    FROM copie c
    WHERE c.libro = _libro AND c.id NOT IN (
      SELECT p.copia
      FROM prestiti p
      WHERE p.dataRestituzione IS NULL
    ) AND c.sede = _sede;
  END;
$$;

-- Restituisce tutte le copie senza prestiti attivi di un libro, se presenti, con dati della sede.
-- Input: ISBN (VARCHAR(13))
-- Output: Table(id, libro, sede)
CREATE OR REPLACE FUNCTION get_copie_disponibili_libro (
  _libro VARCHAR(13)
)
RETURNS TABLE (
  id INTEGER,
  libro VARCHAR(13),
  sede INTEGER
)
LANGUAGE plpgsql
AS $$
  BEGIN
  SET search_path TO biblioteca;
  RETURN QUERY
    SELECT
      id,
      libro,
      sede
    FROM copie
    WHERE libro = _libro AND id NOT IN (
      SELECT copia
      FROM prestiti
      WHERE dataRestituzione IS NULL
    );
  END;
$$;

-- Gestione prestiti