--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2 (Debian 17.2-1.pgdg120+1)
-- Dumped by pg_dump version 17.2

-- Started on 2024-12-16 10:49:00 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 892 (class 1247 OID 16390)
-- Name: author_type_enum; Type: TYPE; Schema: public; Owner: janta
--

CREATE TYPE public.author_type_enum AS ENUM (
    'page',
    'user'
);


ALTER TYPE public.author_type_enum OWNER TO janta;

--
-- TOC entry 895 (class 1247 OID 16396)
-- Name: friend_request_status; Type: TYPE; Schema: public; Owner: janta
--

CREATE TYPE public.friend_request_status AS ENUM (
    'pending',
    'accepted',
    'rejected'
);


ALTER TYPE public.friend_request_status OWNER TO janta;

--
-- TOC entry 898 (class 1247 OID 16404)
-- Name: reaction_type; Type: TYPE; Schema: public; Owner: janta
--

CREATE TYPE public.reaction_type AS ENUM (
    'angry',
    'haha',
    'like',
    'love',
    'sad',
    'wow'
);


ALTER TYPE public.reaction_type OWNER TO janta;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 239 (class 1259 OID 16583)
-- Name: addresses; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.addresses (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    street_name character varying(255) NOT NULL,
    building character varying(20),
    gate character varying(20),
    floor character varying(20),
    apartment character varying(20)
);


ALTER TABLE public.addresses OWNER TO janta;

--
-- TOC entry 238 (class 1259 OID 16582)
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.addresses_id_seq OWNER TO janta;

--
-- TOC entry 3682 (class 0 OID 0)
-- Dependencies: 238
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- TOC entry 261 (class 1259 OID 16787)
-- Name: advertisements; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.advertisements (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    content character varying(16000) NOT NULL,
    ad_link character varying(255) NOT NULL,
    page_id bigint
);


ALTER TABLE public.advertisements OWNER TO janta;

--
-- TOC entry 260 (class 1259 OID 16786)
-- Name: advertisements_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.advertisements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.advertisements_id_seq OWNER TO janta;

--
-- TOC entry 3683 (class 0 OID 0)
-- Dependencies: 260
-- Name: advertisements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.advertisements_id_seq OWNED BY public.advertisements.id;


--
-- TOC entry 218 (class 1259 OID 16418)
-- Name: authors; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.authors (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    author_type public.author_type_enum NOT NULL
);


ALTER TABLE public.authors OWNER TO janta;

--
-- TOC entry 217 (class 1259 OID 16417)
-- Name: authors_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.authors_id_seq OWNER TO janta;

--
-- TOC entry 3684 (class 0 OID 0)
-- Dependencies: 217
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.authors_id_seq OWNED BY public.authors.id;


--
-- TOC entry 235 (class 1259 OID 16557)
-- Name: comment_hashtags; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.comment_hashtags (
    comment_id bigint NOT NULL,
    hashtag_id bigint NOT NULL
);


ALTER TABLE public.comment_hashtags OWNER TO janta;

--
-- TOC entry 232 (class 1259 OID 16532)
-- Name: comments; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.comments (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    author_id bigint,
    content text NOT NULL
);


ALTER TABLE public.comments OWNER TO janta;

--
-- TOC entry 231 (class 1259 OID 16531)
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comments_id_seq OWNER TO janta;

--
-- TOC entry 3685 (class 0 OID 0)
-- Dependencies: 231
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- TOC entry 254 (class 1259 OID 16729)
-- Name: conversation_members; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.conversation_members (
    conversation_id bigint NOT NULL,
    author_id bigint NOT NULL
);


ALTER TABLE public.conversation_members OWNER TO janta;

--
-- TOC entry 253 (class 1259 OID 16715)
-- Name: conversations; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.conversations (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    title text NOT NULL,
    icon_url text,
    author_id bigint NOT NULL
);


ALTER TABLE public.conversations OWNER TO janta;

--
-- TOC entry 252 (class 1259 OID 16714)
-- Name: conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.conversations_id_seq OWNER TO janta;

--
-- TOC entry 3686 (class 0 OID 0)
-- Dependencies: 252
-- Name: conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.conversations_id_seq OWNED BY public.conversations.id;


--
-- TOC entry 247 (class 1259 OID 16669)
-- Name: event_members; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.event_members (
    event_id bigint NOT NULL,
    author_id bigint NOT NULL
);


ALTER TABLE public.event_members OWNER TO janta;

--
-- TOC entry 246 (class 1259 OID 16650)
-- Name: events; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    author_id bigint NOT NULL,
    name character varying(300) NOT NULL,
    description character varying(1024),
    start_date date NOT NULL,
    end_date date NOT NULL,
    location_id bigint
);


ALTER TABLE public.events OWNER TO janta;

--
-- TOC entry 245 (class 1259 OID 16649)
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.events_id_seq OWNER TO janta;

--
-- TOC entry 3687 (class 0 OID 0)
-- Dependencies: 245
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- TOC entry 228 (class 1259 OID 16498)
-- Name: external_author_links; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.external_author_links (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    author_id bigint NOT NULL,
    platform text NOT NULL,
    link text NOT NULL
);


