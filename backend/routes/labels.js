const express = require("express");
const router = express.Router();
const Label = require("../models/Label");

// Get all labels
router.get("/", async (req, res) => {
  try {
    const labels = await Label.find();
    res.json(labels);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Create a new label
router.post("/", async (req, res) => {
  const label = new Label({ name: req.body.name });
  try {
    const newLabel = await label.save();
    res.status(201).json(newLabel);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

module.exports = router;
