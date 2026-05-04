--
-- PostgreSQL database dump
--

\restrict 94QmaVmgUrR03Zw7MRhfkyhH2LP8nL0SBc7L7DkzyZg1y05ydWb5eovfwHHOaS6

-- Dumped from database version 16.11 (Debian 16.11-1.pgdg12+1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-1.pgdg22.04+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: adapter; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.adapter (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    "table" character varying(100),
    use_same_db boolean,
    type character varying(100),
    database_type character varying(100),
    host character varying(100),
    port integer,
    "user" character varying(100),
    password character varying(150),
    database character varying(100)
);


--
-- Name: application; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.application (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    display_name character varying(100),
    logo character varying(200),
    homepage_url character varying(100),
    description character varying(100),
    organization character varying(100),
    cert character varying(100),
    default_group character varying(100),
    header_html text,
    enable_password boolean,
    enable_sign_up boolean,
    disable_signin boolean,
    enable_signin_session boolean,
    enable_auto_signin boolean,
    enable_code_signin boolean,
    enable_saml_compress boolean,
    enable_saml_c14n10 boolean,
    enable_saml_post_binding boolean,
    use_email_as_saml_name_id boolean,
    enable_web_authn boolean,
    enable_link_with_email boolean,
    org_choice_mode character varying(255),
    saml_reply_url character varying(500),
    providers text,
    signin_methods character varying(2000),
    signup_items character varying(3000),
    signin_items text,
    grant_types character varying(1000),
    tags text,
    saml_attributes character varying(1000),
    is_shared boolean,
    ip_restriction character varying(255),
    client_id character varying(100),
    client_secret character varying(100),
    redirect_uris character varying(1000),
    forced_redirect_origin character varying(100),
    token_format character varying(100),
    token_signing_method character varying(100),
    token_fields character varying(1000),
    expire_in_hours integer,
    refresh_expire_in_hours integer,
    signup_url character varying(200),
    signin_url character varying(200),
    forget_url character varying(200),
    affiliation_url character varying(100),
    ip_whitelist character varying(200),
    terms_of_use character varying(100),
    signup_html text,
    signin_html text,
    theme_data json,
    footer_html text,
    form_css text,
    form_css_mobile text,
    form_offset integer,
    form_side_html text,
    form_background_url character varying(200),
    form_background_url_mobile character varying(200),
    failed_signin_limit integer,
    failed_signin_frozen_time integer
);


--
-- Name: casbin_api_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.casbin_api_rule (
    id bigint NOT NULL,
    ptype character varying(100) DEFAULT ''::character varying NOT NULL,
    v0 character varying(100) DEFAULT ''::character varying NOT NULL,
    v1 character varying(100) DEFAULT ''::character varying NOT NULL,
    v2 character varying(100) DEFAULT ''::character varying NOT NULL,
    v3 character varying(100) DEFAULT ''::character varying NOT NULL,
    v4 character varying(100) DEFAULT ''::character varying NOT NULL,
    v5 character varying(100) DEFAULT ''::character varying NOT NULL
);


--
-- Name: casbin_api_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.casbin_api_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: casbin_api_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.casbin_api_rule_id_seq OWNED BY public.casbin_api_rule.id;


--
-- Name: casbin_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.casbin_rule (
    id bigint NOT NULL,
    ptype character varying(100) DEFAULT ''::character varying NOT NULL,
    v0 character varying(100) DEFAULT ''::character varying NOT NULL,
    v1 character varying(100) DEFAULT ''::character varying NOT NULL,
    v2 character varying(100) DEFAULT ''::character varying NOT NULL,
    v3 character varying(100) DEFAULT ''::character varying NOT NULL,
    v4 character varying(100) DEFAULT ''::character varying NOT NULL,
    v5 character varying(100) DEFAULT ''::character varying NOT NULL
);


--
-- Name: casbin_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.casbin_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: casbin_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.casbin_rule_id_seq OWNED BY public.casbin_rule.id;


--
-- Name: casbin_user_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.casbin_user_rule (
    id bigint NOT NULL,
    ptype character varying(100) DEFAULT ''::character varying NOT NULL,
    v0 character varying(100) DEFAULT ''::character varying NOT NULL,
    v1 character varying(100) DEFAULT ''::character varying NOT NULL,
    v2 character varying(100) DEFAULT ''::character varying NOT NULL,
    v3 character varying(100) DEFAULT ''::character varying NOT NULL,
    v4 character varying(100) DEFAULT ''::character varying NOT NULL,
    v5 character varying(100) DEFAULT ''::character varying NOT NULL
);


--
-- Name: casbin_user_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.casbin_user_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: casbin_user_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.casbin_user_rule_id_seq OWNED BY public.casbin_user_rule.id;


--
-- Name: cert; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cert (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    display_name character varying(100),
    scope character varying(100),
    type character varying(100),
    crypto_algorithm character varying(100),
    bit_size integer,
    expire_in_years integer,
    certificate text,
    private_key text
);


--
-- Name: enforcer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.enforcer (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    updated_time character varying(100),
    display_name character varying(100),
    description character varying(100),
    model character varying(100),
    adapter character varying(100),
    enforcer text
);


--
-- Name: group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."group" (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    updated_time character varying(100),
    display_name character varying(100),
    manager character varying(100),
    contact_email character varying(100),
    type character varying(100),
    parent_id character varying(100),
    is_top_group boolean,
    title character varying(255),
    key character varying(255),
    children text,
    is_enabled boolean
);


--
-- Name: invitation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invitation (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    updated_time character varying(100),
    display_name character varying(100),
    code character varying(100),
    is_regexp boolean,
    quota integer,
    used_count integer,
    application character varying(100),
    username character varying(100),
    email character varying(100),
    phone character varying(100),
    signup_group character varying(100),
    default_code character varying(100),
    state character varying(100)
);


--
-- Name: ldap; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ldap (
    id character varying(100) NOT NULL,
    owner character varying(100),
    created_time character varying(100),
    server_name character varying(100),
    host character varying(100),
    port integer,
    enable_ssl boolean,
    allow_self_signed_cert boolean,
    username character varying(100),
    password character varying(100),
    base_dn character varying(100),
    filter character varying(200),
    filter_fields character varying(100),
    default_group character varying(100),
    password_type character varying(100),
    auto_sync integer,
    last_sync character varying(100)
);


--
-- Name: model; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.model (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    display_name character varying(100),
    description character varying(100),
    model_text text
);


--
-- Name: organization; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    display_name character varying(100),
    website_url character varying(100),
    logo character varying(200),
    logo_dark character varying(200),
    favicon character varying(200),
    has_privilege_consent boolean,
    password_type character varying(100),
    password_salt character varying(100),
    password_options character varying(100),
    password_obfuscator_type character varying(100),
    password_obfuscator_key character varying(100),
    password_expire_days integer,
    country_codes text,
    default_avatar character varying(200),
    default_application character varying(100),
    user_types text,
    tags text,
    languages character varying(255),
    theme_data json,
    master_password character varying(200),
    default_password character varying(200),
    master_verification_code character varying(100),
    ip_whitelist character varying(200),
    init_score integer,
    enable_soft_deletion boolean,
    is_profile_public boolean,
    use_email_as_username boolean,
    enable_tour boolean,
    disable_signin boolean,
    ip_restriction character varying(255),
    nav_items text,
    widget_items text,
    mfa_items character varying(300),
    mfa_remember_in_hours integer,
    account_items text
);