ALTER TABLE public.external_author_links OWNER TO janta;

--
-- TOC entry 227 (class 1259 OID 16497)
-- Name: external_author_links_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.external_author_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.external_author_links_id_seq OWNER TO janta;

--
-- TOC entry 3688 (class 0 OID 0)
-- Dependencies: 227
-- Name: external_author_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.external_author_links_id_seq OWNED BY public.external_author_links.id;


--
-- TOC entry 230 (class 1259 OID 16513)
-- Name: friend_requests; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.friend_requests (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    sender_id bigint NOT NULL,
    receiver_id bigint NOT NULL,
    status public.friend_request_status DEFAULT 'pending'::public.friend_request_status NOT NULL
);


ALTER TABLE public.friend_requests OWNER TO janta;

--
-- TOC entry 229 (class 1259 OID 16512)
-- Name: friend_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.friend_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.friend_requests_id_seq OWNER TO janta;

--
-- TOC entry 3689 (class 0 OID 0)
-- Dependencies: 229
-- Name: friend_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.friend_requests_id_seq OWNED BY public.friend_requests.id;


--
-- TOC entry 237 (class 1259 OID 16573)
-- Name: geolocations; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.geolocations (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL
);


ALTER TABLE public.geolocations OWNER TO janta;

--
-- TOC entry 236 (class 1259 OID 16572)
-- Name: geolocations_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.geolocations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.geolocations_id_seq OWNER TO janta;

--
-- TOC entry 3690 (class 0 OID 0)
-- Dependencies: 236
-- Name: geolocations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.geolocations_id_seq OWNED BY public.geolocations.id;


--
-- TOC entry 221 (class 1259 OID 16433)
-- Name: group_members; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.group_members (
    group_id bigint NOT NULL,
    author_id bigint NOT NULL
);


ALTER TABLE public.group_members OWNER TO janta;

--
-- TOC entry 220 (class 1259 OID 16426)
-- Name: groups; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.groups (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    name character varying(100) NOT NULL
);


ALTER TABLE public.groups OWNER TO janta;

--
-- TOC entry 219 (class 1259 OID 16425)
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.groups_id_seq OWNER TO janta;

--
-- TOC entry 3691 (class 0 OID 0)
-- Dependencies: 219
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- TOC entry 234 (class 1259 OID 16547)
-- Name: hashtags; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.hashtags (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    tag_name character varying(200) NOT NULL
);


ALTER TABLE public.hashtags OWNER TO janta;

--
-- TOC entry 233 (class 1259 OID 16546)
-- Name: hashtags_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.hashtags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hashtags_id_seq OWNER TO janta;

--
-- TOC entry 3692 (class 0 OID 0)
-- Dependencies: 233
-- Name: hashtags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.hashtags_id_seq OWNED BY public.hashtags.id;


--
-- TOC entry 241 (class 1259 OID 16591)
-- Name: locations; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.locations (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    city character varying(100),
    country character varying(100),
    postal_code character varying(20),
    geolocation_id bigint,
    address_id bigint
);


ALTER TABLE public.locations OWNER TO janta;

--
-- TOC entry 240 (class 1259 OID 16590)
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.locations_id_seq OWNER TO janta;

--
-- TOC entry 3693 (class 0 OID 0)
-- Dependencies: 240
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- TOC entry 251 (class 1259 OID 16700)
-- Name: messages; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.messages (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    content text NOT NULL,
    author_id bigint NOT NULL,
    conversation_id bigint NOT NULL
);


ALTER TABLE public.messages OWNER TO janta;

--
-- TOC entry 250 (class 1259 OID 16699)
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.messages_id_seq OWNER TO janta;

--
-- TOC entry 3694 (class 0 OID 0)
-- Dependencies: 250
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- TOC entry 259 (class 1259 OID 16771)
-- Name: page_tags; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.page_tags (
    tag_id bigint NOT NULL,
    page_id bigint NOT NULL
);


ALTER TABLE public.page_tags OWNER TO janta;

--
-- TOC entry 256 (class 1259 OID 16745)
-- Name: pages; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.pages (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    author_id bigint,
    title character varying(100) NOT NULL,
    picture_url character varying(255),
    background_url character varying(255),
    views bigint DEFAULT 0,
    likes bigint DEFAULT 0
);


ALTER TABLE public.pages OWNER TO janta;

--
-- TOC entry 255 (class 1259 OID 16744)
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pages_id_seq OWNER TO janta;

--
-- TOC entry 3695 (class 0 OID 0)
-- Dependencies: 255
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- TOC entry 244 (class 1259 OID 16634)
-- Name: post_hashtags; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.post_hashtags (
    post_id bigint NOT NULL,
    hashtag_id bigint NOT NULL
);


ALTER TABLE public.post_hashtags OWNER TO janta;

--
-- TOC entry 243 (class 1259 OID 16609)
-- Name: posts; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.posts (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    author_id bigint NOT NULL,
    title text,
    content text NOT NULL,
    is_public boolean DEFAULT true,
    location_id bigint,
    group_id bigint
);


