# https://app.dbdesigner.net/designer/schema/439529


 CREATE TABLE "public.wine_site" (
	"year" integer NOT NULL,
	"name" VARCHAR(255) NOT NULL,
	"maker" VARCHAR(255) NOT NULL,
	"region" VARCHAR(255) NOT NULL,
	"grape" VARCHAR(255) NOT NULL,
	"link" VARCHAR(255) NOT NULL,
	"price_club" VARCHAR(255) NOT NULL,
	"price_regular" VARCHAR(255) NOT NULL,
	"price_sale" VARCHAR(255) NOT NULL,
	"site_sku" VARCHAR(255) NOT NULL,
	"global_id" VARCHAR(255) NOT NULL
);



CREATE TABLE "public.evino_table" (
	"year" integer NOT NULL,
	"name" VARCHAR(255) NOT NULL,
	"maker" VARCHAR(255) NOT NULL,
	"region" VARCHAR(255) NOT NULL,
	"grape" VARCHAR(255) NOT NULL,
	"link" VARCHAR(255) NOT NULL,
	"price_regular" VARCHAR(255) NOT NULL,
	"price_sale" VARCHAR(255) NOT NULL,
	"site_sku" VARCHAR(255) NOT NULL,
	"global_id" VARCHAR(255) NOT NULL
);



CREATE TABLE "public.same_wines" (
	"global_id_wine" VARCHAR(255) NOT NULL,
	"global_id_evino" VARCHAR(255) NOT NULL
);



CREATE TABLE "public.price_history_wine" (
	"global_id" VARCHAR(255) NOT NULL,
	"price_club" FLOAT NOT NULL,
	"price_regular" FLOAT NOT NULL,
	"price_sale" FLOAT NOT NULL,
	"date" DATE NOT NULL
);


CREATE TABLE "public.price_history_evino" (
	"global_id" VARCHAR(255) NOT NULL,
	"price_regular" FLOAT NOT NULL,
	"price_sale" FLOAT NOT NULL,
	"date" DATE NOT NULL
);

ALTER TABLE "same_wines" ADD CONSTRAINT "same_wines_fk0" FOREIGN KEY ("global_id_wine") REFERENCES "wine_site"("global_id");
ALTER TABLE "same_wines" ADD CONSTRAINT "same_wines_fk1" FOREIGN KEY ("global_id_evino") REFERENCES "evino_table"("global_id");

ALTER TABLE "price_history_wine" ADD CONSTRAINT "price_history_wine_fk0" FOREIGN KEY ("global_id") REFERENCES "wine_site"("global_id");

ALTER TABLE "price_history_evino" ADD CONSTRAINT "price_history_evino_fk0" FOREIGN KEY ("global_id") REFERENCES "evino_table"("global_id");