--
-- Name: payment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    display_name character varying(100),
    provider character varying(100),
    type character varying(100),
    product_name character varying(100),
    product_display_name character varying(100),
    detail character varying(255),
    tag character varying(100),
    currency character varying(100),
    price double precision,
    return_url character varying(1000),
    is_recharge boolean,
    "user" character varying(100),
    person_name character varying(100),
    person_id_card character varying(100),
    person_email character varying(100),
    person_phone character varying(100),
    invoice_type character varying(100),
    invoice_title character varying(100),
    invoice_tax_id character varying(100),
    invoice_remark character varying(100),
    invoice_url character varying(255),
    out_order_id character varying(100),
    pay_url character varying(2000),
    success_url character varying(2000),
    state character varying(100),
    message character varying(2000)
);


--
-- Name: permission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permission (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    display_name character varying(100),
    description character varying(100),
    users text,
    groups text,
    roles text,
    domains text,
    model character varying(100),
    adapter character varying(100),
    resource_type character varying(100),
    resources text,
    actions text,
    effect character varying(100),
    is_enabled boolean,
    submitter character varying(100),
    approver character varying(100),
    approve_time character varying(100),
    state character varying(100)
);


--
-- Name: permission_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permission_rule (
    id bigint NOT NULL,
    ptype character varying(100) DEFAULT ''::character varying NOT NULL,
    v0 character varying(100) DEFAULT ''::character varying NOT NULL,
    v1 character varying(100) DEFAULT ''::character varying NOT NULL,
    v2 character varying(100) DEFAULT ''::character varying NOT NULL,
    v3 character varying(100) DEFAULT ''::character varying NOT NULL,
    v4 character varying(100) DEFAULT ''::character varying NOT NULL,
    v5 character varying(100) DEFAULT ''::character varying NOT NULL
);


