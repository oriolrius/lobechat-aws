--
-- PostgreSQL database dump
--

\restrict Mmp6aoqxg4OfD0rwbGFAKZlANJDXg4NeN3AIKj5y22JJB11XHSuje9gDgeXOU4c

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

--
-- Data for Name: adapter; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.adapter VALUES ('built-in', 'api-adapter-built-in', '2026-04-29T08:29:23Z', 'casbin_api_rule', true, '', '', '', 0, '', '', '');
INSERT INTO public.adapter VALUES ('built-in', 'user-adapter-built-in', '2026-04-29T08:29:23Z', 'casbin_user_rule', true, '', '', '', 0, '', '', '');


--
-- Data for Name: application; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.application VALUES ('admin', 'lobechat', '2026-04-29T08:29:23Z', 'LobeChat', 'https://lobehub.com/icon-192x192.png', 'https://lobehub.com', '', 'lobechat', 'cert-built-in', '', '', true, false, false, false, false, false, false, false, false, false, false, false, '', '', '[{"owner":"","name":"provider_captcha_default","canSignUp":false,"canSignIn":false,"canUnlink":false,"countryCodes":null,"prompted":false,"signupGroup":"","rule":"","provider":null}]', '[{"name":"Password","displayName":"Password","rule":"All"},{"name":"Verification code","displayName":"Verification code","rule":"All"},{"name":"WebAuthn","displayName":"WebAuthn","rule":"None"},{"name":"Face ID","displayName":"Face ID","rule":"None"}]', '[{"name":"ID","visible":false,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"Random"},{"name":"Username","visible":true,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"None"},{"name":"Display name","visible":true,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"None"},{"name":"Password","visible":true,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"None"},{"name":"Confirm password","visible":true,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"None"},{"name":"Email","visible":true,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"Normal"},{"name":"Phone","visible":true,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"None"},{"name":"Agreement","visible":true,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"None"},{"name":"Signup button","visible":true,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"None"},{"name":"Providers","visible":true,"required":true,"prompted":false,"type":"","customCss":".provider-img {\n width: 30px;\n margin: 5px;\n }\n .provider-big-img {\n margin-bottom: 10px;\n }\n ","label":"","placeholder":"","options":null,"regex":"","rule":"small"}]', '[{"name":"Back button","visible":true,"label":"","customCss":".back-button {\n      top: 65px;\n      left: 15px;\n      position: absolute;\n}\n.back-inner-button{}","placeholder":"","rule":"None","isCustom":false},{"name":"Languages","visible":true,"label":"","customCss":".login-languages {\n    top: 55px;\n    right: 5px;\n    position: absolute;\n}","placeholder":"","rule":"None","isCustom":false},{"name":"Logo","visible":true,"label":"","customCss":".login-logo-box {}","placeholder":"","rule":"None","isCustom":false},{"name":"Signin methods","visible":true,"label":"","customCss":".signin-methods {}","placeholder":"","rule":"None","isCustom":false},{"name":"Username","visible":true,"label":"","customCss":".login-username {}\n.login-username-input{}","placeholder":"","rule":"None","isCustom":false},{"name":"Password","visible":true,"label":"","customCss":".login-password {}\n.login-password-input{}","placeholder":"","rule":"None","isCustom":false},{"name":"Agreement","visible":true,"label":"","customCss":".login-agreement {}","placeholder":"","rule":"None","isCustom":false},{"name":"Forgot password?","visible":true,"label":"","customCss":".login-forget-password {\n    display: inline-flex;\n    justify-content: space-between;\n    width: 320px;\n    margin-bottom: 25px;\n}","placeholder":"","rule":"None","isCustom":false},{"name":"Login button","visible":true,"label":"","customCss":".login-button-box {\n    margin-bottom: 5px;\n}\n.login-button {\n    width: 100%;\n}","placeholder":"","rule":"None","isCustom":false},{"name":"Signup link","visible":true,"label":"","customCss":".login-signup-link {\n    margin-bottom: 24px;\n    display: flex;\n    justify-content: end;\n}","placeholder":"","rule":"None","isCustom":false},{"name":"Providers","visible":true,"label":"","customCss":".provider-img {\n      width: 30px;\n      margin: 5px;\n}\n.provider-big-img {\n      margin-bottom: 10px;\n}","placeholder":"","rule":"small","isCustom":false}]', '["authorization_code","password","client_credentials","token","id_token","refresh_token"]', '[]', 'null', false, '', 'a387a4892ee19b1a2249', '${CASDOOR_APP_LOBECHAT_CLIENT_SECRET}', '["http://wsl.ymbihq.local:47000/api/auth/callback/casdoor"]', '', 'JWT', '', '[]', 168, 168, '', '', '', '', '', '', '', '', NULL, '', '<style>
  .login-panel {
    padding: 40px 70px 0 70px;
    border-radius: 10px;
    background-color: #ffffff;
    box-shadow: rgba(17, 12, 46, 0.15) 0px 48px 100px 0px;
  }
  .panel-logo {
    width: 64px;
  }
  .login-logo-box {
    margin-top: 20px;
  }

  #parent-area
    > main
    > div
    > div.login-content
    > div.login-panel
    > div.login-form
    > div
    > div
    > button {
    box-shadow: none !important;
    border-radius: 10px !important;
    transition-property: all;
    transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
    transition-duration: 150ms;
    border: 1px solid #eee !important;
  }

  @media (max-width: 640px) {
    .login-panel {
      padding: 40px 0 0 0;
      box-shadow: none;
    }
  }
</style>', '<style>
  .login-panel {
    padding: 40px 70px 0 70px;
    border-radius: 10px;
    background-color: #ffffff;
    box-shadow: rgba(17, 12, 46, 0.15) 0px 48px 100px 0px;
  }
  .panel-logo {
    width: 64px;
  }
  .login-logo-box {
    margin-top: 20px;
  }

  #parent-area
    > main
    > div
    > div.login-content
    > div.login-panel
    > div.login-form
    > div
    > div
    > button {
    box-shadow: none !important;
    border-radius: 10px !important;
    transition-property: all;
    transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
    transition-duration: 150ms;
    border: 1px solid #eee !important;
  }

  @media (max-width: 640px) {
    .login-panel {
      padding: 40px 0 0 0;
      box-shadow: none;
    }
  }
</style>', 2, '', '', '', 5, 15);
INSERT INTO public.application VALUES ('admin', 'app-built-in', '2026-04-29T08:29:23Z', 'Casdoor', 'https://cdn.casbin.org/img/casdoor-logo_1185x256.png', 'https://casdoor.org', '', 'built-in', 'cert-built-in', '', '', true, true, false, false, false, false, false, false, false, false, false, false, '', '', '[{"owner":"","name":"provider_captcha_default","canSignUp":false,"canSignIn":false,"canUnlink":false,"countryCodes":null,"prompted":false,"signupGroup":"","rule":"None","provider":null}]', '[{"name":"Password","displayName":"Password","rule":"All"},{"name":"Verification code","displayName":"Verification code","rule":"All"},{"name":"WebAuthn","displayName":"WebAuthn","rule":"None"},{"name":"Face ID","displayName":"Face ID","rule":"None"}]', '[{"name":"ID","visible":false,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"Random"},{"name":"Username","visible":true,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"None"},{"name":"Display name","visible":true,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"None"},{"name":"Password","visible":true,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"None"},{"name":"Confirm password","visible":true,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"None"},{"name":"Email","visible":true,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"Normal"},{"name":"Phone","visible":true,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"None"},{"name":"Agreement","visible":true,"required":true,"prompted":false,"type":"","customCss":"","label":"","placeholder":"","options":null,"regex":"","rule":"None"}]', 'null', '[]', '[]', 'null', false, '', '45f13635c08f7bdb97e4', '${CASDOOR_APP_BUILTIN_CLIENT_SECRET}', '[]', '', 'JWT', '', '[]', 168, 0, '', '', '', '', '', '', '', '', NULL, '', '', '', 2, '', '', '', 0, 0);


--
-- Data for Name: casbin_api_rule; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.casbin_api_rule VALUES (1, 'p', 'built-in', '*', '*', '*', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (2, 'p', 'app', '*', '*', '*', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (3, 'p', '*', '*', 'POST', '/api/signup', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (4, 'p', '*', '*', 'GET', '/api/get-email-and-phone', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (5, 'p', '*', '*', 'POST', '/api/login', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (6, 'p', '*', '*', 'GET', '/api/get-app-login', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (7, 'p', '*', '*', 'POST', '/api/logout', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (8, 'p', '*', '*', 'GET', '/api/logout', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (9, 'p', '*', '*', 'POST', '/api/callback', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (10, 'p', '*', '*', 'POST', '/api/device-auth', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (11, 'p', '*', '*', 'GET', '/api/get-account', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (12, 'p', '*', '*', 'GET', '/api/userinfo', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (13, 'p', '*', '*', 'GET', '/api/user', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (14, 'p', '*', '*', 'GET', '/api/health', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (15, 'p', '*', '*', '*', '/api/webhook', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (16, 'p', '*', '*', 'GET', '/api/get-qrcode', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (17, 'p', '*', '*', 'GET', '/api/get-webhook-event', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (18, 'p', '*', '*', 'GET', '/api/get-captcha-status', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (19, 'p', '*', '*', '*', '/api/login/oauth', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (20, 'p', '*', '*', 'GET', '/api/get-application', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (21, 'p', '*', '*', 'GET', '/api/get-organization-applications', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (22, 'p', '*', '*', 'GET', '/api/get-user', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (23, 'p', '*', '*', 'GET', '/api/get-user-application', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (24, 'p', '*', '*', 'GET', '/api/get-resources', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (25, 'p', '*', '*', 'GET', '/api/get-records', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (26, 'p', '*', '*', 'GET', '/api/get-product', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (27, 'p', '*', '*', 'POST', '/api/buy-product', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (28, 'p', '*', '*', 'GET', '/api/get-payment', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (29, 'p', '*', '*', 'POST', '/api/update-payment', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (30, 'p', '*', '*', 'POST', '/api/invoice-payment', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (31, 'p', '*', '*', 'POST', '/api/notify-payment', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (32, 'p', '*', '*', 'POST', '/api/unlink', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (33, 'p', '*', '*', 'POST', '/api/set-password', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (34, 'p', '*', '*', 'POST', '/api/send-verification-code', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (35, 'p', '*', '*', 'GET', '/api/get-captcha', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (36, 'p', '*', '*', 'POST', '/api/verify-captcha', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (37, 'p', '*', '*', 'POST', '/api/verify-code', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (38, 'p', '*', '*', 'POST', '/api/reset-email-or-phone', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (39, 'p', '*', '*', 'POST', '/api/upload-resource', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (40, 'p', '*', '*', 'GET', '/.well-known/openid-configuration', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (41, 'p', '*', '*', 'GET', '/.well-known/webfinger', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (42, 'p', '*', '*', '*', '/.well-known/jwks', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (43, 'p', '*', '*', 'GET', '/api/get-saml-login', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (44, 'p', '*', '*', 'POST', '/api/acs', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (45, 'p', '*', '*', 'GET', '/api/saml/metadata', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (46, 'p', '*', '*', '*', '/api/saml/redirect', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (47, 'p', '*', '*', '*', '/cas', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (48, 'p', '*', '*', '*', '/scim', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (49, 'p', '*', '*', '*', '/api/webauthn', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (50, 'p', '*', '*', 'GET', '/api/get-release', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (51, 'p', '*', '*', 'GET', '/api/get-default-application', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (52, 'p', '*', '*', 'GET', '/api/get-prometheus-info', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (53, 'p', '*', '*', '*', '/api/metrics', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (54, 'p', '*', '*', 'GET', '/api/get-pricing', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (55, 'p', '*', '*', 'GET', '/api/get-plan', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (56, 'p', '*', '*', 'GET', '/api/get-subscription', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (57, 'p', '*', '*', 'GET', '/api/get-provider', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (58, 'p', '*', '*', 'GET', '/api/get-organization-names', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (59, 'p', '*', '*', 'GET', '/api/get-all-objects', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (60, 'p', '*', '*', 'GET', '/api/get-all-actions', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (61, 'p', '*', '*', 'GET', '/api/get-all-roles', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (62, 'p', '*', '*', 'GET', '/api/run-casbin-command', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (63, 'p', '*', '*', 'POST', '/api/refresh-engines', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (64, 'p', '*', '*', 'GET', '/api/get-invitation-info', '*', '*');
INSERT INTO public.casbin_api_rule VALUES (65, 'p', '*', '*', 'GET', '/api/faceid-signin-begin', '*', '*');


--
-- Data for Name: casbin_rule; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: casbin_user_rule; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: cert; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.cert VALUES ('admin', 'cert-built-in', '2026-04-29T08:29:23Z', 'Built-in Cert', 'JWT', 'x509', 'RS256', 4096, 20, '-----BEGIN CERTIFICATE-----
MIIE3TCCAsWgAwIBAgIDAeJAMA0GCSqGSIb3DQEBCwUAMCgxDjAMBgNVBAoTBWFk
bWluMRYwFAYDVQQDEw1jZXJ0LWJ1aWx0LWluMB4XDTI1MDgxMTA4NDMyNVoXDTQ1
MDgxMTA4NDMyNVowKDEOMAwGA1UEChMFYWRtaW4xFjAUBgNVBAMTDWNlcnQtYnVp
bHQtaW4wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDqvw3MYJxa1sKq
dyU+GGDkIqGzcvkkLn/EsrZJrKaWaS7yPqjtx5VFIqn6VOUTvA0CNbaqWZT+qwM3
hjmcZ+nRzHMA62ZnMZvm7GR/njWUoSaHMJf3AT66f8WJxTsuwiYF/vbG7Z7ZUyyV
ChFA+BEwjaVghL4JFe7lMqxoBhaajYVs9RZabIw5Od7Rr4WoQYh5cGUBqgW9tn4F
MFH7poMT85LiM0hKIceQqLVWAbX0Cgr9JX2qRH5QDac+iIVnt836oRO+ojJIhK+y
f65yyPy+TM7X6PNmU/UaRGxE6K9uqbXTJDi4zNoU1tgK2cv4eIo0epxF4QcyheZs
lZnIckp/Z6cJLu2DEoMMSHVDu46AXYSuNRYkawKGlvNq3KkUXRl2+GEPvUQVNRSI
HCioHDF45SXrlrcVC27ADOo8zjRzeGXSsJ+ncVlY8nuXhPL/ZTbh9ivLRqXG6ZJX
DHXteMm8Dbept4nt+jCgTgC+0GkXqAO2+ZDfHNCu2En2BfQDWmE90G/QIC6ckLDR
Zzdp+q8CsFcEHuM6c7ur8MHn4Rcxt8aqSZJQhPd6fpFlGYdJAQH0nwJGigsOaBfV
9MPXMkGPoczWcQCFizqs1LbSDKwUiRr8zIFhyxQ78AqGwDd01l/BcuyNu4uZXPdV
QCbnxVhShVCqz8WD9fk2+Ro4k+6yjQIDAQABoxAwDjAMBgNVHRMBAf8EAjAAMA0G
CSqGSIb3DQEBCwUAA4ICAQCfQjWOtGU4JSqDkUuz7JI4Y7Or2WpDZrRearXeytgP
Ktwc/TlWxcLZ46UcxzcqK5Fs09enVWv64g3abfCwpkhU91c1E3BrZBCkRcOC2Ort
lZXPjph4H94DaKw0S4IZ6+syMXhFbFdrLlfStQRw97rmwiiz3HQQ5l5zdc4bFchW
lVDOrV5qvXfa2SSoiICnxy9d/IS4TRHN0q+21nbwWuCFRAdOXPkvzkoVnHle92UH
HWmK2CbUPXn17zv/ZRRGUJ+sCpZmHQ3l6PETZhZiYiuN5DL+pOkrJYpC8k37BuEZ
G7qmMbdMQWJENRBJRUW1cS/r5A3kTLyEJciPCEI3agHtNx043Y+3JwXIyfg41Gpx
rr6RxB7j8Az+JSJgNrU0IY9WsUb6hEbyFlwDdmCNtq+z+Yr5FLuY6y/mX0544bBg
1GKEtO8DM7Ks6+6FdOvUDWPrBC6mTmjqN1Oq9wqrHHQ+M85eG4FHl653ctKswijA
09GHgn6+j0gIGrVAjk0vRqBcshDQ5yKHeg7cECVStzRV4zFXceHC1ocBOgoMPFaS
zBdCiRPQzzi06b4060lab5tKRl7eB1yAThpTNpR/CFiU3HXGVQe3b02Dytj1xfHD
noyTPdKxeCSMNBL1233ZR0fhc9o1Og+aBaSvHa1O//M6OUk6tQYhSOabobCdiEjH
lg==
-----END CERTIFICATE-----
', '${CASDOOR_CERT_BUILTIN_PRIVATE_KEY}');


--
-- Data for Name: enforcer; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.enforcer VALUES ('built-in', 'api-enforcer-built-in', '2026-04-29T08:29:23Z', '2026-04-29 08:29:23', 'API Enforcer', '', 'built-in/api-model-built-in', 'built-in/api-adapter-built-in', NULL);
INSERT INTO public.enforcer VALUES ('built-in', 'user-enforcer-built-in', '2026-04-29T08:29:23Z', '2026-04-29 08:29:23', 'User Enforcer', '', 'built-in/user-model-built-in', 'built-in/user-adapter-built-in', NULL);


--
-- Data for Name: group; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: invitation; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: ldap; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.ldap VALUES ('ldap-built-in', 'built-in', '2025-08-11T08:43:25Z', 'BuildIn LDAP Server', 'example.com', 389, false, false, 'cn=buildin,dc=example,dc=com', '${CASDOOR_LDAP_BUILTIN_PASSWORD}', 'ou=BuildIn,dc=example,dc=com', '', 'null', '', '', 0, '');


--
-- Data for Name: model; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.model VALUES ('built-in', 'api-model-built-in', '2026-04-29T08:29:23Z', 'API Model', '', '[request_definition]
r = subOwner, subName, method, urlPath, objOwner, objName

[policy_definition]
p = subOwner, subName, method, urlPath, objOwner, objName

[role_definition]
g = _, _

[policy_effect]
e = some(where (p.eft == allow))

[matchers]
m = (r.subOwner == p.subOwner || p.subOwner == "*") && \
    (r.subName == p.subName || p.subName == "*" || r.subName != "anonymous" && p.subName == "!anonymous") && \
    (r.method == p.method || p.method == "*") && \
    (r.urlPath == p.urlPath || p.urlPath == "*") && \
    (r.objOwner == p.objOwner || p.objOwner == "*") && \
    (r.objName == p.objName || p.objName == "*") || \
    (r.subOwner == r.objOwner && r.subName == r.objName)');
INSERT INTO public.model VALUES ('built-in', 'user-model-built-in', '2026-04-29T08:29:23Z', 'Built-in Model', '', '[request_definition]
r = sub, obj, act

[policy_definition]
p = sub, obj, act

[role_definition]
g = _, _

[policy_effect]
e = some(where (p.eft == allow))

[matchers]
m = g(r.sub, p.sub) && r.obj == p.obj && r.act == p.act');


--
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.organization VALUES ('admin', 'lobechat', '2026-04-29T08:29:23Z', 'LobeChat', 'https://lobehub.com', 'https://lobehub.com/icon-192x192.png', '', 'https://lobehub.com/favicon.ico', false, 'plain', '', '["AtLeast6"]', 'Plain', '', 0, '["US"]', 'https://lobehub.com/favicon.ico', '', 'null', '[]', '["en","es","fr","de","zh","id","ja","ko","ru","vi","pt","it","ms","tr","ar","he","nl","pl","fi","sv","uk","kk","fa","cs","sk"]', NULL, '', '', '', '', 0, false, true, false, true, false, '', 'null', 'null', 'null', 12, '[{"name":"Organization","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"ID","visible":true,"viewRule":"Public","modifyRule":"Immutable","regex":""},{"name":"Name","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"Display name","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Avatar","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"User type","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"Password","visible":true,"viewRule":"Self","modifyRule":"Self","regex":""},{"name":"Email","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Phone","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Country code","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Country/Region","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Location","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Address","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Affiliation","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Title","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"ID card type","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"ID card","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"ID card info","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Homepage","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Bio","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Tag","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"Language","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"Gender","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"Birthday","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"Education","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"Score","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"Karma","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"Ranking","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"Signup application","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"API key","visible":false,"viewRule":"","modifyRule":"Self","regex":""},{"name":"Groups","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"Roles","visible":true,"viewRule":"Public","modifyRule":"Immutable","regex":""},{"name":"Permissions","visible":true,"viewRule":"Public","modifyRule":"Immutable","regex":""},{"name":"3rd-party logins","visible":true,"viewRule":"Self","modifyRule":"Self","regex":""},{"name":"Properties","visible":false,"viewRule":"Admin","modifyRule":"Admin","regex":""},{"name":"Is online","visible":true,"viewRule":"Admin","modifyRule":"Admin","regex":""},{"name":"Is admin","visible":true,"viewRule":"Admin","modifyRule":"Admin","regex":""},{"name":"Is forbidden","visible":true,"viewRule":"Admin","modifyRule":"Admin","regex":""},{"name":"Is deleted","visible":true,"viewRule":"Admin","modifyRule":"Admin","regex":""},{"name":"Multi-factor authentication","visible":true,"viewRule":"Self","modifyRule":"Self","regex":""},{"name":"WebAuthn credentials","visible":true,"viewRule":"Self","modifyRule":"Self","regex":""},{"name":"Managed accounts","visible":true,"viewRule":"Self","modifyRule":"Self","regex":""},{"name":"MFA accounts","visible":true,"viewRule":"Self","modifyRule":"Self","regex":""}]');
INSERT INTO public.organization VALUES ('admin', 'built-in', '2026-04-29T08:29:23Z', 'Built-in Organization', 'https://example.com', '', '', 'https://cdn.casbin.org/img/casbin/favicon.ico', false, 'plain', '', '["AtLeast6"]', '', '', 0, '["US","ES","FR","DE","GB","CN","JP","KR","VN","ID","SG","IN"]', 'https://cdn.casbin.org/img/casbin.svg', '', '[]', '[]', '["en","zh","es","fr","de","id","ja","ko","ru","vi","pt"]', NULL, '', '', '', '', 2000, false, false, false, true, false, '', 'null', 'null', 'null', 0, '[{"name":"Organization","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"ID","visible":true,"viewRule":"Public","modifyRule":"Immutable","regex":""},{"name":"Name","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"Display name","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Avatar","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"User type","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"Password","visible":true,"viewRule":"Self","modifyRule":"Self","regex":""},{"name":"Email","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Phone","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Country code","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"Country/Region","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Location","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Affiliation","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Title","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Homepage","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Bio","visible":true,"viewRule":"Public","modifyRule":"Self","regex":""},{"name":"Tag","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"Signup application","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"Roles","visible":true,"viewRule":"Public","modifyRule":"Immutable","regex":""},{"name":"Permissions","visible":true,"viewRule":"Public","modifyRule":"Immutable","regex":""},{"name":"Groups","visible":true,"viewRule":"Public","modifyRule":"Admin","regex":""},{"name":"3rd-party logins","visible":true,"viewRule":"Self","modifyRule":"Self","regex":""},{"name":"Properties","visible":true,"viewRule":"Admin","modifyRule":"Admin","regex":""},{"name":"Is admin","visible":true,"viewRule":"Admin","modifyRule":"Admin","regex":""},{"name":"Is forbidden","visible":true,"viewRule":"Admin","modifyRule":"Admin","regex":""},{"name":"Is deleted","visible":true,"viewRule":"Admin","modifyRule":"Admin","regex":""},{"name":"Multi-factor authentication","visible":true,"viewRule":"Self","modifyRule":"Self","regex":""},{"name":"WebAuthn credentials","visible":true,"viewRule":"Self","modifyRule":"Self","regex":""},{"name":"Managed accounts","visible":true,"viewRule":"Self","modifyRule":"Self","regex":""},{"name":"MFA accounts","visible":true,"viewRule":"Self","modifyRule":"Self","regex":""}]');


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: permission; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.permission VALUES ('built-in', 'permission-built-in', '2026-04-29T08:29:23Z', 'Built-in Permission', 'Built-in Permission', '["built-in/*"]', '[]', '[]', '[]', 'user-model-built-in', '', 'Application', '["app-built-in"]', '["Read","Write","Admin"]', 'Allow', true, 'admin', 'admin', '2025-08-11T08:43:22Z', 'Approved');


--
-- Data for Name: permission_rule; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.permission_rule VALUES (1, 'p', 'built-in/*', 'app-built-in', 'Read', 'allow', '', 'built-in/permission-built-in');
INSERT INTO public.permission_rule VALUES (2, 'p', 'built-in/*', 'app-built-in', 'Write', 'allow', '', 'built-in/permission-built-in');
INSERT INTO public.permission_rule VALUES (3, 'p', 'built-in/*', 'app-built-in', 'Admin', 'allow', '', 'built-in/permission-built-in');


--
-- Data for Name: plan; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: pricing; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: provider; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.provider VALUES ('admin', 'provider_captcha_default', '2025-08-11T08:43:23Z', 'Captcha Default', 'Captcha', 'Default', '', '', '', '', '', '', '', '', '', '', '', '', 'null', 'null', '', 0, false, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', false, '', '');


--
-- Data for Name: radius_accounting; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: record; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.record VALUES (1, '', '62acf019-f361-43c4-bc69-3651cf60ab9a', '2026-01-26T16:38:43Z', '', '172.25.240.1', '', 'POST', '/api/login?clientId=a387a4892ee19b1a2249&code_challenge=YvHEOvqnDg7JikRwYM7GHD_NDutg2SsLj154oJBrDks&code_challenge_method=S256&nonce=&redirectUri=http%3A//wsl.ymbihq.local%3A47000/api/auth/callback/casdoor&responseType=code&scope=openid+profile+email&state=&type=code', 'login', 'en', '{"application":"lobechat","organization":"lobechat","username":"admin","password":"***","autoSignin":true,"language":"","signinMethod":"Password","type":"code"}', '{status:"error", msg:"The user: lobechat/admin doesn''t exist"}', 200, true);
INSERT INTO public.record VALUES (2, '', 'fe6ce4e8-1153-493c-a19a-d8632ee309ce', '2026-01-26T16:38:51Z', '', '172.25.240.1', '', 'POST', '/api/login?clientId=a387a4892ee19b1a2249&code_challenge=YvHEOvqnDg7JikRwYM7GHD_NDutg2SsLj154oJBrDks&code_challenge_method=S256&nonce=&redirectUri=http%3A//wsl.ymbihq.local%3A47000/api/auth/callback/casdoor&responseType=code&scope=openid+profile+email&state=&type=code', 'login', 'en', '{"application":"lobechat","organization":"lobechat","username":"user","password":"***","autoSignin":true,"language":"","signinMethod":"Password","type":"code"}', '{status:"error", msg:"password or code is incorrect, you have 4 remaining chances"}', 200, true);
INSERT INTO public.record VALUES (3, 'lobechat', 'ae97b448-e194-4804-a6dd-92c10bd8a864', '2026-01-26T16:38:58Z', 'lobechat', '172.25.240.1', 'user', 'POST', '/api/login?clientId=a387a4892ee19b1a2249&code_challenge=YvHEOvqnDg7JikRwYM7GHD_NDutg2SsLj154oJBrDks&code_challenge_method=S256&nonce=&redirectUri=http%3A//wsl.ymbihq.local%3A47000/api/auth/callback/casdoor&responseType=code&scope=openid+profile+email&state=&type=code', 'login', 'en', '{"application":"lobechat","organization":"lobechat","username":"user","password":"***","autoSignin":true,"language":"","signinMethod":"Password","type":"code"}', '{status:"ok", msg:""}', 200, true);
INSERT INTO public.record VALUES (4, '', 'c02ff1c8-e6c2-444c-a6eb-1e3ee949a026', '2026-01-26T16:38:58Z', '', '10.222.8.1', '', 'POST', '/api/login/oauth/access_token', 'login/oauth/access_token', 'en', 'redirect_uri=http%3A%2F%2Fwsl.ymbihq.local%3A47000%2Fapi%2Fauth%2Fcallback%2Fcasdoor&code=8894f76098a5cd67a1b9&code_verifier=1slcYXYfPuGvyX6jgU84I3XUzsj318obnek5d1pgGkY&grant_type=authorization_code', '{status:"", msg:""}', 200, true);
INSERT INTO public.record VALUES (5, '', '5860171b-4abc-4509-beca-56a051d53d3d', '2026-01-26T16:39:26Z', '', '172.25.240.1', '', 'POST', '/api/login?clientId=a387a4892ee19b1a2249&code_challenge=ErEJ2TOBoaoJ3Cc79wDxWK-56IMHU4AfUrUGTeT5BEE&code_challenge_method=S256&nonce=&redirectUri=http%3A//wsl.ymbihq.local%3A47000/api/auth/callback/casdoor&responseType=code&scope=openid+profile+email&state=&type=code', 'login', 'en', '{"application":"lobechat","organization":"lobechat","username":"admin","password":"***","autoSignin":true,"language":"","signinMethod":"Password","type":"code"}', '{status:"error", msg:"The user: lobechat/admin doesn''t exist"}', 200, true);
INSERT INTO public.record VALUES (6, 'lobechat', '404e0cba-bdcf-49b8-b93b-089d7929a16c', '2026-01-26T16:39:31Z', 'lobechat', '172.25.240.1', 'user', 'POST', '/api/login?clientId=a387a4892ee19b1a2249&code_challenge=ErEJ2TOBoaoJ3Cc79wDxWK-56IMHU4AfUrUGTeT5BEE&code_challenge_method=S256&nonce=&redirectUri=http%3A//wsl.ymbihq.local%3A47000/api/auth/callback/casdoor&responseType=code&scope=openid+profile+email&state=&type=code', 'login', 'en', '{"application":"lobechat","organization":"lobechat","username":"user","password":"***","autoSignin":true,"language":"","signinMethod":"Password","type":"code"}', '{status:"ok", msg:""}', 200, true);
INSERT INTO public.record VALUES (7, '', '8557c6ce-75df-407f-bca0-183d0b27de3b', '2026-01-26T16:39:31Z', '', '10.222.8.1', '', 'POST', '/api/login/oauth/access_token', 'login/oauth/access_token', 'en', 'redirect_uri=http%3A%2F%2Fwsl.ymbihq.local%3A47000%2Fapi%2Fauth%2Fcallback%2Fcasdoor&code=7dc796a5f83c16bb9df7&code_verifier=sw6R0v8Y_8T3oGxLlhpP86HVWOdqtupj0PGC7NEmEU8&grant_type=authorization_code', '{status:"", msg:""}', 200, true);
INSERT INTO public.record VALUES (8, '', '287a4a87-12e8-4a9e-a188-39ee288d4366', '2026-01-27T06:05:16Z', '', '172.25.240.1', '', 'POST', '/api/login?clientId=a387a4892ee19b1a2249&code_challenge=vMX0MPPvVlbAX9uyiUaI6NPnxtL8HYTTXAYVgDeKTFQ&code_challenge_method=S256&nonce=&redirectUri=http%3A//wsl.ymbihq.local%3A47000/api/auth/callback/casdoor&responseType=code&scope=openid+profile+email&state=&type=code', 'login', 'en', '{"application":"lobechat","organization":"lobechat","username":"admin","password":"***","autoSignin":true,"language":"","signinMethod":"Password","type":"code"}', '{status:"error", msg:"The user: lobechat/admin doesn''t exist"}', 200, true);
INSERT INTO public.record VALUES (9, '', '12baa410-5541-41fb-a8c4-1e3fed2c7412', '2026-01-27T06:05:38Z', '', '172.25.240.1', '', 'POST', '/api/login?clientId=a387a4892ee19b1a2249&code_challenge=vMX0MPPvVlbAX9uyiUaI6NPnxtL8HYTTXAYVgDeKTFQ&code_challenge_method=S256&nonce=&redirectUri=http%3A//wsl.ymbihq.local%3A47000/api/auth/callback/casdoor&responseType=code&scope=openid+profile+email&state=&type=code', 'login', 'en', '{"application":"lobechat","organization":"lobechat","username":"admin","password":"***","autoSignin":true,"language":"","signinMethod":"Password","type":"code"}', '{status:"error", msg:"The user: lobechat/admin doesn''t exist"}', 200, true);
INSERT INTO public.record VALUES (10, 'lobechat', 'cb523ec0-47ec-4917-8a07-d1341e6bb27e', '2026-01-27T06:05:57Z', 'lobechat', '172.25.240.1', 'user', 'POST', '/api/login?clientId=a387a4892ee19b1a2249&code_challenge=vMX0MPPvVlbAX9uyiUaI6NPnxtL8HYTTXAYVgDeKTFQ&code_challenge_method=S256&nonce=&redirectUri=http%3A//wsl.ymbihq.local%3A47000/api/auth/callback/casdoor&responseType=code&scope=openid+profile+email&state=&type=code', 'login', 'en', '{"application":"lobechat","organization":"lobechat","username":"user","password":"***","autoSignin":true,"language":"","signinMethod":"Password","type":"code"}', '{status:"ok", msg:""}', 200, true);
INSERT INTO public.record VALUES (11, '', 'cdaaf7b3-fa85-4014-a5e1-47190b88cc44', '2026-01-27T06:05:57Z', '', '10.222.8.1', '', 'POST', '/api/login/oauth/access_token', 'login/oauth/access_token', 'en', 'redirect_uri=http%3A%2F%2Fwsl.ymbihq.local%3A47000%2Fapi%2Fauth%2Fcallback%2Fcasdoor&code=54b03b39e718ba9fd0e5&code_verifier=6pWNVTL_anD3Xk0ypaCN9gP7yj0wkpQ1Uq2p78nGwLM&grant_type=authorization_code', '{status:"", msg:""}', 200, true);
INSERT INTO public.record VALUES (12, 'lobechat', '456c78de-82a6-4103-a110-e61b88a740bb', '2026-01-27T08:08:01Z', 'lobechat', '172.25.240.1', 'user', 'POST', '/api/login?clientId=a387a4892ee19b1a2249&code_challenge=tLZT94wf7M5plSQ-HAuQgIaAu8jHo0ZrFC2qP4lpGsA&code_challenge_method=S256&nonce=&redirectUri=http%3A//wsl.ymbihq.local%3A47000/api/auth/callback/casdoor&responseType=code&scope=openid+profile+email&state=&type=code', 'login', 'en', '{"application":"lobechat","organization":"lobechat","username":"user","password":"***","autoSignin":true,"language":"","signinMethod":"Password","type":"code"}', '{status:"ok", msg:""}', 200, true);
INSERT INTO public.record VALUES (13, '', '58f18ff8-08a1-4d45-b26e-ca07fef5f80e', '2026-01-27T08:08:01Z', '', '10.222.8.1', '', 'POST', '/api/login/oauth/access_token', 'login/oauth/access_token', 'en', 'redirect_uri=http%3A%2F%2Fwsl.ymbihq.local%3A47000%2Fapi%2Fauth%2Fcallback%2Fcasdoor&code=6192c659f572a32ecba7&code_verifier=vC5DWi-H5GRhTxv2oek4H2g-7KvInN6Nym7EeuO1GEs&grant_type=authorization_code', '{status:"", msg:""}', 200, true);
INSERT INTO public.record VALUES (14, 'lobechat', '7daf4f5f-af87-44e7-a5c0-206bc6dfd58d', '2026-01-27T08:10:22Z', 'lobechat', '172.25.240.1', 'user', 'POST', '/api/login?clientId=a387a4892ee19b1a2249&code_challenge=-NFmj00GdQJO3R7v5H26k1W75AzK--oHAOE4lSSBSh8&code_challenge_method=S256&nonce=&redirectUri=http%3A//wsl.ymbihq.local%3A47000/api/auth/callback/casdoor&responseType=code&scope=openid+profile+email&state=&type=code', 'login', 'en', '{"application":"lobechat","organization":"lobechat","username":"user","password":"***","autoSignin":true,"language":"","signinMethod":"Password","type":"code"}', '{status:"ok", msg:""}', 200, true);
INSERT INTO public.record VALUES (15, '', '0a1d244d-c66a-4241-bfa7-f27e96db7bec', '2026-01-27T08:10:22Z', '', '10.222.8.1', '', 'POST', '/api/login/oauth/access_token', 'login/oauth/access_token', 'en', 'redirect_uri=http%3A%2F%2Fwsl.ymbihq.local%3A47000%2Fapi%2Fauth%2Fcallback%2Fcasdoor&code=26c819494ca56d5e0186&code_verifier=M5KHjgaYXCsuVZbZ3flZE0aS_cYhdHXPBBFjWjT3dmo&grant_type=authorization_code', '{status:"", msg:""}', 200, true);
INSERT INTO public.record VALUES (16, 'lobechat', 'a0aca14a-cf30-494a-b37d-70b1919b6eb1', '2026-02-11T04:24:57Z', 'lobechat', '172.25.245.23', 'user', 'POST', '/api/login?clientId=a387a4892ee19b1a2249&code_challenge=DVBX2V5N4rS7W4LjCSt0gbiZ1F7pj6i46LW5UB_gapo&code_challenge_method=S256&nonce=&redirectUri=http%3A//wsl.ymbihq.local%3A47000/api/auth/callback/casdoor&responseType=code&scope=openid+profile+email&state=&type=code', 'login', 'en', '{"application":"lobechat","organization":"lobechat","username":"user","autoSignin":true,"password":"***","language":"","signinMethod":"Password","type":"code"}', '{status:"ok", msg:""}', 200, true);
INSERT INTO public.record VALUES (17, 'lobechat', '804f4439-ea3b-4e7a-8a41-ef1e84e5b03c', '2026-02-11T04:25:15Z', 'lobechat', '172.25.245.23', 'user', 'POST', '/api/login?clientId=a387a4892ee19b1a2249&code_challenge=MwW47G1CfxcV7Q75uT-E5NYE2hDJUIOujZ1JpZSaDxg&code_challenge_method=S256&nonce=&redirectUri=http%3A//wsl.ymbihq.local%3A47000/api/auth/callback/casdoor&responseType=code&scope=openid+profile+email&state=&type=code', 'login', 'en', '{"application":"lobechat","organization":"lobechat","username":"user","password":"***","autoSignin":true,"language":"","signinMethod":"Password","type":"code"}', '{status:"ok", msg:""}', 200, true);
INSERT INTO public.record VALUES (18, '', 'dbc4d1df-17d3-43fc-8891-e32a18aaf355', '2026-02-11T04:25:15Z', '', '10.222.1.1', '', 'POST', '/api/login/oauth/access_token', 'login/oauth/access_token', 'en', 'redirect_uri=http%3A%2F%2Fwsl.ymbihq.local%3A47000%2Fapi%2Fauth%2Fcallback%2Fcasdoor&code=f79b5dd100026f26dacf&code_verifier=lL-VuhwqztA09Z2Kl9JPvIoZrXtALUqzwkwaS5iLbZI&grant_type=authorization_code', '{status:"", msg:""}', 200, true);
INSERT INTO public.record VALUES (19, 'lobechat', '1204048a-f6a1-4ebf-ac7f-cb649c1ce077', '2026-04-29T05:22:05Z', 'lobechat', '172.25.245.23', 'user', 'POST', '/api/login?clientId=a387a4892ee19b1a2249&code_challenge=qyiLhaJ2OHyK8sU8SkmMoEwBppu5KINByROhutxh0Kw&code_challenge_method=S256&nonce=&redirectUri=http%3A//wsl.ymbihq.local%3A47000/api/auth/callback/casdoor&responseType=code&scope=openid+profile+email&state=&type=code', 'login', 'en', '{"application":"lobechat","organization":"lobechat","username":"user","autoSignin":true,"password":"***","language":"","signinMethod":"Password","type":"code"}', '{status:"ok", msg:""}', 200, true);
INSERT INTO public.record VALUES (20, 'lobechat', '053abc4d-4c89-48a9-9fb5-f32f70d6b97b', '2026-04-29T05:22:28Z', 'lobechat', '172.25.245.23', 'user', 'POST', '/api/login?clientId=a387a4892ee19b1a2249&code_challenge=G4ta8laqmnM5F-6uI99t9uwhi_9_ZVZUefr6RpOIR2A&code_challenge_method=S256&nonce=&redirectUri=http%3A//wsl.ymbihq.local%3A47000/api/auth/callback/casdoor&responseType=code&scope=openid+profile+email&state=&type=code', 'login', 'en', '{"application":"lobechat","organization":"lobechat","username":"user","autoSignin":true,"password":"***","language":"","signinMethod":"Password","type":"code"}', '{status:"ok", msg:""}', 200, true);
INSERT INTO public.record VALUES (21, '', 'e0e66218-b8a8-48b7-85db-0fc74911197b', '2026-04-29T05:22:28Z', '', '10.222.1.1', '', 'POST', '/api/login/oauth/access_token', 'login/oauth/access_token', 'en', 'redirect_uri=http%3A%2F%2Fwsl.ymbihq.local%3A47000%2Fapi%2Fauth%2Fcallback%2Fcasdoor&code=b60ea11b78e4839635d1&code_verifier=SJE8L4Q1WB0_lAh1eh7sofZfwbNetWlysFHwiN7EtFc&grant_type=authorization_code', '{status:"", msg:""}', 200, true);


--
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: subscription; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: syncer; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public."user" VALUES ('lobechat', 'user', '2026-04-29T08:29:23Z', '2025-08-11T09:19:46Z', '', '7d66c02c-a40b-4b58-ba1d-7862451514e5', '', 'normal-user', '${CASDOOR_USER_DEFAULT_PASSWORD}', '', 'plain', 'User', '', '', 'https://lobehub.com/favicon.ico', '', '', 'pfub7l@example.com', false, '93788949801', 'US', '', '', '[]', 'Example Inc.', '', '', '', '', '', 'staff', '', '', '', '', 0, 0, 1, 0, '', false, false, false, false, false, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '\x6e756c6c', '', 'null', '', false, false, '', '', 'null', '', '{}', 'null', 'null', '[]', '2025-08-11T09:19:46Z', '', 0, '\x6e756c6c', '\x6e756c6c', 'null', '', false, '');
INSERT INTO public."user" VALUES ('built-in', 'admin', '2026-04-29T08:29:23Z', '2025-08-11T09:26:11Z', '', 'b631b95c-7893-4e5f-aa04-1a402f147db5', '', 'normal-user', '${CASDOOR_USER_DEFAULT_PASSWORD}', '', 'plain', 'Admin', '', '', 'https://cdn.casbin.org/img/casbin.svg', '', '', 'admin@example.com', false, '12345678910', 'US', '', '', '[]', 'Example Inc.', '', '', '', '', '', 'staff', '', '', '', '', 2000, 0, 1, 0, '', false, false, true, false, false, 'app-built-in', '', '', '', '', '', '127.0.0.1', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '\x6e756c6c', '', 'null', '', false, false, '', '', 'null', '', '{}', 'null', 'null', 'null', '2025-08-11T09:26:11Z', '', 0, '\x6e756c6c', '\x6e756c6c', 'null', '', false, '');


--
-- Data for Name: webhook; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.webhook VALUES ('admin', 'webhook_default', '2026-04-29T08:29:23Z', 'lobechat', 'http://localhost:3210/api/webhooks/casdoor', 'POST', 'application/json', '[{"name":"casdoor-secret","value":"casdoor-secret"}]', '["update-user"]', 'null', '["All"]', false, false, true);


--
-- Name: casbin_api_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.casbin_api_rule_id_seq', 65, true);


--
-- Name: casbin_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.casbin_rule_id_seq', 1, false);


--
-- Name: casbin_user_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.casbin_user_rule_id_seq', 1, false);


--
-- Name: permission_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.permission_rule_id_seq', 3, true);


--
-- Name: record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.record_id_seq', 21, true);


--
-- PostgreSQL database dump complete
--

\unrestrict Mmp6aoqxg4OfD0rwbGFAKZlANJDXg4NeN3AIKj5y22JJB11XHSuje9gDgeXOU4c

