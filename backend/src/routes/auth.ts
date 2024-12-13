import { NewUser } from "./../db/schema";
import { eq } from "drizzle-orm";
import { Request, Response, Router } from "express";
import { db } from "../db";
import { users } from "../db/schema";
import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";
import { auth, AuthRequest } from "../middleware/auth";
import { error } from "console";

const authRouter = Router();

interface SignUpBody {
  name: string;
  email: string;
  password: string;
}

interface LoginBody {
  email: string;
  password: string;
}

authRouter.post(
  "/signup",
  async (req: Request<{}, {}, SignUpBody>, res: Response) => {
    try {
      const { name, email, password } = req.body;

      const existUser = await db
        .select()
        .from(users)
        .where(eq(users.email, email));

      if (existUser.length) {
        res.status(400).json({
          msg: "User with the same email already exist!",
        });
        return;
      }
      const hashedPassword = await bcryptjs.hash(password, 8);
      const newUser: NewUser = {
        name,
        email,
        password: hashedPassword,
      };

      const [addedUser] = await db.insert(users).values(newUser).returning();
      res.status(201).json(addedUser);
    } catch (error) {
      res.status(500).json({ error });
    }
  }
);

authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) {
      res.json(false);
      return;
    }
    const verified = jwt.verify(token, "secretkey");

    if (!verified) {
      res.json(false);
      return;
    }

    const verifiedToken = verified as { id: string };
    const [user] = await db
      .select()
      .from(users)
      .where(eq(users.id, verifiedToken.id));

    if (!user) {
      res.json(false);
      return;
    }

    res.json(true);
  } catch (error) {
    res.status(500).json(false);
  }
});

authRouter.post(
  "/login",
  async (req: Request<{}, {}, LoginBody>, res: Response) => {
    try {
      const { email, password } = req.body;

      const [existUser] = await db
        .select()
        .from(users)
        .where(eq(users.email, email));

      if (!existUser) {
        res.status(400).json({
          msg: "Invalid credentials!",
        });
        return;
      }
      const isMatchPassword = await bcryptjs.compare(
        password,
        existUser.password
      );

      if (!isMatchPassword) {
        res.status(400).json({
          msg: "Invalid credentials!",
        });
        return;
      }

      const token = jwt.sign({ id: existUser.id }, "secretkey");

      res.status(200).json({ token, ...existUser });
    } catch (error) {
      res.status(500).json({ error });
    }
  }
);

authRouter.get("/", auth, async (req: AuthRequest, res) => {
  if (!req.user) {
    res.status(404).json({
      error: "User not found!",
    });
  }
  res.status(200).json(req.user);
});

export default authRouter;