--
-- Name: permission_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.permission_rule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: permission_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.permission_rule_id_seq OWNED BY public.permission_rule.id;


--
-- Name: plan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plan (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    display_name character varying(100),
    description character varying(100),
    price double precision,
    currency character varying(100),
    period character varying(100),
    product character varying(100),
    payment_providers character varying(100),
    is_enabled boolean,
    role character varying(100)
);


--
-- Name: pricing; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pricing (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    display_name character varying(100),
    description character varying(100),
    plans text,
    is_enabled boolean,
    trial_duration integer,
    application character varying(100)
);


--
-- Name: product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    display_name character varying(100),
    image character varying(100),
    detail character varying(1000),
    description character varying(200),
    tag character varying(100),
    currency character varying(100),
    price double precision,
    quantity integer,
    sold integer,
    is_recharge boolean,
    providers character varying(255),
    return_url character varying(1000),
    success_url character varying(1000),
    state character varying(100)
);


--
-- Name: provider; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.provider (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    display_name character varying(100),
    category character varying(100),
    type character varying(100),
    sub_type character varying(100),
    method character varying(100),
    client_id character varying(200),
    client_secret character varying(3000),
    client_id2 character varying(100),
    client_secret2 character varying(500),
    cert character varying(100),
    custom_auth_url character varying(200),
    custom_token_url character varying(200),
    custom_user_info_url character varying(200),
    custom_logo character varying(200),
    scopes character varying(100),
    user_mapping character varying(500),
    http_headers character varying(500),
    host character varying(100),
    port integer,
    disable_ssl boolean,
    title character varying(100),
    content character varying(2000),
    receiver character varying(100),
    region_id character varying(100),
    sign_name character varying(100),
    template_code character varying(100),
    app_id character varying(100),
    endpoint character varying(1000),
    intranet_endpoint character varying(100),
    domain character varying(100),
    bucket character varying(100),
    path_prefix character varying(100),
    metadata text,
    id_p text,
    issuer_url character varying(100),
    enable_sign_authn_request boolean,
    email_regex character varying(200),
    provider_url character varying(200)
);


--
-- Name: radius_accounting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.radius_accounting (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time timestamp without time zone,
    username character varying(255),
    service_type bigint,
    nas_id character varying(255),
    nas_ip_addr character varying(255),
    nas_port_id character varying(255),
    nas_port_type bigint,
    nas_port bigint,
    framed_ip_addr character varying(255),
    framed_ip_netmask character varying(255),
    acct_session_id character varying(255),
    acct_session_time bigint,
    acct_input_total bigint,
    acct_output_total bigint,
    acct_input_packets bigint,
    acct_output_packets bigint,
    acct_terminate_cause bigint,
    last_update timestamp without time zone,
    acct_start_time timestamp without time zone,
    acct_stop_time timestamp without time zone
);


--
-- Name: record; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.record (
    id integer NOT NULL,
    owner character varying(100),
    name character varying(100),
    created_time character varying(100),
    organization character varying(100),
    client_ip character varying(100),
    "user" character varying(100),
    method character varying(100),
    request_uri character varying(1000),
    action character varying(1000),
    language character varying(100),
    object text,
    response text,
    status_code integer,
    is_triggered boolean
);


--
-- Name: record_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.record_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.record_id_seq OWNED BY public.record.id;


--
-- Name: resource; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource (
    owner character varying(100) NOT NULL,
    name character varying(180) NOT NULL,
    created_time character varying(100),
    "user" character varying(100),
    provider character varying(100),
    application character varying(100),
    tag character varying(100),
    parent character varying(100),
    file_name character varying(255),
    file_type character varying(100),
    file_format character varying(100),
    file_size integer,
    url character varying(500),
    description character varying(255)
);


