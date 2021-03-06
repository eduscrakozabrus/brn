create table if not exists authority
(
    id             bigint       not null
        constraint authority_pkey
            primary key,
    authority_name varchar(255) not null
        constraint uk_6ct98mcqw43jw46da6tbapvie
            unique
);

create table if not exists exercise_group
(
    id          bigint       not null
        constraint exercise_group_pkey
            primary key,
    description varchar(255),
    name        varchar(255) not null
        constraint uk_n4n5r4j77tp0j7w0ibumainjs
            unique
);

create table if not exists progress
(
    id                bigint not null
        constraint progress_pkey
            primary key,
    progress          varchar(255) not null,
    exercise_group_id bigint
        constraint fkm2f9vxu8rxyuvq2qlvaps3d1o
            references exercise_group
);

create table if not exists resource
(
    id               bigint not null
        constraint resource_pkey
            primary key,
    audio_file_url   varchar(255) not null,
    picture_file_url varchar(255),
    sounds_count     integer,
    word             varchar(255) not null,
    word_type        varchar(255),
    constraint uk7rqvk7iml0lvslr33ujqrbneu
        unique (word, audio_file_url)
);

create index if not exists word_audio_file_idx
    on resource (word, audio_file_url);

create index if not exists audio_file_idx
    on resource (audio_file_url);

create table if not exists series
(
    id                bigint       not null
        constraint series_pkey
            primary key,
    description       varchar(255),
    name              varchar(255) not null
        constraint uk_s4jd0prfged1pucstgaoh8qj4
            unique,
    exercise_group_id bigint
        constraint fk2c08ai2hn3ol2by2ff3ldvoqq
            references exercise_group
);

create table if not exists exercise
(
    id                 bigint  not null
        constraint exercise_pkey
            primary key,
    description        varchar(255),
    exercise_type      varchar(255),
    level              integer,
    name               varchar(255),
    noise_level        integer not null,
    noise_url          varchar(255),
    picture_url        varchar(255),
    template           varchar(255),
    exercise_series_id bigint
        constraint fkbnnibamsgvjhy13uli9s73yfr
            references series,
    constraint uk1qbx6egnaof1jh2y0qtkoe8rj
        unique (name, level)
);

create table if not exists signal
(
    id          bigint not null
        constraint signal_pkey
            primary key,
    frequency   integer,
    length      integer,
    name        varchar(255),
    url         varchar(255),
    exercise_id bigint
        constraint fkrue6p2si4x3op2j3psi4fc5sw
            references exercise
);

create table if not exists task
(
    id            bigint not null
        constraint task_pkey
            primary key,
    name          varchar(255),
    serial_number integer,
    resource_id   bigint
        constraint fkk7kpuq2akyqlrv8eun1rhrnh1
            references resource,
    exercise_id   bigint
        constraint fkar49eehe2lkif6att6hhepj75
            references exercise
);

create table if not exists answer_parts_resources
(
    task_id          bigint  not null
        constraint fkli78oee5qfbby4mptccvyhexy
            references task,
    resource_id      bigint  not null
        constraint fkrim8nplpgigv4yon68b4nna0g
            references resource,
    answer_parts_key integer not null,
    constraint answer_parts_resources_pkey
        primary key (task_id, answer_parts_key)
);

create table if not exists task_resources
(
    task_id     bigint not null
        constraint fk14xdd2jsgmhi1x2x77u3oxar1
            references task,
    resource_id bigint not null
        constraint fk7mg14e02mp6680t1rhsjj7lip
            references resource,
    constraint task_resources_pkey
        primary key (task_id, resource_id)
);

create table if not exists user_account
(
    id          bigint not null
        constraint user_account_pkey
            primary key,
    active      boolean      not null,
    birthday    date,
    email       varchar(255) not null
        constraint uk_hl02wv5hym99ys465woijmfib
            unique,
    first_name  varchar(255) not null,
    last_name   varchar(255),
    password    varchar(255) not null,
    progress_id bigint
        constraint fkcr5eonbalqc6icwdje9ekcdhm
            references progress
);

create table if not exists study_history
(
    id                  bigint   not null
        constraint study_history_pkey
            primary key,
    end_time            timestamp,
    execution_seconds   integer  not null,
    repetition_index    real,
    replays_count       integer  not null,
    wrongAnswers        integer  not null,
    right_answers_index real,
    start_time          timestamp,
    tasks_count         smallint not null,
    exercise_id         bigint
        constraint fkdew54asp48c4r8wu0dttmps4d
            references exercise,
    user_id             bigint
        constraint fk5gkcspvt7bmyc80jv8vfbfpqt
            references user_account,
    constraint ukblb87no1fhqw76655j1xfbjc8
        unique (user_id, exercise_id, start_time)
);

create index if not exists study_history_ix_user_exercise
    on study_history (user_id, exercise_id);

create table if not exists user_authorities
(
    user_id      bigint not null
        constraint fk6teafluo1xt1re7vbgr16w8iy
            references user_account,
    authority_id bigint not null
        constraint fk2n9bab2v62l3y2jgu3qup4etw
            references authority,
    constraint user_authorities_pkey
        primary key (user_id, authority_id)
);