-- Tabella padre degli utenti
CREATE TABLE utenti (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    cf varchar(16) NOT NULL UNIQUE,
    ruolo TIPO_UTENTE NOT NULL,
    password text NOT NULL CHECK (password ~ '^.{6,}$'),
    nome text NOT NULL CHECK (nome ~* '^.+$'),
    cognome text NOT NULL CHECK (cognome ~* '^.+$')
);

-- Tabella utenti lettori
CREATE TABLE lettori (
     id uuid PRIMARY KEY REFERENCES utenti(id),
    categoria TIPO_LETTORE NOT NULL,
    riconsegne_ritardo SMALLINT NOT NULL DEFAULT 0 CHECK (riconsegne_ritardo BETWEEN 0 AND 5)
);

-- Tabella utenti bibliotecari
CREATE TABLE bibliotecari (
    id uuid PRIMARY KEY REFERENCES utenti(id)
);

-- Tabella autori di libri registrati
CREATE TABLE autori (
    id SERIAL PRIMARY KEY,
    nome text NOT NULL CHECK (nome ~* '^.+$'),
    cognome text NOT NULL CHECK (cognome ~* '^.+$'),
    dataNascita DATE NOT NULL,
    dataMorte DATE,
    biografia TEXT,
    CONSTRAINT autori_unici UNIQUE (nome, cognome, dataNascita)
);

-- Tabella sedi della biblioteca
CREATE TABLE sedi (
    id SERIAL PRIMARY KEY,
    città text NOT NULL,
    indirizzo text NOT NULL,
    civico SMALLINT NOT NULL CHECK (civico >= 0),
    CONSTRAINT sedi_uniche UNIQUE (città, indirizzo, civico)
);

-- Tabella libri
CREATE TABLE libri (
    ISBN VARCHAR(13) PRIMARY KEY,
    titolo text NOT NULL CHECK (titolo ~* '^.+$'),
    autore SERIAL REFERENCES autori(id),
    trama text NOT NULL CHECK (trama ~* '^.+$'),
    casaEditrice text NOT NULL CHECK (casaEditrice ~* '^.+$')
);

-- Tabella copie dei libri
CREATE TABLE copie (
    id SERIAL PRIMARY KEY,
    libro VARCHAR(13) NOT NULL REFERENCES libri(ISBN) ON UPDATE CASCADE,
    sede SERIAL NOT NULL REFERENCES sedi(id),
    disponibilità BOOLEAN NOT NULL DEFAULT TRUE,
    rimossa BOOLEAN NOT NULL DEFAULT FALSE
);

-- Tabella prestiti dei libri
CREATE TABLE prestiti (
    id SERIAL PRIMARY KEY,
    lettore uuid NOT NULL REFERENCES lettori(id),
    copia SERIAL NOT NULL REFERENCES copie(id),
    dataInizio DATE NOT NULL,
    scadenza DATE,
    dataRestituzione DATE,
    CONSTRAINT prestiti_unici UNIQUE (lettore, copia, dataInizio)
);

-- 2.2.7 --> Statistiche sedi, mantiene numero delle copie e libri presenti in ogni sede e numero di prestiti attivi.

CREATE MATERIALIZED VIEW statistiche_sedi AS
SELECT
    s.id AS sede,
    COUNT(c.id) AS copie,
    COUNT(DISTINCT l.isbn) AS libri,
    COUNT(p.id) AS prestiti
FROM
    sedi s
    LEFT JOIN copie c ON s.id = c.sede
    LEFT JOIN libri l ON c.libro = l.isbn
    LEFT JOIN prestiti p ON c.id = p.copia
WHERE
    c.rimossa = FALSE AND p.datarestituzione IS NULL
GROUP BY
    s.id;

-- 2.2.8 --> Ritardi per ogni sede, è necessario generare un report, per ogni sede, dove sono indicati i prestiti in ritardo e i lettori che li hanno effettuati.

CREATE VIEW report_ritardi_sedi AS
SELECT
    s.id AS sede,
    p.id AS prestito,
    c.id as copia,
    c.libro AS ISBN,
    p.dataInizio,
    p.scadenza,
    l.id AS lettore,
    u.nome,
    u.cognome
FROM
    sedi s
    JOIN copie c ON s.id = c.sede
    JOIN prestiti p ON c.id = p.copia
    JOIN lettori l ON p.lettore = l.id
    JOIN utenti u ON l.id = u.id
WHERE
    p.datarestituzione IS NULL AND p.scadenza < CURRENT_DATE
GROUP BY
    s.id, p.id, c.libro, p.dataInizio, p.scadenza, l.id, u.nome, u.cognome, c.id
ORDER BY
    p.scadenza DESC;
