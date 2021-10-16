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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: channels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.channels (
    api_id character varying NOT NULL,
    title character varying NOT NULL,
    thumbnail character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    secret_key character varying DEFAULT ''::character varying NOT NULL,
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL
);


--
-- Name: items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.items (
    state integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    subscription_id uuid NOT NULL,
    video_id uuid NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscriptions (
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    channel_id uuid NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    email character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    password_digest character varying NOT NULL,
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL
);


--
-- Name: videos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.videos (
    api_id character varying NOT NULL,
    title character varying NOT NULL,
    duration integer DEFAULT 0 NOT NULL,
    published_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_live boolean DEFAULT false NOT NULL,
    is_live_content boolean DEFAULT false NOT NULL,
    is_upcoming boolean DEFAULT false NOT NULL,
    scheduled_at timestamp without time zone,
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    channel_id uuid NOT NULL
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: channels channels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.channels
    ADD CONSTRAINT channels_pkey PRIMARY KEY (id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: videos videos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


--
-- Name: index_channels_on_api_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_channels_on_api_id ON public.channels USING btree (api_id);


--
-- Name: index_channels_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_channels_on_id ON public.channels USING btree (id);


--
-- Name: index_items_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_items_on_id ON public.items USING btree (id);


--
-- Name: index_items_on_subscription_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_subscription_id ON public.items USING btree (subscription_id);


--
-- Name: index_items_on_video_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_items_on_video_id ON public.items USING btree (video_id);


--
-- Name: index_subscriptions_on_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_channel_id ON public.subscriptions USING btree (channel_id);


--
-- Name: index_subscriptions_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_subscriptions_on_id ON public.subscriptions USING btree (id);


--
-- Name: index_subscriptions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_user_id ON public.subscriptions USING btree (user_id);


--
-- Name: index_subscriptions_on_user_id_and_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_subscriptions_on_user_id_and_channel_id ON public.subscriptions USING btree (user_id, channel_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_id ON public.users USING btree (id);


--
-- Name: index_videos_on_api_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_videos_on_api_id ON public.videos USING btree (api_id);


--
-- Name: index_videos_on_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_channel_id ON public.videos USING btree (channel_id);


--
-- Name: index_videos_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_videos_on_id ON public.videos USING btree (id);


--
-- Name: items fk_rails_2a3b826863; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT fk_rails_2a3b826863 FOREIGN KEY (subscription_id) REFERENCES public.subscriptions(id);


--
-- Name: items fk_rails_621e93af28; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT fk_rails_621e93af28 FOREIGN KEY (video_id) REFERENCES public.videos(id);


--
-- Name: subscriptions fk_rails_7e8baea494; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_7e8baea494 FOREIGN KEY (channel_id) REFERENCES public.channels(id);


--
-- Name: subscriptions fk_rails_933bdff476; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_933bdff476 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: videos fk_rails_b71dd278a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT fk_rails_b71dd278a6 FOREIGN KEY (channel_id) REFERENCES public.channels(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20160815161102'),
('20160815161420'),
('20160815172635'),
('20160815181345'),
('20160815181908'),
('20160815182423'),
('20160815184158'),
('20160817162932'),
('20160817173237'),
('20170401020551'),
('20190602061347'),
('20190602102525'),
('20190606115220'),
('20200306231156'),
('20200916115413'),
('20201108043801'),
('20210127124541'),
('20211001093711'),
('20211008112023'),
('20211016020737'),
('20220407073237');


