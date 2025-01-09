-- ON INSERT IN utenti mette il cf in maiuscolo e la password in hash

CREATE OR REPLACE FUNCTION utenti_insert()
RETURNS TRIGGER 
    LANGUAGE plpgsql
    AS $$ 
        BEGIN
            SET search_path TO biblioteca;
            
            NEW.cf = UPPER(NEW.cf);
            NEW.password = crypt(NEW.password, gen_salt('bf'));
            
            RETURN NEW;
        END;
    $$;

CREATE TRIGGER utenti_insert
    BEFORE INSERT
    ON utenti
    FOR EACH ROW
        EXECUTE FUNCTION utenti_insert();


-- 2.2.1 --> Blocco prestiti a lettori ritardatari.
--           Se il lettore ha 5 riconsegne in ritardo all’attivo, non può richiedere ulteriori prestiti.

CREATE OR REPLACE FUNCTION blocco_prestiti_ritardatari()
RETURNS TRIGGER 
    LANGUAGE plpgsql
    AS $$
        DECLARE
            _riconsegne_ritardo SMALLINT;
        BEGIN
            SET search_path TO biblioteca;
            
            SELECT riconsegne_ritardo INTO _riconsegne_ritardo
            FROM lettori
            WHERE id = NEW.lettore;
            
            IF _riconsegne_ritardo = 5 THEN
                RAISE EXCEPTION 'BLOCCO PRESTITI -- limite riconsegne in ritardo raggiunto.';
            END IF;
            
            RETURN NEW;
        END;
    $$;

CREATE TRIGGER controllo_ritardi
    BEFORE INSERT
    ON prestiti
    FOR EACH ROW
        EXECUTE FUNCTION blocco_prestiti_ritardatari();


-- 2.2.2 --> Limite prestiti attivi per lettore.
--           account BASE: 3 prestiti attivi.
--           account PLUS: 5 prestiti attivi.

CREATE OR REPLACE FUNCTION limite_prestiti_attivi()
RETURNS TRIGGER 
    LANGUAGE plpgsql
    AS $$
        DECLARE
            _categoria TIPO_LETTORE;
            _prestiti_attivi INTEGER;
        BEGIN
            SET search_path TO biblioteca;
            
            SELECT categoria INTO _categoria
            FROM lettori
            WHERE id = NEW.lettore;
            
            SELECT COUNT(*) INTO _prestiti_attivi
            FROM prestiti
            WHERE lettore = NEW.lettore AND datarestituzione IS NULL;
            
            IF _categoria = 'base' AND _prestiti_attivi = 3 THEN
                RAISE EXCEPTION 'LIMITE PRESTITI -- limite prestiti attivi per account BASE raggiunto.';
            END IF;
            
            IF _categoria = 'premium' AND _prestiti_attivi = 5 THEN
                RAISE EXCEPTION 'LIMITE PRESTITI -- limite prestiti attivi per account PLUS raggiunto.';
            END IF;
            
            RETURN NEW;
        END;
    $$;

CREATE TRIGGER controllo_prestiti_attivi
    BEFORE INSERT
    ON prestiti
    FOR EACH ROW
        EXECUTE FUNCTION limite_prestiti_attivi();

-- 2.2.3 --> Ritardi nelle restituzioni.
--           Se un prestito viene restituito in ritardo, il lettore viene penalizzato con un giorno di riconsegna in ritardo.

CREATE OR REPLACE FUNCTION penalizzazione_ritardo()
RETURNS TRIGGER 
    LANGUAGE plpgsql
    AS $$
        DECLARE
            _scadenza DATE;
        BEGIN
            SET search_path TO biblioteca;
            
            SELECT scadenza INTO _scadenza
            FROM prestiti
            WHERE id = NEW.id;
            
            IF NEW.datarestituzione > _scadenza THEN
                UPDATE lettori
                SET riconsegne_ritardo = riconsegne_ritardo + 1
                WHERE id = NEW.lettore;
            END IF;
            
            RETURN NEW;
        END;
    $$;