--
-- Name: role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    display_name character varying(100),
    description character varying(100),
    users text,
    groups text,
    roles text,
    domains text,
    is_enabled boolean
);


--
-- Name: session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    application character varying(100) NOT NULL,
    created_time character varying(100),
    session_id text
);


--
-- Name: subscription; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscription (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    display_name character varying(100),
    created_time character varying(100),
    description character varying(100),
    "user" character varying(100),
    pricing character varying(100),
    plan character varying(100),
    payment character varying(100),
    start_time character varying(100),
    end_time character varying(100),
    period character varying(100),
    state character varying(100)
);


--
-- Name: syncer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.syncer (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    organization character varying(100),
    type character varying(100),
    database_type character varying(100),
    ssl_mode character varying(100),
    ssh_type character varying(100),
    host character varying(100),
    port integer,
    "user" character varying(100),
    password character varying(150),
    ssh_host character varying(100),
    ssh_port integer,
    ssh_user character varying(100),
    ssh_password character varying(150),
    cert character varying(100),
    database character varying(100),
    "table" character varying(100),
    table_columns text,
    affiliation_table character varying(100),
    avatar_base_url character varying(100),
    error_text text,
    sync_interval integer,
    is_read_only boolean,
    is_enabled boolean
);


--
-- Name: token; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.token (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    application character varying(100),
    organization character varying(100),
    "user" character varying(100),
    code character varying(100),
    access_token text,
    refresh_token text,
    access_token_hash character varying(100),
    refresh_token_hash character varying(100),
    expires_in integer,
    scope character varying(100),
    token_type character varying(100),
    code_challenge character varying(100),
    code_is_used boolean,
    code_expire_in bigint
);


--
-- Name: transaction; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transaction (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    display_name character varying(100),
    provider character varying(100),
    category character varying(100),
    type character varying(100),
    product_name character varying(100),
    product_display_name character varying(100),
    detail character varying(255),
    tag character varying(100),
    currency character varying(100),
    amount double precision,
    return_url character varying(1000),
    "user" character varying(100),
    application character varying(100),
    payment character varying(100),
    state character varying(100)
);


--
-- Name: user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user" (
    owner character varying(100) NOT NULL,
    name character varying(255) NOT NULL,
    created_time character varying(100),
    updated_time character varying(100),
    deleted_time character varying(100),
    id character varying(100),
    external_id character varying(100),
    type character varying(100),
    password character varying(150),
    password_salt character varying(100),
    password_type character varying(100),
    display_name character varying(100),
    first_name character varying(100),
    last_name character varying(100),
    avatar character varying(500),
    avatar_type character varying(100),
    permanent_avatar character varying(500),
    email character varying(100),
    email_verified boolean,
    phone character varying(100),
    country_code character varying(6),
    region character varying(100),
    location character varying(100),
    address text,
    affiliation character varying(100),
    title character varying(100),
    id_card_type character varying(100),
    id_card character varying(100),
    homepage character varying(100),
    bio character varying(100),
    tag character varying(100),
    language character varying(100),
    gender character varying(100),
    birthday character varying(100),
    education character varying(100),
    score integer,
    karma integer,
    ranking integer,
    balance double precision,
    currency character varying(100),
    is_default_avatar boolean,
    is_online boolean,
    is_admin boolean,
    is_forbidden boolean,
    is_deleted boolean,
    signup_application character varying(100),
    hash character varying(100),
    pre_hash character varying(100),
    access_key character varying(100),
    access_secret character varying(100),
    access_token text,
    created_ip character varying(100),
    last_signin_time character varying(100),
    last_signin_ip character varying(100),
    github character varying(100),
    google character varying(100),
    qq character varying(100),
    wechat character varying(100),
    facebook character varying(100),
    dingtalk character varying(100),
    weibo character varying(100),
    gitee character varying(100),
    linkedin character varying(100),
    wecom character varying(100),
    lark character varying(100),
    gitlab character varying(100),
    adfs character varying(100),
    baidu character varying(100),
    alipay character varying(100),
    casdoor character varying(100),
    infoflow character varying(100),
    apple character varying(100),
    azuread character varying(100),
    azureadb2c character varying(100),
    slack character varying(100),
    steam character varying(100),
    bilibili character varying(100),
    okta character varying(100),
    douyin character varying(100),
    kwai character varying(100),
    line character varying(100),
    amazon character varying(100),
    auth0 character varying(100),
    battlenet character varying(100),
    bitbucket character varying(100),
    box character varying(100),
    cloudfoundry character varying(100),
    dailymotion character varying(100),
    deezer character varying(100),
    digitalocean character varying(100),
    discord character varying(100),
    dropbox character varying(100),
    eveonline character varying(100),
    fitbit character varying(100),
    gitea character varying(100),
    heroku character varying(100),
    influxcloud character varying(100),
    instagram character varying(100),
    intercom character varying(100),
    kakao character varying(100),
    lastfm character varying(100),
    mailru character varying(100),
    meetup character varying(100),
    microsoftonline character varying(100),
    naver character varying(100),
    nextcloud character varying(100),
    onedrive character varying(100),
    oura character varying(100),
    patreon character varying(100),
    paypal character varying(100),
    salesforce character varying(100),
    shopify character varying(100),
    soundcloud character varying(100),
    spotify character varying(100),
    strava character varying(100),
    stripe character varying(100),
    tiktok character varying(100),
    tumblr character varying(100),
    twitch character varying(100),
    twitter character varying(100),
    typetalk character varying(100),
    uber character varying(100),
    vk character varying(100),
    wepay character varying(100),
    xero character varying(100),
    yahoo character varying(100),
    yammer character varying(100),
    yandex character varying(100),
    zoom character varying(100),
    metamask character varying(100),
    web3onboard character varying(100),
    custom character varying(100),
    "webauthnCredentials" bytea,
    preferred_mfa_type character varying(100),
    recovery_codes text,
    totp_secret character varying(100),
    mfa_phone_enabled boolean,
    mfa_email_enabled boolean,
    invitation character varying(100),
    invitation_code character varying(100),
    face_ids text,
    ldap character varying(100),
    properties text,
    roles text,
    permissions text,
    groups text,
    last_change_password_time character varying(100),
    last_signin_wrong_time character varying(100),
    signin_wrong_times integer,
    "managedAccounts" bytea,
    "mfaAccounts" bytea,
    mfa_items character varying(300),
    mfa_remember_deadline character varying(100),
    need_update_password boolean,
    ip_whitelist character varying(200)
);


