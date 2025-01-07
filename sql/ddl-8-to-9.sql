BEGIN;

DROP TABLE IF EXISTS public.user_followed CASCADE;

DROP TABLE IF EXISTS public.article_hashtags CASCADE;

DROP TABLE IF EXISTS public.articles CASCADE;

DROP TABLE IF EXISTS public.sections CASCADE;

ALTER TABLE
    IF EXISTS public.addresses DROP COLUMN IF EXISTS city;

ALTER TABLE
    IF EXISTS public.addresses DROP COLUMN IF EXISTS country;

ALTER TABLE
    IF EXISTS public.addresses DROP COLUMN IF EXISTS postal_code;

ALTER TABLE
    IF EXISTS public.geolocations DROP COLUMN IF EXISTS geom;

ALTER TABLE
    IF EXISTS public.locations
ADD
    COLUMN city character varying(100) COLLATE pg_catalog."default";

ALTER TABLE
    IF EXISTS public.locations
ADD
    COLUMN country character varying(100) COLLATE pg_catalog."default";

ALTER TABLE
    IF EXISTS public.locations
ADD
    COLUMN postal_code character varying(20) COLLATE pg_catalog."default";

DROP SEQUENCE IF EXISTS public.sections_id_seq;

DROP SEQUENCE IF EXISTS public.articles_id_seq;

END;