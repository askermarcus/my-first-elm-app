const express = require("express");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const cors = require("cors");
const tasksRouter = require("./routes/tasks"); // Import the tasks routes
const labelsRouter = require("./routes/labels");

const app = express();
const PORT = 3000;

// Middleware
app.use(cors()); // Enable Cross-Origin Resource Sharing
app.use(bodyParser.json()); // Parse JSON request bodies

// Routes
app.use("/tasks", tasksRouter); // Register the tasks routes
app.use("/labels", labelsRouter);

// Connect to MongoDB
const mongoUri = process.env.MONGO_URI || "mongodb://localhost:27017/todo";

mongoose
  .connect(mongoUri)
  .then(() => console.log("Connected to MongoDB"))
  .catch((err) => console.error("Could not connect to MongoDB:", err));

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
