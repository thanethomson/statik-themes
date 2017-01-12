---
title: Models
link-title: Models
order: 5
---

# Models

Defining your data models with **Statik** is a breeze. It's important to
note that every YAML file in your project's `models/` folder represents
a database table in the in-memory SQLite database. Therefore, if you
create a file called `models/MyModel.yml`, **Statik** will create a
corresponding `MyModel` table (the filename minus the extension) with
the relevant fields within it.

## Model Format
Your model file should adhere to the following format:

```yaml
field1-name: Field1Type
field2-name: Field2Type
field3-name: Field3Type
# etc.
```

Field names with hyphens in the names will automatically have their
hyphens converted into underscores (_), so `field1-name` will be
converted into `field1_name`, and so on.

## Standard Fields
The following standard field types are currently supported:

* `String` - A simple string field (a standard `VARCHAR` field in SQLite)
* `Integer` - A 32-bit signed integer (`INT` field in SQLite)
* `DateTime` - A standard `DATETIME` type in SQLite
* `Text` - A larger text field than the `String` field (`TEXT` field in SQLite)
* `Boolean` - Simple boolean true/false value field
* `Content` - A `Text` field whose contents are automatically interpreted as Markdown content from the main content of a Markdown file.

**NOTE**: Only one `Content` field is allowed per model. This is because
there's no way at the moment for **Statik** to know which field to
populate from your Markdown file's Markdown content (the content
outside of the YAML preamble).

## Primary Keys
By default, every model will have a `pk` field of type `String` added to
it when it is created. This field will be populated with the file name
(minus the extension) of the model instance file in your `data/` folder.

## One-to-Many and Many-to-One Relationships
Standard SQL foreign key relationships are supported in the following
way: if you have two models defined, say `Post` and `Author`, where
`Author` is defined as:

```yaml
# models/Author.yml
first-name: String
last-name: String
email: String
```

and `Post` is defined as:

```yaml
# models/Post.yml
title: String
author: Author
```

you will see that `Post` has a `FOREIGN KEY` relationship to `Author` on
the field `author`. This allows you to query the related model in your
views' queries:

```yaml
# yourview.yml
# ...
context:
  dynamic:
    posts: session.query(Post).all()
```

```html+jinja
<!-- yourtemplate.html -->
{{ posts[0].author.first_name }}
```

### Reverse Relationships
To define a "reverse" relationship (i.e. backwards from the foreign
model), simply do the following:

```yaml
# models/Post.yml
title: String
author: Author -> posts
```

This allows you to perform such queries:

```html+jinja
<!-- yourtemplate.html -->
{% for post in author.posts %}
  <!-- ... -->
{% endfor %}
```

## Many-to-Many Relationships
Defining many-to-many relationships is just as easy:

```yml
# models/Post.yml
title: String
tags: Tag[] -> posts
```

```yml
# models/Tag.yml
tag-name: String
```

The syntax `<ForeignModel>[]` with the `[]` brackets indicates to
**Statik** that this field must be considered to be a many-to-many
relationship. As you can also see in the example above, the `Tag` model
will now have a *reverse* relationship called `posts` for easy lookup of
the posts associated with the tag:

```html+jinja
<!-- yourtemplate.html -->
{% for tag in post.tags %}
  <!-- do something with tag -->
{% endfor %}

{% for post in tag.posts %}
  <!-- do something with post -->
{% endfor %}
```