"use strict";

const fs = require("fs");

function interactiveElement(properties = {}) {
  return {
    ...properties,
    listeners: {},
    addEventListener(type, listener) { this.listeners[type] = listener; },
    setAttribute(name, value) { this[name] = value; }
  };
}

const controls = {
  start: interactiveElement({ value: "0.45" }),
  end: interactiveElement({ value: "0.75" }),
  n: interactiveElement({ value: "50" })
};
const outputs = { start: {}, end: {}, n: {} };
const buttons = ["stable", "increase", "decrease"].map((preset) => interactiveElement({ dataset: { preset } }));
const summary = { textContent: "" };
let canvasOperations = 0;
const context = new Proxy({}, {
  get(target, property) {
    if (!(property in target)) target[property] = () => { canvasOperations += 1; };
    return target[property];
  },
  set(target, property, value) { target[property] = value; return true; }
});
const canvas = { width: 900, height: 430, getContext: () => context };
const tool = {
  dataset: { seed: "631", repetitions: "3000" },
  querySelector(selector) {
    const control = selector.match(/^\[data-control="(.+)"\]$/);
    if (control) return controls[control[1]];
    const output = selector.match(/^\[data-output="(.+)"\]$/);
    if (output) return outputs[output[1]];
    if (selector === "canvas") return canvas;
    if (selector === ".heritage-summary") return summary;
    return null;
  },
  querySelectorAll(selector) {
    if (selector === "input") return Object.values(controls);
    if (selector === "[data-preset]") return buttons;
    return [];
  }
};
global.document = { querySelectorAll: (selector) => selector === ".heritage-tool" ? [tool] : [] };
require("../assets/heritage-interactive.js");
delete global.document;

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
if (!summary.textContent.includes("Exact mean")) throw new Error("Interactive initialization did not write its live summary.");
if (canvasOperations === 0) throw new Error("Interactive initialization did not draw to the canvas.");
buttons[0].listeners.click();
controls.n.listeners.input();

const html = fs.readFileSync("_site/extensions/heritage-language.html", "utf8");
const requiredFragments = [
  "data-preset=\"stable\"", "data-preset=\"increase\"", "data-preset=\"decrease\"",
  "data-control=\"start\"", "data-control=\"end\"", "data-control=\"n\"",
  "aria-live=\"polite\"", "role=\"img\"", "<noscript>", "heritage-interactive.js"
];
for (const fragment of requiredFragments) {
  if (!html.includes(fragment)) throw new Error(`Rendered interaction is missing: ${fragment}`);
}
if (html.includes("&lt;button") || html.includes("&lt;input")) throw new Error("Rendered controls were escaped as code text.");
if ((html.match(/<button\b/g) || []).length < 3) throw new Error("Rendered interaction has fewer than three real buttons.");
if ((html.match(/<input\b/g) || []).length < 3) throw new Error("Rendered interaction has fewer than three real inputs.");

console.log("Interactive validation passed.");
