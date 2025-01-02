ALTER TABLE "agents" ALTER COLUMN "secrets" SET DATA TYPE jsonb;--> statement-breakpoint
ALTER TABLE "agents" ALTER COLUMN "secrets" SET DEFAULT '{}'::jsonb;