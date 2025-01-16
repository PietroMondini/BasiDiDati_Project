-- Aggiunge 10 autori reali

INSERT INTO autori (nome, cognome, dataNascita, dataMorte, biografia) VALUES
('Alessandro', 'Manzoni', '1785-03-07', '1873-05-22', 'Scrittore e poeta italiano.'),
('Italo', 'Calvino', '1923-10-15', '1985-09-19', 'Scrittore e giornalista italiano.'),
('Umberto', 'Eco', '1932-01-05', '2016-02-19', 'Filosofo, semiologo, scrittore e accademico italiano.'),
('Alberto', 'Moravia', '1907-11-28', '1990-09-26', 'Scrittore, giornalista e saggista italiano.'),
('Elsa', 'Morante', '1912-08-18', '1985-11-25', 'Scrittrice e poetessa italiana.'),
('Giuseppe', 'Tomasi di Lampedusa', '1896-12-23', '1957-07-23', 'Scrittore italiano.'),
('Giovanni', 'Verga', '1840-09-02', '1922-01-27', 'Scrittore italiano.'),
('Carlo', 'Collodi', '1826-11-24', '1890-10-26', 'Scrittore e giornalista italiano.'),
('Giacomo', 'Leopardi', '1798-06-29', '1837-06-14', 'Poeta, scrittore e filosofo italiano.'),
('Luigi', 'Pirandello', '1867-06-28', '1936-12-10', 'Drammaturgo, scrittore e poeta italiano.');

-- Aggiunge 30 libri reali

INSERT INTO libri (ISBN, titolo, autore, trama, casaEditrice) VALUES
('9788806213942', 'I Promessi Sposi', (SELECT id FROM autori WHERE cognome = 'Manzoni'), 'Romanzo storico.', 'Einaudi'),
('9788806213943', 'Il Gattopardo', (SELECT id FROM autori WHERE cognome = 'Tomasi di Lampedusa'), 'Romanzo storico.', 'Mondadori'),
('9788806213944', 'Il Visconte Dimezzato', (SELECT id FROM autori WHERE cognome = 'Calvino'), 'Romanzo fantastico.', 'Mondadori'),
('9788806213945', 'Il Nome della Rosa', (SELECT id FROM autori WHERE cognome = 'Eco'), 'Romanzo storico.', 'Mondadori'),
('9788806213946', 'La Ciociara', (SELECT id FROM autori WHERE cognome = 'Moravia'), 'Romanzo storico.', 'Mondadori'),
('9788806213947', 'La Storia', (SELECT id FROM autori WHERE cognome = 'Morante'), 'Romanzo storico.', 'Mondadori'),
('9788806213948', 'I Malavoglia', (SELECT id FROM autori WHERE cognome = 'Verga'), 'Romanzo storico.', 'Mondadori'),
('9788806213949', 'Pinocchio', (SELECT id FROM autori WHERE cognome = 'Collodi'), 'Romanzo per ragazzi.', 'Mondadori'),
('9788806213950', 'Canti', (SELECT id FROM autori WHERE cognome = 'Leopardi'), 'Raccolta di poesie.', 'Mondadori'),
('9788806213951', 'Uno, Nessuno e Centomila', (SELECT id FROM autori WHERE cognome = 'Pirandello'), 'Romanzo psicologico.', 'Mondadori'),
('9788806213952', 'I Promessi Sposi', (SELECT id FROM autori WHERE cognome = 'Manzoni'), 'Romanzo storico.', 'Einaudi'),
('9788806213953', 'Il Gattopardo', (SELECT id FROM autori WHERE cognome = 'Tomasi di Lampedusa'), 'Romanzo storico.', 'Mondadori'),
('9788806213954', 'Il Visconte Dimezzato', (SELECT id FROM autori WHERE cognome = 'Calvino'), 'Romanzo fantastico.', 'Mondadori'),
('9788806213955', 'Il Nome della Rosa', (SELECT id FROM autori WHERE cognome = 'Eco'), 'Romanzo storico.', 'Mondadori'),
('9788806213956', 'La Ciociara', (SELECT id FROM autori WHERE cognome = 'Moravia'), 'Romanzo storico.', 'Mondadori'),
('9788806213957', 'La Storia', (SELECT id FROM autori WHERE cognome = 'Morante'), 'Romanzo storico.', 'Mondadori'),
('9788806213958', 'I Malavoglia', (SELECT id FROM autori WHERE cognome = 'Verga'), 'Romanzo storico.', 'Mondadori'),
('9788806213959', 'Pinocchio', (SELECT id FROM autori WHERE cognome = 'Collodi'), 'Romanzo per ragazzi.', 'Mondadori'),
('9788806213960', 'Canti', (SELECT id FROM autori WHERE cognome = 'Leopardi'), 'Raccolta di poesie.', 'Mondadori'),
('9788806213961', 'Uno, Nessuno e Centomila', (SELECT id FROM autori WHERE cognome = 'Pirandello'), 'Romanzo psicologico.', 'Mondadori'),
('9788806213962', 'I Promessi Sposi', (SELECT id FROM autori WHERE cognome = 'Manzoni'), 'Romanzo storico.', 'Einaudi'),
('9788806213963', 'Il Gattopardo', (SELECT id FROM autori WHERE cognome = 'Tomasi di Lampedusa'), 'Romanzo storico.', 'Mondadori'),
('9788806213964', 'Il Visconte Dimezzato', (SELECT id FROM autori WHERE cognome = 'Calvino'), 'Romanzo fantastico.', 'Mondadori'),
('9788806213965', 'Il Nome della Rosa', (SELECT id FROM autori WHERE cognome = 'Eco'), 'Romanzo storico.', 'Mondadori'),
('9788806213966', 'La Ciociara', (SELECT id FROM autori WHERE cognome = 'Moravia'), 'Romanzo storico.', 'Mondadori'),
('9788806213967', 'La Storia', (SELECT id FROM autori WHERE cognome = 'Morante'), 'Romanzo storico.', 'Mondadori'),
('9788806213968', 'I Malavoglia', (SELECT id FROM autori WHERE cognome = 'Verga'), 'Romanzo storico.', 'Mondadori'),
('9788806213969', 'Pinocchio', (SELECT id FROM autori WHERE cognome = 'Collodi'), 'Romanzo per ragazzi.', 'Mondadori'),
('9788806213970', 'Canti', (SELECT id FROM autori WHERE cognome = 'Leopardi'), 'Raccolta di poesie.', 'Mondadori'),
('9788806213971', 'Uno, Nessuno e Centomila', (SELECT id FROM autori WHERE cognome = 'Pirandello'), 'Romanzo psicologico.', 'Mondadori');

