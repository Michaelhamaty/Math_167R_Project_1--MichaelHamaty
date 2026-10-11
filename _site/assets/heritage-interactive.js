// Deterministic local interaction adapted from https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API and https://developer.mozilla.org/en-US/docs/Web/API/Element/input_event.
// Mulberry32 adaptation: https://github.com/cprosche/mulberry32. It is noncryptographic and is used only for a deterministic teaching display.
(() => {
  "use strict";

  function mulberry32(seed) {
    let value = seed >>> 0;
    return function random() {
      value += 0x6D2B79F5;
      let result = value;
      result = Math.imul(result ^ (result >>> 15), result | 1);
      result ^= result + Math.imul(result ^ (result >>> 7), result | 61);
      return ((result ^ (result >>> 14)) >>> 0) / 4294967296;
    };
  }

  function settingSeed(base, start, end, n) {
    return (base + Math.round(start * 1000) * 1000003 + Math.round(end * 1000) * 10007 + n * 101) >>> 0;
  }

  function probabilityAt(index, n, start, end) {
    if (n === 1) return start;
    return start + (end - start) * index / (n - 1);
  }

  function simulate(start, end, n, repetitions, seed) {
    const random = mulberry32(settingSeed(seed, start, end, n));
    const means = new Float64Array(repetitions);
    let total = 0;
    for (let repetition = 0; repetition < repetitions; repetition += 1) {
      let successes = 0;
      for (let index = 0; index < n; index += 1) {
        if (random() < probabilityAt(index, n, start, end)) successes += 1;
      }
      means[repetition] = successes / n;
      total += means[repetition];
    }
    let sumSquares = 0;
    const mean = total / repetitions;
    for (const value of means) sumSquares += (value - mean) ** 2;
    return { means, mean, sd: Math.sqrt(sumSquares / (repetitions - 1)) };
  }

  globalThis.HeritageSimulation = { mulberry32, settingSeed, probabilityAt, simulate };

  function draw(tool) {
    const start = Number(tool.querySelector('[data-control="start"]').value);
    const end = Number(tool.querySelector('[data-control="end"]').value);
    const n = Number(tool.querySelector('[data-control="n"]').value);
    const repetitions = Number(tool.dataset.repetitions);
    const seed = Number(tool.dataset.seed);
    tool.querySelector('[data-output="start"]').value = start.toFixed(2);
    tool.querySelector('[data-output="end"]').value = end.toFixed(2);
    tool.querySelector('[data-output="n"]').value = String(n);

    const result = simulate(start, end, n, repetitions, seed);
    const canvas = tool.querySelector("canvas");
    const context = canvas.getContext("2d");
    const width = canvas.width;
    const height = canvas.height;
    context.clearRect(0, 0, width, height);
    context.fillStyle = "#fffdf8";
    context.fillRect(0, 0, width, height);
    context.font = "18px Avenir Next, sans-serif";
    context.fillStyle = "#173f47";
    context.fillText("Probability path", 55, 34);
    context.fillText("Simulated sample averages", 500, 34);

    const pathLeft = 55;
    const pathTop = 60;
    const pathWidth = 350;
    const plotHeight = 285;
    context.strokeStyle = "#d7d4c9";
    context.strokeRect(pathLeft, pathTop, pathWidth, plotHeight);
    context.beginPath();
    for (let index = 0; index < n; index += 1) {
      const x = pathLeft + pathWidth * index / Math.max(1, n - 1);
      const y = pathTop + plotHeight * (1 - probabilityAt(index, n, start, end));
      if (index === 0) context.moveTo(x, y); else context.lineTo(x, y);
    }
    context.strokeStyle = "#56745f";
    context.lineWidth = 4;
    context.stroke();

    const histogramLeft = 500;
    const histogramTop = 60;
    const histogramWidth = 345;
    const bins = 28;
    const counts = new Array(bins).fill(0);
    for (const value of result.means) {
      const index = Math.min(bins - 1, Math.floor(value * bins));
      counts[index] += 1;
    }
    const maximum = Math.max(...counts);
    context.strokeStyle = "#d7d4c9";
    context.strokeRect(histogramLeft, histogramTop, histogramWidth, plotHeight);
    context.fillStyle = "#8b4f79";
    counts.forEach((count, index) => {
      const barWidth = histogramWidth / bins;
      const barHeight = maximum ? plotHeight * count / maximum : 0;
      context.fillRect(histogramLeft + index * barWidth + 1, histogramTop + plotHeight - barHeight, Math.max(1, barWidth - 2), barHeight);
    });

    context.fillStyle = "#40545a";
    context.font = "15px Avenir Next, sans-serif";
    context.fillText("Ordered position", 165, 380);
    context.fillText("Sample average from 3,000 runs", 550, 380);
    context.fillText("0", pathLeft - 12, pathTop + plotHeight + 20);
    context.fillText("1", pathLeft - 12, pathTop + 6);
    context.fillText("0", histogramLeft - 8, histogramTop + plotHeight + 20);
    context.fillText("1", histogramLeft + histogramWidth - 4, histogramTop + plotHeight + 20);

    const exactMean = (start + end) / 2;
    let varianceSum = 0;
    for (let index = 0; index < n; index += 1) {
      const probability = probabilityAt(index, n, start, end);
      varianceSum += probability * (1 - probability);
    }
    const exactSE = Math.sqrt(varianceSum) / n;
    tool.querySelector(".heritage-summary").textContent = `Exact mean ${exactMean.toFixed(3)}; exact SE ${exactSE.toFixed(3)}; simulated mean ${result.mean.toFixed(3)}; simulated SE ${result.sd.toFixed(3)}.`;
  }

  if (typeof document === "undefined") return;

  document.querySelectorAll(".heritage-tool").forEach((tool) => {
    const presets = {
      stable: [0.60, 0.60],
      increase: [0.45, 0.75],
      decrease: [0.75, 0.45]
    };
    tool.querySelectorAll("input").forEach((input) => input.addEventListener("input", () => {
      tool.querySelectorAll("[data-preset]").forEach((button) => button.setAttribute("aria-pressed", "false"));
      draw(tool);
    }));
    tool.querySelectorAll("[data-preset]").forEach((button) => button.addEventListener("click", () => {
      const values = presets[button.dataset.preset];
      tool.querySelector('[data-control="start"]').value = values[0];
      tool.querySelector('[data-control="end"]').value = values[1];
      tool.querySelectorAll("[data-preset]").forEach((candidate) => candidate.setAttribute("aria-pressed", String(candidate === button)));
      draw(tool);
    }));
    draw(tool);
  });
})();