ALTER TABLE public.posts OWNER TO janta;

--
-- TOC entry 242 (class 1259 OID 16608)
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.posts_id_seq OWNER TO janta;

--
-- TOC entry 3696 (class 0 OID 0)
-- Dependencies: 242
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- TOC entry 263 (class 1259 OID 16802)
-- Name: reactions; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.reactions (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    author_id bigint NOT NULL,
    post_id bigint NOT NULL,
    reaction public.reaction_type DEFAULT 'like'::public.reaction_type
);


ALTER TABLE public.reactions OWNER TO janta;

--
-- TOC entry 262 (class 1259 OID 16801)
-- Name: reactions_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.reactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reactions_id_seq OWNER TO janta;

--
-- TOC entry 3697 (class 0 OID 0)
-- Dependencies: 262
-- Name: reactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.reactions_id_seq OWNED BY public.reactions.id;


--
-- TOC entry 249 (class 1259 OID 16685)
-- Name: reels; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.reels (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    author_id bigint NOT NULL,
    content text NOT NULL
);


ALTER TABLE public.reels OWNER TO janta;

--
-- TOC entry 248 (class 1259 OID 16684)
-- Name: reels_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.reels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reels_id_seq OWNER TO janta;

--
-- TOC entry 3698 (class 0 OID 0)
-- Dependencies: 248
-- Name: reels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.reels_id_seq OWNED BY public.reels.id;


--
-- TOC entry 258 (class 1259 OID 16762)
-- Name: tags; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    tag_name character varying(100) NOT NULL
);


ALTER TABLE public.tags OWNER TO janta;

--
-- TOC entry 257 (class 1259 OID 16761)
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tags_id_seq OWNER TO janta;

--
-- TOC entry 3699 (class 0 OID 0)
-- Dependencies: 257
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- TOC entry 226 (class 1259 OID 16482)
-- Name: user_friends; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.user_friends (
    user_author_id bigint NOT NULL,
    friend_author_id bigint NOT NULL
);


ALTER TABLE public.user_friends OWNER TO janta;

--
-- TOC entry 223 (class 1259 OID 16449)
-- Name: user_privileges; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.user_privileges (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    privilege_name character varying(40) NOT NULL
);


ALTER TABLE public.user_privileges OWNER TO janta;

--
-- TOC entry 222 (class 1259 OID 16448)
-- Name: user_privileges_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.user_privileges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_privileges_id_seq OWNER TO janta;

--
-- TOC entry 3700 (class 0 OID 0)
-- Dependencies: 222
-- Name: user_privileges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.user_privileges_id_seq OWNED BY public.user_privileges.id;


--
-- TOC entry 225 (class 1259 OID 16459)
-- Name: users; Type: TABLE; Schema: public; Owner: janta
--

CREATE TABLE public.users (
    author_id bigint NOT NULL,
    first_name character varying(50) NOT NULL,
    second_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password text NOT NULL,
    picture_url character varying(255),
    background_url character varying(255),
    birthday date,
    is_verified boolean DEFAULT false,
    bio character varying(512) DEFAULT 'Edit bio'::character varying,
    user_privilege_id bigint NOT NULL,
    CONSTRAINT chk_users_bio CHECK (((bio)::text <> ''::text))
);


ALTER TABLE public.users OWNER TO janta;

--
-- TOC entry 224 (class 1259 OID 16458)
-- Name: users_author_id_seq; Type: SEQUENCE; Schema: public; Owner: janta
--

CREATE SEQUENCE public.users_author_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_author_id_seq OWNER TO janta;

--
-- TOC entry 3701 (class 0 OID 0)
-- Dependencies: 224
-- Name: users_author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: janta
--

ALTER SEQUENCE public.users_author_id_seq OWNED BY public.users.author_id;


--
-- TOC entry 3354 (class 2604 OID 16586)
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- TOC entry 3366 (class 2604 OID 16790)
-- Name: advertisements id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.advertisements ALTER COLUMN id SET DEFAULT nextval('public.advertisements_id_seq'::regclass);


--
-- TOC entry 3342 (class 2604 OID 16421)
-- Name: authors id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.authors ALTER COLUMN id SET DEFAULT nextval('public.authors_id_seq'::regclass);


--
-- TOC entry 3351 (class 2604 OID 16535)
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- TOC entry 3361 (class 2604 OID 16718)
-- Name: conversations id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.conversations ALTER COLUMN id SET DEFAULT nextval('public.conversations_id_seq'::regclass);


--
-- TOC entry 3358 (class 2604 OID 16653)
-- Name: events id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- TOC entry 3348 (class 2604 OID 16501)
-- Name: external_author_links id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.external_author_links ALTER COLUMN id SET DEFAULT nextval('public.external_author_links_id_seq'::regclass);


--
-- TOC entry 3349 (class 2604 OID 16516)
-- Name: friend_requests id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.friend_requests ALTER COLUMN id SET DEFAULT nextval('public.friend_requests_id_seq'::regclass);


