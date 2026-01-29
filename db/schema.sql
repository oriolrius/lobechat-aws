\restrict hj9Qc5duKdmGtbW5d2EXydIeeGZwb7Fo83Vrwanz21RePrbiiqqVOysbfY6JbxO

-- Dumped from database version 16.11 (Debian 16.11-1.pgdg12+1)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-1.pgdg22.04+1)

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
-- Name: drizzle; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA drizzle;


--
-- Name: vector; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA public;


--
-- Name: EXTENSION vector; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION vector IS 'vector data type and ivfflat and hnsw access methods';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: __drizzle_migrations; Type: TABLE; Schema: drizzle; Owner: -
--

CREATE TABLE drizzle.__drizzle_migrations (
    id integer NOT NULL,
    hash text NOT NULL,
    created_at bigint
);


--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE; Schema: drizzle; Owner: -
--

CREATE SEQUENCE drizzle.__drizzle_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: drizzle; Owner: -
--

ALTER SEQUENCE drizzle.__drizzle_migrations_id_seq OWNED BY drizzle.__drizzle_migrations.id;


--
-- Name: agents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agents (
    id text NOT NULL,
    slug character varying(100),
    title character varying(255),
    description character varying(1000),
    tags jsonb DEFAULT '[]'::jsonb,
    avatar text,
    background_color text,
    plugins jsonb DEFAULT '[]'::jsonb,
    user_id text NOT NULL,
    chat_config jsonb,
    few_shots jsonb,
    model text,
    params jsonb DEFAULT '{}'::jsonb,
    provider text,
    system_role text,
    tts jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    client_id text,
    opening_message text,
    opening_questions text[] DEFAULT '{}'::text[],
    virtual boolean DEFAULT false
);


