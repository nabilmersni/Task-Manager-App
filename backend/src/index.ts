import express from "express";
import cors from "cors";
import authRouter from "./routes/auth";
import taskRouter from "./routes/task";

const app = express();

app.use(
  cors({
    origin: "*",
  })
);
app.use(express.json());
app.use("/auth", authRouter);
app.use("/tasks", taskRouter);

app.listen(8000, () => {
  console.log("Server started on port 8000");
});
