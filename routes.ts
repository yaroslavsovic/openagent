import type { Express } from "express";
import { createServer, type Server } from "http";
import { db } from "@db";
import { agents } from "@db/schema";
import { eq } from "drizzle-orm";
import OpenAI from "openai";

if (!process.env.OPENAI_API_KEY) {
  throw new Error("OPENAI_API_KEY environment variable is missing");
}

// the newest OpenAI model is "gpt-4o" which was released May 13, 2024
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export function registerRoutes(app: Express): Server {
  // Get all agents
  app.get("/api/agents", async (_req, res) => {
    try {
      const allAgents = await db.select().from(agents);
      res.json(allAgents);
    } catch (error) {
      console.error("Failed to fetch agents:", error);
      res.status(500).json({ error: "Failed to fetch agents" });
    }
  });

  // Create a new agent
  app.post("/api/agents", async (req, res) => {
    try {
      const [agent] = await db
        .insert(agents)
        .values(req.body)
        .returning();
      res.json(agent);
    } catch (error) {
      console.error("Failed to create agent:", error);
      res.status(500).json({ error: "Failed to create agent" });
    }
  });

  const httpServer = createServer(app);
  return httpServer;
}