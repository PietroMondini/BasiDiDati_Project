-- Restituisce un lettore dato il suo id
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


-- Restituisce un bibliotecario dato il suo id
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

--Chiama la procedura autore_new per aggiungere un nuovo autore
--Restituisce (TRUE, 'Autore aggiunto con successo') se l'operazione è andata a buon fine
--altrimenti restituisce (FALSE, 'Messaggio di errore')

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

-- Chiama la procedura libro_new per aggiungere un nuovo libro
-- Restituisce (TRUE, 'Libro aggiunto con successo') se l'operazione è andata a buon fine
-- altrimenti restituisce (FALSE, 'Messaggio di errore')

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

-- Restituisce un autore dato il suo id
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

--Restituisce tutte le sedi della biblioteca
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

-- Restituisce un libro dato il suo ISBN
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

-- Restituisce un prestito dato il lettore, l'ISBN del libro e la data di inizio
CREATE OR REPLACE FUNCTION get_prestito (
  _lettore uuid,
  _libro VARCHAR(13),
  _dataInizio DATE
)
RETURNS TABLE (
  lettore uuid,
  copia INTEGER,
  dataInizio DATE,
  scadenza DATE,
  dataRestituzione DATE
)
LANGUAGE plpgsql
AS $$
  BEGIN

  SET search_path TO biblioteca;

  RETURN QUERY
    SELECT
      lettore,
      copia,
      dataInizio,
      scadenza,
      dataRestituzione
    FROM prestiti
    WHERE lettore = _lettore AND libro = _libro AND dataInizio = _dataInizio;

  END;
$$;

-- Restituisce tutti i prestiti di una copia
CREATE OR REPLACE FUNCTION get_prestiti_copia (
  _copia INTEGER
)
RETURNS TABLE (
  lettore uuid,
  copia INTEGER,
  dataInizio DATE,
  scadenza DATE,
  dataRestituzione DATE
)
LANGUAGE plpgsql
AS $$
  BEGIN

  SET search_path TO biblioteca;

  RETURN QUERY
    SELECT
      lettore,
      copia,
      dataInizio,
      scadenza,
      dataRestituzione
    FROM prestiti
    WHERE copia = _copia;

  END;
$$;

-- Restituisce tutti i prestiti attivi di un lettore
-- con i dati della copia e del libro, le date di inizio, scadenza e restituzione.
-- inoltre restituisce lo stato del prestito, se "in corso", "scaduto" o "riconsegnato".
CREATE OR REPLACE FUNCTION get_prestiti_attivi_lettore (
  _lettore uuid
)
RETURNS TABLE (
  ISBN VARCHAR(13),
  copia INTEGER,
  titolo text,
  autore TEXT,
  casaEditrice text,
  dataInizio DATE,
  scadenza DATE,
  stato text
)
LANGUAGE plpgsql
AS $$
  BEGIN

  SET search_path TO biblioteca;

  RETURN QUERY
    SELECT
      l.ISBN,
      c.id AS copia,
      l.titolo,
      CONCAT(a.nome, ' ', a.cognome) AS autore,
      l.casaEditrice,
      p.dataInizio,
      p.scadenza,
      CASE
        WHEN p.dataRestituzione IS NULL THEN 'in corso'
        WHEN CURRENT_DATE > p.scadenza THEN 'in ritardo'
      END AS stato
    FROM prestiti p
    JOIN copie c ON p.copia = c.id
    JOIN libri l ON c.libro = l.ISBN
    JOIN autori a ON l.autore = a.id
    WHERE p.lettore = _lettore AND p.dataRestituzione IS NULL;
  
  END;
$$;

-- Restituisce tutti i prestiti di un lettore
-- con i dati della copia e del libro, le date di inizio, scadenza e restituzione.
-- inoltre restituisce lo stato del prestito, se "in corso", "scaduto" o "riconsegnato".

