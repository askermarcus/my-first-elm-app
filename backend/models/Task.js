const mongoose = require("mongoose");

const labelSchema = new mongoose.Schema({
  name: { type: String, required: true, unique: true },
});
// Define the schema for a task
const TaskSchema = new mongoose.Schema({
  description: { type: String, required: true }, // Task description (required)
  completed: { type: Boolean, default: false }, // Completion status (default: false)
  timestamp: { type: Date, default: Date.now }, // Timestamp of task creation (default: current date)
  labels: [{ type: mongoose.Schema.Types.ObjectId, ref: "Label" }],
});

// Export the Task model
module.exports = mongoose.model("Task", TaskSchema);
