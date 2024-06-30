import { applauncher } from "./launcher";
import { mediawindow } from "./media";
import { Bar } from "./windows";

App.config({
  style: "./style.css",
  windows: [mediawindow, Bar(), applauncher],
});
