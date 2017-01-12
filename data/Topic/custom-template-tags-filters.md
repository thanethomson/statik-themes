---
title: Custom Template Tags/Filters
link-title: Custom Tags/Filters
order: 9
---

# Custom Template Tags and Filters

The [Jinja2](http://jinja.pocoo.org/) template engine supports custom
template tags and filters, and as of v0.6.0 so does **Statik**. To make
custom template tags and/or filters available to your templates, simply
do the following:

1. Write your tags/filters in Python code, making sure to **register**
   them (see the examples below).
2. Drop them into your project's `templatetags` directory.
3. Use them in your templates!

## Custom Filters
A filter allows you to pass a variable or expression through a
particular function, and gives you a value on the output.

Let's say we wanted a super simple filter that takes a string as an
input, and converts it into a
[slug](https://en.wikipedia.org/wiki/Semantic_URL#Slug). For this, we're
going to use the
[python-slugify](https://github.com/un33k/python-slugify) library, so
make sure you've installed it first:

```bash
> cd /path/to/your/project/
# Activate your virtual environment
> source bin/activate
# Install python-slugify
> pip install python-slugify
```

Then, write your filter code:

```python
# templatetags/myfilters.py
from statik.templatetags import register
from slugify import slugify

@register.filter(name='slugify')
def filter_slugify(s):
    return slugify(s)
```

In your template, you'd use the filter as follows:

```html+jinja
<!-- ... -->
Here's the slugified version of "Hello world!": {{ "Hello world!"|slugify }}
```

Of course, you would most likely pass variables in instead of constant
strings, like the `"Hello world!"` string above, like `{{
my_variable|slugify }}` or `{{ post.title|slugify }}`. See the
[example project](https://github.com/thanethomson/statik/tree/master/examples/blog)
in the **Statik** repo for an example.

## Custom Template Tags
Jinja2 template tags are usually better likened to function calls, and
are called differently to filters. Right now, **Statik** only supports
simple tags that take zero or more arguments. Support for custom
block-style tags (like Jinja's built-in `{% for %}{% endfor %}` tags)
will come in future.

Let's say you wanted to create a tag that generated a random integer,
called `{% rand %}`. By default, with no arguments, we want it to
generate a random number between 1 and 100 (inclusive). Otherwise, we
want to be able to supply two integers to act as the inclusive boundary
parameters, within which we want to generate a random integer (like `{%
rand 25 255 %}`, which will generate a random number between 25 and
255).

```python
# templatetags/mytags.py
from statik.templatetags import register
import random

@register.simple_tag(name='rand')
def tag_random(*args):
    lower_bound = 1
    upper_bound = 100
    if len(args) == 2:
        lower_bound = args[0]
        upper_bound = args[1]
    return random.randint(lower_bound, upper_bound)
```

Using the tag is now as simple as doing the following from your
template:

```html+jinja
Random number between 1 and 100: {% rand %}<br />
Random number between 25 and 255: {% rand 25 255 %}
```

See the
[blog example](https://github.com/thanethomson/statik/tree/master/examples/blog)
in the `examples` directory of the repo for an implementation of this.

## API

### `@register.filter` decorator
The `@register.filter` decorator allows you to register a filter. If no
parameter is supplied to the decorator, it assumes that you want to use
the name of the function as the filter name.

```python
@register.filter
def my_simple_filter(s):
    # ...
```

Then, in your template, you can use it as follows:

```html+jinja
Let's test out {{ var|my_simple_filter }}.
```

Alternatively, if you want to customise the name of your filter, you can
specify a custom name for it as follows:

```python
@register.filter(name='myfilter')
def filter_myfilter(s):
    # ...
```

Then you'll access it from your template as follows:

```html+jinja
Let's test out {{ var|myfilter }}.
```

### `@register.simple_tag` decorator
The `@register.simple_tag` decorator allows you to register a simple tag
with **Statik**, usable from your templates. Works similarly to the
`@register.filter` decorator in terms of naming your tag.
