-- Popola il database con dei dati di esempio

-- Inserimento utenti
INSERT INTO utenti (cf, ruolo, password, nome, cognome) VALUES
('RSSMRA85M01H501Z', 'lettore', 'password123', 'Mario', 'Rossi'),
('VRDLGI85M01H501Z', 'lettore', 'password123', 'Luigi', 'Verdi'),
('BNCLRA85M01H501Z', 'bibliotecario', 'password123', 'Clara', 'Bianchi');

-- Inserimento lettori
INSERT INTO lettori (id, categoria) VALUES
((SELECT id FROM utenti WHERE cf = 'RSSMRA85M01H501Z'), 'base'),
((SELECT id FROM utenti WHERE cf = 'VRDLGI85M01H501Z'), 'premium');

-- Inserimento bibliotecari
INSERT INTO bibliotecari (id) VALUES
((SELECT id FROM utenti WHERE cf = 'BNCLRA85M01H501Z'));

-- Inserimento autori
INSERT INTO autori (nome, cognome, dataNascita, dataMorte, biografia) VALUES
('Giovanni', 'Boccaccio', '1313-06-16', '1375-12-21', 'Scrittore e poeta italiano.'),
('Dante', 'Alighieri', '1265-05-21', '1321-09-14', 'Poeta, scrittore e politico italiano.');

-- Inserimento sedi
INSERT INTO sedi (città, indirizzo, civico) VALUES
('Roma', 'Via Roma', 1),
('Milano', 'Via Milano', 2);

-- Inserimento libri
INSERT INTO libri (ISBN, titolo, autore, trama, casaEditrice) VALUES
('9781234567897', 'Il Decameron', (SELECT id FROM autori WHERE cognome = 'Boccaccio'), 'Raccolta di novelle.', 'Mondadori'),
('9781234567898', 'La Divina Commedia', (SELECT id FROM autori WHERE cognome = 'Alighieri'), 'Poema epico.', 'Einaudi');

-- Inserimento copie
INSERT INTO copie (libro, sede, disponibilità, rimossa) VALUES
('9781234567897', (SELECT id FROM sedi WHERE città = 'Roma'), TRUE, FALSE),
('9781234567898', (SELECT id FROM sedi WHERE città = 'Milano'), TRUE, FALSE);

-- Inserimento prestiti
INSERT INTO prestiti (lettore, copia, dataInizio, scadenza) VALUES
((SELECT id FROM lettori WHERE id = (SELECT id FROM utenti WHERE cf = 'RSSMRA85M01H501Z')), (SELECT id FROM copie WHERE libro = '9781234567897'), '2023-10-01', '2023-10-15'),
((SELECT id FROM lettori WHERE id = (SELECT id FROM utenti WHERE cf = 'VRDLGI85M01H501Z')), (SELECT id FROM copie WHERE libro = '9781234567898'), '2023-10-01', '2023-10-15');