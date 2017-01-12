---
title: Themes
link-title: Themes
order: 11
---

# Themes

**Statik** supports themes as of `v0.11.0`.

There are several reasons as to why you'd want to have multiple themes
in your project. Perhaps you're upgrading the look/feel of your site,
and you want to experiment with a new look while still keeping the
ability to roll back to an old look. Perhaps you've got several themes
and want to test out what your site looks like with each theme for the
best feel. Whatever your reason, **Statik** now supports this.

## Adding Themes
To add themes to your project, simply create a `themes` folder in your
project's folder and add each theme in its own folder. It's generally a
good idea to call your themes' subfolders by simple names, like
`mytheme1` or `flaming-lamborghini` (lowercase, skewered names). Each of
these folders needs an `assets` and `templates` folder, because those
are the only two things that should change as you vary your look/feel.
Your folder layout of your `themes` folder should look something like
the following:

```
themes/                              - Folder containing all your themes
themes/mytheme1                      - Base folder for the "mytheme1" theme
themes/mytheme1/assets               - Assets for the project when using the "mytheme1" theme
themes/mytheme1/templates            - Templates for mytheme1
themes/flaming-lamborghini           - Base folder for the "flaming-lamborghini" theme
themes/flaming-lamborghini/assets    - Assets for the project when using the "flaming-lamborghini" theme
themes/flaming-lamborghini/templates - Templates for flaming-lamborghini
```

Then, in your `config.yml` file, make sure you specify which theme to
use or your `themes` folder will be completely ignored:

```yaml
project-name: My Project
base-path: /
theme: flaming-lamborghini
```

**Note** that if you specify a theme, all assets and templates in the
project's base `assets` and `templates` folders will be ignored.

## Non-Themed Use
**Statik** will continue to work as it used to. Specifically, if no
`theme` parameter is supplied in your `config.yml` file, **Statik**
will look to your project's base `assets` and `templates` folders for
static files and templates.