CREATE TRIGGER controllo_ritardi_restituzione
    AFTER UPDATE
    ON prestiti
    FOR EACH ROW
        EXECUTE FUNCTION penalizzazione_ritardo();

-- 2.2.4 --> Disponibilità copie.
--           Se una copia viene prenotata, la disponibilità viene impostata a FALSE.
--           Se una copia viene restituita, la disponibilità viene impostata a TRUE.
--           Se viene effettuato un prestito su una copia non disponibile o rimossa, viene sollevata un'eccezione.

CREATE OR REPLACE FUNCTION aggiorna_disponibilità_prestito()
RETURNS TRIGGER 
    LANGUAGE plpgsql
    AS $$
        BEGIN
            SET search_path TO biblioteca;

            UPDATE copie
            SET disponibilità = FALSE
            WHERE id = NEW.copia;
            
            RETURN NEW;
        END;
    $$;

CREATE TRIGGER aggiorna_disponibilità_prestito
    AFTER INSERT
    ON prestiti
    FOR EACH ROW
        EXECUTE FUNCTION aggiorna_disponibilità_prestito();

CREATE OR REPLACE FUNCTION aggiorna_disponibilità_restituzione()
RETURNS TRIGGER 
    LANGUAGE plpgsql
    AS $$
        BEGIN
            SET search_path TO biblioteca;

            IF NEW.datarestituzione IS NOT NULL THEN
                UPDATE copie
                SET disponibilità = TRUE
                WHERE id = NEW.copia;
            END IF;
            
            RETURN NEW;
        END;
    $$;

CREATE TRIGGER  aggiorna_disponibilità_restituzione
    AFTER UPDATE
    ON prestiti
    FOR EACH ROW
        EXECUTE FUNCTION aggiorna_disponibilità_restituzione();

CREATE OR REPLACE FUNCTION controllo_disponibilità()
RETURNS TRIGGER 
    LANGUAGE plpgsql
    AS $$
        DECLARE
            _disponibilità BOOLEAN;
            _rimossa BOOLEAN;
        BEGIN
            SET search_path TO biblioteca;
            
            SELECT disponibilità, rimossa
            FROM copie
            WHERE id = NEW.copia
            INTO _disponibilità, _rimossa;

            IF _disponibilità = FALSE THEN
                RAISE EXCEPTION 'DISPONIBILITÀ -- copia non disponibile.';
            END IF;
            
            IF _rimossa = TRUE THEN
                RAISE EXCEPTION 'DISPONIBILITÀ -- copia rimossa.';
            END IF;

            RETURN NEW;
        END;
    $$;

CREATE TRIGGER controllo_disponibilità
    BEFORE INSERT
    ON prestiti
    FOR EACH ROW
        EXECUTE FUNCTION controllo_disponibilità();

-- 2.2.5 --> Proroga prestiti.
--           I prestiti possono essere prorogati di 14 giorni solo se non sono già in ritardo o già restituiti.

CREATE OR REPLACE FUNCTION controllo_proroga_prestito()
RETURNS TRIGGER 
    LANGUAGE plpgsql
    AS $$
        BEGIN
            SET search_path TO biblioteca;
            
            IF NEW.datarestituzione IS NOT NULL THEN
                RAISE EXCEPTION 'PROROGA -- prestito già restituito.';
            END IF;
            
            IF NEW.scadenza < CURRENT_DATE THEN
                RAISE EXCEPTION 'PROROGA -- prestito già in ritardo.';
            END IF;
            
            RETURN NEW;
        END;
    $$;

CREATE TRIGGER controllo_proroga
    BEFORE UPDATE
    OF scadenza ON prestiti
    FOR EACH ROW
        EXECUTE FUNCTION controllo_proroga_prestito();

-- 2.2.7 --> Statistiche sedi, aggiornamento automatico.
--           Ogni volta che viene effettuato un prestito o una restituzione, o viene aggiunta o rimossa una copia,
--           o viene aggiunto o rimosso un libro, le statistiche vengono aggiornate.