CREATE OR REPLACE FUNCTION get_prestiti_lettore (
  _lettore uuid
)
RETURNS TABLE (
  ISBN VARCHAR(13),
  titolo text,
  autore TEXT,
  casaEditrice text,
  dataInizio DATE,
  scadenza DATE,
  stato text
)
LANGUAGE plpgsql
AS $$
  BEGIN

  SET search_path TO biblioteca;

  RETURN QUERY
    SELECT
      l.ISBN,
      l.titolo,
      CONCAT(a.nome, ' ', a.cognome) AS autore,
      l.casaEditrice,
      p.dataInizio,
      p.scadenza,
      CASE
        WHEN p.scadenza < CURRENT_DATE THEN 'in ritardo'
        WHEN p.datarestituzione IS NULL THEN 'in corso'
        WHEN p.datarestituzione > p.scadenza THEN 'riconsegnato in ritardo'
        ELSE 'riconsegnato'
      END AS stato
    FROM prestiti p
    JOIN copie c ON p.copia = c.id
    JOIN libri l ON c.libro = l.ISBN
    JOIN autori a ON l.autore = a.id
    WHERE p.lettore = _lettore
    ORDER BY p.dataInizio DESC, p.scadenza DESC, p.dataRestituzione DESC;

  END;
$$;

-- Restituisce tutti i prestiti attivi
CREATE OR REPLACE FUNCTION get_prestiti_attivi ()
RETURNS TABLE (
  lettore uuid,
  copia INTEGER,
  dataInizio DATE,
  scadenza DATE,
  dataRestituzione DATE
)
LANGUAGE plpgsql
AS $$
  BEGIN

  SET search_path TO biblioteca;

  RETURN QUERY
    SELECT
      lettore,
      copia,
      dataInizio,
      scadenza,
      dataRestituzione
    FROM prestiti
    WHERE dataRestituzione IS NULL;

  END;
$$;

-- Restituisce tutti i prestiti restituiti in ritardo
CREATE OR REPLACE FUNCTION get_prestiti_ritardati ()
RETURNS TABLE (
  lettore uuid,
  copia INTEGER,
  dataInizio DATE,
  scadenza DATE,
  dataRestituzione DATE
)
LANGUAGE plpgsql
AS $$
  BEGIN

  SET search_path TO biblioteca;

  RETURN QUERY
    SELECT
      lettore,
      copia,
      dataInizio,
      scadenza,
      dataRestituzione
    FROM prestiti
    WHERE dataRestituzione > scadenza;

  END;
$$;

-- Restituisce tutti i prestiti restituiti in tempo
CREATE OR REPLACE FUNCTION get_prestiti_in_tempo ()
RETURNS TABLE (
  lettore uuid,
  copia INTEGER,
  dataInizio DATE,
  scadenza DATE,
  dataRestituzione DATE
)
LANGUAGE plpgsql
AS $$
  BEGIN

  SET search_path TO biblioteca;

  RETURN QUERY
    SELECT
      lettore,
      copia,
      dataInizio,
      scadenza,
      dataRestituzione
    FROM prestiti
    WHERE dataRestituzione <= scadenza;

  END;
$$;

