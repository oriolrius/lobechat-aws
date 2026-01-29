-- Create lobechat database (used by Lobe Chat database version)
CREATE DATABASE lobechat;

-- Create casdoor database (used by Casdoor SSO)
CREATE DATABASE casdoor;

-- Switch to lobechat database to enable pgvector extension
\c lobechat
CREATE EXTENSION IF NOT EXISTS vector;
