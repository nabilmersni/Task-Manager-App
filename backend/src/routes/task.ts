import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { NewTask, tasks } from "../db/schema";
import { db } from "../db";
import { eq } from "drizzle-orm";

const taskRouter = Router();

taskRouter.post("/", auth, async (req: AuthRequest, res) => {
  try {
    req.body = {
      ...req.body,
      uid: req.userId,
      dueAt: new Date(req.body.dueAt),
    };
    const newTask: NewTask = req.body;
    const [task] = await db.insert(tasks).values(newTask).returning();

    res.status(201).json(task);
  } catch (e) {
    res.status(500).json({ error: e });
  }
});

taskRouter.get("/", auth, async (req: AuthRequest, res) => {
  try {
    const allTasks = await db
      .select()
      .from(tasks)
      .where(eq(tasks.uid, req.userId!));

    res.status(200).json(allTasks);
  } catch (e) {
    res.status(500).json({ error: e });
  }
});

taskRouter.delete("/", auth, async (req: AuthRequest, res) => {
  try {
    const { taskId }: { taskId: string } = req.body;
    await db.delete(tasks).where(eq(tasks.id, taskId));

    res.status(204).json(true);
  } catch (e) {
    res.status(500).json({ error: e });
  }
});

taskRouter.post("/sync", auth, async (req: AuthRequest, res) => {
  try {
    const tasksList = req.body;

    const filtredTasks: NewTask[] = [];
    for (let t of tasksList) {
      t = {
        ...t,
        uid: req.userId,
        dueAt: new Date(t.dueAt),
        createdAt: new Date(t.createdAt),
        updatedAt: new Date(t.updatedAt),
      };
      filtredTasks.push(t);
    }
    console.log(filtredTasks);
    const pushedTasks = await db.insert(tasks).values(filtredTasks).returning();

    res.status(201).json(pushedTasks);
  } catch (e) {
    res.status(500).json({ error: e });
  }
});

export default taskRouter;
