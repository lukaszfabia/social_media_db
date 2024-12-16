--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0 (Debian 17.0-1.pgdg120+1)
-- Dumped by pg_dump version 17.0 (Debian 17.0-1.pgdg120+1)

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
-- Name: author_type_enum; Type: TYPE; Schema: public; Owner: lukasz
--

CREATE TYPE public.author_type_enum AS ENUM (
    'page',
    'user'
);


ALTER TYPE public.author_type_enum OWNER TO lukasz;

--
-- Name: friend_request_status; Type: TYPE; Schema: public; Owner: lukasz
--

CREATE TYPE public.friend_request_status AS ENUM (
    'pending',
    'accepted',
    'rejected'
);


ALTER TYPE public.friend_request_status OWNER TO lukasz;

--
-- Name: reaction_type; Type: TYPE; Schema: public; Owner: lukasz
--

CREATE TYPE public.reaction_type AS ENUM (
    'angry',
    'haha',
    'like',
    'love',
    'sad',
    'wow'
);


ALTER TYPE public.reaction_type OWNER TO lukasz;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: lukasz
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


ALTER TABLE public.addresses OWNER TO lukasz;

--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.addresses_id_seq OWNER TO lukasz;

--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- Name: advertisements; Type: TABLE; Schema: public; Owner: lukasz
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


ALTER TABLE public.advertisements OWNER TO lukasz;

--
-- Name: advertisements_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.advertisements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.advertisements_id_seq OWNER TO lukasz;

--
-- Name: advertisements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.advertisements_id_seq OWNED BY public.advertisements.id;


--
-- Name: authors; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.authors (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    author_type public.author_type_enum NOT NULL
);


ALTER TABLE public.authors OWNER TO lukasz;

--
-- Name: authors_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.authors_id_seq OWNER TO lukasz;

--
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.authors_id_seq OWNED BY public.authors.id;


--
-- Name: comment_hashtags; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.comment_hashtags (
    comment_id bigint NOT NULL,
    hashtag_id bigint NOT NULL
);


ALTER TABLE public.comment_hashtags OWNER TO lukasz;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.comments (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    author_id bigint,
    content text NOT NULL
);


ALTER TABLE public.comments OWNER TO lukasz;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comments_id_seq OWNER TO lukasz;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: conversation_members; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.conversation_members (
    conversation_id bigint NOT NULL,
    author_id bigint NOT NULL
);


ALTER TABLE public.conversation_members OWNER TO lukasz;

--
-- Name: conversations; Type: TABLE; Schema: public; Owner: lukasz
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


ALTER TABLE public.conversations OWNER TO lukasz;

--
-- Name: conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.conversations_id_seq OWNER TO lukasz;

--
-- Name: conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.conversations_id_seq OWNED BY public.conversations.id;


--
-- Name: event_members; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.event_members (
    event_id bigint NOT NULL,
    author_id bigint NOT NULL
);


ALTER TABLE public.event_members OWNER TO lukasz;

--
-- Name: events; Type: TABLE; Schema: public; Owner: lukasz
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
    location_id bigint,
    CONSTRAINT chk_events_start_date CHECK ((start_date < end_date))
);


ALTER TABLE public.events OWNER TO lukasz;

--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.events_id_seq OWNER TO lukasz;

--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: external_user_links; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.external_user_links (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    author_id bigint NOT NULL,
    platform text NOT NULL,
    link text NOT NULL
);


ALTER TABLE public.external_user_links OWNER TO lukasz;

--
-- Name: external_user_links_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.external_user_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.external_user_links_id_seq OWNER TO lukasz;

--
-- Name: external_user_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.external_user_links_id_seq OWNED BY public.external_user_links.id;


--
-- Name: friend_requests; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.friend_requests (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    sender_id bigint NOT NULL,
    receiver_id bigint NOT NULL,
    status public.friend_request_status DEFAULT 'pending'::public.friend_request_status,
    CONSTRAINT chk_friend_requests_receiver_id CHECK ((sender_id <> receiver_id)),
    CONSTRAINT sender_not_receiver CHECK ((sender_id <> receiver_id))
);