CREATE OR REPLACE FUNCTION aggiorna_statistiche_sedi()
RETURNS TRIGGER 
    LANGUAGE plpgsql
    AS $$
        BEGIN
            SET search_path TO biblioteca;
            
            REFRESH MATERIALIZED VIEW statistiche_sedi;
            
            RETURN NEW;
        END;
    $$;

CREATE TRIGGER aggiorna_statistiche_sedi
    AFTER INSERT OR UPDATE ON prestiti
    FOR EACH STATEMENT
        EXECUTE FUNCTION aggiorna_statistiche_sedi();
    
CREATE TRIGGER aggiorna_statistiche_sedi
    AFTER INSERT OR UPDATE ON copie
    FOR EACH STATEMENT
        EXECUTE FUNCTION aggiorna_statistiche_sedi();

CREATE TRIGGER aggiorna_statistiche_sedi
    AFTER INSERT OR UPDATE ON libri
    FOR EACH STATEMENT
        EXECUTE FUNCTION aggiorna_statistiche_sedi();

-- BEFORE INSERT IN prestiti mette dataInizio = CURRENT_DATE e scadenza = CURRENT_DATE + 30 giorni

CREATE OR REPLACE FUNCTION prestiti_insert()
RETURNS TRIGGER 
    LANGUAGE plpgsql
    AS $$
        BEGIN
            SET search_path TO biblioteca;
            
            NEW.dataInizio = CURRENT_DATE;
            NEW.scadenza = CURRENT_DATE + INTERVAL '30 days';
            
            RETURN NEW;
        END;
    $$;

CREATE TRIGGER prestiti_insert
    BEFORE INSERT
    ON prestiti
    FOR EACH ROW
        EXECUTE FUNCTION prestiti_insert();

-- ON DELETE IN prestiti rimette disponibilità = TRUE nella copia e se restituito in ritardo decrementa riconsegne_ritardo

CREATE OR REPLACE FUNCTION prestiti_delete()
RETURNS TRIGGER 
    LANGUAGE plpgsql
    AS $$
        DECLARE
            _scadenza DATE;
        BEGIN
            SET search_path TO biblioteca;
            
            SELECT scadenza INTO _scadenza
            FROM prestiti
            WHERE id = OLD.id;
            
            IF OLD.datarestituzione > _scadenza THEN
                UPDATE lettori
                SET riconsegne_ritardo = riconsegne_ritardo - 1
                WHERE id = OLD.lettore;
            END IF;
            
            UPDATE copie
            SET disponibilità = TRUE
            WHERE id = OLD.copia;
            
            RETURN OLD;
        END;
    $$;

CREATE TRIGGER prestiti_delete
    AFTER DELETE
    ON prestiti
    FOR EACH ROW
        EXECUTE FUNCTION prestiti_delete();

-- ON INSERT prestiti controlla che il lettore non abbia già un prestito attivo per quel libro

CREATE OR REPLACE FUNCTION controllo_prestito_attivo()
RETURNS TRIGGER 
    LANGUAGE plpgsql
    AS $$
        DECLARE
            _prestito_attivo BOOLEAN;
        BEGIN
            SET search_path TO biblioteca;
            
            SELECT TRUE
            FROM prestiti
            JOIN copie ON prestiti.copia = copie.id
            WHERE lettore = NEW.lettore AND datarestituzione IS NULL
            AND copie.libro = (SELECT libro FROM copie WHERE id = NEW.copia)
            INTO _prestito_attivo;
            
            IF _prestito_attivo = TRUE THEN
                RAISE EXCEPTION 'PRESTITO -- prestito attivo per questo libro.';
            END IF;
            
            RETURN NEW;
        END;
    $$;

CREATE TRIGGER controllo_prestito_attivo
    BEFORE INSERT
    ON prestiti
    FOR EACH ROW
        EXECUTE FUNCTION controllo_prestito_attivo();