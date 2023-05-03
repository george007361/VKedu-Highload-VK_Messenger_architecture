CREATE TABLE "users" (
  "id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR(64) NOT NULL,
  "last_name" VARCHAR(64) NOT NULL,
  "about" VARCHAR(40),
  "email" VARCHAR(256) NOT NULL,
  "passwd_hash" VARCHAR(128) NOT NULL,
  "avatar_uuid" SERIAL
);

CREATE TABLE "chat_users" (
  "id" SERIAL PRIMARY KEY,
  "chat_id" SERIAL,
  "user_id" SERIAL,
  "joined" timestamp
);

CREATE TABLE "chats" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(32),
  "created" timestamp
);

CREATE TABLE "messages" (
  "id" BIGSERIAL PRIMARY KEY,
  "author_id" SERIAL,
  "chat_id" SERIAL,
  "create_date" timestamp,
  "edit_date" timestamp,
  "text_content" VARCHAR(1024),
  "voice_content_uuid" SERIAL,
  "attachment_uuids" UUID[]
);

CREATE TABLE "cookies" (
  "id" SERIAL PRIMARY KEY,
  "user_id" SERIAL,
  "cookie" UUID,
  "expires" timestamp
);

CREATE TABLE "avatars" (
  "uuid" SERIAL PRIMARY KEY,
  "blob" bytea
);

CREATE TABLE "attachments" (
  "uuid" SERIAL PRIMARY KEY,
  "blob" bytea
);

CREATE TABLE "voices" (
  "uuid" SERIAL PRIMARY KEY,
  "blob" bytea
);

CREATE INDEX ON "users" (((lower(first_name)), (lower(last_name))));

CREATE INDEX ON "users" ((lower(first_name)));

CREATE INDEX ON "users" ((lower(last_name)));

CREATE INDEX ON "messages" ("chat_id", "create_date");

ALTER TABLE "chat_users" ADD FOREIGN KEY ("chat_id") REFERENCES "chats" ("id");

ALTER TABLE "chat_users" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "users" ADD FOREIGN KEY ("avatar_uuid") REFERENCES "avatars" ("uuid");

ALTER TABLE "messages" ADD FOREIGN KEY ("author_id") REFERENCES "users" ("id");

ALTER TABLE "messages" ADD FOREIGN KEY ("chat_id") REFERENCES "chats" ("id");

ALTER TABLE "messages" ADD FOREIGN KEY ("voice_content_uuid") REFERENCES "voices" ("uuid");

ALTER TABLE "messages" ADD FOREIGN KEY ("attachment_uuids") REFERENCES "attachments" ("uuid");

ALTER TABLE "cookies" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");
