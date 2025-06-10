const express = require("express");
const router = express.Router();
const Task = require("../models/Task");

router.get("/", async (req, res) => {
  try {
    const search = req.query.search;
    let query = {};
    if (search) {
      query.description = { $regex: search, $options: "i" };
    }
    const tasks = await Task.find(query);
    res.json(tasks);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Create a new task
router.post("/", async (req, res) => {
  const task = new Task({
    description: req.body.description, // Get description from request body
    completed: req.body.completed || false, // Default to false if not provided
    timestamp: new Date(),
  });

  try {
    const newTask = await task.save(); // Save the task to the database
    res.status(201).json(newTask); // Respond with the created task
  } catch (err) {
    res.status(400).json({ message: err.message }); // Handle validation errors
  }
});

// Update a task
router.patch("/:id", async (req, res) => {
  try {
    const task = await Task.findById(req.params.id); // Find task by ID
    if (!task) return res.status(404).json({ message: "Task not found" });

    // Update fields if provided in the request body
    if (req.body.description != null) {
      task.description = req.body.description;
    }
    if (req.body.completed != null) {
      task.completed = req.body.completed;
    }

    const updatedTask = await task.save(); // Save the updated task
    res.json(updatedTask); // Respond with the updated task
  } catch (err) {
    res.status(400).json({ message: err.message }); // Handle errors
  }
});

// Delete a task
router.delete("/:id", async (req, res) => {
  try {
    const task = await Task.findById(req.params.id); // Find task by ID
    if (!task) {
      return res.status(404).json({ message: "Task not found" });
    }

    await task.deleteOne(); // Use deleteOne instead of remove
    res.json({ message: "Task deleted" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router; // Export the router