-- Aggiunge 10 sedi reali anche in città uguali

INSERT INTO sedi (città, indirizzo, civico) VALUES
('Torino', 'Via Torino', 3),
('Napoli', 'Via Napoli', 4),
('Firenze', 'Via Firenze', 5),
('Bologna', 'Via Bologna', 6),
('Genova', 'Via Genova', 7),
('Venezia', 'Via Venezia', 8),
('Verona', 'Via Verona', 9),
('Torino', 'Via Torino', 10),
('Napoli', 'Via Napoli', 11),
('Firenze', 'Via Firenze', 12);


-- Aggiunge 100 copie reali

INSERT INTO copie (libro, sede, disponibilità) VALUES
('9788806213942', (SELECT id FROM sedi WHERE città = 'Torino' AND indirizzo = 'Via Torino' AND civico = 3), TRUE),
('9788806213943', (SELECT id FROM sedi WHERE città = 'Napoli' AND indirizzo = 'Via Napoli' AND civico = 4), TRUE),
('9788806213944', (SELECT id FROM sedi WHERE città = 'Firenze' AND indirizzo = 'Via Firenze' AND civico = 5), TRUE),
('9788806213945', (SELECT id FROM sedi WHERE città = 'Bologna' AND indirizzo = 'Via Bologna' AND civico = 6), TRUE),
('9788806213946', (SELECT id FROM sedi WHERE città = 'Genova' AND indirizzo = 'Via Genova' AND civico = 7), TRUE),
('9788806213947', (SELECT id FROM sedi WHERE città = 'Venezia' AND indirizzo = 'Via Venezia' AND civico = 8), TRUE),
('9788806213948', (SELECT id FROM sedi WHERE città = 'Verona' AND indirizzo = 'Via Verona' AND civico = 9), TRUE),
('9788806213949', (SELECT id FROM sedi WHERE città = 'Torino' AND indirizzo = 'Via Torino' AND civico = 10), TRUE),
('9788806213950', (SELECT id FROM sedi WHERE città = 'Napoli' AND indirizzo = 'Via Napoli' AND civico = 11), TRUE),
('9788806213951', (SELECT id FROM sedi WHERE città = 'Firenze' AND indirizzo = 'Via Firenze' AND civico = 12), TRUE),
('9788806213952', (SELECT id FROM sedi WHERE città = 'Torino' AND indirizzo = 'Via Torino' AND civico = 3), TRUE),
('9788806213953', (SELECT id FROM sedi WHERE città = 'Napoli' AND indirizzo = 'Via Napoli' AND civico = 4), TRUE),
('9788806213954', (SELECT id FROM sedi WHERE città = 'Firenze' AND indirizzo = 'Via Firenze' AND civico = 5), TRUE),
('9788806213955', (SELECT id FROM sedi WHERE città = 'Bologna' AND indirizzo = 'Via Bologna' AND civico = 6), TRUE),
('9788806213956', (SELECT id FROM sedi WHERE città = 'Genova' AND indirizzo = 'Via Genova' AND civico = 7), TRUE),
('9788806213957', (SELECT id FROM sedi WHERE città = 'Venezia' AND indirizzo = 'Via Venezia' AND civico = 8), TRUE),
('9788806213958', (SELECT id FROM sedi WHERE città = 'Verona' AND indirizzo = 'Via Verona' AND civico = 9), TRUE),
('9788806213959', (SELECT id FROM sedi WHERE città = 'Torino' AND indirizzo = 'Via Torino' AND civico = 10), TRUE),
('9788806213960', (SELECT id FROM sedi WHERE città = 'Napoli' AND indirizzo = 'Via Napoli' AND civico = 11), TRUE),
('9788806213961', (SELECT id FROM sedi WHERE città = 'Firenze' AND indirizzo = 'Via Firenze' AND civico = 12), TRUE),
('9788806213962', (SELECT id FROM sedi WHERE città = 'Torino' AND indirizzo = 'Via Torino' AND civico = 3), TRUE),
('9788806213963', (SELECT id FROM sedi WHERE città = 'Napoli' AND indirizzo = 'Via Napoli' AND civico = 4), TRUE),
('9788806213964', (SELECT id FROM sedi WHERE città = 'Firenze' AND indirizzo = 'Via Firenze' AND civico = 5), TRUE),
('9788806213965', (SELECT id FROM sedi WHERE città = 'Bologna' AND indirizzo = 'Via Bologna' AND civico = 6), TRUE),
('9788806213966', (SELECT id FROM sedi WHERE città = 'Genova' AND indirizzo = 'Via Genova' AND civico = 7), TRUE),
('9788806213967', (SELECT id FROM sedi WHERE città = 'Venezia' AND indirizzo = 'Via Venezia' AND civico = 8), TRUE),
('9788806213968', (SELECT id FROM sedi WHERE città = 'Verona' AND indirizzo = 'Via Verona' AND civico = 9), TRUE),
('9788806213969', (SELECT id FROM sedi WHERE città = 'Torino' AND indirizzo = 'Via Torino' AND civico = 10), TRUE),
('9788806213970', (SELECT id FROM sedi WHERE città = 'Napoli' AND indirizzo = 'Via Napoli' AND civico = 11), TRUE),
('9788806213971', (SELECT id FROM sedi WHERE città = 'Firenze' AND indirizzo = 'Via Firenze' AND civico = 12), TRUE),
('9788806213942', (SELECT id FROM sedi WHERE città = 'Torino' AND indirizzo = 'Via Torino' AND civico = 3), TRUE),
('9788806213943', (SELECT id FROM sedi WHERE città = 'Napoli' AND indirizzo = 'Via Napoli' AND civico = 4), TRUE),
('9788806213944', (SELECT id FROM sedi WHERE città = 'Firenze' AND indirizzo = 'Via Firenze' AND civico = 5), TRUE),
('9788806213945', (SELECT id FROM sedi WHERE città = 'Bologna' AND indirizzo = 'Via Bologna' AND civico = 6), TRUE),
('9788806213946', (SELECT id FROM sedi WHERE città = 'Genova' AND indirizzo = 'Via Genova' AND civico = 7), TRUE),
('9788806213947', (SELECT id FROM sedi WHERE città = 'Venezia' AND indirizzo = 'Via Venezia' AND civico = 8), TRUE),
('9788806213948', (SELECT id FROM sedi WHERE città = 'Verona' AND indirizzo = 'Via Verona' AND civico = 9), TRUE),
('9788806213949', (SELECT id FROM sedi WHERE città = 'Torino' AND indirizzo = 'Via Torino' AND civico = 10), TRUE),
('9788806213950', (SELECT id FROM sedi WHERE città = 'Napoli' AND indirizzo = 'Via Napoli' AND civico = 11), TRUE),
('9788806213951', (SELECT id FROM sedi WHERE città = 'Firenze' AND indirizzo = 'Via Firenze' AND civico = 12), TRUE),
('9788806213952', (SELECT id FROM sedi WHERE città = 'Torino' AND indirizzo = 'Via Torino' AND civico = 3), TRUE),
('9788806213953', (SELECT id FROM sedi WHERE città = 'Napoli' AND indirizzo = 'Via Napoli' AND civico = 4), TRUE),
('9788806213954', (SELECT id FROM sedi WHERE città = 'Firenze' AND indirizzo = 'Via Firenze' AND civico = 5), TRUE),
('9788806213955', (SELECT id FROM sedi WHERE città = 'Bologna' AND indirizzo = 'Via Bologna' AND civico = 6), TRUE),
('9788806213956', (SELECT id FROM sedi WHERE città = 'Genova' AND indirizzo = 'Via Genova' AND civico = 7), TRUE),
('9788806213957', (SELECT id FROM sedi WHERE città = 'Venezia' AND indirizzo = 'Via Venezia' AND civico = 8), TRUE),
('9788806213958', (SELECT id FROM sedi WHERE città = 'Verona' AND indirizzo = 'Via Verona' AND civico = 9), TRUE),
('9788806213959', (SELECT id FROM sedi WHERE città = 'Torino' AND indirizzo = 'Via Torino' AND civico = 10), TRUE),
('9788806213960', (SELECT id FROM sedi WHERE città = 'Napoli' AND indirizzo = 'Via Napoli' AND civico = 11), TRUE),
('9788806213961', (SELECT id FROM sedi WHERE città = 'Firenze' AND indirizzo = 'Via Firenze' AND civico = 12), TRUE),
('9788806213962', (SELECT id FROM sedi WHERE città = 'Torino' AND indirizzo = 'Via Torino' AND civico = 3), TRUE),
('9788806213963', (SELECT id FROM sedi WHERE città = 'Napoli' AND indirizzo = 'Via Napoli' AND civico = 4), TRUE),
('9788806213964', (SELECT id FROM sedi WHERE città = 'Firenze' AND indirizzo = 'Via Firenze' AND civico = 5), TRUE),
('9788806213965', (SELECT id FROM sedi WHERE città = 'Bologna' AND indirizzo = 'Via Bologna' AND civico = 6), TRUE),
('9788806213966', (SELECT id FROM sedi WHERE città = 'Genova' AND indirizzo = 'Via Genova' AND civico = 7), TRUE),
('9788806213967', (SELECT id FROM sedi WHERE città = 'Venezia' AND indirizzo = 'Via Venezia' AND civico = 8), TRUE),
('9788806213968', (SELECT id FROM sedi WHERE città = 'Verona' AND indirizzo = 'Via Verona' AND civico = 9), TRUE),
('9788806213969', (SELECT id FROM sedi WHERE città = 'Torino' AND indirizzo = 'Via Torino' AND civico = 10), TRUE),
('9788806213970', (SELECT id FROM sedi WHERE città = 'Napoli' AND indirizzo = 'Via Napoli' AND civico = 11), TRUE),
('9788806213971', (SELECT id FROM sedi WHERE città = 'Firenze' AND indirizzo = 'Via Firenze' AND civico = 12), TRUE),
('9788806213942', (SELECT id FROM sedi WHERE città = 'Torino' AND indirizzo = 'Via Torino' AND civico = 3), TRUE),
('9788806213943', (SELECT id FROM sedi WHERE città = 'Napoli' AND indirizzo = 'Via Napoli' AND civico = 4), TRUE),
('9788806213944', (SELECT id FROM sedi WHERE città = 'Firenze' AND indirizzo = 'Via Firenze' AND civico = 5), TRUE),
('9788806213945', (SELECT id FROM sedi WHERE città = 'Bologna' AND indirizzo = 'Via Bologna' AND civico = 6), TRUE),
('9788806213946', (SELECT id FROM sedi WHERE città = 'Genova' AND indirizzo = 'Via Genova' AND civico = 7), TRUE),
('9788806213947', (SELECT id FROM sedi WHERE città = 'Venezia' AND indirizzo = 'Via Venezia' AND civico = 8), TRUE),
('9788806213948', (SELECT id FROM sedi WHERE città = 'Verona' AND indirizzo = 'Via Verona' AND civico = 9), TRUE),
('9788806213949', (SELECT id FROM sedi WHERE città = 'Torino' AND indirizzo = 'Via Torino' AND civico = 10), TRUE),
('9788806213950', (SELECT id FROM sedi WHERE città = 'Napoli' AND indirizzo = 'Via Napoli' AND civico = 11), TRUE),
('9788806213951', (SELECT id FROM sedi WHERE città = 'Firenze' AND indirizzo = 'Via Firenze' AND civico = 12), TRUE),
('9788806213952', (SELECT id FROM sedi WHERE città = 'Torino' AND indirizzo = 'Via Torino' AND civico = 3), TRUE),
('9788806213953', (SELECT id FROM sedi WHERE città = 'Napoli' AND indirizzo = 'Via Napoli' AND civico = 4), TRUE),
('9788806213954', (SELECT id FROM sedi WHERE città = 'Firenze' AND indirizzo = 'Via Firenze' AND civico = 5), TRUE),
('9788806213955', (SELECT id FROM sedi WHERE città = 'Bologna' AND indirizzo = 'Via Bologna' AND civico = 6), TRUE),
('9788806213956', (SELECT id FROM sedi WHERE città = 'Genova' AND indirizzo = 'Via Genova' AND civico = 7), TRUE),
('9788806213957', (SELECT id FROM sedi WHERE città = 'Venezia' AND indirizzo = 'Via Venezia' AND civico = 8), TRUE),
('9788806213958', (SELECT id FROM sedi WHERE città = 'Verona' AND indirizzo = 'Via Verona' AND civico = 9), TRUE),
('9788806213959', (SELECT id FROM sedi WHERE città = 'Torino' AND indirizzo = 'Via Torino' AND civico = 10), TRUE),
('9788806213960', (SELECT id FROM sedi WHERE città = 'Napoli' AND indirizzo = 'Via Napoli' AND civico = 11), TRUE),
('9788806213961', (SELECT id FROM sedi WHERE città = 'Firenze' AND indirizzo = 'Via Firenze' AND civico = 12), TRUE);

