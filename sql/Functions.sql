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