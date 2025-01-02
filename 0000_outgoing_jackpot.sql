CREATE TABLE IF NOT EXISTS "agent_recovery_logs" (
	"id" serial PRIMARY KEY NOT NULL,
	"agent_id" integer NOT NULL,
	"error_type" text NOT NULL,
	"error_details" jsonb NOT NULL,
	"recovery_action" text NOT NULL,
	"successful" boolean NOT NULL,
	"recovered_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "agents" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"voice" text DEFAULT 'alloy' NOT NULL,
	"model" text DEFAULT 'gpt-4' NOT NULL,
	"temperature" integer DEFAULT 70 NOT NULL,
	"token_limit" integer DEFAULT 2048 NOT NULL,
	"language" text DEFAULT 'English' NOT NULL,
	"first_message" text NOT NULL,
	"system_prompt" text NOT NULL,
	"tools" text[] DEFAULT chat NOT NULL,
	"secrets" text DEFAULT '{}' NOT NULL,
	"avatar_url" text,
	"avatar_prompt" text,
	"wins" integer DEFAULT 0 NOT NULL,
	"losses" integer DEFAULT 0 NOT NULL,
	"status" text DEFAULT 'active' NOT NULL,
	"last_error" jsonb,
	"recovery_attempts" integer DEFAULT 0 NOT NULL,
	"last_recovery_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "chats" (
	"id" serial PRIMARY KEY NOT NULL,
	"agent1_id" integer NOT NULL,
	"agent2_id" integer NOT NULL,
	"topic" text NOT NULL,
	"winner_id" integer,
	"message_count" integer DEFAULT 0 NOT NULL,
	"status" text DEFAULT 'active' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "messages" (
	"id" serial PRIMARY KEY NOT NULL,
	"chat_id" integer NOT NULL,
	"agent_id" integer NOT NULL,
	"content" text NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "agent_recovery_logs" ADD CONSTRAINT "agent_recovery_logs_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "agents"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chats" ADD CONSTRAINT "chats_agent1_id_agents_id_fk" FOREIGN KEY ("agent1_id") REFERENCES "agents"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chats" ADD CONSTRAINT "chats_agent2_id_agents_id_fk" FOREIGN KEY ("agent2_id") REFERENCES "agents"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chats" ADD CONSTRAINT "chats_winner_id_agents_id_fk" FOREIGN KEY ("winner_id") REFERENCES "agents"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "messages" ADD CONSTRAINT "messages_chat_id_chats_id_fk" FOREIGN KEY ("chat_id") REFERENCES "chats"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "messages" ADD CONSTRAINT "messages_agent_id_agents_id_fk" FOREIGN KEY ("agent_id") REFERENCES "agents"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
