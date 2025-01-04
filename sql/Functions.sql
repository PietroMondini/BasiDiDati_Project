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
  _ISBN VARCHAR(15)
)
RETURNS TABLE (
  ISBN VARCHAR(15),
  titolo text,
  autore uuid,
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

-- Restituisce una copia dato il suo id
CREATE OR REPLACE FUNCTION get_copia (
  _id uuid
)
RETURNS TABLE (
  id uuid,
  libro VARCHAR(15),
  sede uuid
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
    WHERE id = _id;

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
  copia uuid,
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

-- Restituisce tutti i prestiti di un lettore
CREATE OR REPLACE FUNCTION get_prestiti_lettore (
  _lettore uuid
)
RETURNS TABLE (
  lettore uuid,
  copia uuid,
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
    WHERE lettore = _lettore;

  END;
$$;

-- Restituisce tutti i prestiti di una copia
CREATE OR REPLACE FUNCTION get_prestiti_copia (
  _copia uuid
)
RETURNS TABLE (
  lettore uuid,
  copia uuid,
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
CREATE OR REPLACE FUNCTION get_prestiti_attivi_lettore (
  _lettore uuid
)
RETURNS TABLE (
  lettore uuid,
  copia uuid,
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
    WHERE lettore = _lettore AND dataRestituzione IS NULL;

  END;
$$;

-- Restituisce tutti i prestiti attivi
CREATE OR REPLACE FUNCTION get_prestiti_attivi ()
RETURNS TABLE (
  lettore uuid,
  copia uuid,
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
  copia uuid,
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
  copia uuid,
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
  _libro VARCHAR(15),
  _sede uuid
)
RETURNS TABLE (
  id uuid,
  libro VARCHAR(15),
  sede uuid
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
  _libro VARCHAR(15)
)
RETURNS TABLE (
  id uuid,
  libro VARCHAR(15),
  sede uuid
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
  _sede uuid
)
RETURNS TABLE (
  id uuid,
  libro VARCHAR(15),
  sede uuid
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

-- Restituisce tutti i libri di un autore
CREATE OR REPLACE FUNCTION get_libri_autore (
  _autore uuid
)
RETURNS TABLE (
  ISBN VARCHAR(15),
  titolo text,
  autore uuid,
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
  _sede uuid
)
RETURNS TABLE (
  ISBN VARCHAR(15),
  titolo text,
  autore uuid,
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
  ISBN VARCHAR(15),
  titolo text,
  autore uuid,
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

-- Restituisce tutte le copie senza prestiti attivi di un libro in una sede, se presenti.
CREATE OR REPLACE FUNCTION get_copie_disponibili (
  _libro VARCHAR(15),
  _sede uuid
)
RETURNS TABLE (
  id uuid,
  libro VARCHAR(15),
  sede uuid
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
    ) AND sede = _sede;
    
  END;
$$;

-- Restituisce tutte le copie senza prestiti attivi di un libro, se presenti, con dati della sede.
CREATE OR REPLACE FUNCTION get_copie_disponibili_libro (
  _libro VARCHAR(15)
)
RETURNS TABLE (
  id uuid,
  libro VARCHAR(15),
  sede uuid
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