--
-- TOC entry 3353 (class 2604 OID 16576)
-- Name: geolocations id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.geolocations ALTER COLUMN id SET DEFAULT nextval('public.geolocations_id_seq'::regclass);


--
-- TOC entry 3343 (class 2604 OID 16429)
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- TOC entry 3352 (class 2604 OID 16550)
-- Name: hashtags id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.hashtags ALTER COLUMN id SET DEFAULT nextval('public.hashtags_id_seq'::regclass);


--
-- TOC entry 3355 (class 2604 OID 16594)
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- TOC entry 3360 (class 2604 OID 16703)
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- TOC entry 3362 (class 2604 OID 16748)
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- TOC entry 3356 (class 2604 OID 16612)
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- TOC entry 3367 (class 2604 OID 16805)
-- Name: reactions id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.reactions ALTER COLUMN id SET DEFAULT nextval('public.reactions_id_seq'::regclass);


--
-- TOC entry 3359 (class 2604 OID 16688)
-- Name: reels id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.reels ALTER COLUMN id SET DEFAULT nextval('public.reels_id_seq'::regclass);


--
-- TOC entry 3365 (class 2604 OID 16765)
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- TOC entry 3344 (class 2604 OID 16452)
-- Name: user_privileges id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.user_privileges ALTER COLUMN id SET DEFAULT nextval('public.user_privileges_id_seq'::regclass);


--
-- TOC entry 3345 (class 2604 OID 16462)
-- Name: users author_id; Type: DEFAULT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.users ALTER COLUMN author_id SET DEFAULT nextval('public.users_author_id_seq'::regclass);


--
-- TOC entry 3652 (class 0 OID 16583)
-- Dependencies: 239
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.addresses (id, created_at, updated_at, deleted_at, street_name, building, gate, floor, apartment) FROM stdin;
\.


--
-- TOC entry 3674 (class 0 OID 16787)
-- Dependencies: 261
-- Data for Name: advertisements; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.advertisements (id, created_at, updated_at, deleted_at, content, ad_link, page_id) FROM stdin;
\.


--
-- TOC entry 3631 (class 0 OID 16418)
-- Dependencies: 218
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.authors (id, created_at, updated_at, deleted_at, author_type) FROM stdin;
\.


--
-- TOC entry 3648 (class 0 OID 16557)
-- Dependencies: 235
-- Data for Name: comment_hashtags; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.comment_hashtags (comment_id, hashtag_id) FROM stdin;
\.


--
-- TOC entry 3645 (class 0 OID 16532)
-- Dependencies: 232
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.comments (id, created_at, updated_at, deleted_at, author_id, content) FROM stdin;
\.


--
-- TOC entry 3667 (class 0 OID 16729)
-- Dependencies: 254
-- Data for Name: conversation_members; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.conversation_members (conversation_id, author_id) FROM stdin;
\.


--
-- TOC entry 3666 (class 0 OID 16715)
-- Dependencies: 253
-- Data for Name: conversations; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.conversations (id, created_at, updated_at, deleted_at, title, icon_url, author_id) FROM stdin;
\.


--
-- TOC entry 3660 (class 0 OID 16669)
-- Dependencies: 247
-- Data for Name: event_members; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.event_members (event_id, author_id) FROM stdin;
\.


--
-- TOC entry 3659 (class 0 OID 16650)
-- Dependencies: 246
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.events (id, created_at, updated_at, deleted_at, author_id, name, description, start_date, end_date, location_id) FROM stdin;
\.


--
-- TOC entry 3641 (class 0 OID 16498)
-- Dependencies: 228
-- Data for Name: external_author_links; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.external_author_links (id, created_at, updated_at, deleted_at, author_id, platform, link) FROM stdin;
\.


--
-- TOC entry 3643 (class 0 OID 16513)
-- Dependencies: 230
-- Data for Name: friend_requests; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.friend_requests (id, created_at, updated_at, deleted_at, sender_id, receiver_id, status) FROM stdin;
\.


--
-- TOC entry 3650 (class 0 OID 16573)
-- Dependencies: 237
-- Data for Name: geolocations; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.geolocations (id, created_at, updated_at, deleted_at, latitude, longitude) FROM stdin;
\.


--
-- TOC entry 3634 (class 0 OID 16433)
-- Dependencies: 221
-- Data for Name: group_members; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.group_members (group_id, author_id) FROM stdin;
\.


--
-- TOC entry 3633 (class 0 OID 16426)
-- Dependencies: 220
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.groups (id, created_at, updated_at, deleted_at, name) FROM stdin;
\.


--
-- TOC entry 3647 (class 0 OID 16547)
-- Dependencies: 234
-- Data for Name: hashtags; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.hashtags (id, created_at, updated_at, deleted_at, tag_name) FROM stdin;
\.


--
-- TOC entry 3654 (class 0 OID 16591)
-- Dependencies: 241
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.locations (id, created_at, updated_at, deleted_at, city, country, postal_code, geolocation_id, address_id) FROM stdin;
\.


--
-- TOC entry 3664 (class 0 OID 16700)
-- Dependencies: 251
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.messages (id, created_at, updated_at, deleted_at, content, author_id, conversation_id) FROM stdin;
\.


