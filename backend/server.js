const express = require("express");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const cors = require("cors");
const tasksRouter = require("./routes/tasks"); // Import the tasks routes

const app = express();
const PORT = 3000;

// Middleware
app.use(cors()); // Enable Cross-Origin Resource Sharing
app.use(bodyParser.json()); // Parse JSON request bodies

// Routes
app.use("/tasks", tasksRouter); // Register the tasks routes

// Connect to MongoDB
mongoose
  .connect("mongodb://localhost:27017/todo", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("Connected to MongoDB"))
  .catch((err) => console.error("Could not connect to MongoDB:", err));

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
