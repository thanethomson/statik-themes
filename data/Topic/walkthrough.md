---
title: Walkthrough
link-title: Walkthrough
order: 3
---

# Walkthrough

Before starting your first **Statik** project, you've got to understand that it isn't geared to only produce blogs, where the majority of other [static site generators](https://www.staticgen.com/) seem to be dedicated to blogs and the like.

## Step 1: Create project skeleton
After [installing Statik](Installation), create yourself a directory somewhere for your project with the following sub-directory structure:

```
models/    - This is where your data models will go.
data/      - This is where your data will go.
templates/ - Your site templates will go here.
views/     - Configuration setting up your views (i.e. how your URLs/data/templates are processed) will go here.
assets/    - All of the static files (JavaScript/CSS/images/etc.) for your project will go here.
```

Fortunately, **Statik** provides a `quickstart` command to create all of this for you:

```bash
> statik -p /path/to/new/project --quickstart
```

## Step 2: Set up your project configuration
Create a `config.yml` file in the root of your project, with the following (YAML) format:

```yaml
project-name: My Project's Name
base-path: /
context:
  static:
    site-title: My Site Title
  dynamic:
    all-authors: session.query(Author).all()
```

#### `project-name`
This is purely for informational purposes.

#### `base-path`
Sometimes you'll want to serve your generated static site from a non-root location on your web server (e.g. `http://somewhere.com/mysite/` instead of from `http://somewhere.com`). **Statik** generates URLs in a relative manner, so this `base-path` value is prepended to all generated URLs in your templates.

#### `context`
This variable defines `static` and `dynamic` context that is accessible from any of your templates (not just from specific views). The `static` variables are provided as-is into your templates, whereas you define actual Python SQLAlchemy query code in the `dynamic` variables (this is prepopulated before rendering the templates).

## Step 3: Define your data models
**Statik** uses [SQLAlchemy](http://www.sqlalchemy.org/) under the hood to build up an in-memory SQLite database from which your views and templates can execute queries. You define your models in YAML format.

#### Sample model: `models/Post.yml`
```yaml
title: String
slug: String
author: Author       # This will be auto-detected as a foreign key reference
summary: String
published: DateTime
content: Content
```

#### Sample model: `models/Author.yml`
```yaml
first-name: String
last-name: String
email: String
```

These will be converted into SQL database tables in your in-memory SQLite database while building your project.

**IMPORTANT**: All field names will have their dashes (-) replaced by underscores (_) when creating the in-memory database. So `first-name` will become `first_name`.

## Step 4: Define your data
So now that you've defined what your database "tables" will be, you need some data in those tables to make your site useful. Data can either be defined in YAML format, or in [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) format.

For each of your models, create a subfolder in your project's `data/` folder as such:

```
data/Author/ - Where your site's "Author" model instances will be stored.
data/Post/   - Where your site's "Post" model instances will be stored.
```

Each `.yml` or `.md` file in each of those folders will represent an instance of the relevant model, with the file name of the file itself becoming the *primary key* of that particular instance. So, a file called `michael.yml` in the `data/Author` folder will be inserted as an entry whose primary key is `michael` into the `Author` in-memory database table.

By default, all primary key fields for all models are `String` fields with the field name `pk`.

#### Sample instance: `data/Author/michael.yml`
```yaml
first-name: Michael
last-name: Anderson
email: manderson@somewhere.com
```

This defines an `Author` model instance, where the `pk` (primary key) field will be `michael` (as per the file name, minus the extension), and the 3 fields of the model will be populated (`first_name`, `last_name`, `email`).

#### Sample instance: `data/Post/2016-06-22-my-first-post.md`
```md
---
title: My first post
slug: my-first-post
summary: A little summary about my first post
author: michael
published: 2016-06-22
---

This is the **Markdown** content that will automatically be inserted into the
`content` field of the model instance, because the `content` field is of type
`Content` (which, by the way, is translated into a SQLite `TEXT` field in the
in-memory database).
```

Note the YAML "preamble" at the beginning of the Markdown file, started and ended with three dashes (`---`).

Also note how the `author` field simply has the name `michael` attached to it. Under the hood, this is the primary key reference to the relevant `Author` model instance to attach to this `Post` instance (i.e. this refers to our earlier defined `michael.yml` instance).

## Step 5: Define your templates
**Statik** uses the [Jinja2](http://jinja.pocoo.org/) templating engine under the hood, so Python developers with Jinja2 experience, and those familiar with the Django templating engine, shouldn't have a hard time writing **Statik** templates. For more detailed information, see the [Jinja2 documentation](http://jinja.pocoo.org/docs/dev/templates/).

#### Sample template: `templates/base.html`
```html+jinja
<!DOCTYPE html>
<html>
<head>
  <title>{% block title %}{% if page_title %}{{ page_title }}{% else %}My Blog{% endif %}{% endblock %}</title>
</head>
<body>
  <div class="container">
    {% block body %}{% endblock %}
  </div>
</body>
</html>
```

This defines our generic web page layout that we'll apply across all of our different kinds of pages. It allows us to avoid having to rewrite all of this code over and over again for all of our templates, only varying the parts that change depending on what kind of page we're displaying.

#### Sample template: `templates/home.html`
```html+jinja
{% extends "base.html" %}

{% block body %}
  <h1>Welcome to My Blog!</h1>
  <p>These are my latest posts</p>
  <ul>
    {% for post in posts %}
      <li><a href="{% url "post", post %}">{{ post.title }}</a></li>
    {% endfor %}
  </ul>
{% endblock %}
```

This is a more complex template (to represent our home page/primary landing page), so let's go through it step by step:

* `{% extends "base.html" %}` - Tells the template engine to base our current template on the `base.html` file we
  defined previously.
* `{% block body %}...{% endblock %}` - This tells the template engine to insert whatever's inside the block into the
  block named `body`, which we defined in our `base.html` file.
* `{% for post in posts %}...{% endfor %}` - This is a `for` loop that iterates over a list variable called `posts`,
  which we will define when we define our **views** (see below).
* `{% url "post", post %}` - This tells the template engine to render a relative URL using the view called `post` (which
  we will define a little later), passing the current `post` object to that view when rendering the URL.
* `{{ post.title }}` - Outputs the current `for` loop iteration's `post` object's `title` field value.

#### Sample template: `templates/post.html`
```html+jinja
{% extends "base.html" %}

{% block body %}
  <h1>{{ post.title }}</h1>
  <div class="content">
    {{ post.content|safe }}
  </div>
{% endblock %}
```

This template defines how we'll be rendering individual posts, and is similar in structure to our `home.html` template in how it overrides the `base.html` page, but defines different inner content inside the `body` block.

You'll notice that we're passing the `post.content` variable contents through the `safe` filter here - this is because our Markdown content is generated as pure HTML, and the Jinja2 templating engine automatically escapes HTML content by default. We're telling Jinja2 here that our `post.content` field's contents are safe to render without escaping here.

## Step 6: Tie it all together with views
Views allow you to tell **Statik** how to render the various different URLs of your static web site. They can either be simple, or complex. Simple views specify how to render a specific URL (e.g. if you're rendering the home page, or an about page), whereas complex views define *recipes* for collections of views (e.g. if you're rendering a whole bunch of `Post` instances).

#### Sample view: `views/home.yml`
```yaml
path: /
template: home     # The .html is automatically added by Statik
context:
  static:
    page-title: Welcome to my blog
  dynamic:
    posts: session.query(Post).filter(Post.published != None).order_by(Post.published.desc()).all()
```

There's a lot going on here in one little view, so let's walk through it:

* `path: /` - This defines which relative URL (relative to the base path) we're rendering. As you can see, this is a
  *simple* view, as it only defines a single path.
* `template: home` - This defines which template to use in our `templates` folder when rendering this view. **Statik**
  will automatically add the `.html` extension when looking for the template in your `templates` folder, so this refers
  to our `templates/home.html` template that we defined in our previous step.
* `context:` - This section defines "context" variables which are passed into the Jinja2 template renderer.
* `  static:` - This defines "static" context variables passed in as-is into the Jinja2 template rendered. If a variable
  is defined under this section, like the `page-title` variable, its value will be passed into the template engine
  as-is.
* `  dynamic:` - This is where some real magic happens. Variables defined as being "dynamic" are assumed to be
  [SQLAlchemy ORM queries](http://docs.sqlalchemy.org/en/rel_1_0/orm/tutorial.html), and are therefore actually just
  Python code that's executed to populate these dynamic variables. **Statik** makes a `session` variable available, which
  is an ORM session to access the in-memory SQLite database once all models and data have been populated. You can then
  refer to each of your defined models by their name, as they are also made available when defining your queries.

#### Sample view: `views/post.yml`
```yaml
path:
  template: /{{ post.published|date("%Y/%m/%d") }}/{{ post.slug }}
  for-each:
    post: session.query(Post).filter(Post.published != None).all()
template: post
```

This is an example of a *complex* view, where a recipe for a path is given.

* `path: template:` - This defines the template for the URL we're going to render. It's just a Jinja2 template.
* `path: for-each:` - We can define **one** variable here (we've defined one called `post`), where its value is
  a SQLAlchemy ORM query. Here we're basically getting a list of all of the posts that have been published
  already. **Statik** will render this view for each of these instances, and will render each one according to
  the template defined in `template:` above.
* `template:` - This is the template for the view itself, or how we're going to render each post. Here, we've
  specified to use the `templates/post.html` file to render each post.

**NOTE**: Remember how, in our `templates/home.html` file we used the `{% url %}` tag to refer to the `post` view? Well, this is the view we're referring to (`views/post.yml`). **Statik** will take the `post` instance from the `home.html` template and pass it into this `views/post.yml` view in order to compute the post's URL from the view recipe.

## Step 7: Build your project!
Now, we're ready to build the project.

```bash
> statik
```

Now check your project's directory for a `public/` folder - that's where we've generated the new static site.
