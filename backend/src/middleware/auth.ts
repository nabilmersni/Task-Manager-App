import { UUID } from "crypto";
import { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import { db } from "../db";
import { User, users } from "../db/schema";
import { eq } from "drizzle-orm";

export interface AuthRequest extends Request {
  userId?: UUID;
  token?: string;
  user?: User;
}

export const auth = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) {
      res.status(401).json({ msg: "No auth token, access denied!" });
      return;
    }
    const verified = jwt.verify(token, "secretkey");

    if (!verified) {
      res.status(401).json({ msg: "Token verification failed!" });
      return;
    }

    const verifiedToken = verified as { id: UUID };
    const [user] = await db
      .select()
      .from(users)
      .where(eq(users.id, verifiedToken.id));

    if (!user) {
      res.status(401).json({ msg: "User not found!" });
      return;
    }

    req.userId = verifiedToken.id;
    req.token = token;
    req.user = user;

    next();
  } catch (error) {
    res.status(500).json({
      msg: error,
    });
  }
};