ALTER TABLE public.friend_requests OWNER TO lukasz;

--
-- Name: friend_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.friend_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.friend_requests_id_seq OWNER TO lukasz;

--
-- Name: friend_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.friend_requests_id_seq OWNED BY public.friend_requests.id;


--
-- Name: geolocations; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.geolocations (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL
);


ALTER TABLE public.geolocations OWNER TO lukasz;

--
-- Name: geolocations_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.geolocations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.geolocations_id_seq OWNER TO lukasz;

--
-- Name: geolocations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.geolocations_id_seq OWNED BY public.geolocations.id;


--
-- Name: group_members; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.group_members (
    group_id bigint NOT NULL,
    author_id bigint NOT NULL
);


ALTER TABLE public.group_members OWNER TO lukasz;

--
-- Name: groups; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.groups (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    name character varying(100) NOT NULL
);


ALTER TABLE public.groups OWNER TO lukasz;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.groups_id_seq OWNER TO lukasz;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: hashtags; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.hashtags (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    tag_name character varying(200) NOT NULL
);


ALTER TABLE public.hashtags OWNER TO lukasz;

--
-- Name: hashtags_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.hashtags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hashtags_id_seq OWNER TO lukasz;

--
-- Name: hashtags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.hashtags_id_seq OWNED BY public.hashtags.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: lukasz
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


ALTER TABLE public.locations OWNER TO lukasz;

--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.locations_id_seq OWNER TO lukasz;

--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: lukasz
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


ALTER TABLE public.messages OWNER TO lukasz;

--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.messages_id_seq OWNER TO lukasz;

--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: page_tags; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.page_tags (
    page_id bigint NOT NULL,
    tag_id bigint NOT NULL
);


ALTER TABLE public.page_tags OWNER TO lukasz;

--
-- Name: pages; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.pages (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    author_id bigint,
    title character varying(100) NOT NULL,
    views bigint DEFAULT 0,
    likes bigint DEFAULT 0
);


ALTER TABLE public.pages OWNER TO lukasz;

--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pages_id_seq OWNER TO lukasz;

--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- Name: post_hashtags; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.post_hashtags (
    post_id bigint NOT NULL,
    hashtag_id bigint NOT NULL
);


ALTER TABLE public.post_hashtags OWNER TO lukasz;

--
-- Name: posts; Type: TABLE; Schema: public; Owner: lukasz
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
    location_id bigint
);


ALTER TABLE public.posts OWNER TO lukasz;

--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.posts_id_seq OWNER TO lukasz;

--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: reactions; Type: TABLE; Schema: public; Owner: lukasz
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


ALTER TABLE public.reactions OWNER TO lukasz;

--
-- Name: reactions_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.reactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reactions_id_seq OWNER TO lukasz;

--
-- Name: reactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.reactions_id_seq OWNED BY public.reactions.id;


--
-- Name: reels; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.reels (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    author_id bigint NOT NULL,
    content text NOT NULL
);


ALTER TABLE public.reels OWNER TO lukasz;

--
-- Name: reels_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.reels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reels_id_seq OWNER TO lukasz;

--
-- Name: reels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.reels_id_seq OWNED BY public.reels.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    page_id bigint,
    tag_name character varying(100) NOT NULL
);


ALTER TABLE public.tags OWNER TO lukasz;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tags_id_seq OWNER TO lukasz;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: user_friends; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.user_friends (
    user_author_id bigint NOT NULL,
    friend_author_id bigint NOT NULL,
    CONSTRAINT user_cant_have_himself_on_friend_list CHECK ((user_author_id <> friend_author_id))
);


ALTER TABLE public.user_friends OWNER TO lukasz;

--
-- Name: user_privileges; Type: TABLE; Schema: public; Owner: lukasz
--

CREATE TABLE public.user_privileges (
    id bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone,
    privilege_name character varying(40) NOT NULL
);


ALTER TABLE public.user_privileges OWNER TO lukasz;

--
-- Name: user_privileges_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.user_privileges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_privileges_id_seq OWNER TO lukasz;

