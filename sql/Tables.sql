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
    categoria TIPO_LETTORE NOT NULL
);

-- Tabella utenti bibliotecari
CREATE TABLE bibliotecari (
    id uuid PRIMARY KEY REFERENCES utenti(id)
);

-- Tabella autori di libri registrati
CREATE TABLE autori (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nome text NOT NULL CHECK (nome ~* '^.+$'),
    cognome text NOT NULL CHECK (cognome ~* '^.+$'),
    dataNascita DATE NOT NULL,
    dataMorte DATE,
    biografia TEXT
);

-- Tabella sedi della biblioteca
CREATE TABLE sedi (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    città text NOT NULL,
    indirizzo text NOT NULL,
    civico SMALLINT NOT NULL CHECK (civico >= 0)
);

-- Tabella libri
CREATE TABLE libri (
    ISBN VARCHAR(15) PRIMARY KEY,
    titolo text NOT NULL CHECK (titolo ~* '^.+$'),
    autore uuid NOT NULL REFERENCES autori(id),
    trama text NOT NULL CHECK (trama ~* '^.+$'),
    casaEditrice text NOT NULL CHECK (casaEditrice ~* '^.+$')
);

-- Tabella copie dei libri
CREATE TABLE copie (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    libro VARCHAR(15) NOT NULL REFERENCES libri(ISBN) ON UPDATE CASCADE,
    sede uuid NOT NULL REFERENCES sedi(id)
);

-- Tabella prestiti dei libri
CREATE TABLE prestiti (
    lettore uuid NOT NULL REFERENCES lettori(id),
    copia uuid NULL REFERENCES copie(id),
    dataInizio DATE NOT NULL,
    scadenza DATE NOT NULL,
    dataRestituzione DATE,
    PRIMARY KEY (lettore, copia, dataInizio)
)