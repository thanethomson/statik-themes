---
title: Templates
link-title: Templates
order: 7
---

# Templates

**Statik** uses [Jinja2](http://jinja.pocoo.org/) as its templating
*engine, so if you're familiar with
*[Django](https://www.djangoproject.com/)'s templating engine it'll be
*pretty easy to get into using **Statik**'s.

This guide will only cover the basics of **Jinja2** templating with
**Statik** context variables. For more details, the [Jinja2 Template
Designer Documentation](http://jinja.pocoo.org/docs/dev/templates/) will
help.

## Contents
* [Variables](#variables)
* [Template Tags](#template-tags)
* [Filters](#filters)

## Variables
One of the most powerful features of any templating engine is its
ability to embed variable values when rendering the templates.
**Statik** template variables can come from two different places:

1. **View context** - Every view can also define `context` variables
   (both `static` and `dynamic`). See the [Views](../views/) documentation on
   how to configure views.
2. **Project context** - In your `config.yml`
   file within your project, you can define a `context` variable with both
   `static` and `dynamic` context. See the
   [Project Configuration](../project-config/) documentation for more
   details.

The above order also gives the order of precedence for your variables
(i.e. if a view context variable and project context variable both have
the same name, view variables will override project variables).

### Static Context Variables
When defining static context variables, their exact value will be
inserted into your template when rendering. Say, for example, your
`config.yml` file defines the following static context:

```yaml
# config.yml
# ...
context:
  static:
    site-title: This is my page title!
```

And say, for example, your template looks like this:

```html+jinja
<!DOCTYPE html>
<html>
<head><title>{{ site_title }}</title></head>
<body>
  <!-- page body goes here... -->
</body>
</html>
```

When your template is rendered, it will contain the following HTML content:

```html
<!DOCTYPE html>
<html>
<head><title>This is my page title!</title></head>
<body>
  <!-- page body goes here... -->
</body>
</html>
```

### Dynamic Context Variables
Dynamic context variables are probably the most powerful feature of
**Statik**, where you can define
[SQLAlchemy](http://www.sqlalchemy.org/) queries to query your project's
data in versatile ways to insert into your templates.

Here's an example `config.yml` file that defines a global dynamic
variable called `authors`, which is effectively a string containing a
SQLAlchemy query. This query is executed when **Statik** builds your
project, prior to rendering your views.

```yaml
# config.yml
# ...
context:
  dynamic:
    authors: session.query(Author).order_by(Author.last_name.asc()).all()
```

#### It's Python Code!
The first thing to notice here is that we're writing actual *Python
code* in our dynamic variables. One could use Python features such as
list comprehension here, lambdas, etc. The result of whatever we write
here gets put directly in to the dynamic variable `authors`
(technically, this means we could just write straight Python code here,
such as mathematical operations and the like, but it's generally more
versatile to use this to query our in-memory SQLAlchemy database).

#### Accessible Global Variables
The second thing to notice here is that there are many variables and
classes exposed when executing the Python code. For one, there's a
`session` variable that we're using in the query that is exposed from
the global scope - this is a standard SQLAlchemy
[session object](http://docs.sqlalchemy.org/en/rel_1_0/orm/session_basics.html).

Next, you'll see that your `Author` model is exposed as a global
variable and is accessible from your dynamic context variables too. In
fact, all of your models are represented in global scope by SQLAlchemy
models derived from a common `Base` object. See the [SQLAlchemy ORM
Tutorial](http://docs.sqlalchemy.org/en/rel_1_0/orm/tutorial.html) for
more details.

#### Dynamic Context Variables Example
Say, for example, you've got 2 instances of your `Author` model:

```yaml
# data/Author/michael.yml
first-name: Michael
last-name: Anderson
email: manderson@somewhere.com
```

and

```yaml
# data/Author/andrew.yml
first-name: Andrew
last-name: Michaels
email: amichaels@somewhere.com
```

And you've got a template that makes use of your `authors` dynamic
context variable as follows:

```html+jinja
<!-- ... -->

<ul class="authors-list">
  {% for author in authors %}
    <li><a href="mailto:{{ author.email }}">{{ author.first_name }} {{ author.last_name }}</a></li>
  {% endfor %}
</ul>

<!-- ... -->
```

This will ultimately render to the following HTML code:

```html
<!-- ... -->

<ul class="authors-list">
  <li><a href="mailto:manderson@somewhere.com">Michael Anderson</a></li>
  <li><a href="mailto:amichaels@somewhere.com">Andrew Michaels</a></li>
</ul>

<!-- ... -->
```

## Template Tags
**Statik** provides two additional
[template tag extensions](http://jinja.pocoo.org/docs/dev/templates/#extensions):

### `{% url "view-name"[, optional_param] %}`
This tag renders the URL for the view with the specified name. See
[Views](../views/) for detailed information on **Statik**'s views system.
This tag always renders **relative URLs**.

To render a simple view, only the view name is needed:

```html+jinja
<!-- my-simple-template.html -->
<!-- The following link refers to a view called "home" (views/home.yml). -->
Let's go <a href="{% url "home" %}">home</a>.
```

Complex views usually require a parameter/variable from which to
generate the full path:

```html+jinja
<!-- my-complex-template.html -->
<!-- The following link assumes there's a view called "post" (views/post.yml) that takes
     a single variable (post) as a parameter, from which it generates the URL for the view -->
Let's see what the <a href="{% url "post.yml", post %}">post</a> looks like.
```

If your project has a non-standard `base-path` configuration parameter
(see [Project configuration](../project-config/)), the `url` tag will
automatically prepend this to the generated link.

### `{% asset "relative/path/to/asset.js" %}`
This is a shortcut function to help in rendering the appropriate
relative URL to the given asset in your project's `assets.dest`
configuration parameter.

For example, if your project's source `assets` folder is structured as
follows:

```
assets/
assets/js/
assets/js/jquery.min.js
assets/css/reset.css
assets/css/styles.css
assets/images/logo.jpg
```

and you wanted to refer to `jquery.min.js` and the two CSS files from
your HTML template, you could simply just do the following:

```html+jinja
<!DOCTYPE html>
<html>
<head>
  <!-- ... -->
  <link rel="stylesheet" href="{% asset "css/reset.css" %}" />
  <link rel="stylesheet" href="{% asset "css/styles.css" %}" />
</head>
<body>
  <img src="{% asset "images/logo.jpg" %}" />
  <script src="{% asset "js/jquery.min.js" %}"></script>
</body>
</html>
```

Depending on how you've configured your project's `assets.dest`
parameter (see the relevant section in the
[project configuration](../project-config/#dest) documentation), this `asset`
tag will automatically render the appropriate **relative** URL for the
asset file you're requesting.

## Filters
**Statik** also provides an additional
[filter](http://jinja.pocoo.org/docs/dev/templates/#filters) for your
convenience.

### `date`
Allows you to render a `DateTime` (Python's `datetime`) object as a
string using the standard Python
[`strftime`](https://docs.python.org/3.5/library/datetime.html#strftime-strptime-behavior)
conventions.

For example, if you've got the following template content:

```html+jinja
Post was published on {{ post.published|date("%Y-%m-%d") }}
```

and the `post` variable has a timestamp of the 24th of June 2016, you'll
get the following output:

```html
Post was published on 2016-06-24
```
