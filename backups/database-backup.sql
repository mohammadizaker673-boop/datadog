--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg110+2)
-- Dumped by pg_dump version 16.4 (Debian 16.4-1.pgdg110+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: datadog_user
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO datadog_user;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: datadog_user
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO datadog_user;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: datadog_user
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO datadog_user;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: datadog_user
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: business_categories; Type: TABLE; Schema: public; Owner: datadog_user
--

CREATE TABLE public.business_categories (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    parent_category_id uuid,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.business_categories OWNER TO datadog_user;

--
-- Name: business_sources; Type: TABLE; Schema: public; Owner: datadog_user
--

CREATE TABLE public.business_sources (
    id uuid NOT NULL,
    business_id uuid NOT NULL,
    source_name character varying(255) NOT NULL,
    source_id character varying(500),
    last_verified timestamp without time zone DEFAULT now(),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.business_sources OWNER TO datadog_user;

--
-- Name: businesses; Type: TABLE; Schema: public; Owner: datadog_user
--

CREATE TABLE public.businesses (
    id uuid NOT NULL,
    name character varying(500) NOT NULL,
    category character varying(255) NOT NULL,
    description character varying(2000),
    address character varying(500) NOT NULL,
    phone character varying(20),
    website character varying(500),
    email character varying(255),
    city_id uuid NOT NULL,
    status character varying(50) NOT NULL,
    confidence_score double precision,
    fingerprint_hash character varying(64),
    first_seen_date timestamp without time zone DEFAULT now(),
    last_verified_date timestamp without time zone DEFAULT now(),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    trading_address character varying(500),
    crn character varying(20),
    sic_code character varying(10),
    company_size character varying(50)
);


ALTER TABLE public.businesses OWNER TO datadog_user;

--
-- Name: cities; Type: TABLE; Schema: public; Owner: datadog_user
--

CREATE TABLE public.cities (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    country_id uuid NOT NULL,
    state character varying(255),
    latitude double precision,
    longitude double precision,
    geom public.geometry(Point,4326),
    population integer,
    timezone character varying(100),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    region_id uuid,
    is_major_city integer DEFAULT 0
);


ALTER TABLE public.cities OWNER TO datadog_user;

--
-- Name: continents; Type: TABLE; Schema: public; Owner: datadog_user
--

CREATE TABLE public.continents (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(10) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.continents OWNER TO datadog_user;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: datadog_user
--

CREATE TABLE public.countries (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    iso_code character varying(2) NOT NULL,
    iso3_code character varying(3) NOT NULL,
    continent_id uuid NOT NULL,
    currency character varying(3),
    language character varying[],
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.countries OWNER TO datadog_user;

--
-- Name: regions; Type: TABLE; Schema: public; Owner: datadog_user
--

CREATE TABLE public.regions (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(10),
    country_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.regions OWNER TO datadog_user;

--
-- Name: sub_areas; Type: TABLE; Schema: public; Owner: datadog_user
--

CREATE TABLE public.sub_areas (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    city_id uuid NOT NULL,
    type character varying(50),
    latitude double precision,
    longitude double precision,
    location public.geometry(Point,4326),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.sub_areas OWNER TO datadog_user;

--
-- Data for Name: business_categories; Type: TABLE DATA; Schema: public; Owner: datadog_user
--

COPY public.business_categories (id, name, parent_category_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: business_sources; Type: TABLE DATA; Schema: public; Owner: datadog_user
--

COPY public.business_sources (id, business_id, source_name, source_id, last_verified, created_at) FROM stdin;
7716529d-2c97-4278-8eb7-316fbe277d46	d571c6e0-3832-42c7-b79d-56bd2643b8d1	Companies House	10430663	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418
804e9ec7-d1eb-4629-939f-3cc4ecd34064	b97249ba-dcd2-4693-89fa-26961ff80cc0	Companies House	12245364	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418
6d2ca5a2-5dd3-43c0-a9e8-52da4fb71ba3	e889f87a-b7c1-41b5-9adc-0b6bbd82d4a6	Companies House	11622784	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418
0f1c59b7-3871-4368-984e-33245e506917	e6588174-5812-493c-8e1c-46ce9bc12adc	Companies House	11954149	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418
ee6dc959-6cad-49e7-97f1-df1a48e75616	a2dc4aef-906e-4ce0-ab55-4ad37bcccc37	Companies House	11760727	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418
a61e5293-0fe2-424a-b428-3754b9b29379	c69ce2b2-9f48-4d05-8064-8c2518545d53	Companies House	07776513	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418
b3ec4649-c519-4597-a62a-73f3af4374f7	9d440801-b635-4090-b8a1-ff5aaaee8eac	Companies House	11227995	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418
a27dd3be-d954-4d50-b287-a02e4798a2ca	bcead2b0-ca23-4549-9f51-9ee768b8d847	Companies House	11638316	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418
d9fe8aff-4816-48fb-93b1-4f4baca75638	767b8db8-52ae-48d6-81e7-90aae4ceda30	Companies House	11007553	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418
45d7e775-a378-4b97-8f7b-a59c448a3eb9	9fb6699b-d4a4-463d-96dc-e397b62ebd22	Companies House	13900718	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421
17ef0984-67f2-45d9-9531-a291768b2db1	6d6e5b0f-624e-45c5-b400-3053edeb586a	Companies House	15483230	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421
99899063-9590-41a3-8f42-415f367f42de	2da44e39-fc66-435a-ac00-096b60f51fa9	Companies House	04444664	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421
2d39e070-93a5-447d-8dc5-dffef7e387df	7eefea13-4c3a-46eb-8a14-2b59298d980d	Companies House	02962116	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421
637f94ed-3019-4d99-808d-46d53da9fea9	59ec3c63-87d8-482a-a808-cf1fabd5473b	Companies House	13970698	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421
a3187680-7b2c-4c22-91f2-1c048a483981	f31b374f-4eee-4ee2-9457-71c0cf372184	Companies House	09302331	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486
087d1414-8b96-4d2a-823f-21f9685bb9a4	abd828d4-916a-4590-bcbf-d6226f1a66ce	Companies House	02796297	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486
9e44ecfc-7347-4bdc-9cd7-0479a966c372	e0f30a1d-fa89-47d2-a003-317caf43152b	Companies House	16454490	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486
429a03ec-dd44-42cd-8d0f-0e062d5ac789	43706f30-6733-4738-bbbc-15ab888ff0c2	Companies House	14171437	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486
cee518ed-ab3c-490b-ac7a-ca2939f519a3	3552667d-530a-4f42-8056-3bff0f63124d	Companies House	12289852	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486
d50533dc-c8c3-484e-a19b-82204ef41bfe	4470d992-2e67-4562-b68d-bb532d877742	Companies House	13341052	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486
3f96f416-6047-40f8-81ba-0d39fba14355	cb6b350b-dcff-4a37-b843-b5f42d702c52	Companies House	14691989	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486
6f0a1005-078b-48a5-836b-3db1bd609b90	4928617d-766a-4639-8620-5d2b70c53910	Companies House	15970700	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486
fe861094-6fb5-4087-a0c1-db8a587e5da4	20b116ad-67e1-42cd-8306-e5dc74625cdf	Companies House	SC399996	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283
32d9293c-5ad3-4589-a5ee-7ba1baff8d03	8f2e40c1-d9ff-4b61-bb5a-451a0ecb61be	Companies House	SC314278	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283
25a26dd0-c3b6-4200-b55d-1c18569e50a6	8e20ca38-555e-4d3a-8e19-9e71763e6348	Companies House	SC858406	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283
ebc9eb9a-d1f9-4c2d-8e2f-439b976e3826	2293c882-5f81-4869-a9a3-2a7503135517	Companies House	SC579419	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283
1df775a6-a678-4e5d-a5c1-c570bdb4d254	350dcd03-94b5-461f-af12-165870517722	Companies House	SC652350	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283
b4f3ff13-969f-4696-a46c-af45de11758d	0d79bac9-60cb-47bc-9c06-de92e90f1e67	Companies House	SC761924	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283
\.


--
-- Data for Name: businesses; Type: TABLE DATA; Schema: public; Owner: datadog_user
--

COPY public.businesses (id, name, category, description, address, phone, website, email, city_id, status, confidence_score, fingerprint_hash, first_seen_date, last_verified_date, created_at, updated_at, trading_address, crn, sic_code, company_size) FROM stdin;
d571c6e0-3832-42c7-b79d-56bd2643b8d1	ABC TRAVELERS LIMITED	Education	Type: ltd | SIC: 85590, 85600	Flat 4 Scotts Road, London, W12 8HQ	\N	\N	\N	a1ca91e7-0c4f-42dc-b2ea-b85e483e82af	active	0.9	ade447deac8676698f78b918705205f2643bf7a8f1d50d9554a383a34989d8f6	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	\N	\N	\N	\N
b97249ba-dcd2-4693-89fa-26961ff80cc0	AS LONDON HOTEL MANAGEMENT LIMITED	Hotels & Lodging	Type: ltd | SIC: 55100	Cannon Place, 78 Cannon Street, London, EC4N 6AF	\N	\N	\N	a1ca91e7-0c4f-42dc-b2ea-b85e483e82af	active	0.9	e2c59a5a7134dddc58e690b08c4d68a50ca56afbf0160e60d75f871334e7fc30	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	\N	\N	\N	\N
e889f87a-b7c1-41b5-9adc-0b6bbd82d4a6	A STRATEGY ART CONSULTING LTD.	Professional Services	Type: ltd | SIC: 84120	2505 Harcourt Tower, 67 Marsh Wall, London, E14 9SW	\N	\N	\N	a1ca91e7-0c4f-42dc-b2ea-b85e483e82af	active	0.9	37ef8ecc0b03da262794501e9a33f7a56c6df69f91174d3bd807394e251e6ebd	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	\N	\N	\N	\N
e6588174-5812-493c-8e1c-46ce9bc12adc	BARNRISE PROPERTIES LTD	Real Estate	Type: ltd | SIC: 68100, 68209	186 Camden High Street, London, NW1 8QP	\N	\N	\N	a1ca91e7-0c4f-42dc-b2ea-b85e483e82af	active	0.9	df3f87aa4f76be7ee2786ee3aed308a7f195f0317152db43424e2f62754b09ae	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	\N	\N	\N	\N
a2dc4aef-906e-4ce0-ab55-4ad37bcccc37	BAUHAUS GLAZING GROUP LIMITED	Professional Services	Type: ltd | SIC: 43342	128 City Road, London, EC1V 2NX	\N	\N	\N	a1ca91e7-0c4f-42dc-b2ea-b85e483e82af	active	0.9	031014f679e75e1a56f7ddccd0aa0408bfec5cc2c9fe01aa053234ae017cbab2	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	\N	\N	\N	\N
c69ce2b2-9f48-4d05-8064-8c2518545d53	BETTER ARCHITECTURE LTD	Professional Services	Type: ltd | SIC: 71111	703 Hoey Court 4 Barry Blandford Way, London, E3 3TR	\N	\N	\N	a1ca91e7-0c4f-42dc-b2ea-b85e483e82af	active	0.9	26042df503cc09d360a591f50de43aeb0941d98b14c0fbfab9c8ec896e2259fc	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	\N	\N	\N	\N
9d440801-b635-4090-b8a1-ff5aaaee8eac	THE BRIGHT COLLEGE LIMITED	Education	Type: ltd | SIC: 85590	30 St. Georges Road, London, SW19 4BD	\N	\N	\N	a1ca91e7-0c4f-42dc-b2ea-b85e483e82af	active	0.9	f05be3f510373091db5d73cc60f8101eed08100e216e78bb2adaa87736c0f369	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	\N	\N	\N	\N
bcead2b0-ca23-4549-9f51-9ee768b8d847	BRITLAND RETAIL (UK) PREMISES LIMITED	Professional Services	Type: ltd | SIC: 46190, 52103, 68100, 68209	31 Belson Road, Woolwich, London, SE18 5PU	\N	\N	\N	a1ca91e7-0c4f-42dc-b2ea-b85e483e82af	active	0.9	9de80dfd22125d2fda6d813b2a9481b12fdd738928922f3efed7a9001d81e6d6	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	\N	\N	\N	\N
767b8db8-52ae-48d6-81e7-90aae4ceda30	CHANCERY LAW ADVISORY LIMITED	Finance	Type: ltd | SIC: 64910, 64929, 64992, 64999	31 Belson Road, Woolwich, London, SE18 5PU	\N	\N	\N	a1ca91e7-0c4f-42dc-b2ea-b85e483e82af	active	0.9	a466f0ac0760d0e49e3022bd531bc94421a0e03c6bcca805b15b0b61747e749d	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	2026-01-05 19:43:46.469418	\N	\N	\N	\N
9fb6699b-d4a4-463d-96dc-e397b62ebd22	PORTSMOUTH ADVANCED STUDENT SERVICES (PASS) LTD	Real Estate	Type: ltd | SIC: 68209, 68320, 96090	Room 212 Technopole, Kingston Crescent, Portsmouth, PO2 8FA	\N	\N	\N	fa2509a4-1ae6-459f-a6d4-a1a11192dee9	active	0.9	e7c3959e2786888a8746a5784ef7599ae72cf6d0c04f959f0a4d601ba073c159	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421	\N	\N	\N	\N
6d6e5b0f-624e-45c5-b400-3053edeb586a	PORTSMOUTH ALBERT ROAD LTD	Professional Services	Type: ltd | SIC: 47110	131 Albert Road, Portsmouth, PO5 2SL	\N	\N	\N	fa2509a4-1ae6-459f-a6d4-a1a11192dee9	inactive	0.9	9586578345dcb0a131df1a22fe1335c58bacb7ca8ed7f65d6f0e511be6561181	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421	\N	\N	\N	\N
2da44e39-fc66-435a-ac00-096b60f51fa9	PORTSMOUTH & DISTRICT PRIVATE LANDLORDS ASSOCIATION	Professional Services	Type: private-limited-guarant-nsc-limited-exemption | SIC: 94990	214 Chichester Road, Portsmouth, PO2 0AX	\N	\N	\N	fa2509a4-1ae6-459f-a6d4-a1a11192dee9	active	0.9	8777d504955ff48d6aaed02787397eafcf72b0042abebc0d8393e11b73a0c033	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421	\N	\N	\N	\N
7eefea13-4c3a-46eb-8a14-2b59298d980d	PORTSMOUTH AND SOUTH EAST HAMPSHIRE PARTNERSHIP LIMITED	Real Estate	Type: private-limited-guarant-nsc | SIC: 68209, 82110, 94110	Portsmouth Guildhall, Guildhall Square, Portsmouth, PO1 2AB	\N	\N	\N	fa2509a4-1ae6-459f-a6d4-a1a11192dee9	active	0.9	313b7baa3cf26852d52675d70828420643f6fb8cd7795c449ce7ec9585639e4b	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421	\N	\N	\N	\N
59ec3c63-87d8-482a-a808-cf1fabd5473b	PORTSMOUTH & SOUTHSEA FUTSAL CLUB LTD	Education	Type: ltd | SIC: 85510	Flat 1 22 St Marys Road, Portsmouth, PO1 5PH	\N	\N	\N	fa2509a4-1ae6-459f-a6d4-a1a11192dee9	active	0.9	2798ee11c076721a04e7732b7fb03a62d8944b99af2d26fbe0f4f2b4f2d6e844	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421	2026-01-05 21:03:09.327421	\N	\N	\N	\N
f31b374f-4eee-4ee2-9457-71c0cf372184	ATLANTIC CONSTRUCTION BUILDERS LTD	Professional Services	Type: ltd | SIC: 43310	212 St. Fagans Road, Cardiff, CF5 3EW	\N	\N	\N	11e11d56-3d45-446b-96c9-08c85d62ae33	active	0.9	fbc4dfeac58beeaa67dc1df810758552b6c19d10a46ecc36f390b49dec870fd0	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	\N	\N	\N	\N
abd828d4-916a-4590-bcbf-d6226f1a66ce	CARDIFF ACADEMIC PRESS LIMITED	Technology	Type: ltd | SIC: 58110	St. Fagans Road, Fairwater, Cardiff, CF5 3AE	\N	\N	\N	11e11d56-3d45-446b-96c9-08c85d62ae33	active	0.9	fa0767d31cab6e907f2e4c894d52979f92420cbfd668796634a14246bf19a053	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	\N	\N	\N	\N
e0f30a1d-fa89-47d2-a003-317caf43152b	CARDIFF ACADEMY LTD	Education	Type: ltd | SIC: 85590, 85600	168 City Road, Cardiff, CF24 3JE	\N	\N	\N	11e11d56-3d45-446b-96c9-08c85d62ae33	active	0.9	c83bb01da08f5c96b0f75f51e67c22572151f51a44f93ae957e8cd142db5c77e	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	\N	\N	\N	\N
43706f30-6733-4738-bbbc-15ab888ff0c2	CARDIFF ACCOUNTANTS LTD	Professional Services	Type: ltd | SIC: 69202	25 Goldcrest Drive, Cardiff, CF23 7HJ	\N	\N	\N	11e11d56-3d45-446b-96c9-08c85d62ae33	active	0.9	3efa0977493c451b1f7e25d67d9e93301d0e3c6fd7745c9ced58654dc7d432fe	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	\N	\N	\N	\N
3552667d-530a-4f42-8056-3bff0f63124d	CARDIFF ACQUISITIONS LTD	Real Estate	Type: ltd | SIC: 68209, 68320, 82990	18 Churchill Way, Cardiff, CF10 2DY	\N	\N	\N	11e11d56-3d45-446b-96c9-08c85d62ae33	active	0.9	1149c575f484521c104e6e85cc0a1933dcfc8ab6bb4cca006775214e73edbf0f	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	\N	\N	\N	\N
4470d992-2e67-4562-b68d-bb532d877742	CARDIFF AGGREGATES LIMITED	Professional Services	Type: ltd | SIC: 52290	6 Lovage Close, Pontprennau, Cardiff, CF23 8SB	\N	\N	\N	11e11d56-3d45-446b-96c9-08c85d62ae33	active	0.9	f09933b995dd0bfb65287f15ccd7503924b89e9f3c21c3e46e9dd80c5f407896	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	\N	\N	\N	\N
cb6b350b-dcff-4a37-b843-b5f42d702c52	CARDIFF AI LIMITED	Professional Services	Type: ltd | SIC: 62020	2 Alexandra Gate, Ffordd Pengam, Cardiff, CF24 2SA	\N	\N	\N	11e11d56-3d45-446b-96c9-08c85d62ae33	active	0.9	8d15697699961d95fdb2f45d2f724555bc37af26c301474b2e76f7cc97b2200c	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	\N	\N	\N	\N
4928617d-766a-4639-8620-5d2b70c53910	CARDIFF AIRPORT TRANSFERS LTD	Transportation	Type: ltd | SIC: 49390	5 Brachdy Lane, Rumney, Cardiff, CF3 3AR	\N	\N	\N	11e11d56-3d45-446b-96c9-08c85d62ae33	active	0.9	657dfc261aab77f7f0d64a3a5ab0aa212b1b6da0caeeece277d7f68414e341cd	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	2026-01-05 21:03:43.607486	\N	\N	\N	\N
20b116ad-67e1-42cd-8306-e5dc74625cdf	DUNDEE LTD	Professional Services	Type: ltd | SIC: 70100	11g Hebrides Drive, Dundee, DD4 9SD	\N	\N	\N	3d1581a6-0380-4299-8057-53ad6ea0b29f	inactive	0.9	c21c8103ca4cc86a5c92d2ceccdcb5e1c64212972f2f40522650b7ea109dcd72	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	\N	\N	\N	\N
8f2e40c1-d9ff-4b61-bb5a-451a0ecb61be	DUNDEE AND ANGUS CHAMBER OF COMMERCE LIMITED	Professional Services	Type: private-limited-guarant-nsc | SIC: 94110	Whitehall House, 33 Yeaman Shore, Dundee, DD1 4BJ	\N	\N	\N	3d1581a6-0380-4299-8057-53ad6ea0b29f	active	0.9	c4718489a135c1bd69aea36ef11e155b27ce4254fe7ce950fa0fe18360d76808	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	\N	\N	\N	\N
8e20ca38-555e-4d3a-8e19-9e71763e6348	DUNDEE & ANGUS JOINERS LIMITED	Professional Services	Type: ltd | SIC: 43320	4 Valentine Court, Dundee Business Park, Dundee, DD2 3QB	\N	\N	\N	3d1581a6-0380-4299-8057-53ad6ea0b29f	active	0.9	aaa00d721a5723ea04c4adf981bad6f1a1766e5a747a4a165e219785fed15638	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	\N	\N	\N	\N
2293c882-5f81-4869-a9a3-2a7503135517	DUNDEE & ANGUS RECYCLING GROUP CIC	Professional Services	Type: private-limited-guarant-nsc | SIC: 16290, 85590	34 Faraday Street, Dryburgh Industrial Estate, Dundee, DD2 3QQ	\N	\N	\N	3d1581a6-0380-4299-8057-53ad6ea0b29f	inactive	0.9	55e1174ce2d3b7d2c034a6f1d9f9e134b12a36974c8c3b9653615c8cfe7e53f7	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	\N	\N	\N	\N
350dcd03-94b5-461f-af12-165870517722	DUNDEE & TAYSIDE CARPETS AND CLEANING SERVICE LIMITED	Professional Services	Type: ltd | SIC: 96090	14 Polepark Road, Dundee, DD1 5QS	\N	\N	\N	3d1581a6-0380-4299-8057-53ad6ea0b29f	active	0.9	2f91329a71cf64d6cbb2de083e858ebf1accb84de34e0ea69f03193bc29b445a	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	\N	\N	\N	\N
0d79bac9-60cb-47bc-9c06-de92e90f1e67	DUNDEE A1 TYRES LTD	Retail	Type: ltd | SIC: 45320	54a East Dock Street, 54a East Dock Street, Dundee, DD1 3JX	\N	\N	\N	3d1581a6-0380-4299-8057-53ad6ea0b29f	active	0.9	23ce80bee63c2837a219733457816ce0322743e4a4e30fe9cdae3bb18af955ac	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	2026-01-05 21:08:13.435283	\N	\N	\N	\N
\.


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: datadog_user
--

COPY public.cities (id, name, country_id, state, latitude, longitude, geom, population, timezone, created_at, updated_at, region_id, is_major_city) FROM stdin;
aec59bc7-a51d-43ed-8b3a-9110d596f6b5	Berlin	a9cf74aa-2b13-4faa-9748-fb5404a0aa58	\N	52.52	13.405	\N	\N	Europe/Berlin	2026-01-05 19:24:24.749318	2026-01-05 19:24:24.749318	\N	0
ebd37820-c4ea-40f8-9d14-b7f784791f04	New York	74a707e3-a8e7-4c5d-8fd4-9a8eb7f78a21	\N	40.7128	-74.006	\N	\N	America/New_York	2026-01-05 19:24:24.749318	2026-01-05 19:24:24.749318	\N	0
a1ca91e7-0c4f-42dc-b2ea-b85e483e82af	London	a9d77143-c453-42d8-9a65-f8877c542e92	\N	51.5074	-0.1278	\N	\N	Europe/London	2026-01-05 19:24:24.749318	2026-01-05 19:24:24.749318	\N	0
3a9f92a9-a130-4ba5-91da-aee8de3b5e6f	Paris	157d389d-2799-4e89-87a2-5a5bd088cac9	\N	48.8566	2.3522	\N	\N	Europe/Paris	2026-01-05 19:24:24.749318	2026-01-05 19:24:24.749318	\N	0
2410a114-dec2-4783-a9ff-ecc03112ac17	Tokyo	83f526e7-d940-439e-9541-d275ddf76580	\N	35.6762	139.6503	\N	\N	Asia/Tokyo	2026-01-05 19:24:24.749318	2026-01-05 19:24:24.749318	\N	0
fb80692b-bb78-4ad2-ab10-05b696ea45a2	Sydney	175f1e63-3f5e-4cf1-a6b9-1a198b0cba9f	\N	-33.8688	151.2093	\N	\N	Australia/Sydney	2026-01-05 19:24:24.749318	2026-01-05 19:24:24.749318	\N	0
1b8b3050-f5fb-4262-8ca4-dce3a18595f6	London	a9d77143-c453-42d8-9a65-f8877c542e92	\N	51.5074	-0.1278	\N	9000000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	88a881ab-ff63-416b-a0e5-d678aaa7edcd	1
556127cd-edfc-453a-90bf-838dc46406ba	Manchester	a9d77143-c453-42d8-9a65-f8877c542e92	\N	53.4808	-2.2426	\N	2800000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	88a881ab-ff63-416b-a0e5-d678aaa7edcd	1
17af7772-a8ae-4fb7-9551-250c522e7c48	Birmingham	a9d77143-c453-42d8-9a65-f8877c542e92	\N	52.4862	-1.8904	\N	2600000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	88a881ab-ff63-416b-a0e5-d678aaa7edcd	1
fb1305b8-87c7-4138-b0a9-763b15daf712	Leeds	a9d77143-c453-42d8-9a65-f8877c542e92	\N	53.8008	-1.5491	\N	1900000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	88a881ab-ff63-416b-a0e5-d678aaa7edcd	1
f7792633-1204-425c-b468-aaa2b62c3da0	Liverpool	a9d77143-c453-42d8-9a65-f8877c542e92	\N	53.4084	-2.9916	\N	1500000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	88a881ab-ff63-416b-a0e5-d678aaa7edcd	1
421e421e-f1ab-4736-9f94-0cd2c073e82d	Bristol	a9d77143-c453-42d8-9a65-f8877c542e92	\N	51.4545	-2.5879	\N	700000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	88a881ab-ff63-416b-a0e5-d678aaa7edcd	1
5da02f72-cb03-4d4f-b679-af9135b06304	Newcastle	a9d77143-c453-42d8-9a65-f8877c542e92	\N	54.9783	-1.6178	\N	800000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	88a881ab-ff63-416b-a0e5-d678aaa7edcd	1
ac7b16b8-c904-47a6-84e9-2646c0d3291b	Sheffield	a9d77143-c453-42d8-9a65-f8877c542e92	\N	53.3811	-1.4701	\N	700000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	88a881ab-ff63-416b-a0e5-d678aaa7edcd	1
dd3f1ea5-20d0-4292-bb48-b92d867c9023	Nottingham	a9d77143-c453-42d8-9a65-f8877c542e92	\N	52.9548	-1.1581	\N	730000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	88a881ab-ff63-416b-a0e5-d678aaa7edcd	1
2b962e13-373c-415b-b255-45e801bfa6a6	Southampton	a9d77143-c453-42d8-9a65-f8877c542e92	\N	50.9097	-1.4044	\N	500000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	88a881ab-ff63-416b-a0e5-d678aaa7edcd	1
acc60c8e-c17c-48c7-8b40-8548be88f404	Oxford	a9d77143-c453-42d8-9a65-f8877c542e92	\N	51.752	-1.2577	\N	150000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	88a881ab-ff63-416b-a0e5-d678aaa7edcd	0
1387f5b6-99e3-4eef-8696-4d5185dda351	Cambridge	a9d77143-c453-42d8-9a65-f8877c542e92	\N	52.2053	0.1218	\N	130000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	88a881ab-ff63-416b-a0e5-d678aaa7edcd	0
f099ceca-b06e-41ae-8548-823d0c11671d	Bath	a9d77143-c453-42d8-9a65-f8877c542e92	\N	51.3758	-2.3599	\N	90000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	88a881ab-ff63-416b-a0e5-d678aaa7edcd	0
532f2cab-e040-4b56-bcfb-acff3b7c046d	York	a9d77143-c453-42d8-9a65-f8877c542e92	\N	53.9591	-1.0815	\N	200000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	88a881ab-ff63-416b-a0e5-d678aaa7edcd	0
bce08605-befa-4ac3-b3f9-83835374f9da	Brighton	a9d77143-c453-42d8-9a65-f8877c542e92	\N	50.8225	-0.1372	\N	290000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	88a881ab-ff63-416b-a0e5-d678aaa7edcd	0
4706a085-b43f-40ef-b5d9-1cdb49d2c4fd	Edinburgh	a9d77143-c453-42d8-9a65-f8877c542e92	\N	55.9533	-3.1883	\N	530000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	abe6f744-16e7-4dcd-82b1-4a036cd7fc31	1
d1a53aae-e6f7-49db-985f-35e10c1d2939	Glasgow	a9d77143-c453-42d8-9a65-f8877c542e92	\N	55.8642	-4.2518	\N	635000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	abe6f744-16e7-4dcd-82b1-4a036cd7fc31	1
30d556d5-72ee-4bea-9a18-4b7a430d008b	Aberdeen	a9d77143-c453-42d8-9a65-f8877c542e92	\N	57.1497	-2.0943	\N	200000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	abe6f744-16e7-4dcd-82b1-4a036cd7fc31	1
3d1581a6-0380-4299-8057-53ad6ea0b29f	Dundee	a9d77143-c453-42d8-9a65-f8877c542e92	\N	56.462	-2.9707	\N	150000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	abe6f744-16e7-4dcd-82b1-4a036cd7fc31	0
9e0481fd-590b-49cd-add4-a7d0187b6d90	Inverness	a9d77143-c453-42d8-9a65-f8877c542e92	\N	57.4778	-4.2247	\N	70000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	abe6f744-16e7-4dcd-82b1-4a036cd7fc31	0
11e11d56-3d45-446b-96c9-08c85d62ae33	Cardiff	a9d77143-c453-42d8-9a65-f8877c542e92	\N	51.4816	-3.1791	\N	365000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	cc690ac1-8b63-45b3-8b99-377339c6e8a7	1
b46e3b36-b09a-4a76-bf65-099646b1c42a	Swansea	a9d77143-c453-42d8-9a65-f8877c542e92	\N	51.6214	-3.9436	\N	245000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	cc690ac1-8b63-45b3-8b99-377339c6e8a7	1
e603ea53-f9a9-4234-8cd7-be78ef18bff3	Newport	a9d77143-c453-42d8-9a65-f8877c542e92	\N	51.5842	-2.9977	\N	150000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	cc690ac1-8b63-45b3-8b99-377339c6e8a7	0
0d5b7b4e-e014-47c4-9a52-7b876a7da647	Belfast	a9d77143-c453-42d8-9a65-f8877c542e92	\N	54.5973	-5.9301	\N	345000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	027b82ae-d064-4cb5-a2f0-05d103255704	1
3eb7b576-304a-4d96-8e50-6e04065ba0b4	Derry	a9d77143-c453-42d8-9a65-f8877c542e92	\N	54.9966	-7.3086	\N	85000	Europe/London	2026-01-05 20:28:52.999894	2026-01-05 20:28:52.999894	027b82ae-d064-4cb5-a2f0-05d103255704	0
1787eecd-92a4-478a-a4ca-cd30353e3da4	Leicester	a9d77143-c453-42d8-9a65-f8877c542e92	\N	52.6369	-1.1398	0101000020E61000005BB1BFEC9E3CF2BF44696FF085514A40	355000	\N	2026-01-05 21:02:20.714378	2026-01-05 21:02:20.714378	88a881ab-ff63-416b-a0e5-d678aaa7edcd	0
fa2509a4-1ae6-459f-a6d4-a1a11192dee9	Portsmouth	a9d77143-c453-42d8-9a65-f8877c542e92	\N	50.8198	-1.088	0101000020E61000009CC420B07268F1BF62A1D634EF684940	240000	\N	2026-01-05 21:02:20.714378	2026-01-05 21:02:20.714378	88a881ab-ff63-416b-a0e5-d678aaa7edcd	0
\.


--
-- Data for Name: continents; Type: TABLE DATA; Schema: public; Owner: datadog_user
--

COPY public.continents (id, name, code, created_at, updated_at) FROM stdin;
370a3a44-5c26-491d-bf66-d8bfca2c5e92	Africa	AF	2026-01-05 19:24:24.656391	2026-01-05 19:24:24.656391
548725c2-1b9b-4d1f-ab66-69f1df9f5a6c	Asia	AS	2026-01-05 19:24:24.656391	2026-01-05 19:24:24.656391
bb167c19-ccbc-4922-bd58-3b310c76bf16	Europe	EU	2026-01-05 19:24:24.656391	2026-01-05 19:24:24.656391
71ff87bd-627c-4430-a653-cabe7b2fc244	North America	NA	2026-01-05 19:24:24.656391	2026-01-05 19:24:24.656391
5f37dccb-1a99-48da-986a-fae205b2134c	South America	SA	2026-01-05 19:24:24.656391	2026-01-05 19:24:24.656391
20c2771d-c0e6-40e8-8847-9b32cd5fe7e1	Oceania	OC	2026-01-05 19:24:24.656391	2026-01-05 19:24:24.656391
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: datadog_user
--

COPY public.countries (id, name, iso_code, iso3_code, continent_id, currency, language, created_at, updated_at) FROM stdin;
a9cf74aa-2b13-4faa-9748-fb5404a0aa58	Germany	DE	DEU	bb167c19-ccbc-4922-bd58-3b310c76bf16	EUR	\N	2026-01-05 19:24:24.709621	2026-01-05 19:24:24.709621
74a707e3-a8e7-4c5d-8fd4-9a8eb7f78a21	United States	US	USA	71ff87bd-627c-4430-a653-cabe7b2fc244	USD	\N	2026-01-05 19:24:24.709621	2026-01-05 19:24:24.709621
a9d77143-c453-42d8-9a65-f8877c542e92	United Kingdom	GB	GBR	bb167c19-ccbc-4922-bd58-3b310c76bf16	GBP	\N	2026-01-05 19:24:24.709621	2026-01-05 19:24:24.709621
157d389d-2799-4e89-87a2-5a5bd088cac9	France	FR	FRA	bb167c19-ccbc-4922-bd58-3b310c76bf16	EUR	\N	2026-01-05 19:24:24.709621	2026-01-05 19:24:24.709621
83f526e7-d940-439e-9541-d275ddf76580	Japan	JP	JPN	548725c2-1b9b-4d1f-ab66-69f1df9f5a6c	JPY	\N	2026-01-05 19:24:24.709621	2026-01-05 19:24:24.709621
175f1e63-3f5e-4cf1-a6b9-1a198b0cba9f	Australia	AU	AUS	20c2771d-c0e6-40e8-8847-9b32cd5fe7e1	AUD	\N	2026-01-05 19:24:24.709621	2026-01-05 19:24:24.709621
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: datadog_user
--

COPY public.regions (id, name, code, country_id, created_at, updated_at) FROM stdin;
88a881ab-ff63-416b-a0e5-d678aaa7edcd	England	ENG	a9d77143-c453-42d8-9a65-f8877c542e92	2026-01-05 20:28:06.419514	2026-01-05 20:28:06.419517
abe6f744-16e7-4dcd-82b1-4a036cd7fc31	Scotland	SCT	a9d77143-c453-42d8-9a65-f8877c542e92	2026-01-05 20:28:06.426144	2026-01-05 20:28:06.426147
cc690ac1-8b63-45b3-8b99-377339c6e8a7	Wales	WLS	a9d77143-c453-42d8-9a65-f8877c542e92	2026-01-05 20:28:06.429026	2026-01-05 20:28:06.429029
027b82ae-d064-4cb5-a2f0-05d103255704	Northern Ireland	NIR	a9d77143-c453-42d8-9a65-f8877c542e92	2026-01-05 20:28:06.43145	2026-01-05 20:28:06.431452
64638137-9769-426b-ac6a-2be8b42e1d38	Crown Dependencies	CRO	a9d77143-c453-42d8-9a65-f8877c542e92	2026-01-05 20:28:06.433727	2026-01-05 20:28:06.433729
752ecf4a-83ea-4636-8e98-de630b29be86	Overseas Territories	OVS	a9d77143-c453-42d8-9a65-f8877c542e92	2026-01-05 20:28:06.437839	2026-01-05 20:28:06.437842
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: datadog_user
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: sub_areas; Type: TABLE DATA; Schema: public; Owner: datadog_user
--

COPY public.sub_areas (id, name, city_id, type, latitude, longitude, location, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: datadog_user
--

COPY tiger.geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: datadog_user
--

COPY tiger.pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: datadog_user
--

COPY tiger.pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: datadog_user
--

COPY tiger.pagc_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: datadog_user
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: datadog_user
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Name: topology_id_seq; Type: SEQUENCE SET; Schema: topology; Owner: datadog_user
--

SELECT pg_catalog.setval('topology.topology_id_seq', 1, false);


--
-- Name: business_categories business_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: datadog_user
--

ALTER TABLE ONLY public.business_categories
    ADD CONSTRAINT business_categories_pkey PRIMARY KEY (id);


--
-- Name: business_sources business_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: datadog_user
--

ALTER TABLE ONLY public.business_sources
    ADD CONSTRAINT business_sources_pkey PRIMARY KEY (id);


--
-- Name: businesses businesses_pkey; Type: CONSTRAINT; Schema: public; Owner: datadog_user
--

ALTER TABLE ONLY public.businesses
    ADD CONSTRAINT businesses_pkey PRIMARY KEY (id);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: datadog_user
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: continents continents_pkey; Type: CONSTRAINT; Schema: public; Owner: datadog_user
--

ALTER TABLE ONLY public.continents
    ADD CONSTRAINT continents_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: datadog_user
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: datadog_user
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: sub_areas sub_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: datadog_user
--

ALTER TABLE ONLY public.sub_areas
    ADD CONSTRAINT sub_areas_pkey PRIMARY KEY (id);


--
-- Name: idx_business_city_name; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX idx_business_city_name ON public.businesses USING btree (city_id, name);


--
-- Name: idx_business_fingerprint; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX idx_business_fingerprint ON public.businesses USING btree (fingerprint_hash);


--
-- Name: idx_cities_geom; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX idx_cities_geom ON public.cities USING gist (geom);


--
-- Name: idx_region_country_name; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX idx_region_country_name ON public.regions USING btree (country_id, name);


--
-- Name: idx_sub_areas_location; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX idx_sub_areas_location ON public.sub_areas USING gist (location);


--
-- Name: idx_subarea_city_name; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX idx_subarea_city_name ON public.sub_areas USING btree (city_id, name);


--
-- Name: ix_business_categories_name; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE UNIQUE INDEX ix_business_categories_name ON public.business_categories USING btree (name);


--
-- Name: ix_business_sources_business_id; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_business_sources_business_id ON public.business_sources USING btree (business_id);


--
-- Name: ix_business_sources_source_name; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_business_sources_source_name ON public.business_sources USING btree (source_name);


--
-- Name: ix_businesses_category; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_businesses_category ON public.businesses USING btree (category);


--
-- Name: ix_businesses_city_id; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_businesses_city_id ON public.businesses USING btree (city_id);


--
-- Name: ix_businesses_fingerprint_hash; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_businesses_fingerprint_hash ON public.businesses USING btree (fingerprint_hash);


--
-- Name: ix_businesses_name; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_businesses_name ON public.businesses USING btree (name);


--
-- Name: ix_businesses_phone; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_businesses_phone ON public.businesses USING btree (phone);


--
-- Name: ix_cities_country_id; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_cities_country_id ON public.cities USING btree (country_id);


--
-- Name: ix_cities_name; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_cities_name ON public.cities USING btree (name);


--
-- Name: ix_continents_code; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE UNIQUE INDEX ix_continents_code ON public.continents USING btree (code);


--
-- Name: ix_continents_name; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE UNIQUE INDEX ix_continents_name ON public.continents USING btree (name);


--
-- Name: ix_countries_continent_id; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_countries_continent_id ON public.countries USING btree (continent_id);


--
-- Name: ix_countries_iso3_code; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE UNIQUE INDEX ix_countries_iso3_code ON public.countries USING btree (iso3_code);


--
-- Name: ix_countries_iso_code; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE UNIQUE INDEX ix_countries_iso_code ON public.countries USING btree (iso_code);


--
-- Name: ix_countries_name; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_countries_name ON public.countries USING btree (name);


--
-- Name: ix_regions_code; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_regions_code ON public.regions USING btree (code);


--
-- Name: ix_regions_country_id; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_regions_country_id ON public.regions USING btree (country_id);


--
-- Name: ix_regions_id; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_regions_id ON public.regions USING btree (id);


--
-- Name: ix_regions_name; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_regions_name ON public.regions USING btree (name);


--
-- Name: ix_sub_areas_city_id; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_sub_areas_city_id ON public.sub_areas USING btree (city_id);


--
-- Name: ix_sub_areas_id; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_sub_areas_id ON public.sub_areas USING btree (id);


--
-- Name: ix_sub_areas_name; Type: INDEX; Schema: public; Owner: datadog_user
--

CREATE INDEX ix_sub_areas_name ON public.sub_areas USING btree (name);


--
-- Name: business_categories business_categories_parent_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: datadog_user
--

ALTER TABLE ONLY public.business_categories
    ADD CONSTRAINT business_categories_parent_category_id_fkey FOREIGN KEY (parent_category_id) REFERENCES public.business_categories(id);


--
-- Name: business_sources business_sources_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: datadog_user
--

ALTER TABLE ONLY public.business_sources
    ADD CONSTRAINT business_sources_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id);


--
-- Name: businesses businesses_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: datadog_user
--

ALTER TABLE ONLY public.businesses
    ADD CONSTRAINT businesses_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: cities cities_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: datadog_user
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: cities cities_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: datadog_user
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- Name: countries countries_continent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: datadog_user
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_continent_id_fkey FOREIGN KEY (continent_id) REFERENCES public.continents(id);


--
-- Name: regions regions_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: datadog_user
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id) ON DELETE CASCADE;


--
-- Name: sub_areas sub_areas_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: datadog_user
--

ALTER TABLE ONLY public.sub_areas
    ADD CONSTRAINT sub_areas_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