--
-- Name: verification_record; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.verification_record (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    remote_addr character varying(100),
    type character varying(10),
    "user" character varying(100) NOT NULL,
    provider character varying(100) NOT NULL,
    receiver character varying(100) NOT NULL,
    code character varying(10) NOT NULL,
    "time" bigint NOT NULL,
    is_used boolean NOT NULL
);


--
-- Name: webhook; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.webhook (
    owner character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    created_time character varying(100),
    organization character varying(100),
    url character varying(200),
    method character varying(100),
    content_type character varying(100),
    headers text,
    events character varying(1000),
    token_fields character varying(1000),
    object_fields character varying(1000),
    is_user_extended boolean,
    single_org_only boolean,
    is_enabled boolean
);


--
-- Name: casbin_api_rule id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.casbin_api_rule ALTER COLUMN id SET DEFAULT nextval('public.casbin_api_rule_id_seq'::regclass);


--
-- Name: casbin_rule id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.casbin_rule ALTER COLUMN id SET DEFAULT nextval('public.casbin_rule_id_seq'::regclass);


--
-- Name: casbin_user_rule id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.casbin_user_rule ALTER COLUMN id SET DEFAULT nextval('public.casbin_user_rule_id_seq'::regclass);


--
-- Name: permission_rule id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permission_rule ALTER COLUMN id SET DEFAULT nextval('public.permission_rule_id_seq'::regclass);


--
-- Name: record id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.record ALTER COLUMN id SET DEFAULT nextval('public.record_id_seq'::regclass);


--
-- Name: adapter adapter_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adapter
    ADD CONSTRAINT adapter_pkey PRIMARY KEY (owner, name);


--
-- Name: application application_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_pkey PRIMARY KEY (owner, name);


--
-- Name: casbin_api_rule casbin_api_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.casbin_api_rule
    ADD CONSTRAINT casbin_api_rule_pkey PRIMARY KEY (id);


--
-- Name: casbin_rule casbin_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.casbin_rule
    ADD CONSTRAINT casbin_rule_pkey PRIMARY KEY (id);


--
-- Name: casbin_user_rule casbin_user_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.casbin_user_rule
    ADD CONSTRAINT casbin_user_rule_pkey PRIMARY KEY (id);


