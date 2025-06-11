const mongoose = require("mongoose");

const LabelSchema = new mongoose.Schema({
  name: { type: String, required: true, unique: true },
});

module.exports = mongoose.model("Label", LabelSchema);
