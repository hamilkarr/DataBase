const member = require("../models/member");
const express = require("express");
const router = express.Router();

router.get("/", async (req, res) => {
  const list = await member.getList();
  // console.log(list);
  return res.render("main/index", { list: list });
});

module.exports = router;