--
-- Name: user_privileges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.user_privileges_id_seq OWNED BY public.user_privileges.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: lukasz
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
    bio character varying(160) DEFAULT 'Edit bio'::character varying,
    user_privilege_id bigint NOT NULL,
    CONSTRAINT chk_users_bio CHECK (((bio)::text <> ''::text))
);


ALTER TABLE public.users OWNER TO lukasz;

--
-- Name: users_author_id_seq; Type: SEQUENCE; Schema: public; Owner: lukasz
--

CREATE SEQUENCE public.users_author_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_author_id_seq OWNER TO lukasz;

--
-- Name: users_author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lukasz
--

ALTER SEQUENCE public.users_author_id_seq OWNED BY public.users.author_id;


--
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- Name: advertisements id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.advertisements ALTER COLUMN id SET DEFAULT nextval('public.advertisements_id_seq'::regclass);


--
-- Name: authors id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.authors ALTER COLUMN id SET DEFAULT nextval('public.authors_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: conversations id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.conversations ALTER COLUMN id SET DEFAULT nextval('public.conversations_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: external_user_links id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.external_user_links ALTER COLUMN id SET DEFAULT nextval('public.external_user_links_id_seq'::regclass);


--
-- Name: friend_requests id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.friend_requests ALTER COLUMN id SET DEFAULT nextval('public.friend_requests_id_seq'::regclass);


--
-- Name: geolocations id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.geolocations ALTER COLUMN id SET DEFAULT nextval('public.geolocations_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: hashtags id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.hashtags ALTER COLUMN id SET DEFAULT nextval('public.hashtags_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: reactions id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.reactions ALTER COLUMN id SET DEFAULT nextval('public.reactions_id_seq'::regclass);


--
-- Name: reels id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.reels ALTER COLUMN id SET DEFAULT nextval('public.reels_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: user_privileges id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.user_privileges ALTER COLUMN id SET DEFAULT nextval('public.user_privileges_id_seq'::regclass);


--
-- Name: users author_id; Type: DEFAULT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.users ALTER COLUMN author_id SET DEFAULT nextval('public.users_author_id_seq'::regclass);


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.addresses (id, created_at, updated_at, deleted_at, street_name, building, gate, floor, apartment) FROM stdin;
\.


--
-- Data for Name: advertisements; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.advertisements (id, created_at, updated_at, deleted_at, content, ad_link, page_id) FROM stdin;
\.


--
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.authors (id, created_at, updated_at, deleted_at, author_type) FROM stdin;
\.


--
-- Data for Name: comment_hashtags; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.comment_hashtags (comment_id, hashtag_id) FROM stdin;
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.comments (id, created_at, updated_at, deleted_at, author_id, content) FROM stdin;
\.


--
-- Data for Name: conversation_members; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.conversation_members (conversation_id, author_id) FROM stdin;
\.


--
-- Data for Name: conversations; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.conversations (id, created_at, updated_at, deleted_at, title, icon_url, author_id) FROM stdin;
\.


--
-- Data for Name: event_members; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.event_members (event_id, author_id) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.events (id, created_at, updated_at, deleted_at, author_id, name, description, start_date, end_date, location_id) FROM stdin;
\.


--
-- Data for Name: external_user_links; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.external_user_links (id, created_at, updated_at, deleted_at, author_id, platform, link) FROM stdin;
\.


--
-- Data for Name: friend_requests; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.friend_requests (id, created_at, updated_at, deleted_at, sender_id, receiver_id, status) FROM stdin;
\.


--
-- Data for Name: geolocations; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.geolocations (id, created_at, updated_at, deleted_at, latitude, longitude) FROM stdin;
\.


--
-- Data for Name: group_members; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.group_members (group_id, author_id) FROM stdin;
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.groups (id, created_at, updated_at, deleted_at, name) FROM stdin;
\.


--
-- Data for Name: hashtags; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.hashtags (id, created_at, updated_at, deleted_at, tag_name) FROM stdin;
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.locations (id, created_at, updated_at, deleted_at, city, country, postal_code, geolocation_id, address_id) FROM stdin;
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.messages (id, created_at, updated_at, deleted_at, content, author_id, conversation_id) FROM stdin;
\.


--
-- Data for Name: page_tags; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.page_tags (page_id, tag_id) FROM stdin;
\.


--
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.pages (id, created_at, updated_at, deleted_at, author_id, title, views, likes) FROM stdin;
\.


--
-- Data for Name: post_hashtags; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.post_hashtags (post_id, hashtag_id) FROM stdin;
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.posts (id, created_at, updated_at, deleted_at, author_id, title, content, is_public, location_id) FROM stdin;
\.


--
-- Data for Name: reactions; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.reactions (id, created_at, updated_at, deleted_at, author_id, post_id, reaction) FROM stdin;
\.


--
-- Data for Name: reels; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.reels (id, created_at, updated_at, deleted_at, author_id, content) FROM stdin;
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.tags (id, created_at, updated_at, deleted_at, page_id, tag_name) FROM stdin;
\.


--
-- Data for Name: user_friends; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.user_friends (user_author_id, friend_author_id) FROM stdin;
\.


--
-- Data for Name: user_privileges; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.user_privileges (id, created_at, updated_at, deleted_at, privilege_name) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: lukasz
--

COPY public.users (author_id, first_name, second_name, email, password, picture_url, background_url, birthday, is_verified, bio, user_privilege_id) FROM stdin;
\.


--
-- Name: addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.addresses_id_seq', 1, false);


--
-- Name: advertisements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.advertisements_id_seq', 1, false);


--
-- Name: authors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.authors_id_seq', 1, false);


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.comments_id_seq', 1, false);


--
-- Name: conversations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.conversations_id_seq', 1, false);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.events_id_seq', 1, false);


--
-- Name: external_user_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.external_user_links_id_seq', 1, false);


--
-- Name: friend_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.friend_requests_id_seq', 1, false);


--
-- Name: geolocations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.geolocations_id_seq', 1, false);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.groups_id_seq', 1, false);


--
-- Name: hashtags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.hashtags_id_seq', 1, false);


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.locations_id_seq', 1, false);


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.messages_id_seq', 1, false);


--
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.pages_id_seq', 1, false);


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.posts_id_seq', 1, false);


--
-- Name: reactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.reactions_id_seq', 1, false);


--
-- Name: reels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.reels_id_seq', 1, false);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.tags_id_seq', 1, false);