-- Restituisce tutte le copie di un libro presenti in una sede
CREATE OR REPLACE FUNCTION get_copie_libro_sede (
  _libro VARCHAR(13),
  _sede INTEGER
)
RETURNS TABLE (
  id uuid,
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
    FROM get_copie_libro(_libro)
    WHERE sede = _sede;

  END;
$$;

-- Restituisce tutte le copie di un libro
CREATE OR REPLACE FUNCTION get_copie_libro (
  _libro VARCHAR(13)
)
RETURNS TABLE (
  id uuid,
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
    WHERE libro = _libro;

  END;
$$;

-- Restituisce tutte le copie presenti in una sede
CREATE OR REPLACE FUNCTION get_copie_sede (
  _sede INTEGER
)
RETURNS TABLE (
  id uuid,
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
    WHERE sede = _sede;

  END;
$$;

-- Restituisce tutti i libri della biblioteca
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

-- Restituisce tutte le copie senza prestiti attivi di un libro in una sede, se presenti.
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

-- Genera un report sui prestiti in ritardo per ogni sede, ritornando la vista report_ritardi_sedi
CREATE OR REPLACE FUNCTION report_ritardi_sedi ()
RETURNS TABLE (
  sede INTEGER,
  lettore uuid,
  copia INTEGER,
  prestito INTEGER,
  ISBN VARCHAR(13),
  nome text,
  cognome text,
  dataInizio DATE,
  scadenza DATE
)
LANGUAGE plpgsql
AS $$
  BEGIN

  SET search_path TO biblioteca;

  RETURN QUERY
    SELECT
      sede,
      lettore,
      copia,
      dataInizio,
      scadenza,
      dataRestituzione
    FROM report_ritardi_sedi;

  END;
$$;


-- check_login --> procedura usata per il login dell'utente con il cf e la password dati 
--                 restituisce la tabella dei dati dell'utente da passare al client, se esiste
--                 altrimenti restituisce una tabella vuota.

CREATE OR REPLACE FUNCTION check_login (
  _cf       VARCHAR(16),
  _password TEXT
) 
RETURNS TABLE (
  id          UUID,
  nome        TEXT,
  cognome     TEXT,
  cf          VARCHAR(16),
  ruolo       TIPO_UTENTE
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
        u.cf,
        u.ruolo
      FROM utenti u
      WHERE u.cf = UPPER(_cf) AND u.password = crypt(_password, u.password);


    END;
  $$;

-- get_categoria_ritardi_lettore --> procedura usata per ottenere la categoria e i ritardi di un lettore dato il suo id

CREATE OR REPLACE FUNCTION get_categoria_ritardi_lettore (
  _id UUID
)
RETURNS TABLE (
  categoria TIPO_LETTORE,
  ritardi  SMALLINT
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

    SET search_path TO biblioteca;

    RETURN QUERY
      SELECT
        l.categoria,
        l.riconsegne_ritardo
      FROM lettori l
      WHERE l.id = _id;

    END;
  $$;

-- Chiama la procedura copia_new_N per aggiungere una nuova copia di un libro in una sede
-- Restituisce (TRUE, 'Copia aggiunta con successo') se l'operazione è andata a buon fine
-- altrimenti restituisce (FALSE, 'Messaggio di errore')

CREATE OR REPLACE FUNCTION copia_new_function (
  _libro VARCHAR(13),
  _N SMALLINT,
  _sede INTEGER
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
    CALL copia_new_N(_libro, _sede, _N);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN QUERY
        SELECT FALSE, SQLERRM;
      RETURN;
  END;

  RETURN QUERY
    SELECT TRUE, 'Copia aggiunta con successo.';

  END;
$$;

-- get_prima_copia_disponibile --> procedura usata per ottenere la prima copia disponibile di un libro in una sede.
--                                 restituisce la tabella con i dati della copia, se esiste, altrimenti una tabella vuota.

CREATE OR REPLACE FUNCTION get_prima_copia_disponibile (
  _libro VARCHAR(13),
  _sede  INTEGER
)
RETURNS TABLE (
  id INTEGER
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

    SET search_path TO biblioteca;

    RETURN QUERY
      SELECT gc.id
      FROM get_copie_disponibili(_libro, _sede) gc
      LIMIT 1; 

    END;
  $$;


-- richiesta_prestito --> funzione usata per richiedere un prestito di una copia di un libro da parte di un lettore.
--                        restituisce TRUE se la richiesta è andata a buon fine, (FALSE, 'messaggio di errore') altrimenti.

CREATE OR REPLACE FUNCTION richiesta_prestito (
  _lettore UUID,
  _libro   VARCHAR(13),
  _sede    INTEGER
)
RETURNS TABLE (
  successo BOOLEAN,
  messaggio TEXT
)
  LANGUAGE plpgsql
  AS $$
    DECLARE
      _copia INTEGER;
    BEGIN

    SET search_path TO biblioteca;

    SELECT id 
    FROM get_prima_copia_disponibile(_libro, _sede)
    INTO _copia;

    IF NOT FOUND THEN
      RETURN QUERY
        SELECT FALSE, 'Nessuna copia disponibile.';
      RETURN;
    ELSE
      BEGIN
        CALL prestito_new(_lettore, _copia);
      EXCEPTION
        WHEN OTHERS THEN
          RETURN QUERY
            SELECT FALSE, SQLERRM;
          RETURN;
      END;
    END IF;
    RETURN QUERY 
      SELECT TRUE, 'Richiesta di prestito effettuata con successo.';
    END;
  $$;
