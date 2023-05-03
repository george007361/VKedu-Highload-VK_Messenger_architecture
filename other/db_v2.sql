create table users(
    id serial primary key,
    first_name VARCHAR(64) NOT NULL,
    last_name VARCHAR(64) NOT NULL,
    email VARCHAR(64) NOT NULL,
    avatar_id serial references avatars(id)
);

create table chats(
    id serial primary key,
    create_date timestamp,
    name VARCHAR(32)
);

create table chat_users(
    id serial primary key,
    chat_id serial references chats(id),
    user_id serial references users(id),
    joined timestamp
);

create table messages(
    id bigserial primary key,
    author_id serial references users(id),
    chat_id serial references chats(id),
    create_date timestamp,
    edit_date timestamp,
    text_content VARCHAR(1024),
    voice_content_id bigserial references voices(id),
    attachment_ids bigserial[] references attachments(id)
);

create table cookies(
    id serial primary key,
    user_id serial references users(id),
    cookie VARCHAR(64),
    expires timestamp
);

create table avatars(
    id serial primary key,
    blob bytea
);

create table attachments(
    id bigserial primary key,
    blob bytea
);

create table voices(
    id bigserial primary key,
    blob bytea
);