--
-- Name: user_privileges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.user_privileges_id_seq', 1, false);


--
-- Name: users_author_id_seq; Type: SEQUENCE SET; Schema: public; Owner: lukasz
--

SELECT pg_catalog.setval('public.users_author_id_seq', 1, false);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: advertisements advertisements_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.advertisements
    ADD CONSTRAINT advertisements_pkey PRIMARY KEY (id);


--
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- Name: comment_hashtags comment_hashtags_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.comment_hashtags
    ADD CONSTRAINT comment_hashtags_pkey PRIMARY KEY (comment_id, hashtag_id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: conversation_members conversation_members_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.conversation_members
    ADD CONSTRAINT conversation_members_pkey PRIMARY KEY (conversation_id, author_id);


--
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);


--
-- Name: event_members event_members_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.event_members
    ADD CONSTRAINT event_members_pkey PRIMARY KEY (event_id, author_id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: external_user_links external_user_links_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.external_user_links
    ADD CONSTRAINT external_user_links_pkey PRIMARY KEY (id);


--
-- Name: friend_requests friend_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.friend_requests
    ADD CONSTRAINT friend_requests_pkey PRIMARY KEY (id);


--
-- Name: geolocations geolocations_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.geolocations
    ADD CONSTRAINT geolocations_pkey PRIMARY KEY (id);


--
-- Name: group_members group_members_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_pkey PRIMARY KEY (group_id, author_id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: hashtags hashtags_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.hashtags
    ADD CONSTRAINT hashtags_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: page_tags page_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.page_tags
    ADD CONSTRAINT page_tags_pkey PRIMARY KEY (page_id, tag_id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: post_hashtags post_hashtags_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.post_hashtags
    ADD CONSTRAINT post_hashtags_pkey PRIMARY KEY (post_id, hashtag_id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: reactions reactions_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.reactions
    ADD CONSTRAINT reactions_pkey PRIMARY KEY (id, author_id, post_id);


--
-- Name: reels reels_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.reels
    ADD CONSTRAINT reels_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: hashtags uni_hashtags_tag_name; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.hashtags
    ADD CONSTRAINT uni_hashtags_tag_name UNIQUE (tag_name);


--
-- Name: tags uni_tags_tag_name; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT uni_tags_tag_name UNIQUE (tag_name);


--
-- Name: user_privileges uni_user_privileges_privilege_name; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.user_privileges
    ADD CONSTRAINT uni_user_privileges_privilege_name UNIQUE (privilege_name);


--
-- Name: users uni_users_email; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uni_users_email UNIQUE (email);


--
-- Name: user_friends user_friends_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.user_friends
    ADD CONSTRAINT user_friends_pkey PRIMARY KEY (user_author_id, friend_author_id);


--
-- Name: user_privileges user_privileges_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.user_privileges
    ADD CONSTRAINT user_privileges_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (author_id);


--
-- Name: idx_addresses_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_addresses_deleted_at ON public.addresses USING btree (deleted_at);


--
-- Name: idx_advertisements_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_advertisements_deleted_at ON public.advertisements USING btree (deleted_at);


--
-- Name: idx_authors_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_authors_deleted_at ON public.authors USING btree (deleted_at);


--
-- Name: idx_comments_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_comments_deleted_at ON public.comments USING btree (deleted_at);


--
-- Name: idx_conversations_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_conversations_deleted_at ON public.conversations USING btree (deleted_at);


--
-- Name: idx_events_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_events_deleted_at ON public.events USING btree (deleted_at);


--
-- Name: idx_external_user_links_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_external_user_links_deleted_at ON public.external_user_links USING btree (deleted_at);


--
-- Name: idx_friend_requests_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_friend_requests_deleted_at ON public.friend_requests USING btree (deleted_at);


--
-- Name: idx_geolocations_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_geolocations_deleted_at ON public.geolocations USING btree (deleted_at);


--
-- Name: idx_groups_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_groups_deleted_at ON public.groups USING btree (deleted_at);


--
-- Name: idx_hashtags_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_hashtags_deleted_at ON public.hashtags USING btree (deleted_at);


--
-- Name: idx_locations_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_locations_deleted_at ON public.locations USING btree (deleted_at);


--
-- Name: idx_messages_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_messages_deleted_at ON public.messages USING btree (deleted_at);


--
-- Name: idx_pages_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_pages_deleted_at ON public.pages USING btree (deleted_at);


--
-- Name: idx_posts_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_posts_deleted_at ON public.posts USING btree (deleted_at);


--
-- Name: idx_reactions_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_reactions_deleted_at ON public.reactions USING btree (deleted_at);


--
-- Name: idx_reels_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_reels_deleted_at ON public.reels USING btree (deleted_at);


--
-- Name: idx_tags_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_tags_deleted_at ON public.tags USING btree (deleted_at);


--
-- Name: idx_user_privileges_deleted_at; Type: INDEX; Schema: public; Owner: lukasz
--

CREATE INDEX idx_user_privileges_deleted_at ON public.user_privileges USING btree (deleted_at);


--
-- Name: comments fk_authors_comments; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_authors_comments FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- Name: conversations fk_authors_conversations; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT fk_authors_conversations FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- Name: events fk_authors_events; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_authors_events FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- Name: messages fk_authors_messages; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT fk_authors_messages FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- Name: posts fk_authors_posts; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT fk_authors_posts FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- Name: reactions fk_authors_reactions; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.reactions
    ADD CONSTRAINT fk_authors_reactions FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- Name: reels fk_authors_reels; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.reels
    ADD CONSTRAINT fk_authors_reels FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- Name: comment_hashtags fk_comment_hashtags_comment; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.comment_hashtags
    ADD CONSTRAINT fk_comment_hashtags_comment FOREIGN KEY (comment_id) REFERENCES public.comments(id);


--
-- Name: comment_hashtags fk_comment_hashtags_hashtag; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.comment_hashtags
    ADD CONSTRAINT fk_comment_hashtags_hashtag FOREIGN KEY (hashtag_id) REFERENCES public.hashtags(id);


--
-- Name: conversation_members fk_conversation_members_author; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.conversation_members
    ADD CONSTRAINT fk_conversation_members_author FOREIGN KEY (author_id) REFERENCES public.authors(id);


--
-- Name: conversation_members fk_conversation_members_conversation; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.conversation_members
    ADD CONSTRAINT fk_conversation_members_conversation FOREIGN KEY (conversation_id) REFERENCES public.conversations(id);


--
-- Name: event_members fk_event_members_author; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.event_members
    ADD CONSTRAINT fk_event_members_author FOREIGN KEY (author_id) REFERENCES public.authors(id);


--
-- Name: event_members fk_event_members_event; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.event_members
    ADD CONSTRAINT fk_event_members_event FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: events fk_events_location; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_events_location FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: friend_requests fk_friend_requests_sender; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.friend_requests
    ADD CONSTRAINT fk_friend_requests_sender FOREIGN KEY (sender_id) REFERENCES public.users(author_id) ON DELETE CASCADE;


--
-- Name: group_members fk_group_members_author; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT fk_group_members_author FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- Name: group_members fk_group_members_group; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT fk_group_members_group FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- Name: locations fk_locations_address; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT fk_locations_address FOREIGN KEY (address_id) REFERENCES public.addresses(id);


--
-- Name: locations fk_locations_geolocation; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT fk_locations_geolocation FOREIGN KEY (geolocation_id) REFERENCES public.geolocations(id);


--
-- Name: page_tags fk_page_tags_page; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.page_tags
    ADD CONSTRAINT fk_page_tags_page FOREIGN KEY (page_id) REFERENCES public.pages(id);


--
-- Name: page_tags fk_page_tags_tag; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.page_tags
    ADD CONSTRAINT fk_page_tags_tag FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: advertisements fk_pages_advertisements; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.advertisements
    ADD CONSTRAINT fk_pages_advertisements FOREIGN KEY (page_id) REFERENCES public.pages(id);


--
-- Name: pages fk_pages_author; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT fk_pages_author FOREIGN KEY (author_id) REFERENCES public.authors(id);


--
-- Name: post_hashtags fk_post_hashtags_hashtag; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.post_hashtags
    ADD CONSTRAINT fk_post_hashtags_hashtag FOREIGN KEY (hashtag_id) REFERENCES public.hashtags(id);


--
-- Name: post_hashtags fk_post_hashtags_post; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.post_hashtags
    ADD CONSTRAINT fk_post_hashtags_post FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- Name: posts fk_posts_location; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT fk_posts_location FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: user_friends fk_user_friends_friends; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.user_friends
    ADD CONSTRAINT fk_user_friends_friends FOREIGN KEY (friend_author_id) REFERENCES public.users(author_id);


--
-- Name: user_friends fk_user_friends_user; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.user_friends
    ADD CONSTRAINT fk_user_friends_user FOREIGN KEY (user_author_id) REFERENCES public.users(author_id);


--
-- Name: users fk_user_privileges_users; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_user_privileges_users FOREIGN KEY (user_privilege_id) REFERENCES public.user_privileges(id);


--
-- Name: users fk_users_author; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_author FOREIGN KEY (author_id) REFERENCES public.authors(id) ON DELETE CASCADE;


--
-- Name: external_user_links fk_users_external_user_links; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.external_user_links
    ADD CONSTRAINT fk_users_external_user_links FOREIGN KEY (author_id) REFERENCES public.users(author_id);


--
-- Name: friend_requests fk_users_friend_requests; Type: FK CONSTRAINT; Schema: public; Owner: lukasz
--

ALTER TABLE ONLY public.friend_requests
    ADD CONSTRAINT fk_users_friend_requests FOREIGN KEY (receiver_id) REFERENCES public.users(author_id);


--
-- PostgreSQL database dump complete
--