--
-- Name: cert cert_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cert
    ADD CONSTRAINT cert_pkey PRIMARY KEY (owner, name);


--
-- Name: enforcer enforcer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.enforcer
    ADD CONSTRAINT enforcer_pkey PRIMARY KEY (owner, name);


--
-- Name: group group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (owner, name);


--
-- Name: invitation invitation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitation
    ADD CONSTRAINT invitation_pkey PRIMARY KEY (owner, name);


--
-- Name: ldap ldap_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ldap
    ADD CONSTRAINT ldap_pkey PRIMARY KEY (id);


--
-- Name: model model_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.model
    ADD CONSTRAINT model_pkey PRIMARY KEY (owner, name);


--
-- Name: organization organization_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (owner, name);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (owner, name);


--
-- Name: permission permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permission
    ADD CONSTRAINT permission_pkey PRIMARY KEY (owner, name);


--
-- Name: permission_rule permission_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permission_rule
    ADD CONSTRAINT permission_rule_pkey PRIMARY KEY (id);


--
-- Name: plan plan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plan
    ADD CONSTRAINT plan_pkey PRIMARY KEY (owner, name);


--
-- Name: pricing pricing_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pricing
    ADD CONSTRAINT pricing_pkey PRIMARY KEY (owner, name);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (owner, name);


--
-- Name: provider provider_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider
    ADD CONSTRAINT provider_pkey PRIMARY KEY (owner, name);


--
-- Name: radius_accounting radius_accounting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.radius_accounting
    ADD CONSTRAINT radius_accounting_pkey PRIMARY KEY (owner, name);


--
-- Name: record record_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.record
    ADD CONSTRAINT record_pkey PRIMARY KEY (id);


--
-- Name: resource resource_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (owner, name);


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (owner, name);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (owner, name, application);


--
-- Name: subscription subscription_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_pkey PRIMARY KEY (owner, name);


--
-- Name: syncer syncer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.syncer
    ADD CONSTRAINT syncer_pkey PRIMARY KEY (owner, name);


--
-- Name: token token_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.token
    ADD CONSTRAINT token_pkey PRIMARY KEY (owner, name);


--
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (owner, name);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (owner, name);


--
-- Name: verification_record verification_record_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_record
    ADD CONSTRAINT verification_record_pkey PRIMARY KEY (owner, name);


--
-- Name: webhook webhook_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhook
    ADD CONSTRAINT webhook_pkey PRIMARY KEY (owner, name);


--
-- Name: IDX_casbin_api_rule_ptype; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_api_rule_ptype" ON public.casbin_api_rule USING btree (ptype);


--
-- Name: IDX_casbin_api_rule_v0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_api_rule_v0" ON public.casbin_api_rule USING btree (v0);


--
-- Name: IDX_casbin_api_rule_v1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_api_rule_v1" ON public.casbin_api_rule USING btree (v1);


--
-- Name: IDX_casbin_api_rule_v2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_api_rule_v2" ON public.casbin_api_rule USING btree (v2);


--
-- Name: IDX_casbin_api_rule_v3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_api_rule_v3" ON public.casbin_api_rule USING btree (v3);


--
-- Name: IDX_casbin_api_rule_v4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_api_rule_v4" ON public.casbin_api_rule USING btree (v4);


--
-- Name: IDX_casbin_api_rule_v5; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_api_rule_v5" ON public.casbin_api_rule USING btree (v5);


--
-- Name: IDX_casbin_rule_ptype; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_rule_ptype" ON public.casbin_rule USING btree (ptype);


--
-- Name: IDX_casbin_rule_v0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_rule_v0" ON public.casbin_rule USING btree (v0);


--
-- Name: IDX_casbin_rule_v1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_rule_v1" ON public.casbin_rule USING btree (v1);


--
-- Name: IDX_casbin_rule_v2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_rule_v2" ON public.casbin_rule USING btree (v2);


--
-- Name: IDX_casbin_rule_v3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_rule_v3" ON public.casbin_rule USING btree (v3);


--
-- Name: IDX_casbin_rule_v4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_rule_v4" ON public.casbin_rule USING btree (v4);


--
-- Name: IDX_casbin_rule_v5; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_rule_v5" ON public.casbin_rule USING btree (v5);