--
-- TOC entry 3672 (class 0 OID 16771)
-- Dependencies: 259
-- Data for Name: page_tags; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.page_tags (tag_id, page_id) FROM stdin;
\.


--
-- TOC entry 3669 (class 0 OID 16745)
-- Dependencies: 256
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.pages (id, created_at, updated_at, deleted_at, author_id, title, picture_url, background_url, views, likes) FROM stdin;
\.


--
-- TOC entry 3657 (class 0 OID 16634)
-- Dependencies: 244
-- Data for Name: post_hashtags; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.post_hashtags (post_id, hashtag_id) FROM stdin;
\.


--
-- TOC entry 3656 (class 0 OID 16609)
-- Dependencies: 243
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.posts (id, created_at, updated_at, deleted_at, author_id, title, content, is_public, location_id, group_id) FROM stdin;
\.


--
-- TOC entry 3676 (class 0 OID 16802)
-- Dependencies: 263
-- Data for Name: reactions; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.reactions (id, created_at, updated_at, deleted_at, author_id, post_id, reaction) FROM stdin;
\.


--
-- TOC entry 3662 (class 0 OID 16685)
-- Dependencies: 249
-- Data for Name: reels; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.reels (id, created_at, updated_at, deleted_at, author_id, content) FROM stdin;
\.


--
-- TOC entry 3671 (class 0 OID 16762)
-- Dependencies: 258
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.tags (id, created_at, updated_at, deleted_at, tag_name) FROM stdin;
\.


--
-- TOC entry 3639 (class 0 OID 16482)
-- Dependencies: 226
-- Data for Name: user_friends; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.user_friends (user_author_id, friend_author_id) FROM stdin;
\.


--
-- TOC entry 3636 (class 0 OID 16449)
-- Dependencies: 223
-- Data for Name: user_privileges; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.user_privileges (id, created_at, updated_at, deleted_at, privilege_name) FROM stdin;
\.


--
-- TOC entry 3638 (class 0 OID 16459)
-- Dependencies: 225
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: janta
--

COPY public.users (author_id, first_name, second_name, email, password, picture_url, background_url, birthday, is_verified, bio, user_privilege_id) FROM stdin;
\.


--
-- TOC entry 3702 (class 0 OID 0)
-- Dependencies: 238
-- Name: addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.addresses_id_seq', 1, false);


--
-- TOC entry 3703 (class 0 OID 0)
-- Dependencies: 260
-- Name: advertisements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.advertisements_id_seq', 1, false);


--
-- TOC entry 3704 (class 0 OID 0)
-- Dependencies: 217
-- Name: authors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.authors_id_seq', 1, false);


--
-- TOC entry 3705 (class 0 OID 0)
-- Dependencies: 231
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.comments_id_seq', 1, false);


--
-- TOC entry 3706 (class 0 OID 0)
-- Dependencies: 252
-- Name: conversations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.conversations_id_seq', 1, false);


--
-- TOC entry 3707 (class 0 OID 0)
-- Dependencies: 245
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.events_id_seq', 1, false);


--
-- TOC entry 3708 (class 0 OID 0)
-- Dependencies: 227
-- Name: external_author_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.external_author_links_id_seq', 1, false);


--
-- TOC entry 3709 (class 0 OID 0)
-- Dependencies: 229
-- Name: friend_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.friend_requests_id_seq', 1, false);


--
-- TOC entry 3710 (class 0 OID 0)
-- Dependencies: 236
-- Name: geolocations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.geolocations_id_seq', 1, false);


--
-- TOC entry 3711 (class 0 OID 0)
-- Dependencies: 219
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.groups_id_seq', 1, false);


--
-- TOC entry 3712 (class 0 OID 0)
-- Dependencies: 233
-- Name: hashtags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.hashtags_id_seq', 1, false);


--
-- TOC entry 3713 (class 0 OID 0)
-- Dependencies: 240
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.locations_id_seq', 1, false);


--
-- TOC entry 3714 (class 0 OID 0)
-- Dependencies: 250
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.messages_id_seq', 1, false);


--
-- TOC entry 3715 (class 0 OID 0)
-- Dependencies: 255
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.pages_id_seq', 1, false);


--
-- TOC entry 3716 (class 0 OID 0)
-- Dependencies: 242
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.posts_id_seq', 1, false);


--
-- TOC entry 3717 (class 0 OID 0)
-- Dependencies: 262
-- Name: reactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.reactions_id_seq', 1, false);


--
-- TOC entry 3718 (class 0 OID 0)
-- Dependencies: 248
-- Name: reels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.reels_id_seq', 1, false);


--
-- TOC entry 3719 (class 0 OID 0)
-- Dependencies: 257
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.tags_id_seq', 1, false);


--
-- TOC entry 3720 (class 0 OID 0)
-- Dependencies: 222
-- Name: user_privileges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.user_privileges_id_seq', 1, false);


--
-- TOC entry 3721 (class 0 OID 0)
-- Dependencies: 224
-- Name: users_author_id_seq; Type: SEQUENCE SET; Schema: public; Owner: janta
--

