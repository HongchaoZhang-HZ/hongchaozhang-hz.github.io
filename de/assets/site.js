/* Derivation Engine documentation site: progressive enhancement only.
 *
 * Every page renders its full content, its sidebar, and its current-page
 * marker from static HTML. This script adds three optional conveniences:
 * a persisted theme choice, a narrow-screen sidebar toggle, and persisted
 * open/closed state for the sidebar groups. Nothing here is required to
 * read a page or to follow a link.
 */

(function () {
  "use strict";

  var THEME_KEY = "de-docs-theme";
  var GROUP_KEY_PREFIX = "de-docs-group:";
  var root = document.documentElement;

  function readStore(key) {
    try {
      return window.localStorage.getItem(key);
    } catch (error) {
      return null;
    }
  }

  function writeStore(key, value) {
    try {
      window.localStorage.setItem(key, value);
    } catch (error) {
      /* Private modes and disabled storage are not an error here. */
    }
  }

  /* Runs while the document head is parsed, so the stored theme is applied
     before the body paints. */
  root.classList.add("js");
  var storedTheme = readStore(THEME_KEY);
  if (storedTheme === "dark" || storedTheme === "light") {
    root.setAttribute("data-theme", storedTheme);
  }

  function prefersDark() {
    return (
      typeof window.matchMedia === "function" &&
      window.matchMedia("(prefers-color-scheme: dark)").matches
    );
  }

  function activeTheme() {
    var explicit = root.getAttribute("data-theme");
    if (explicit === "dark" || explicit === "light") {
      return explicit;
    }
    return prefersDark() ? "dark" : "light";
  }

  function setUpTheme() {
    var toggle = document.querySelector("[data-theme-toggle]");
    if (!toggle) {
      return;
    }

    function paint() {
      var dark = activeTheme() === "dark";
      toggle.textContent = dark ? "Light theme" : "Dark theme";
      toggle.setAttribute("aria-pressed", dark ? "true" : "false");
      toggle.setAttribute(
        "aria-label",
        dark ? "Switch to the light theme" : "Switch to the dark theme"
      );
    }

    toggle.hidden = false;
    paint();
    toggle.addEventListener("click", function () {
      var next = activeTheme() === "dark" ? "light" : "dark";
      root.setAttribute("data-theme", next);
      writeStore(THEME_KEY, next);
      paint();
    });
  }

  function setUpSidebar() {
    var toggle = document.querySelector("[data-nav-toggle]");
    var sidebar = document.getElementById("site-nav");
    if (!toggle || !sidebar) {
      return;
    }

    function close() {
      sidebar.classList.remove("is-open");
      toggle.setAttribute("aria-expanded", "false");
    }

    toggle.hidden = false;
    close();
    toggle.addEventListener("click", function () {
      var open = sidebar.classList.toggle("is-open");
      toggle.setAttribute("aria-expanded", open ? "true" : "false");
    });
    document.addEventListener("keydown", function (event) {
      if (event.key === "Escape" && sidebar.classList.contains("is-open")) {
        close();
        toggle.focus();
      }
    });
    /* Only now may the narrow-screen stylesheet collapse the sidebar: the
       button that reopens it exists and is wired. */
    root.classList.add("nav-enhanced");
  }

  function setUpGroups() {
    var groups = document.querySelectorAll("[data-nav-group]");
    Array.prototype.forEach.call(groups, function (group) {
      var key = GROUP_KEY_PREFIX + group.getAttribute("data-nav-group");
      var stored = readStore(key);
      /* A stored choice never hides the group the reader is currently in. The
         marker is a nested link on most pages and the group heading itself on
         the guide pages, so the group is matched on the state, not the tag. */
      if (stored === "closed" && !group.querySelector('[aria-current="page"]')) {
        group.open = false;
      } else if (stored === "open") {
        group.open = true;
      }
      group.addEventListener("toggle", function () {
        writeStore(key, group.open ? "open" : "closed");
      });
    });
  }

  /* One failing enhancement must never take the others down with it, and it
     must never leave the page in a state the reader cannot use. */
  function run(setUp) {
    try {
      setUp();
    } catch (error) {
      return;
    }
  }

  function start() {
    run(setUpTheme);
    run(setUpSidebar);
    run(setUpGroups);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", start);
  } else {
    start();
  }
})();
