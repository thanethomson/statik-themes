---
title: Views
link-title: Views
order: 8
---

# Views

Views are the glue that ties your entire **Statik** project's
configuration, models, data and templates together. They define the
various URLs that your generated static site will have, as well as which
templates to render for each of those URLs. Views are written in YAML
format, and they go into your project's `views` folder.

Each view has a *name*, where this is defined by the filename portion of
the view's file name, without the extension. So, for example, if you
have a view called `views/home.yml`, the name of that view will be
`home`.

There are two kinds of views: *simple* and *complex*.

## Simple Views
A simple view only has a single URL/path associated with it. For
example:

```yaml
# views/home.yml
path: /
template: home
context:
  static:
    page-title: Welcome
```

Since this view's filename is `home.yml`, its name will be `home`.

The `path` parameter here tells **Statik** to render this view at the
path `/` in our generated static output (i.e. `/index.html`). The
`template` parameter tells **Statik** to use the template
`templates/home.html` (if you don't give it an extension, it'll
automatically append `.html`).

The `context` parameter gives an indication as to which variables to
expose to the template. See
[the section on template variables and context](../templates/#variables)
for more details.

## Complex Views
Complex views make use of the results of SQLAlchemy ORM/database queries
to build up URLs from a template. An example of this would be as
follows:

```yaml
path:
  template: /{{ post.published|date("%Y/%m/%d") }}/{{ post.slug }}
  for-each:
    post: session.query(Post).all()
template: post
```

This defines a complex `path` variable with `template` and `for-each`
parameters. The `template` is a string in plain Jinja2 templating
format. All of the usual Jinja2 filters are available to you when
rendering the path string.

The `for-each` parameter must contain one, and only one, variable whose
values can be obtained from a database query. This is handled by
**Statik** in the same way that
[dynamic context variables](../templates/#dynamic-context-variables) are.
The result of this query must be a Python `list` (or must at least be
iterable in `list` fashion). Each individual value in the list will be
passed through the path template in order to generate a URL for each of
the instances (it's up to you, by the way, to make sure that your path
template will generate a unique URL for each instance; otherwise
**Statik** will end up overwriting some of your instances' rendered
views).

When rendering each instance, it will make use of the `post` template
(i.e. `templates/post.html`).

## Pretty URLs
By default, **Statik** only supports pretty URLs. When it renders a URL,
say for example `/posts/2016/06/24/my-first-post/`, it will recursively
create all of those folders in the output and write the HTML output for
that URL into an `index.html` file (i.e.
`/posts/2016/06/24/my-first-post/index.html`).