SELECT pg_catalog.setval('public.users_author_id_seq', 1, false);


--
-- TOC entry 3410 (class 2606 OID 16588)
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- TOC entry 3447 (class 2606 OID 16794)
-- Name: advertisements advertisements_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.advertisements
    ADD CONSTRAINT advertisements_pkey PRIMARY KEY (id);


--
-- TOC entry 3371 (class 2606 OID 16423)
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- TOC entry 3405 (class 2606 OID 16561)
-- Name: comment_hashtags comment_hashtags_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.comment_hashtags
    ADD CONSTRAINT comment_hashtags_pkey PRIMARY KEY (comment_id, hashtag_id);


--
-- TOC entry 3396 (class 2606 OID 16539)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- TOC entry 3435 (class 2606 OID 16733)
-- Name: conversation_members conversation_members_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.conversation_members
    ADD CONSTRAINT conversation_members_pkey PRIMARY KEY (conversation_id, author_id);


--
-- TOC entry 3432 (class 2606 OID 16722)
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);


--
-- TOC entry 3424 (class 2606 OID 16673)
-- Name: event_members event_members_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.event_members
    ADD CONSTRAINT event_members_pkey PRIMARY KEY (event_id, author_id);


--
-- TOC entry 3421 (class 2606 OID 16657)
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- TOC entry 3390 (class 2606 OID 16505)
-- Name: external_author_links external_author_links_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.external_author_links
    ADD CONSTRAINT external_author_links_pkey PRIMARY KEY (id);


--
-- TOC entry 3393 (class 2606 OID 16519)
-- Name: friend_requests friend_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.friend_requests
    ADD CONSTRAINT friend_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 3407 (class 2606 OID 16580)
-- Name: geolocations geolocations_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.geolocations
    ADD CONSTRAINT geolocations_pkey PRIMARY KEY (id);


--
-- TOC entry 3377 (class 2606 OID 16437)
-- Name: group_members group_members_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_pkey PRIMARY KEY (group_id, author_id);


--
-- TOC entry 3374 (class 2606 OID 16431)
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- TOC entry 3399 (class 2606 OID 16552)
-- Name: hashtags hashtags_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.hashtags
    ADD CONSTRAINT hashtags_pkey PRIMARY KEY (id);


--
-- TOC entry 3414 (class 2606 OID 16596)
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- TOC entry 3430 (class 2606 OID 16707)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- TOC entry 3445 (class 2606 OID 16775)
-- Name: page_tags page_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.page_tags
    ADD CONSTRAINT page_tags_pkey PRIMARY KEY (tag_id, page_id);


--
-- TOC entry 3438 (class 2606 OID 16754)
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- TOC entry 3419 (class 2606 OID 16638)
-- Name: post_hashtags post_hashtags_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.post_hashtags
    ADD CONSTRAINT post_hashtags_pkey PRIMARY KEY (post_id, hashtag_id);


--
-- TOC entry 3417 (class 2606 OID 16617)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- TOC entry 3451 (class 2606 OID 16808)
-- Name: reactions reactions_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.reactions
    ADD CONSTRAINT reactions_pkey PRIMARY KEY (id, author_id, post_id);


--
-- TOC entry 3427 (class 2606 OID 16692)
-- Name: reels reels_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.reels
    ADD CONSTRAINT reels_pkey PRIMARY KEY (id);


--
-- TOC entry 3441 (class 2606 OID 16767)
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- TOC entry 3403 (class 2606 OID 16554)
-- Name: hashtags uni_hashtags_tag_name; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.hashtags
    ADD CONSTRAINT uni_hashtags_tag_name UNIQUE (tag_name);


--
-- TOC entry 3443 (class 2606 OID 16769)
-- Name: tags uni_tags_tag_name; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT uni_tags_tag_name UNIQUE (tag_name);


--
-- TOC entry 3380 (class 2606 OID 16456)
-- Name: user_privileges uni_user_privileges_privilege_name; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.user_privileges
    ADD CONSTRAINT uni_user_privileges_privilege_name UNIQUE (privilege_name);


--
-- TOC entry 3384 (class 2606 OID 16471)
-- Name: users uni_users_email; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uni_users_email UNIQUE (email);


--
-- TOC entry 3388 (class 2606 OID 16486)
-- Name: user_friends user_friends_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.user_friends
    ADD CONSTRAINT user_friends_pkey PRIMARY KEY (user_author_id, friend_author_id);


--
-- TOC entry 3382 (class 2606 OID 16454)
-- Name: user_privileges user_privileges_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.user_privileges
    ADD CONSTRAINT user_privileges_pkey PRIMARY KEY (id);


--
-- TOC entry 3386 (class 2606 OID 16469)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (author_id);


--
-- TOC entry 3411 (class 1259 OID 16589)
-- Name: idx_addresses_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_addresses_deleted_at ON public.addresses USING btree (deleted_at);


--
-- TOC entry 3448 (class 1259 OID 16800)
-- Name: idx_advertisements_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_advertisements_deleted_at ON public.advertisements USING btree (deleted_at);