-- Aggiunge 20 utenti reali

INSERT INTO utenti (cf, ruolo, password, nome, cognome) VALUES
('RSSMRA85M01H501Z', 'lettore', 'password1', 'Mario', 'Rossi'),
('VRDLGI85M01H501Z', 'lettore', 'password2', 'Luigi', 'Verdi'),
('BNCLRA85M01H501Z', 'lettore', 'password3', 'Lara', 'Bianchi'),
('FRNMLA85M01H501Z', 'lettore', 'password4', 'Mila', 'Ferrari'),
('RCCGNN85M01H501Z', 'lettore', 'password5', 'Gianni', 'Rocca'),
('BLGMRC85M01H501Z', 'lettore', 'password6', 'Marco', 'Bello'),
('SNTGNN85M01H501Z', 'lettore', 'password7', 'Gianna', 'Santoro'),
('MRNLGI85M01H501Z', 'lettore', 'password8', 'Luigi', 'Marino'),
('RCCLRA85M01H501Z', 'lettore', 'password9', 'Lara', 'Rocca'),
('VRDMLA85M01H501Z', 'lettore', 'password10', 'Mila', 'Verdi'),
('RSSMRA85M01H501Y', 'bibliotecario', 'password11', 'Mario', 'Rossi'),
('VRDLGI85M01H501Y', 'bibliotecario', 'password12', 'Luigi', 'Verdi'),
('BNCLRA85M01H501Y', 'bibliotecario', 'password13', 'Lara', 'Bianchi'),
('FRNMLA85M01H501Y', 'bibliotecario', 'password14', 'Mila', 'Ferrari'),
('RCCGNN85M01H501Y', 'bibliotecario', 'password15', 'Gianni', 'Rocca'),
('BLGMRC85M01H501Y', 'bibliotecario', 'password16', 'Marco', 'Bello'),
('SNTGNN85M01H501Y', 'bibliotecario', 'password17', 'Gianna', 'Santoro'),
('MRNLGI85M01H501Y', 'bibliotecario', 'password18', 'Luigi', 'Marino'),
('RCCLRA85M01H501Y', 'bibliotecario', 'password19', 'Lara', 'Rocca'),
('VRDMLA85M01H501Y', 'bibliotecario', 'password20', 'Mila', 'Verdi');

