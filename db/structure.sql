CREATE TABLE "schema_migrations" ("version" varchar NOT NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
CREATE TABLE "users" ("id" binary(16) PRIMARY KEY NOT NULL, "email" varchar DEFAULT '' NOT NULL, "encrypted_password" varchar DEFAULT '' NOT NULL, "reset_password_token" varchar, "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0 NOT NULL, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar, "last_sign_in_ip" varchar, "confirmation_token" varchar, "confirmed_at" datetime, "confirmation_sent_at" datetime, "unconfirmed_email" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "authentication_token" varchar);
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token");
CREATE UNIQUE INDEX "index_users_on_confirmation_token" ON "users" ("confirmation_token");
CREATE TABLE "roles" ("id" binary(16) PRIMARY KEY NOT NULL, "name" varchar, "resource_id" binary(16), "resource_type" varchar, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "users_roles" ("user_id" binary(16), "role_id" binary(16));
CREATE INDEX "index_roles_on_name" ON "roles" ("name");
CREATE INDEX "index_roles_on_name_and_resource_type_and_resource_id" ON "roles" ("name", "resource_type", "resource_id");
CREATE INDEX "index_users_roles_on_user_id_and_role_id" ON "users_roles" ("user_id", "role_id");
CREATE TABLE "channels" ("id" binary(16) PRIMARY KEY NOT NULL, "api_id" varchar NOT NULL, "title" varchar NOT NULL, "thumbnail" varchar NOT NULL, "uploads_id" varchar NOT NULL, "checked_at" datetime NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_channels_on_api_id" ON "channels" ("api_id");
CREATE TABLE "videos" ("id" binary(16) PRIMARY KEY NOT NULL, "api_id" varchar NOT NULL, "channel_id" binary(16) NOT NULL, "title" varchar NOT NULL, "thumbnail" varchar NOT NULL, "duration" integer NOT NULL, "published_at" datetime NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_videos_on_api_id" ON "videos" ("api_id");
CREATE INDEX "index_videos_on_channel_id" ON "videos" ("channel_id");
CREATE TABLE "subscriptions" ("id" binary(16) PRIMARY KEY NOT NULL, "user_id" binary(16) NOT NULL, "channel_id" binary(16) NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_subscriptions_on_user_id_and_channel_id" ON "subscriptions" ("user_id", "channel_id");
CREATE TABLE "items" ("id" binary(16) PRIMARY KEY NOT NULL, "subscription_id" binary(16) NOT NULL, "video_id" binary(16) NOT NULL, "state" integer DEFAULT 0 NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_items_on_subscription_id" ON "items" ("subscription_id");
CREATE INDEX "index_items_on_video_id" ON "items" ("video_id");
INSERT INTO schema_migrations (version) VALUES ('20160815161102');

INSERT INTO schema_migrations (version) VALUES ('20160815161420');

INSERT INTO schema_migrations (version) VALUES ('20160815172635');

INSERT INTO schema_migrations (version) VALUES ('20160815181345');

INSERT INTO schema_migrations (version) VALUES ('20160815181908');

INSERT INTO schema_migrations (version) VALUES ('20160815182423');

INSERT INTO schema_migrations (version) VALUES ('20160815184158');

