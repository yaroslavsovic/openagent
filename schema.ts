import { pgTable, text, serial, integer } from "drizzle-orm/pg-core";
import { createInsertSchema, createSelectSchema } from "drizzle-zod";

// Core agents table
export const agents = pgTable("agents", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  model: text("model").notNull().default("gpt-4o"), // latest model
  temperature: integer("temperature").notNull().default(70),
  systemPrompt: text("system_prompt").notNull(),
  firstMessage: text("first_message").notNull(),
  language: text("language").notNull().default("English"),
});

// Create Zod schemas for type safety
export const insertAgentSchema = createInsertSchema(agents);
export const selectAgentSchema = createSelectSchema(agents);

// Export types
export type InsertAgent = typeof agents.$inferInsert;
export type SelectAgent = typeof agents.$inferSelect;