-- Aggiunge nella tabella lettori i 10 lettori

INSERT INTO lettori (id, categoria) VALUES
((SELECT id FROM utenti WHERE cf = 'RSSMRA85M01H501Z'), 'base'),
((SELECT id FROM utenti WHERE cf = 'VRDLGI85M01H501Z'), 'base'),
((SELECT id FROM utenti WHERE cf = 'BNCLRA85M01H501Z'), 'premium'),
((SELECT id FROM utenti WHERE cf = 'FRNMLA85M01H501Z'), 'base'),
((SELECT id FROM utenti WHERE cf = 'RCCGNN85M01H501Z'), 'premium'),
((SELECT id FROM utenti WHERE cf = 'BLGMRC85M01H501Z'), 'base'),
((SELECT id FROM utenti WHERE cf = 'SNTGNN85M01H501Z'), 'premium'),
((SELECT id FROM utenti WHERE cf = 'MRNLGI85M01H501Z'), 'base'),
((SELECT id FROM utenti WHERE cf = 'RCCLRA85M01H501Z'), 'premium'),
((SELECT id FROM utenti WHERE cf = 'VRDMLA85M01H501Z'), 'base');

-- Aggiunge nella tabella bibliotecari i 10 bibliotecari

INSERT INTO bibliotecari (id) VALUES
((SELECT id FROM utenti WHERE cf = 'RSSMRA85M01H501Y')),
((SELECT id FROM utenti WHERE cf = 'VRDLGI85M01H501Y')),
((SELECT id FROM utenti WHERE cf = 'BNCLRA85M01H501Y')),
((SELECT id FROM utenti WHERE cf = 'FRNMLA85M01H501Y')),
((SELECT id FROM utenti WHERE cf = 'RCCGNN85M01H501Y')),
((SELECT id FROM utenti WHERE cf = 'BLGMRC85M01H501Y')),
((SELECT id FROM utenti WHERE cf = 'SNTGNN85M01H501Y')),
((SELECT id FROM utenti WHERE cf = 'MRNLGI85M01H501Y')),
((SELECT id FROM utenti WHERE cf = 'RCCLRA85M01H501Y')),
((SELECT id FROM utenti WHERE cf = 'VRDMLA85M01H501Y'));


