"use strict";

const fs = require("fs");
require("../assets/heritage-interactive.js");

const simulation = globalThis.HeritageSimulation;
if (!simulation) throw new Error("Interactive simulation API was not exposed.");

const first = simulation.simulate(0.45, 0.75, 50, 3000, 631);
const second = simulation.simulate(0.45, 0.75, 50, 3000, 631);
if (first.mean !== second.mean || first.sd !== second.sd) throw new Error("Interactive simulation is not deterministic.");
if (!Array.from(first.means).every((value, index) => value === second.means[index])) throw new Error("Interactive draws are not deterministic.");

const increasing = Array.from({ length: 50 }, (_, index) => simulation.probabilityAt(index, 50, 0.45, 0.75));
const decreasing = Array.from({ length: 50 }, (_, index) => simulation.probabilityAt(index, 50, 0.75, 0.45));
const tolerance = 1e-12;
if (!increasing.every((value, index) => Math.abs(value - decreasing[decreasing.length - 1 - index]) < tolerance)) throw new Error("Increasing and decreasing paths are not reversals.");
if (Math.abs(increasing.reduce((total, value) => total + value, 0) / increasing.length - 0.60) > tolerance) throw new Error("Creative path mean is not 0.60.");
if (Math.abs(first.mean - 0.60) > 0.02) throw new Error("Interactive simulation center is unexpectedly far from exact theory.");

const html = fs.readFileSync("_site/extensions/heritage-language.html", "utf8");
const requiredFragments = [
  "data-preset=\"stable\"", "data-preset=\"increase\"", "data-preset=\"decrease\"",
  "data-control=\"start\"", "data-control=\"end\"", "data-control=\"n\"",
  "aria-live=\"polite\"", "role=\"img\"", "<noscript>", "heritage-interactive.js"
];
for (const fragment of requiredFragments) {
  if (!html.includes(fragment)) throw new Error(`Rendered interaction is missing: ${fragment}`);
}

console.log("Interactive validation passed.");