--
-- Name: agents_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agents_files (
    file_id text NOT NULL,
    agent_id text NOT NULL,
    enabled boolean DEFAULT true,
    user_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: agents_knowledge_bases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agents_knowledge_bases (
    agent_id text NOT NULL,
    knowledge_base_id text NOT NULL,
    user_id text NOT NULL,
    enabled boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: agents_to_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agents_to_sessions (
    agent_id text NOT NULL,
    session_id text NOT NULL,
    user_id text NOT NULL
);


--
-- Name: ai_models; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_models (
    id character varying(150) NOT NULL,
    display_name character varying(200),
    description text,
    organization character varying(100),
    enabled boolean,
    provider_id character varying(64) NOT NULL,
    type character varying(20) DEFAULT 'chat'::character varying NOT NULL,
    sort integer,
    user_id text NOT NULL,
    pricing jsonb,
    parameters jsonb DEFAULT '{}'::jsonb,
    config jsonb,
    abilities jsonb DEFAULT '{}'::jsonb,
    context_window_tokens integer,
    source character varying(20),
    released_at character varying(10),
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: ai_providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_providers (
    id character varying(64) NOT NULL,
    name text,
    user_id text NOT NULL,
    sort integer,
    enabled boolean,
    fetch_on_client boolean,
    check_model text,
    logo text,
    description text,
    key_vaults text,
    source character varying(20),
    settings jsonb,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    config jsonb
);


--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.api_keys (
    id integer NOT NULL,
    name character varying(256) NOT NULL,
    key character varying(256) NOT NULL,
    enabled boolean DEFAULT true,
    expires_at timestamp with time zone,
    last_used_at timestamp with time zone,
    user_id text NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.api_keys ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.api_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: async_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.async_tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type text,
    status text,
    error jsonb,
    user_id text NOT NULL,
    duration integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: chat_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_groups (
    id text NOT NULL,
    title text,
    description text,
    config jsonb,
    client_id text,
    user_id text NOT NULL,
    pinned boolean DEFAULT false,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    group_id text
);


--
-- Name: chat_groups_agents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_groups_agents (
    chat_group_id text NOT NULL,
    agent_id text NOT NULL,
    user_id text NOT NULL,
    enabled boolean DEFAULT true,
    "order" integer DEFAULT 0,
    role text DEFAULT 'participant'::text,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: chunks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chunks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    text text,
    abstract text,
    metadata jsonb,
    index integer,
    type character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id text,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    client_id text
)
WITH (autovacuum_vacuum_scale_factor='0.02', autovacuum_vacuum_threshold='1000');


--
-- Name: document_chunks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.document_chunks (
    document_id character varying(30) NOT NULL,
    chunk_id uuid NOT NULL,
    page_index integer,
    user_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.documents (
    id character varying(30) NOT NULL,
    title text,
    content text,
    file_type character varying(255) NOT NULL,
    filename text,
    total_char_count integer NOT NULL,
    total_line_count integer NOT NULL,
    metadata jsonb,
    pages jsonb,
    source_type text NOT NULL,
    source text NOT NULL,
    file_id text,
    user_id text NOT NULL,
    client_id text,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    editor_data jsonb
);


--
-- Name: embeddings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.embeddings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    chunk_id uuid,
    embeddings public.vector(1024),
    model text,
    user_id text,
    client_id text
)
WITH (autovacuum_vacuum_scale_factor='0.02', autovacuum_vacuum_threshold='1000');


--
-- Name: file_chunks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.file_chunks (
    file_id character varying NOT NULL,
    chunk_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id text NOT NULL
);


--
-- Name: files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.files (
    id text NOT NULL,
    user_id text NOT NULL,
    file_type character varying(255) NOT NULL,
    name text NOT NULL,
    size integer NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    file_hash character varying(64),
    chunk_task_id uuid,
    embedding_task_id uuid,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    client_id text,
    source text
);


--
-- Name: files_to_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.files_to_sessions (
    file_id text NOT NULL,
    session_id text NOT NULL,
    user_id text NOT NULL
);


--
-- Name: generation_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.generation_batches (
    id text NOT NULL,
    user_id text NOT NULL,
    generation_topic_id text NOT NULL,
    provider text NOT NULL,
    model text NOT NULL,
    prompt text NOT NULL,
    width integer,
    height integer,
    ratio character varying(64),
    config jsonb,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: generation_topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.generation_topics (
    id text NOT NULL,
    user_id text NOT NULL,
    title text,
    cover_url text,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: generations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.generations (
    id text NOT NULL,
    user_id text NOT NULL,
    generation_batch_id character varying(64) NOT NULL,
    async_task_id uuid,
    file_id text,
    seed integer,
    asset jsonb,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: global_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.global_files (
    hash_id character varying(64) NOT NULL,
    file_type character varying(255) NOT NULL,
    size integer NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    creator text
);


--
-- Name: knowledge_base_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.knowledge_base_files (
    knowledge_base_id text NOT NULL,
    file_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id text NOT NULL
);


--
-- Name: knowledge_bases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.knowledge_bases (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    avatar text,
    type text,
    user_id text NOT NULL,
    is_public boolean DEFAULT false,
    settings jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    client_id text
);


--
-- Name: message_chunks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.message_chunks (
    message_id text NOT NULL,
    chunk_id uuid NOT NULL,
    user_id text NOT NULL
);


--
-- Name: message_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.message_groups (
    id character varying(255) NOT NULL,
    topic_id text,
    user_id text NOT NULL,
    parent_group_id character varying(255),
    parent_message_id text,
    title character varying(255),
    description text,
    client_id character varying(255),
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: message_plugins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.message_plugins (
    id text NOT NULL,
    tool_call_id text,
    type text DEFAULT 'default'::text,
    api_name text,
    arguments text,
    identifier text,
    state jsonb,
    error jsonb,
    user_id text NOT NULL,
    client_id text
);


--
-- Name: message_queries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.message_queries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    message_id text NOT NULL,
    rewrite_query text,
    user_query text,
    embeddings_id uuid,
    user_id text NOT NULL,
    client_id text
);


--
-- Name: message_query_chunks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.message_query_chunks (
    id text NOT NULL,
    query_id uuid NOT NULL,
    chunk_id uuid NOT NULL,
    similarity numeric(6,5),
    user_id text NOT NULL
);


--
-- Name: message_translates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.message_translates (
    id text NOT NULL,
    content text,
    "from" text,
    "to" text,
    user_id text NOT NULL,
    client_id text
);


--
-- Name: message_tts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.message_tts (
    id text NOT NULL,
    content_md5 text,
    file_id text,
    voice text,
    user_id text NOT NULL,
    client_id text
);


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id text NOT NULL,
    role character varying(255) NOT NULL,
    content text,
    model text,
    provider text,
    favorite boolean DEFAULT false,
    error jsonb,
    tools jsonb,
    trace_id text,
    observation_id text,
    user_id text NOT NULL,
    session_id text,
    topic_id text,
    parent_id text,
    quota_id text,
    agent_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    client_id text,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    thread_id text,
    reasoning jsonb,
    search jsonb,
    metadata jsonb,
    group_id text,
    target_id text,
    message_group_id character varying(255)
);


--
-- Name: messages_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages_files (
    file_id text NOT NULL,
    message_id text NOT NULL,
    user_id text NOT NULL
);


--
-- Name: nextauth_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nextauth_accounts (
    access_token text,
    expires_at integer,
    id_token text,
    provider text NOT NULL,
    "providerAccountId" text NOT NULL,
    refresh_token text,
    scope text,
    session_state text,
    token_type text,
    type text NOT NULL,
    "userId" text NOT NULL
);


--
-- Name: nextauth_authenticators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nextauth_authenticators (
    counter integer NOT NULL,
    "credentialBackedUp" boolean NOT NULL,
    "credentialDeviceType" text NOT NULL,
    "credentialID" text NOT NULL,
    "credentialPublicKey" text NOT NULL,
    "providerAccountId" text NOT NULL,
    transports text,
    "userId" text NOT NULL
);


--
-- Name: nextauth_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nextauth_sessions (
    expires timestamp without time zone NOT NULL,
    "sessionToken" text NOT NULL,
    "userId" text NOT NULL
);


--
-- Name: nextauth_verificationtokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nextauth_verificationtokens (
    expires timestamp without time zone NOT NULL,
    identifier text NOT NULL,
    token text NOT NULL
);


--
-- Name: oauth_handoffs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_handoffs (
    id text NOT NULL,
    client character varying(50) NOT NULL,
    payload jsonb NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: oidc_access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oidc_access_tokens (
    id character varying(255) NOT NULL,
    data jsonb NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    consumed_at timestamp with time zone,
    user_id text NOT NULL,
    client_id character varying(255) NOT NULL,
    grant_id character varying(255),
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: oidc_authorization_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oidc_authorization_codes (
    id character varying(255) NOT NULL,
    data jsonb NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    consumed_at timestamp with time zone,
    user_id text NOT NULL,
    client_id character varying(255) NOT NULL,
    grant_id character varying(255),
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: oidc_clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oidc_clients (
    id character varying(255) NOT NULL,
    name text NOT NULL,
    description text,
    client_secret character varying(255),
    redirect_uris text[] NOT NULL,
    grants text[] NOT NULL,
    response_types text[] NOT NULL,
    scopes text[] NOT NULL,
    token_endpoint_auth_method character varying(20),
    application_type character varying(20),
    client_uri text,
    logo_uri text,
    policy_uri text,
    tos_uri text,
    is_first_party boolean DEFAULT false,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: oidc_consents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oidc_consents (
    user_id text NOT NULL,
    client_id character varying(255) NOT NULL,
    scopes text[] NOT NULL,
    expires_at timestamp with time zone,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: oidc_device_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oidc_device_codes (
    id character varying(255) NOT NULL,
    data jsonb NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    consumed_at timestamp with time zone,
    user_id text,
    client_id character varying(255) NOT NULL,
    grant_id character varying(255),
    user_code character varying(255),
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: oidc_grants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oidc_grants (
    id character varying(255) NOT NULL,
    data jsonb NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    consumed_at timestamp with time zone,
    user_id text NOT NULL,
    client_id character varying(255) NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: oidc_interactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oidc_interactions (
    id character varying(255) NOT NULL,
    data jsonb NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: oidc_refresh_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oidc_refresh_tokens (
    id character varying(255) NOT NULL,
    data jsonb NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    consumed_at timestamp with time zone,
    user_id text NOT NULL,
    client_id character varying(255) NOT NULL,
    grant_id character varying(255),
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: oidc_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oidc_sessions (
    id character varying(255) NOT NULL,
    data jsonb NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    user_id text NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: rag_eval_dataset_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rag_eval_dataset_records (
    id integer NOT NULL,
    dataset_id integer NOT NULL,
    ideal text,
    question text,
    reference_files text[],
    metadata jsonb,
    user_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: rag_eval_dataset_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.rag_eval_dataset_records ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.rag_eval_dataset_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rag_eval_datasets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rag_eval_datasets (
    id integer NOT NULL,
    description text,
    name text NOT NULL,
    knowledge_base_id text,
    user_id text,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: rag_eval_datasets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.rag_eval_datasets ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.rag_eval_datasets_id_seq
    START WITH 30000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rag_eval_evaluation_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rag_eval_evaluation_records (
    id integer NOT NULL,
    question text NOT NULL,
    answer text,
    context text[],
    ideal text,
    status text,
    error jsonb,
    language_model text,
    embedding_model text,
    question_embedding_id uuid,
    duration integer,
    dataset_record_id integer NOT NULL,
    evaluation_id integer NOT NULL,
    user_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: rag_eval_evaluation_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.rag_eval_evaluation_records ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.rag_eval_evaluation_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rag_eval_evaluations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rag_eval_evaluations (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    eval_records_url text,
    status text,
    error jsonb,
    dataset_id integer NOT NULL,
    knowledge_base_id text,
    language_model text,
    embedding_model text,
    user_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: rag_eval_evaluations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.rag_eval_evaluations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.rag_eval_evaluations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rbac_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rbac_permissions (
    id integer NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    description text,
    category text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: rbac_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.rbac_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.rbac_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rbac_role_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rbac_role_permissions (
    role_id integer NOT NULL,
    permission_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: rbac_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rbac_roles (
    id integer NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    description text,
    is_system boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb
);


--
-- Name: rbac_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.rbac_roles ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.rbac_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: rbac_user_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rbac_user_roles (
    user_id text NOT NULL,
    role_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: session_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session_groups (
    id text NOT NULL,
    name text NOT NULL,
    sort integer,
    user_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    client_id text,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id text NOT NULL,
    slug character varying(100) NOT NULL,
    title text,
    description text,
    avatar text,
    background_color text,
    type text DEFAULT 'agent'::text,
    user_id text NOT NULL,
    group_id text,
    pinned boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    client_id text,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: threads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.threads (
    id text NOT NULL,
    title text,
    type text NOT NULL,
    status text DEFAULT 'active'::text,
    topic_id text NOT NULL,
    source_message_id text NOT NULL,
    parent_thread_id text,
    user_id text NOT NULL,
    last_active_at timestamp with time zone DEFAULT now(),
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    client_id text
);


--
-- Name: topic_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.topic_documents (
    document_id text NOT NULL,
    topic_id text NOT NULL,
    user_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.topics (
    id text NOT NULL,
    session_id text,
    user_id text NOT NULL,
    favorite boolean DEFAULT false,
    title text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    client_id text,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    history_summary text,
    metadata jsonb,
    group_id text
);


--
-- Name: unstructured_chunks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.unstructured_chunks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    text text,
    metadata jsonb,
    index integer,
    type character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    parent_id character varying,
    composite_id uuid,
    user_id text,
    file_id character varying,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    client_id text
);


--
-- Name: user_installed_plugins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_installed_plugins (
    user_id text NOT NULL,
    identifier text NOT NULL,
    type text NOT NULL,
    manifest jsonb,
    settings jsonb,
    custom_params jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: user_memories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_memories (
    id character varying(255) NOT NULL,
    user_id text,
    memory_category character varying(255),
    memory_layer character varying(255),
    memory_type character varying(255),
    title character varying(255),
    summary text,
    summary_vector_1024 public.vector(1024),
    details text,
    details_vector_1024 public.vector(1024),
    status character varying(255),
    accessed_count bigint DEFAULT 0,
    last_accessed_at timestamp with time zone NOT NULL,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    metadata jsonb,
    tags text[]
);


--
-- Name: user_memories_contexts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_memories_contexts (
    id character varying(255) NOT NULL,
    user_memory_ids jsonb,
    associated_objects jsonb,
    associated_subjects jsonb,
    title text,
    title_vector public.vector(1024),
    description text,
    description_vector public.vector(1024),
    type character varying(255),
    current_status text,
    score_impact numeric DEFAULT 0,
    score_urgency numeric DEFAULT 0,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id text,
    metadata jsonb,
    tags text[]
);


--
-- Name: user_memories_experiences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_memories_experiences (
    id character varying(255) NOT NULL,
    user_memory_id character varying(255),
    type character varying(255),
    situation text,
    situation_vector public.vector(1024),
    reasoning text,
    possible_outcome text,
    action text,
    action_vector public.vector(1024),
    key_learning text,
    key_learning_vector public.vector(1024),
    metadata jsonb,
    score_confidence real DEFAULT 0,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id text,
    tags text[]
);


--
-- Name: user_memories_identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_memories_identities (
    description text,
    description_vector public.vector(1024),
    id character varying(255) NOT NULL,
    relationship character varying(255),
    role text,
    type character varying(255),
    user_memory_id character varying(255),
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id text,
    metadata jsonb,
    tags text[],
    episodic_date timestamp with time zone
);


--
-- Name: user_memories_preferences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_memories_preferences (
    id character varying(255) NOT NULL,
    user_memory_id character varying(255),
    conclusion_directives text,
    conclusion_directives_vector public.vector(1024),
    type character varying(255),
    suggestions text,
    score_priority numeric DEFAULT 0,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id text,
    metadata jsonb,
    tags text[]
);


--
-- Name: user_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_settings (
    id text NOT NULL,
    tts jsonb,
    key_vaults text,
    general jsonb,
    language_model jsonb,
    system_agent jsonb,
    default_agent jsonb,
    tool jsonb,
    hotkey jsonb,
    image jsonb
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id text NOT NULL,
    username text,
    email text,
    avatar text,
    phone text,
    first_name text,
    last_name text,
    is_onboarded boolean DEFAULT false,
    clerk_created_at timestamp with time zone,
    preference jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    full_name text,
    email_verified_at timestamp with time zone,
    accessed_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: __drizzle_migrations id; Type: DEFAULT; Schema: drizzle; Owner: -
--

ALTER TABLE ONLY drizzle.__drizzle_migrations ALTER COLUMN id SET DEFAULT nextval('drizzle.__drizzle_migrations_id_seq'::regclass);


--
-- Name: __drizzle_migrations __drizzle_migrations_pkey; Type: CONSTRAINT; Schema: drizzle; Owner: -
--

ALTER TABLE ONLY drizzle.__drizzle_migrations
    ADD CONSTRAINT __drizzle_migrations_pkey PRIMARY KEY (id);


--
-- Name: agents_files agents_files_file_id_agent_id_user_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents_files
    ADD CONSTRAINT agents_files_file_id_agent_id_user_id_pk PRIMARY KEY (file_id, agent_id, user_id);


--
-- Name: agents_knowledge_bases agents_knowledge_bases_agent_id_knowledge_base_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents_knowledge_bases
    ADD CONSTRAINT agents_knowledge_bases_agent_id_knowledge_base_id_pk PRIMARY KEY (agent_id, knowledge_base_id);


--
-- Name: agents agents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_pkey PRIMARY KEY (id);


--
-- Name: agents agents_slug_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_slug_unique UNIQUE (slug);


--
-- Name: agents_to_sessions agents_to_sessions_agent_id_session_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents_to_sessions
    ADD CONSTRAINT agents_to_sessions_agent_id_session_id_pk PRIMARY KEY (agent_id, session_id);


--
-- Name: ai_models ai_models_id_provider_id_user_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_models
    ADD CONSTRAINT ai_models_id_provider_id_user_id_pk PRIMARY KEY (id, provider_id, user_id);


--
-- Name: ai_providers ai_providers_id_user_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_providers
    ADD CONSTRAINT ai_providers_id_user_id_pk PRIMARY KEY (id, user_id);


--
-- Name: api_keys api_keys_key_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_key_unique UNIQUE (key);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: async_tasks async_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.async_tasks
    ADD CONSTRAINT async_tasks_pkey PRIMARY KEY (id);


--
-- Name: chat_groups_agents chat_groups_agents_chat_group_id_agent_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_groups_agents
    ADD CONSTRAINT chat_groups_agents_chat_group_id_agent_id_pk PRIMARY KEY (chat_group_id, agent_id);


--
-- Name: chat_groups chat_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_groups
    ADD CONSTRAINT chat_groups_pkey PRIMARY KEY (id);


--
-- Name: chunks chunks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chunks
    ADD CONSTRAINT chunks_pkey PRIMARY KEY (id);


--
-- Name: document_chunks document_chunks_document_id_chunk_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_chunks
    ADD CONSTRAINT document_chunks_document_id_chunk_id_pk PRIMARY KEY (document_id, chunk_id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: embeddings embeddings_chunk_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.embeddings
    ADD CONSTRAINT embeddings_chunk_id_unique UNIQUE (chunk_id);


--
-- Name: embeddings embeddings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.embeddings
    ADD CONSTRAINT embeddings_pkey PRIMARY KEY (id);


--
-- Name: file_chunks file_chunks_file_id_chunk_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_chunks
    ADD CONSTRAINT file_chunks_file_id_chunk_id_pk PRIMARY KEY (file_id, chunk_id);


--
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: messages_files files_to_messages_file_id_message_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages_files
    ADD CONSTRAINT files_to_messages_file_id_message_id_pk PRIMARY KEY (file_id, message_id);


--
-- Name: files_to_sessions files_to_sessions_file_id_session_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.files_to_sessions
    ADD CONSTRAINT files_to_sessions_file_id_session_id_pk PRIMARY KEY (file_id, session_id);


--
-- Name: generation_batches generation_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generation_batches
    ADD CONSTRAINT generation_batches_pkey PRIMARY KEY (id);


--
-- Name: generation_topics generation_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generation_topics
    ADD CONSTRAINT generation_topics_pkey PRIMARY KEY (id);


--
-- Name: generations generations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generations
    ADD CONSTRAINT generations_pkey PRIMARY KEY (id);


--
-- Name: global_files global_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.global_files
    ADD CONSTRAINT global_files_pkey PRIMARY KEY (hash_id);


--
-- Name: knowledge_base_files knowledge_base_files_knowledge_base_id_file_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knowledge_base_files
    ADD CONSTRAINT knowledge_base_files_knowledge_base_id_file_id_pk PRIMARY KEY (knowledge_base_id, file_id);


--
-- Name: knowledge_bases knowledge_bases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knowledge_bases
    ADD CONSTRAINT knowledge_bases_pkey PRIMARY KEY (id);


--
-- Name: message_chunks message_chunks_chunk_id_message_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_chunks
    ADD CONSTRAINT message_chunks_chunk_id_message_id_pk PRIMARY KEY (chunk_id, message_id);


--
-- Name: message_groups message_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_groups
    ADD CONSTRAINT message_groups_pkey PRIMARY KEY (id);


--
-- Name: message_plugins message_plugins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_plugins
    ADD CONSTRAINT message_plugins_pkey PRIMARY KEY (id);


--
-- Name: message_queries message_queries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_queries
    ADD CONSTRAINT message_queries_pkey PRIMARY KEY (id);


--
-- Name: message_query_chunks message_query_chunks_chunk_id_id_query_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_query_chunks
    ADD CONSTRAINT message_query_chunks_chunk_id_id_query_id_pk PRIMARY KEY (chunk_id, id, query_id);


--
-- Name: message_translates message_translates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_translates
    ADD CONSTRAINT message_translates_pkey PRIMARY KEY (id);


--
-- Name: message_tts message_tts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_tts
    ADD CONSTRAINT message_tts_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: nextauth_accounts nextauth_accounts_provider_providerAccountId_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nextauth_accounts
    ADD CONSTRAINT "nextauth_accounts_provider_providerAccountId_pk" PRIMARY KEY (provider, "providerAccountId");


--
-- Name: nextauth_authenticators nextauth_authenticators_credentialID_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nextauth_authenticators
    ADD CONSTRAINT "nextauth_authenticators_credentialID_unique" UNIQUE ("credentialID");


--
-- Name: nextauth_authenticators nextauth_authenticators_userId_credentialID_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nextauth_authenticators
    ADD CONSTRAINT "nextauth_authenticators_userId_credentialID_pk" PRIMARY KEY ("userId", "credentialID");


--
-- Name: nextauth_sessions nextauth_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nextauth_sessions
    ADD CONSTRAINT nextauth_sessions_pkey PRIMARY KEY ("sessionToken");


--
-- Name: nextauth_verificationtokens nextauth_verificationtokens_identifier_token_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nextauth_verificationtokens
    ADD CONSTRAINT nextauth_verificationtokens_identifier_token_pk PRIMARY KEY (identifier, token);


--
-- Name: oauth_handoffs oauth_handoffs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_handoffs
    ADD CONSTRAINT oauth_handoffs_pkey PRIMARY KEY (id);


--
-- Name: oidc_access_tokens oidc_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_access_tokens
    ADD CONSTRAINT oidc_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: oidc_authorization_codes oidc_authorization_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_authorization_codes
    ADD CONSTRAINT oidc_authorization_codes_pkey PRIMARY KEY (id);


--
-- Name: oidc_clients oidc_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_clients
    ADD CONSTRAINT oidc_clients_pkey PRIMARY KEY (id);


--
-- Name: oidc_consents oidc_consents_user_id_client_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_consents
    ADD CONSTRAINT oidc_consents_user_id_client_id_pk PRIMARY KEY (user_id, client_id);


--
-- Name: oidc_device_codes oidc_device_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_device_codes
    ADD CONSTRAINT oidc_device_codes_pkey PRIMARY KEY (id);


--
-- Name: oidc_grants oidc_grants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_grants
    ADD CONSTRAINT oidc_grants_pkey PRIMARY KEY (id);


--
-- Name: oidc_interactions oidc_interactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_interactions
    ADD CONSTRAINT oidc_interactions_pkey PRIMARY KEY (id);


--
-- Name: oidc_refresh_tokens oidc_refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_refresh_tokens
    ADD CONSTRAINT oidc_refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: oidc_sessions oidc_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_sessions
    ADD CONSTRAINT oidc_sessions_pkey PRIMARY KEY (id);


--
-- Name: rag_eval_dataset_records rag_eval_dataset_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rag_eval_dataset_records
    ADD CONSTRAINT rag_eval_dataset_records_pkey PRIMARY KEY (id);


--
-- Name: rag_eval_datasets rag_eval_datasets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rag_eval_datasets
    ADD CONSTRAINT rag_eval_datasets_pkey PRIMARY KEY (id);


--
-- Name: rag_eval_evaluation_records rag_eval_evaluation_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rag_eval_evaluation_records
    ADD CONSTRAINT rag_eval_evaluation_records_pkey PRIMARY KEY (id);


--
-- Name: rag_eval_evaluations rag_eval_evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rag_eval_evaluations
    ADD CONSTRAINT rag_eval_evaluations_pkey PRIMARY KEY (id);


--
-- Name: rbac_permissions rbac_permissions_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rbac_permissions
    ADD CONSTRAINT rbac_permissions_code_unique UNIQUE (code);


--
-- Name: rbac_permissions rbac_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rbac_permissions
    ADD CONSTRAINT rbac_permissions_pkey PRIMARY KEY (id);


--
-- Name: rbac_role_permissions rbac_role_permissions_role_id_permission_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rbac_role_permissions
    ADD CONSTRAINT rbac_role_permissions_role_id_permission_id_pk PRIMARY KEY (role_id, permission_id);


--
-- Name: rbac_roles rbac_roles_name_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rbac_roles
    ADD CONSTRAINT rbac_roles_name_unique UNIQUE (name);


--
-- Name: rbac_roles rbac_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rbac_roles
    ADD CONSTRAINT rbac_roles_pkey PRIMARY KEY (id);


--
-- Name: rbac_user_roles rbac_user_roles_user_id_role_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rbac_user_roles
    ADD CONSTRAINT rbac_user_roles_user_id_role_id_pk PRIMARY KEY (user_id, role_id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: session_groups session_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_groups
    ADD CONSTRAINT session_groups_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: threads threads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.threads
    ADD CONSTRAINT threads_pkey PRIMARY KEY (id);


--
-- Name: topic_documents topic_documents_document_id_topic_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topic_documents
    ADD CONSTRAINT topic_documents_document_id_topic_id_pk PRIMARY KEY (document_id, topic_id);


--
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: unstructured_chunks unstructured_chunks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unstructured_chunks
    ADD CONSTRAINT unstructured_chunks_pkey PRIMARY KEY (id);


--
-- Name: user_installed_plugins user_installed_plugins_user_id_identifier_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_installed_plugins
    ADD CONSTRAINT user_installed_plugins_user_id_identifier_pk PRIMARY KEY (user_id, identifier);


--
-- Name: user_memories_contexts user_memories_contexts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_memories_contexts
    ADD CONSTRAINT user_memories_contexts_pkey PRIMARY KEY (id);


--
-- Name: user_memories_experiences user_memories_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_memories_experiences
    ADD CONSTRAINT user_memories_experiences_pkey PRIMARY KEY (id);


--
-- Name: user_memories_identities user_memories_identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_memories_identities
    ADD CONSTRAINT user_memories_identities_pkey PRIMARY KEY (id);


--
-- Name: user_memories user_memories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_memories
    ADD CONSTRAINT user_memories_pkey PRIMARY KEY (id);


--
-- Name: user_memories_preferences user_memories_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_memories_preferences
    ADD CONSTRAINT user_memories_preferences_pkey PRIMARY KEY (id);


--
-- Name: user_settings user_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_settings
    ADD CONSTRAINT user_settings_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- Name: agents_description_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX agents_description_idx ON public.agents USING btree (description);


--
-- Name: agents_title_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX agents_title_idx ON public.agents USING btree (title);


--
-- Name: chat_groups_client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX chat_groups_client_id_user_id_unique ON public.chat_groups USING btree (client_id, user_id);


--
-- Name: chunks_client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX chunks_client_id_user_id_unique ON public.chunks USING btree (client_id, user_id);


--
-- Name: chunks_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chunks_user_id_idx ON public.chunks USING btree (user_id);


--
-- Name: client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX client_id_user_id_unique ON public.agents USING btree (client_id, user_id);


--
-- Name: documents_client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX documents_client_id_user_id_unique ON public.documents USING btree (client_id, user_id);


--
-- Name: documents_file_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX documents_file_id_idx ON public.documents USING btree (file_id);


--
-- Name: documents_file_type_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX documents_file_type_idx ON public.documents USING btree (file_type);


--
-- Name: documents_source_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX documents_source_idx ON public.documents USING btree (source);


--
-- Name: embeddings_chunk_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX embeddings_chunk_id_idx ON public.embeddings USING btree (chunk_id);


--
-- Name: embeddings_client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX embeddings_client_id_user_id_unique ON public.embeddings USING btree (client_id, user_id);


--
-- Name: file_hash_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX file_hash_idx ON public.files USING btree (file_hash);


--
-- Name: files_client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX files_client_id_user_id_unique ON public.files USING btree (client_id, user_id);


--
-- Name: knowledge_bases_client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX knowledge_bases_client_id_user_id_unique ON public.knowledge_bases USING btree (client_id, user_id);


--
-- Name: message_client_id_user_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX message_client_id_user_unique ON public.messages USING btree (client_id, user_id);


--
-- Name: message_groups_client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX message_groups_client_id_user_id_unique ON public.message_groups USING btree (client_id, user_id);


--
-- Name: message_plugins_client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX message_plugins_client_id_user_id_unique ON public.message_plugins USING btree (client_id, user_id);


--
-- Name: message_queries_client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX message_queries_client_id_user_id_unique ON public.message_queries USING btree (client_id, user_id);


--
-- Name: message_translates_client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX message_translates_client_id_user_id_unique ON public.message_translates USING btree (client_id, user_id);


--
-- Name: message_tts_client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX message_tts_client_id_user_id_unique ON public.message_tts USING btree (client_id, user_id);


--
-- Name: messages_created_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX messages_created_at_idx ON public.messages USING btree (created_at);


--
-- Name: messages_parent_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX messages_parent_id_idx ON public.messages USING btree (parent_id);


--
-- Name: messages_quota_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX messages_quota_id_idx ON public.messages USING btree (quota_id);


--
-- Name: messages_session_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX messages_session_id_idx ON public.messages USING btree (session_id);


--
-- Name: messages_thread_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX messages_thread_id_idx ON public.messages USING btree (thread_id);


--
-- Name: messages_topic_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX messages_topic_id_idx ON public.messages USING btree (topic_id);


--
-- Name: messages_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX messages_user_id_idx ON public.messages USING btree (user_id);


--
-- Name: rbac_role_permissions_permission_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rbac_role_permissions_permission_id_idx ON public.rbac_role_permissions USING btree (permission_id);


--
-- Name: rbac_role_permissions_role_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rbac_role_permissions_role_id_idx ON public.rbac_role_permissions USING btree (role_id);


--
-- Name: rbac_user_roles_role_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rbac_user_roles_role_id_idx ON public.rbac_user_roles USING btree (role_id);


--
-- Name: rbac_user_roles_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rbac_user_roles_user_id_idx ON public.rbac_user_roles USING btree (user_id);


--
-- Name: session_groups_client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX session_groups_client_id_user_id_unique ON public.session_groups USING btree (client_id, user_id);


--
-- Name: sessions_client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sessions_client_id_user_id_unique ON public.sessions USING btree (client_id, user_id);


--
-- Name: sessions_id_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sessions_id_user_id_idx ON public.sessions USING btree (id, user_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sessions_user_id_idx ON public.sessions USING btree (user_id);


--
-- Name: slug_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX slug_user_id_unique ON public.sessions USING btree (slug, user_id);


--
-- Name: threads_client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX threads_client_id_user_id_unique ON public.threads USING btree (client_id, user_id);


--
-- Name: topics_client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX topics_client_id_user_id_unique ON public.topics USING btree (client_id, user_id);


--
-- Name: topics_id_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX topics_id_user_id_idx ON public.topics USING btree (id, user_id);


--
-- Name: topics_user_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX topics_user_id_idx ON public.topics USING btree (user_id);


--
-- Name: unstructured_chunks_client_id_user_id_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unstructured_chunks_client_id_user_id_unique ON public.unstructured_chunks USING btree (client_id, user_id);


--
-- Name: user_memories_contexts_description_vector_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_memories_contexts_description_vector_index ON public.user_memories_contexts USING hnsw (description_vector public.vector_cosine_ops);


--
-- Name: user_memories_contexts_title_vector_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_memories_contexts_title_vector_index ON public.user_memories_contexts USING hnsw (title_vector public.vector_cosine_ops);


--
-- Name: user_memories_contexts_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_memories_contexts_type_index ON public.user_memories_contexts USING btree (type);


--
-- Name: user_memories_details_vector_1024_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_memories_details_vector_1024_index ON public.user_memories USING hnsw (details_vector_1024 public.vector_cosine_ops);


--
-- Name: user_memories_experiences_action_vector_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_memories_experiences_action_vector_index ON public.user_memories_experiences USING hnsw (action_vector public.vector_cosine_ops);


--
-- Name: user_memories_experiences_key_learning_vector_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_memories_experiences_key_learning_vector_index ON public.user_memories_experiences USING hnsw (key_learning_vector public.vector_cosine_ops);


--
-- Name: user_memories_experiences_situation_vector_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_memories_experiences_situation_vector_index ON public.user_memories_experiences USING hnsw (situation_vector public.vector_cosine_ops);


--
-- Name: user_memories_experiences_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_memories_experiences_type_index ON public.user_memories_experiences USING btree (type);


--
-- Name: user_memories_identities_description_vector_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_memories_identities_description_vector_index ON public.user_memories_identities USING hnsw (description_vector public.vector_cosine_ops);


--
-- Name: user_memories_identities_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_memories_identities_type_index ON public.user_memories_identities USING btree (type);


--
-- Name: user_memories_preferences_conclusion_directives_vector_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_memories_preferences_conclusion_directives_vector_index ON public.user_memories_preferences USING hnsw (conclusion_directives_vector public.vector_cosine_ops);


--
-- Name: user_memories_summary_vector_1024_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_memories_summary_vector_1024_index ON public.user_memories USING hnsw (summary_vector_1024 public.vector_cosine_ops);


--
-- Name: agents_files agents_files_agent_id_agents_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents_files
    ADD CONSTRAINT agents_files_agent_id_agents_id_fk FOREIGN KEY (agent_id) REFERENCES public.agents(id) ON DELETE CASCADE;


--
-- Name: agents_files agents_files_file_id_files_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents_files
    ADD CONSTRAINT agents_files_file_id_files_id_fk FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;


--
-- Name: agents_files agents_files_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents_files
    ADD CONSTRAINT agents_files_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: agents_knowledge_bases agents_knowledge_bases_agent_id_agents_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents_knowledge_bases
    ADD CONSTRAINT agents_knowledge_bases_agent_id_agents_id_fk FOREIGN KEY (agent_id) REFERENCES public.agents(id) ON DELETE CASCADE;


--
-- Name: agents_knowledge_bases agents_knowledge_bases_knowledge_base_id_knowledge_bases_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents_knowledge_bases
    ADD CONSTRAINT agents_knowledge_bases_knowledge_base_id_knowledge_bases_id_fk FOREIGN KEY (knowledge_base_id) REFERENCES public.knowledge_bases(id) ON DELETE CASCADE;


--
-- Name: agents_knowledge_bases agents_knowledge_bases_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents_knowledge_bases
    ADD CONSTRAINT agents_knowledge_bases_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: agents_to_sessions agents_to_sessions_agent_id_agents_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents_to_sessions
    ADD CONSTRAINT agents_to_sessions_agent_id_agents_id_fk FOREIGN KEY (agent_id) REFERENCES public.agents(id) ON DELETE CASCADE;


--
-- Name: agents_to_sessions agents_to_sessions_session_id_sessions_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents_to_sessions
    ADD CONSTRAINT agents_to_sessions_session_id_sessions_id_fk FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON DELETE CASCADE;


--
-- Name: agents_to_sessions agents_to_sessions_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents_to_sessions
    ADD CONSTRAINT agents_to_sessions_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: agents agents_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: ai_models ai_models_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_models
    ADD CONSTRAINT ai_models_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: ai_providers ai_providers_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_providers
    ADD CONSTRAINT ai_providers_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: api_keys api_keys_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: async_tasks async_tasks_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.async_tasks
    ADD CONSTRAINT async_tasks_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: chat_groups_agents chat_groups_agents_agent_id_agents_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_groups_agents
    ADD CONSTRAINT chat_groups_agents_agent_id_agents_id_fk FOREIGN KEY (agent_id) REFERENCES public.agents(id) ON DELETE CASCADE;


--
-- Name: chat_groups_agents chat_groups_agents_chat_group_id_chat_groups_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_groups_agents
    ADD CONSTRAINT chat_groups_agents_chat_group_id_chat_groups_id_fk FOREIGN KEY (chat_group_id) REFERENCES public.chat_groups(id) ON DELETE CASCADE;


--
-- Name: chat_groups_agents chat_groups_agents_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_groups_agents
    ADD CONSTRAINT chat_groups_agents_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: chat_groups chat_groups_group_id_session_groups_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_groups
    ADD CONSTRAINT chat_groups_group_id_session_groups_id_fk FOREIGN KEY (group_id) REFERENCES public.session_groups(id) ON DELETE SET NULL;


--
-- Name: chat_groups chat_groups_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_groups
    ADD CONSTRAINT chat_groups_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: chunks chunks_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chunks
    ADD CONSTRAINT chunks_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: document_chunks document_chunks_chunk_id_chunks_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_chunks
    ADD CONSTRAINT document_chunks_chunk_id_chunks_id_fk FOREIGN KEY (chunk_id) REFERENCES public.chunks(id) ON DELETE CASCADE;


--
-- Name: document_chunks document_chunks_document_id_documents_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_chunks
    ADD CONSTRAINT document_chunks_document_id_documents_id_fk FOREIGN KEY (document_id) REFERENCES public.documents(id) ON DELETE CASCADE;


--
-- Name: document_chunks document_chunks_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_chunks
    ADD CONSTRAINT document_chunks_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: documents documents_file_id_files_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_file_id_files_id_fk FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE SET NULL;


--
-- Name: documents documents_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: embeddings embeddings_chunk_id_chunks_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.embeddings
    ADD CONSTRAINT embeddings_chunk_id_chunks_id_fk FOREIGN KEY (chunk_id) REFERENCES public.chunks(id) ON DELETE CASCADE;


--
-- Name: embeddings embeddings_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.embeddings
    ADD CONSTRAINT embeddings_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: file_chunks file_chunks_chunk_id_chunks_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_chunks
    ADD CONSTRAINT file_chunks_chunk_id_chunks_id_fk FOREIGN KEY (chunk_id) REFERENCES public.chunks(id) ON DELETE CASCADE;


--
-- Name: file_chunks file_chunks_file_id_files_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_chunks
    ADD CONSTRAINT file_chunks_file_id_files_id_fk FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;


--
-- Name: file_chunks file_chunks_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_chunks
    ADD CONSTRAINT file_chunks_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: files files_chunk_task_id_async_tasks_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_chunk_task_id_async_tasks_id_fk FOREIGN KEY (chunk_task_id) REFERENCES public.async_tasks(id) ON DELETE SET NULL;


--
-- Name: files files_embedding_task_id_async_tasks_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_embedding_task_id_async_tasks_id_fk FOREIGN KEY (embedding_task_id) REFERENCES public.async_tasks(id) ON DELETE SET NULL;


--
-- Name: files files_file_hash_global_files_hash_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_file_hash_global_files_hash_id_fk FOREIGN KEY (file_hash) REFERENCES public.global_files(hash_id);


--
-- Name: messages_files files_to_messages_file_id_files_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages_files
    ADD CONSTRAINT files_to_messages_file_id_files_id_fk FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;


--
-- Name: messages_files files_to_messages_message_id_messages_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages_files
    ADD CONSTRAINT files_to_messages_message_id_messages_id_fk FOREIGN KEY (message_id) REFERENCES public.messages(id) ON DELETE CASCADE;


--
-- Name: files_to_sessions files_to_sessions_file_id_files_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.files_to_sessions
    ADD CONSTRAINT files_to_sessions_file_id_files_id_fk FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;


--
-- Name: files_to_sessions files_to_sessions_session_id_sessions_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.files_to_sessions
    ADD CONSTRAINT files_to_sessions_session_id_sessions_id_fk FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON DELETE CASCADE;


--
-- Name: files_to_sessions files_to_sessions_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.files_to_sessions
    ADD CONSTRAINT files_to_sessions_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: files files_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: generation_batches generation_batches_generation_topic_id_generation_topics_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generation_batches
    ADD CONSTRAINT generation_batches_generation_topic_id_generation_topics_id_fk FOREIGN KEY (generation_topic_id) REFERENCES public.generation_topics(id) ON DELETE CASCADE;


--
-- Name: generation_batches generation_batches_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generation_batches
    ADD CONSTRAINT generation_batches_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: generation_topics generation_topics_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generation_topics
    ADD CONSTRAINT generation_topics_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: generations generations_async_task_id_async_tasks_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generations
    ADD CONSTRAINT generations_async_task_id_async_tasks_id_fk FOREIGN KEY (async_task_id) REFERENCES public.async_tasks(id) ON DELETE SET NULL;


--
-- Name: generations generations_file_id_files_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generations
    ADD CONSTRAINT generations_file_id_files_id_fk FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;


--
-- Name: generations generations_generation_batch_id_generation_batches_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generations
    ADD CONSTRAINT generations_generation_batch_id_generation_batches_id_fk FOREIGN KEY (generation_batch_id) REFERENCES public.generation_batches(id) ON DELETE CASCADE;


--
-- Name: generations generations_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generations
    ADD CONSTRAINT generations_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: global_files global_files_creator_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.global_files
    ADD CONSTRAINT global_files_creator_users_id_fk FOREIGN KEY (creator) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: knowledge_base_files knowledge_base_files_file_id_files_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knowledge_base_files
    ADD CONSTRAINT knowledge_base_files_file_id_files_id_fk FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;


--
-- Name: knowledge_base_files knowledge_base_files_knowledge_base_id_knowledge_bases_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knowledge_base_files
    ADD CONSTRAINT knowledge_base_files_knowledge_base_id_knowledge_bases_id_fk FOREIGN KEY (knowledge_base_id) REFERENCES public.knowledge_bases(id) ON DELETE CASCADE;


--
-- Name: knowledge_base_files knowledge_base_files_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knowledge_base_files
    ADD CONSTRAINT knowledge_base_files_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: knowledge_bases knowledge_bases_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.knowledge_bases
    ADD CONSTRAINT knowledge_bases_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: message_chunks message_chunks_chunk_id_chunks_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_chunks
    ADD CONSTRAINT message_chunks_chunk_id_chunks_id_fk FOREIGN KEY (chunk_id) REFERENCES public.chunks(id) ON DELETE CASCADE;


--
-- Name: message_chunks message_chunks_message_id_messages_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_chunks
    ADD CONSTRAINT message_chunks_message_id_messages_id_fk FOREIGN KEY (message_id) REFERENCES public.messages(id) ON DELETE CASCADE;


--
-- Name: message_chunks message_chunks_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_chunks
    ADD CONSTRAINT message_chunks_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: message_groups message_groups_parent_group_id_message_groups_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_groups
    ADD CONSTRAINT message_groups_parent_group_id_message_groups_id_fk FOREIGN KEY (parent_group_id) REFERENCES public.message_groups(id) ON DELETE CASCADE;


--
-- Name: message_groups message_groups_parent_message_id_messages_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_groups
    ADD CONSTRAINT message_groups_parent_message_id_messages_id_fk FOREIGN KEY (parent_message_id) REFERENCES public.messages(id) ON DELETE CASCADE;


--
-- Name: message_groups message_groups_topic_id_topics_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_groups
    ADD CONSTRAINT message_groups_topic_id_topics_id_fk FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE CASCADE;


--
-- Name: message_groups message_groups_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_groups
    ADD CONSTRAINT message_groups_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: message_plugins message_plugins_id_messages_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_plugins
    ADD CONSTRAINT message_plugins_id_messages_id_fk FOREIGN KEY (id) REFERENCES public.messages(id) ON DELETE CASCADE;


--
-- Name: message_plugins message_plugins_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_plugins
    ADD CONSTRAINT message_plugins_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: message_queries message_queries_embeddings_id_embeddings_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_queries
    ADD CONSTRAINT message_queries_embeddings_id_embeddings_id_fk FOREIGN KEY (embeddings_id) REFERENCES public.embeddings(id) ON DELETE SET NULL;


--
-- Name: message_queries message_queries_message_id_messages_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_queries
    ADD CONSTRAINT message_queries_message_id_messages_id_fk FOREIGN KEY (message_id) REFERENCES public.messages(id) ON DELETE CASCADE;


--
-- Name: message_queries message_queries_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_queries
    ADD CONSTRAINT message_queries_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: message_query_chunks message_query_chunks_chunk_id_chunks_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_query_chunks
    ADD CONSTRAINT message_query_chunks_chunk_id_chunks_id_fk FOREIGN KEY (chunk_id) REFERENCES public.chunks(id) ON DELETE CASCADE;


--
-- Name: message_query_chunks message_query_chunks_id_messages_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_query_chunks
    ADD CONSTRAINT message_query_chunks_id_messages_id_fk FOREIGN KEY (id) REFERENCES public.messages(id) ON DELETE CASCADE;


--
-- Name: message_query_chunks message_query_chunks_query_id_message_queries_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_query_chunks
    ADD CONSTRAINT message_query_chunks_query_id_message_queries_id_fk FOREIGN KEY (query_id) REFERENCES public.message_queries(id) ON DELETE CASCADE;


--
-- Name: message_query_chunks message_query_chunks_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_query_chunks
    ADD CONSTRAINT message_query_chunks_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: message_translates message_translates_id_messages_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_translates
    ADD CONSTRAINT message_translates_id_messages_id_fk FOREIGN KEY (id) REFERENCES public.messages(id) ON DELETE CASCADE;


--
-- Name: message_translates message_translates_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_translates
    ADD CONSTRAINT message_translates_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: message_tts message_tts_file_id_files_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_tts
    ADD CONSTRAINT message_tts_file_id_files_id_fk FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;


--
-- Name: message_tts message_tts_id_messages_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_tts
    ADD CONSTRAINT message_tts_id_messages_id_fk FOREIGN KEY (id) REFERENCES public.messages(id) ON DELETE CASCADE;


--
-- Name: message_tts message_tts_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_tts
    ADD CONSTRAINT message_tts_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: messages messages_agent_id_agents_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_agent_id_agents_id_fk FOREIGN KEY (agent_id) REFERENCES public.agents(id) ON DELETE SET NULL;


--
-- Name: messages_files messages_files_file_id_files_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages_files
    ADD CONSTRAINT messages_files_file_id_files_id_fk FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;


--
-- Name: messages_files messages_files_message_id_messages_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages_files
    ADD CONSTRAINT messages_files_message_id_messages_id_fk FOREIGN KEY (message_id) REFERENCES public.messages(id) ON DELETE CASCADE;


--
-- Name: messages_files messages_files_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages_files
    ADD CONSTRAINT messages_files_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: messages messages_group_id_chat_groups_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_group_id_chat_groups_id_fk FOREIGN KEY (group_id) REFERENCES public.chat_groups(id) ON DELETE SET NULL;


--
-- Name: messages messages_message_group_id_message_groups_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_message_group_id_message_groups_id_fk FOREIGN KEY (message_group_id) REFERENCES public.message_groups(id) ON DELETE CASCADE;


--
-- Name: messages messages_parent_id_messages_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_parent_id_messages_id_fk FOREIGN KEY (parent_id) REFERENCES public.messages(id) ON DELETE SET NULL;


--
-- Name: messages messages_quota_id_messages_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_quota_id_messages_id_fk FOREIGN KEY (quota_id) REFERENCES public.messages(id) ON DELETE SET NULL;


--
-- Name: messages messages_session_id_sessions_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_session_id_sessions_id_fk FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON DELETE CASCADE;


--
-- Name: messages messages_thread_id_threads_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_thread_id_threads_id_fk FOREIGN KEY (thread_id) REFERENCES public.threads(id) ON DELETE CASCADE;


--
-- Name: messages messages_topic_id_topics_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_topic_id_topics_id_fk FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE CASCADE;


--
-- Name: messages messages_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: nextauth_accounts nextauth_accounts_userId_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nextauth_accounts
    ADD CONSTRAINT "nextauth_accounts_userId_users_id_fk" FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: nextauth_authenticators nextauth_authenticators_userId_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nextauth_authenticators
    ADD CONSTRAINT "nextauth_authenticators_userId_users_id_fk" FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: nextauth_sessions nextauth_sessions_userId_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nextauth_sessions
    ADD CONSTRAINT "nextauth_sessions_userId_users_id_fk" FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: oidc_access_tokens oidc_access_tokens_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_access_tokens
    ADD CONSTRAINT oidc_access_tokens_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: oidc_authorization_codes oidc_authorization_codes_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_authorization_codes
    ADD CONSTRAINT oidc_authorization_codes_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: oidc_consents oidc_consents_client_id_oidc_clients_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_consents
    ADD CONSTRAINT oidc_consents_client_id_oidc_clients_id_fk FOREIGN KEY (client_id) REFERENCES public.oidc_clients(id) ON DELETE CASCADE;


--
-- Name: oidc_consents oidc_consents_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_consents
    ADD CONSTRAINT oidc_consents_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: oidc_device_codes oidc_device_codes_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_device_codes
    ADD CONSTRAINT oidc_device_codes_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: oidc_grants oidc_grants_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_grants
    ADD CONSTRAINT oidc_grants_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: oidc_refresh_tokens oidc_refresh_tokens_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_refresh_tokens
    ADD CONSTRAINT oidc_refresh_tokens_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: oidc_sessions oidc_sessions_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oidc_sessions
    ADD CONSTRAINT oidc_sessions_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: rag_eval_dataset_records rag_eval_dataset_records_dataset_id_rag_eval_datasets_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rag_eval_dataset_records
    ADD CONSTRAINT rag_eval_dataset_records_dataset_id_rag_eval_datasets_id_fk FOREIGN KEY (dataset_id) REFERENCES public.rag_eval_datasets(id) ON DELETE CASCADE;


--
-- Name: rag_eval_dataset_records rag_eval_dataset_records_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rag_eval_dataset_records
    ADD CONSTRAINT rag_eval_dataset_records_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: rag_eval_datasets rag_eval_datasets_knowledge_base_id_knowledge_bases_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rag_eval_datasets
    ADD CONSTRAINT rag_eval_datasets_knowledge_base_id_knowledge_bases_id_fk FOREIGN KEY (knowledge_base_id) REFERENCES public.knowledge_bases(id) ON DELETE CASCADE;


--
-- Name: rag_eval_datasets rag_eval_datasets_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rag_eval_datasets
    ADD CONSTRAINT rag_eval_datasets_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: rag_eval_evaluation_records rag_eval_evaluation_records_dataset_record_id_rag_eval_dataset_; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rag_eval_evaluation_records
    ADD CONSTRAINT rag_eval_evaluation_records_dataset_record_id_rag_eval_dataset_ FOREIGN KEY (dataset_record_id) REFERENCES public.rag_eval_dataset_records(id) ON DELETE CASCADE;


--
-- Name: rag_eval_evaluation_records rag_eval_evaluation_records_evaluation_id_rag_eval_evaluations_; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rag_eval_evaluation_records
    ADD CONSTRAINT rag_eval_evaluation_records_evaluation_id_rag_eval_evaluations_ FOREIGN KEY (evaluation_id) REFERENCES public.rag_eval_evaluations(id) ON DELETE CASCADE;


--
-- Name: rag_eval_evaluation_records rag_eval_evaluation_records_question_embedding_id_embeddings_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rag_eval_evaluation_records
    ADD CONSTRAINT rag_eval_evaluation_records_question_embedding_id_embeddings_id FOREIGN KEY (question_embedding_id) REFERENCES public.embeddings(id) ON DELETE SET NULL;


--
-- Name: rag_eval_evaluation_records rag_eval_evaluation_records_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rag_eval_evaluation_records
    ADD CONSTRAINT rag_eval_evaluation_records_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: rag_eval_evaluations rag_eval_evaluations_dataset_id_rag_eval_datasets_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rag_eval_evaluations
    ADD CONSTRAINT rag_eval_evaluations_dataset_id_rag_eval_datasets_id_fk FOREIGN KEY (dataset_id) REFERENCES public.rag_eval_datasets(id) ON DELETE CASCADE;


--
-- Name: rag_eval_evaluations rag_eval_evaluations_knowledge_base_id_knowledge_bases_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rag_eval_evaluations
    ADD CONSTRAINT rag_eval_evaluations_knowledge_base_id_knowledge_bases_id_fk FOREIGN KEY (knowledge_base_id) REFERENCES public.knowledge_bases(id) ON DELETE CASCADE;


--
-- Name: rag_eval_evaluations rag_eval_evaluations_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rag_eval_evaluations
    ADD CONSTRAINT rag_eval_evaluations_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: rbac_role_permissions rbac_role_permissions_permission_id_rbac_permissions_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rbac_role_permissions
    ADD CONSTRAINT rbac_role_permissions_permission_id_rbac_permissions_id_fk FOREIGN KEY (permission_id) REFERENCES public.rbac_permissions(id) ON DELETE CASCADE;


--
-- Name: rbac_role_permissions rbac_role_permissions_role_id_rbac_roles_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rbac_role_permissions
    ADD CONSTRAINT rbac_role_permissions_role_id_rbac_roles_id_fk FOREIGN KEY (role_id) REFERENCES public.rbac_roles(id) ON DELETE CASCADE;


--
-- Name: rbac_user_roles rbac_user_roles_role_id_rbac_roles_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rbac_user_roles
    ADD CONSTRAINT rbac_user_roles_role_id_rbac_roles_id_fk FOREIGN KEY (role_id) REFERENCES public.rbac_roles(id) ON DELETE CASCADE;


--
-- Name: rbac_user_roles rbac_user_roles_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rbac_user_roles
    ADD CONSTRAINT rbac_user_roles_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: session_groups session_groups_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_groups
    ADD CONSTRAINT session_groups_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_group_id_session_groups_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_group_id_session_groups_id_fk FOREIGN KEY (group_id) REFERENCES public.session_groups(id) ON DELETE SET NULL;


--
-- Name: sessions sessions_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: threads threads_parent_thread_id_threads_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.threads
    ADD CONSTRAINT threads_parent_thread_id_threads_id_fk FOREIGN KEY (parent_thread_id) REFERENCES public.threads(id) ON DELETE SET NULL;


--
-- Name: threads threads_topic_id_topics_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.threads
    ADD CONSTRAINT threads_topic_id_topics_id_fk FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE CASCADE;


--
-- Name: threads threads_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.threads
    ADD CONSTRAINT threads_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: topic_documents topic_documents_document_id_documents_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topic_documents
    ADD CONSTRAINT topic_documents_document_id_documents_id_fk FOREIGN KEY (document_id) REFERENCES public.documents(id) ON DELETE CASCADE;


--
-- Name: topic_documents topic_documents_topic_id_topics_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topic_documents
    ADD CONSTRAINT topic_documents_topic_id_topics_id_fk FOREIGN KEY (topic_id) REFERENCES public.topics(id) ON DELETE CASCADE;


--
-- Name: topic_documents topic_documents_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topic_documents
    ADD CONSTRAINT topic_documents_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: topics topics_group_id_chat_groups_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_group_id_chat_groups_id_fk FOREIGN KEY (group_id) REFERENCES public.chat_groups(id) ON DELETE CASCADE;


--
-- Name: topics topics_session_id_sessions_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_session_id_sessions_id_fk FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON DELETE CASCADE;


--
-- Name: topics topics_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: unstructured_chunks unstructured_chunks_composite_id_chunks_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unstructured_chunks
    ADD CONSTRAINT unstructured_chunks_composite_id_chunks_id_fk FOREIGN KEY (composite_id) REFERENCES public.chunks(id) ON DELETE CASCADE;


--
-- Name: unstructured_chunks unstructured_chunks_file_id_files_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unstructured_chunks
    ADD CONSTRAINT unstructured_chunks_file_id_files_id_fk FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;


--
-- Name: unstructured_chunks unstructured_chunks_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unstructured_chunks
    ADD CONSTRAINT unstructured_chunks_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_installed_plugins user_installed_plugins_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_installed_plugins
    ADD CONSTRAINT user_installed_plugins_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_memories_contexts user_memories_contexts_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_memories_contexts
    ADD CONSTRAINT user_memories_contexts_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_memories_experiences user_memories_experiences_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_memories_experiences
    ADD CONSTRAINT user_memories_experiences_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_memories_experiences user_memories_experiences_user_memory_id_user_memories_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_memories_experiences
    ADD CONSTRAINT user_memories_experiences_user_memory_id_user_memories_id_fk FOREIGN KEY (user_memory_id) REFERENCES public.user_memories(id) ON DELETE CASCADE;


--
-- Name: user_memories_identities user_memories_identities_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_memories_identities
    ADD CONSTRAINT user_memories_identities_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_memories_identities user_memories_identities_user_memory_id_user_memories_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_memories_identities
    ADD CONSTRAINT user_memories_identities_user_memory_id_user_memories_id_fk FOREIGN KEY (user_memory_id) REFERENCES public.user_memories(id) ON DELETE CASCADE;


--
-- Name: user_memories_preferences user_memories_preferences_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_memories_preferences
    ADD CONSTRAINT user_memories_preferences_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_memories_preferences user_memories_preferences_user_memory_id_user_memories_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_memories_preferences
    ADD CONSTRAINT user_memories_preferences_user_memory_id_user_memories_id_fk FOREIGN KEY (user_memory_id) REFERENCES public.user_memories(id) ON DELETE CASCADE;


--
-- Name: user_memories user_memories_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_memories
    ADD CONSTRAINT user_memories_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_settings user_settings_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_settings
    ADD CONSTRAINT user_settings_id_users_id_fk FOREIGN KEY (id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict hj9Qc5duKdmGtbW5d2EXydIeeGZwb7Fo83Vrwanz21RePrbiiqqVOysbfY6JbxO


--
-- Dbmate schema migrations
--