--
-- TOC entry 3372 (class 1259 OID 16424)
-- Name: idx_authors_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_authors_deleted_at ON public.authors USING btree (deleted_at);


--
-- TOC entry 3397 (class 1259 OID 16545)
-- Name: idx_comments_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_comments_deleted_at ON public.comments USING btree (deleted_at);


--
-- TOC entry 3433 (class 1259 OID 16728)
-- Name: idx_conversations_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_conversations_deleted_at ON public.conversations USING btree (deleted_at);


--
-- TOC entry 3422 (class 1259 OID 16668)
-- Name: idx_events_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_events_deleted_at ON public.events USING btree (deleted_at);


--
-- TOC entry 3391 (class 1259 OID 16511)
-- Name: idx_external_author_links_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_external_author_links_deleted_at ON public.external_author_links USING btree (deleted_at);


--
-- TOC entry 3394 (class 1259 OID 16530)
-- Name: idx_friend_requests_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_friend_requests_deleted_at ON public.friend_requests USING btree (deleted_at);


--
-- TOC entry 3408 (class 1259 OID 16581)
-- Name: idx_geolocations_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_geolocations_deleted_at ON public.geolocations USING btree (deleted_at);


--
-- TOC entry 3375 (class 1259 OID 16432)
-- Name: idx_groups_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_groups_deleted_at ON public.groups USING btree (deleted_at);


--
-- TOC entry 3400 (class 1259 OID 16555)
-- Name: idx_hashtags_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_hashtags_deleted_at ON public.hashtags USING btree (deleted_at);


--
-- TOC entry 3401 (class 1259 OID 16556)
-- Name: idx_hashtags_tag_name; Type: INDEX; Schema: public; Owner: janta
--

CREATE UNIQUE INDEX idx_hashtags_tag_name ON public.hashtags USING btree (tag_name);


--
-- TOC entry 3412 (class 1259 OID 16607)
-- Name: idx_locations_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_locations_deleted_at ON public.locations USING btree (deleted_at);


--
-- TOC entry 3428 (class 1259 OID 16713)
-- Name: idx_messages_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_messages_deleted_at ON public.messages USING btree (deleted_at);


--
-- TOC entry 3436 (class 1259 OID 16760)
-- Name: idx_pages_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_pages_deleted_at ON public.pages USING btree (deleted_at);


--
-- TOC entry 3415 (class 1259 OID 16633)
-- Name: idx_posts_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_posts_deleted_at ON public.posts USING btree (deleted_at);


--
-- TOC entry 3449 (class 1259 OID 16814)
-- Name: idx_reactions_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_reactions_deleted_at ON public.reactions USING btree (deleted_at);


--
-- TOC entry 3425 (class 1259 OID 16698)
-- Name: idx_reels_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_reels_deleted_at ON public.reels USING btree (deleted_at);


--
-- TOC entry 3439 (class 1259 OID 16770)
-- Name: idx_tags_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_tags_deleted_at ON public.tags USING btree (deleted_at);


--
-- TOC entry 3378 (class 1259 OID 16457)
-- Name: idx_user_privileges_deleted_at; Type: INDEX; Schema: public; Owner: janta
--

CREATE INDEX idx_user_privileges_deleted_at ON public.user_privileges USING btree (deleted_at);


--
-- TOC entry 3461 (class 2606 OID 16540)
-- Name: comments fk_authors_comments; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_authors_comments FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- TOC entry 3477 (class 2606 OID 16723)
-- Name: conversations fk_authors_conversations; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT fk_authors_conversations FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- TOC entry 3471 (class 2606 OID 16663)
-- Name: events fk_authors_events; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_authors_events FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- TOC entry 3458 (class 2606 OID 16506)
-- Name: external_author_links fk_authors_external_author_links; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.external_author_links
    ADD CONSTRAINT fk_authors_external_author_links FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- TOC entry 3476 (class 2606 OID 16708)
-- Name: messages fk_authors_messages; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT fk_authors_messages FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- TOC entry 3466 (class 2606 OID 16618)
-- Name: posts fk_authors_posts; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT fk_authors_posts FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- TOC entry 3484 (class 2606 OID 16809)
-- Name: reactions fk_authors_reactions; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.reactions
    ADD CONSTRAINT fk_authors_reactions FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- TOC entry 3475 (class 2606 OID 16693)
-- Name: reels fk_authors_reels; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.reels
    ADD CONSTRAINT fk_authors_reels FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- TOC entry 3462 (class 2606 OID 16562)
-- Name: comment_hashtags fk_comment_hashtags_comment; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.comment_hashtags
    ADD CONSTRAINT fk_comment_hashtags_comment FOREIGN KEY (comment_id) REFERENCES public.comments(id) ON DELETE CASCADE;


--
-- TOC entry 3463 (class 2606 OID 16567)
-- Name: comment_hashtags fk_comment_hashtags_hashtag; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.comment_hashtags
    ADD CONSTRAINT fk_comment_hashtags_hashtag FOREIGN KEY (hashtag_id) REFERENCES public.hashtags(id) ON DELETE CASCADE;


