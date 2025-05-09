const mongoose = require("mongoose");

// Define the schema for a task
const TaskSchema = new mongoose.Schema({
  description: { type: String, required: true }, // Task description (required)
  completed: { type: Boolean, default: false }, // Completion status (default: false)
});

// Export the Task model
module.exports = mongoose.model("Task", TaskSchema);
