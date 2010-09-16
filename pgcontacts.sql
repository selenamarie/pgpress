--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: people; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE people (
    name text,
    pgemail text,
    home_email text,
    office_phone text,
    cell_phone text,
    continent text,
    region text,
    url text,
    lang text,
    verified boolean,
    notes text,
    xtra_line text,
    cleanup boolean DEFAULT false
);


ALTER TABLE public.people OWNER TO postgres;

--
-- Name: commacat(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION commacat(acc text, instr text) RETURNS text
    AS $$
  BEGIN
    IF acc IS NULL OR acc = '' THEN
      RETURN instr;
    ELSE
      RETURN acc || E'\n<br />' || instr;
    END IF;
  END;
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.commacat(acc text, instr text) OWNER TO postgres;

--
-- Name: textcat_all(text); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE textcat_all(text) (
    SFUNC = textcat,
    STYPE = text,
    INITCOND = ''
);


ALTER AGGREGATE public.textcat_all(text) OWNER TO postgres;

--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

