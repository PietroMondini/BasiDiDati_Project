SET search_path TO biblioteca;

-- Modifica i campi NOT NULL dell' utente con l'id dato
CREATE OR REPLACE PROCEDURE utente_update_demo (
  _id       uuid,
  _nome     TEXT,
  _cognome  TEXT,
  _cf       VARCHAR(16)
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO biblioteca;

      UPDATE utenti SET
        nome    = INITCAP(COALESCE(NULLIF(_nome, ''), nome)),
        cognome = INITCAP(COALESCE(NULLIF(_cognome, ''), cognome)),
        cf      = INITCAP(COALESCE(NULLIF(_cf, ''), cf))
      WHERE id = _id;
      
    END;
  $$;

-- Modifica la password dell'utente con l'id dato, controlla che la vecchia password coincida con quella criptata salvata.
CREATE OR REPLACE PROCEDURE utente_update_password (
  _id           uuid,
  _oldPassword  text,
  _newPassword  text
)
  LANGUAGE plpgsql
  AS $$
    BEGIN
      SET search_path TO biblioteca;

      UPDATE utenti SET
        password = crypt(_newPassword, gen_salt('bf'))
      WHERE id = _id AND password = crypt(_oldPassword, password);

      IF NOT FOUND THEN
        RAISE EXCEPTION 'Vecchia password errata';
      END IF;

    END;
  $$;

-- Modifica la password dell'utente con l'id dato. ONLY ADMINS
CREATE OR REPLACE PROCEDURE utente_update_password (
  _id           uuid,
  _newPassword  text
)
  LANGUAGE plpgsql
  AS $$
    BEGIN
      SET search_path TO biblioteca;

      UPDATE utenti SET
        password = crypt(_newPassword, gen_salt('bf'))
      WHERE id = _id;
    END;
  $$;

-- Aggiunge un nuovo lettore dati: [NOME, COGNOME, PASSWORD, CF]
CREATE OR REPLACE PROCEDURE lettore_new (
  _cf VARCHAR(16),
  _nome TEXT,
  _cognome TEXT,
  _categoria TIPO_LETTORE,
  _password TEXT
)
  LANGUAGE plpgsql
  AS $$
    DECLARE _id uuid;
    BEGIN

      SET search_path TO biblioteca;

      INSERT INTO utenti(cf, ruolo, password, nome, cognome)
      VALUES (UPPER(_cf), 'lettore', _password, INITCAP(_nome), INITCAP(_cognome)) RETURNING id INTO _id;

      INSERT INTO lettori(id, categoria)
      VALUES (_id, _categoria);
      
    END;
  $$;

-- Modifica la categoria del lettore a 'premium'. ONLY ADMINS
CREATE OR REPLACE PROCEDURE lettore_upgrade (
  _id   uuid
)
  LANGUAGE plpgsql
  AS $$
    BEGIN
      SET search_path TO biblioteca;

      UPDATE lettori SET
        categoria = 'premium'
      WHERE id = _id;
    END;
  $$;

-- Modifica la categoria del lettore a 'base'. ONLY ADMINS
CREATE OR REPLACE PROCEDURE lettore_downgrade (
  _id uuid
)
  LANGUAGE plpgsql
  AS $$
    BEGIN
      SET search_path TO biblioteca;

      UPDATE lettori SET
        categoria = 'base'
      WHERE id = _id;
    END;
  $$;

-- Aggiunge un nuovo bibliotecario dati: [NOME, COGNOME, PASSWORD, CF]
CREATE OR REPLACE PROCEDURE bibliotecario_new (
  _nome     TEXT,
  _cognome  TEXT,
  _password TEXT,
  _cf       VARCHAR(16)
)
  LANGUAGE plpgsql
  AS $$
    DECLARE _id uuid;
    BEGIN

      SET search_path TO biblioteca;

      INSERT INTO utenti(cf, ruolo, password, nome, cognome)
      VALUES (UPPER(_cf), crypt(_password, gen_salt('bf')), 'lettore', INITCAP(_nome), INITCAP(_cognome)) RETURNING id INTO _id;

      INSERT INTO bibliotecari(id)
      VALUES (_id);
      
    END;
  $$;

-- Aggiunge un nuovo autore dati: [NOME, COGNOME, DATA_NASCITA, DATA_MORTE, BIOGRAFIA]. ONLY ADMINS
CREATE OR REPLACE PROCEDURE autore_new (
  _nome         TEXT,
  _cognome      TEXT,
  _dataNascita  DATE,
  _dataMorte    DATE,
  _biografia    TEXT
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO biblioteca;

      INSERT INTO autori(nome,cognome,datanascita,datamorte,biografia)
      VALUES (INITCAP(_nome), INITCAP(_cognome), _datanascita, _datamorte, _biografia);
    END;
  $$;

-- Modifica i campi non NULL dell'autore con l'id dato, considerando che id è salvato come SERIAL ma plpgsql non lo riconosce. ONLY ADMINS
CREATE OR REPLACE PROCEDURE autore_update (
  _id          INTEGER,
  _nome        TEXT,
  _cognome     TEXT,
  _dataNascita DATE,
  _dataMorte   DATE,
  _biografia   TEXT
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

      SET search_path TO biblioteca;

      UPDATE autori SET
        nome        = INITCAP(COALESCE(NULLIF(_nome, ''), nome)),
        cognome     = INITCAP(COALESCE(NULLIF(_cognome, ''), cognome)),
        datanascita = COALESCE(_dataNascita, datanascita),
        datamorte   = COALESCE(_dataMorte, datamorte),
        biografia   = COALESCE(_biografia, biografia)
      WHERE id = _id;
      
    END;
  $$;

-- Aggiunge un nuovo libro dati: [ISBN, TITOLO, AUTORE, TRAMA, CASA EDITRICE]
CREATE OR REPLACE PROCEDURE libro_new (
  _isbn         VARCHAR(13),
  _titolo       TEXT,
  _autore       INTEGER,
  _trama        TEXT,
  _casaEditrice TEXT
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

    SET search_path TO biblioteca;
    
    INSERT INTO libri(isbn, titolo, autore, trama, casaeditrice)
      VALUES (_isbn, _titolo, _autore, _trama, _casaEditrice);
    END;
  $$;

-- Modifica i campi non NULL del libro con l'isbn dato. ONLY ADMINS
  CREATE OR REPLACE PROCEDURE  copia_new (
    _isbn VARCHAR(13),
    _sede INTEGER
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

    SET search_path TO biblioteca;
    
    INSERT INTO copie(libro, sede)
      VALUES (_isbn, _sede);
    END;
  $$;

-- Aggiunge n copie di un libro in una sede. ONLY ADMINS
  CREATE OR REPLACE PROCEDURE copia_new_N (
    _isbn VARCHAR(13),
    _sede INTEGER,
    _n SMALLINT
)
  LANGUAGE plpgsql
  AS $$
    DECLARE _i integer;
    BEGIN

    SET search_path TO biblioteca;
    
    FOR _i IN 1.._n LOOP
      CALL copia_new(_isbn, _sede);
    END LOOP;

    END;
  $$;

-- Modifica l'indirizzo e il civico della sede con la città e l'indirizzo dati. ONLY ADMINS
  CREATE OR REPLACE PROCEDURE sede_new (
    _città text,
    _indirizzo text,
    _civico smallint
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

    SET search_path TO biblioteca;
    
    INSERT INTO sedi(città, indirizzo, civico)
      VALUES (INITCAP(_città), _indirizzo, _civico);
    END;
  $$;

-- Modifica i dati della sede con l'id dato. ONLY ADMINS
  CREATE OR REPLACE PROCEDURE sede_update (
    _id         INTEGER,
    _città      text,
    _indirizzo  text,
    _civico     smallint
  )
  LANGUAGE plpgsql
  AS $$
    BEGIN

    SET search_path TO biblioteca;
    
    UPDATE sedi SET
      città = INITCAP(_città),
      indirizzo = _indirizzo,
      civico = _civico
    WHERE id = _id; 

    END;
  $$;

-- Aggiunge un nuovo prestito dati: [LETTORE, COPIA].
CREATE OR REPLACE PROCEDURE prestito_new (
  _lettore     uuid,
  _copia       INTEGER
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

    SET search_path TO biblioteca;

    INSERT INTO prestiti(lettore, copia)
      VALUES (_lettore, _copia);
    END;
  $$;

-- Restituisce un prestito attivo dati: [LETTORE, COPIA]. ONLY ADMINS
CREATE OR REPLACE PROCEDURE prestito_restituzione (
  _lettore uuid,
  _copia   INTEGER
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

    SET search_path TO biblioteca;
    
    UPDATE prestiti SET
      datarestituzione = CURRENT_DATE
    WHERE lettore = _lettore AND copia = _copia AND datarestituzione IS NULL;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Nessun prestito attivo trovato';
    END IF;

    END;
  $$;

-- Proroga, di 14 giorni, la data di scadenza di un prestito attivo dati: [LETTORE, COPIA]. ONLY ADMINS
CREATE OR REPLACE PROCEDURE prestito_proroga (
  _lettore uuid,
  _copia   INTEGER
)
  LANGUAGE plpgsql
  AS $$
    DECLARE _scadenza DATE;
    BEGIN

    SET search_path TO biblioteca;
    
    UPDATE prestiti SET
      scadenza = scadenza + INTERVAL '14 days'
    WHERE lettore = _lettore AND copia = _copia AND datarestituzione IS NULL;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Nessun prestito attivo trovato';
    END IF;

    END;
  $$;

-- Azzera riconsegne_ritardo del lettore con l'id dato. ONLY ADMINS

CREATE OR REPLACE PROCEDURE reset_ritardi (
  _id uuid
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

    SET search_path TO biblioteca;
    
    UPDATE lettori SET
      riconsegne_ritardo = 0
    WHERE id = _id;

    END;
  $$;