--
-- Name: IDX_casbin_user_rule_ptype; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_user_rule_ptype" ON public.casbin_user_rule USING btree (ptype);


--
-- Name: IDX_casbin_user_rule_v0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_user_rule_v0" ON public.casbin_user_rule USING btree (v0);


--
-- Name: IDX_casbin_user_rule_v1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_user_rule_v1" ON public.casbin_user_rule USING btree (v1);


--
-- Name: IDX_casbin_user_rule_v2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_user_rule_v2" ON public.casbin_user_rule USING btree (v2);


--
-- Name: IDX_casbin_user_rule_v3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_user_rule_v3" ON public.casbin_user_rule USING btree (v3);


--
-- Name: IDX_casbin_user_rule_v4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_user_rule_v4" ON public.casbin_user_rule USING btree (v4);


--
-- Name: IDX_casbin_user_rule_v5; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_casbin_user_rule_v5" ON public.casbin_user_rule USING btree (v5);


--
-- Name: IDX_invitation_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_invitation_code" ON public.invitation USING btree (code);


--
-- Name: IDX_permission_rule_ptype; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_permission_rule_ptype" ON public.permission_rule USING btree (ptype);


--
-- Name: IDX_permission_rule_v0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_permission_rule_v0" ON public.permission_rule USING btree (v0);


--
-- Name: IDX_permission_rule_v1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_permission_rule_v1" ON public.permission_rule USING btree (v1);


--
-- Name: IDX_permission_rule_v2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_permission_rule_v2" ON public.permission_rule USING btree (v2);


--
-- Name: IDX_permission_rule_v3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_permission_rule_v3" ON public.permission_rule USING btree (v3);


--
-- Name: IDX_permission_rule_v4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_permission_rule_v4" ON public.permission_rule USING btree (v4);


--
-- Name: IDX_permission_rule_v5; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_permission_rule_v5" ON public.permission_rule USING btree (v5);


--
-- Name: IDX_radius_accounting_acct_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_radius_accounting_acct_session_id" ON public.radius_accounting USING btree (acct_session_id);


--
-- Name: IDX_radius_accounting_acct_start_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_radius_accounting_acct_start_time" ON public.radius_accounting USING btree (acct_start_time);


--
-- Name: IDX_radius_accounting_acct_stop_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_radius_accounting_acct_stop_time" ON public.radius_accounting USING btree (acct_stop_time);


--
-- Name: IDX_radius_accounting_username; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_radius_accounting_username" ON public.radius_accounting USING btree (username);


--
-- Name: IDX_record_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_record_name" ON public.record USING btree (name);


--
-- Name: IDX_record_owner; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_record_owner" ON public.record USING btree (owner);


--
-- Name: IDX_token_access_token_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_token_access_token_hash" ON public.token USING btree (access_token_hash);


--
-- Name: IDX_token_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_token_code" ON public.token USING btree (code);


--
-- Name: IDX_token_refresh_token_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_token_refresh_token_hash" ON public.token USING btree (refresh_token_hash);


--
-- Name: IDX_user_created_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_user_created_time" ON public."user" USING btree (created_time);


--
-- Name: IDX_user_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_user_email" ON public."user" USING btree (email);


--
-- Name: IDX_user_external_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_user_external_id" ON public."user" USING btree (external_id);


--
-- Name: IDX_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_user_id" ON public."user" USING btree (id);


--
-- Name: IDX_user_id_card; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_user_id_card" ON public."user" USING btree (id_card);


--
-- Name: IDX_user_invitation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_user_invitation" ON public."user" USING btree (invitation);


--
-- Name: IDX_user_invitation_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_user_invitation_code" ON public."user" USING btree (invitation_code);


--
-- Name: IDX_user_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_user_phone" ON public."user" USING btree (phone);


--
-- Name: IDX_verification_record_receiver; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_verification_record_receiver" ON public.verification_record USING btree (receiver);


--
-- Name: IDX_webhook_organization; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_webhook_organization" ON public.webhook USING btree (organization);


--
-- Name: UQE_group_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "UQE_group_name" ON public."group" USING btree (name);


--
-- Name: UQE_provider_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "UQE_provider_name" ON public.provider USING btree (name);


--
-- PostgreSQL database dump complete
--

\unrestrict 94QmaVmgUrR03Zw7MRhfkyhH2LP8nL0SBc7L7DkzyZg1y05ydWb5eovfwHHOaS6