CREATE OR REPLACE FUNCTION create_mockup_prestiti()
RETURNS void AS $$
DECLARE
    i INTEGER;
    lettore_record RECORD;
    copia_id INTEGER;
    prestito_date DATE;
    data_restituzione DATE;
    scadenza DATE;
BEGIN
    FOR i IN 1..100 LOOP

        SELECT * INTO lettore_record 
        FROM lettori 
        ORDER BY RANDOM() 
        LIMIT 1;
        
        IF lettore_record.riconsegne_ritardo < 5 THEN
            SELECT id INTO copia_id 
            FROM copie 
            WHERE disponibilità = TRUE 
            ORDER BY RANDOM() 
            LIMIT 1;
            
            IF RANDOM() < 0.5 THEN
                data_restituzione := NULL;
            ELSE
                data_restituzione := CURRENT_DATE + ((random()*60)::TEXT || ' days')::INTERVAL;
            END IF;
            
            prestito_date := CURRENT_DATE - ((random()*90)::TEXT || ' days')::INTERVAL;
            scadenza := prestito_date + INTERVAL '30 days';
            
            IF data_restituzione IS NOT NULL AND data_restituzione > scadenza THEN
                UPDATE lettori 
                SET riconsegne_ritardo = lettore_record.riconsegne_ritardo + 1 
                WHERE id = lettore_record.id;
            END IF;

            BEGIN
                SET session_replication_role = replica;
                INSERT INTO prestiti (lettore, copia, datainizio, scadenza, datarestituzione)
                VALUES (lettore_record.id, copia_id, prestito_date, scadenza, data_restituzione);
            EXCEPTION
                WHEN OTHERS THEN
                    RAISE NOTICE 'Error inserting prestito: %', SQLERRM;
            END;
        END IF;
    END LOOP;
    SET session_replication_role = DEFAULT;
END;
$$ LANGUAGE plpgsql;


SELECT create_mockup_prestiti();