--
-- TOC entry 3478 (class 2606 OID 16739)
-- Name: conversation_members fk_conversation_members_author; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.conversation_members
    ADD CONSTRAINT fk_conversation_members_author FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- TOC entry 3479 (class 2606 OID 16734)
-- Name: conversation_members fk_conversation_members_conversation; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.conversation_members
    ADD CONSTRAINT fk_conversation_members_conversation FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE;


--
-- TOC entry 3473 (class 2606 OID 16679)
-- Name: event_members fk_event_members_author; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.event_members
    ADD CONSTRAINT fk_event_members_author FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- TOC entry 3474 (class 2606 OID 16674)
-- Name: event_members fk_event_members_event; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.event_members
    ADD CONSTRAINT fk_event_members_event FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- TOC entry 3472 (class 2606 OID 16658)
-- Name: events fk_events_location; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_events_location FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE CASCADE;


--
-- TOC entry 3459 (class 2606 OID 16520)
-- Name: friend_requests fk_friend_requests_sender; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.friend_requests
    ADD CONSTRAINT fk_friend_requests_sender FOREIGN KEY (sender_id) REFERENCES public.users(author_id) ON DELETE CASCADE;


--
-- TOC entry 3452 (class 2606 OID 16443)
-- Name: group_members fk_group_members_author; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT fk_group_members_author FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- TOC entry 3453 (class 2606 OID 16438)
-- Name: group_members fk_group_members_group; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT fk_group_members_group FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- TOC entry 3467 (class 2606 OID 16628)
-- Name: posts fk_groups_posts; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT fk_groups_posts FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- TOC entry 3464 (class 2606 OID 16597)
-- Name: locations fk_locations_address; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT fk_locations_address FOREIGN KEY (address_id) REFERENCES public.addresses(id) ON DELETE CASCADE;


--
-- TOC entry 3465 (class 2606 OID 16602)
-- Name: locations fk_locations_geolocation; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT fk_locations_geolocation FOREIGN KEY (geolocation_id) REFERENCES public.geolocations(id) ON DELETE CASCADE;


--
-- TOC entry 3481 (class 2606 OID 16781)
-- Name: page_tags fk_page_tags_page; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.page_tags
    ADD CONSTRAINT fk_page_tags_page FOREIGN KEY (page_id) REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- TOC entry 3482 (class 2606 OID 16776)
-- Name: page_tags fk_page_tags_tag; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.page_tags
    ADD CONSTRAINT fk_page_tags_tag FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON DELETE CASCADE;


--
-- TOC entry 3483 (class 2606 OID 16795)
-- Name: advertisements fk_pages_advertisements; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.advertisements
    ADD CONSTRAINT fk_pages_advertisements FOREIGN KEY (page_id) REFERENCES public.pages(id);


--
-- TOC entry 3480 (class 2606 OID 16755)
-- Name: pages fk_pages_author; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT fk_pages_author FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- TOC entry 3469 (class 2606 OID 16644)
-- Name: post_hashtags fk_post_hashtags_hashtag; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.post_hashtags
    ADD CONSTRAINT fk_post_hashtags_hashtag FOREIGN KEY (hashtag_id) REFERENCES public.hashtags(id) ON DELETE CASCADE;


--
-- TOC entry 3470 (class 2606 OID 16639)
-- Name: post_hashtags fk_post_hashtags_post; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.post_hashtags
    ADD CONSTRAINT fk_post_hashtags_post FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- TOC entry 3468 (class 2606 OID 16623)
-- Name: posts fk_posts_location; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT fk_posts_location FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE CASCADE;


--
-- TOC entry 3456 (class 2606 OID 16492)
-- Name: user_friends fk_user_friends_friends; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.user_friends
    ADD CONSTRAINT fk_user_friends_friends FOREIGN KEY (friend_author_id) REFERENCES public.users(author_id) ON DELETE CASCADE;


--
-- TOC entry 3457 (class 2606 OID 16487)
-- Name: user_friends fk_user_friends_user; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.user_friends
    ADD CONSTRAINT fk_user_friends_user FOREIGN KEY (user_author_id) REFERENCES public.users(author_id) ON DELETE CASCADE;


--
-- TOC entry 3454 (class 2606 OID 16477)
-- Name: users fk_user_privileges_users; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_user_privileges_users FOREIGN KEY (user_privilege_id) REFERENCES public.user_privileges(id) ON DELETE CASCADE;


--
-- TOC entry 3455 (class 2606 OID 16472)
-- Name: users fk_users_author; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_author FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- TOC entry 3460 (class 2606 OID 16525)
-- Name: friend_requests fk_users_friend_requests; Type: FK CONSTRAINT; Schema: public; Owner: janta
--

ALTER TABLE ONLY public.friend_requests
    ADD CONSTRAINT fk_users_friend_requests FOREIGN KEY (receiver_id) REFERENCES public.users(author_id) ON DELETE CASCADE;


-- Completed on 2024-12-16 10:49:00 UTC

--
-- PostgreSQL database dump complete
--

