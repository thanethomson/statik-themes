---
title: Pagination
link-title: Pagination
order: 10
---

# Pagination

Support for pagination has been added in Statik `v0.10.0`. Pagination in
Statik is relatively flexible, and can be applied to
[complex path templates](../views/#complex-views) or to objects in your
[dynamic context](../templates/#dynamic-context-variables).

**Note**: this paginator starts numbering pages from 1 onwards. So if
you have 10 pages of items, the first page will be page number 1, and
the last page will be page number 10. See the API for the paginator
below for more details.

## Path-Based Pagination
For example, let's say you have a set of blog posts that you want
paginated at 10 posts per page, and you want each page to be accessible
from `/posts/{page_number}`. Simply add the following view
(`paged-posts.yml`):

```yaml
path:
  template: /posts/{{ page }}
  for-each:
    page: paginate(session.query(Post).order_by(Post.published.desc()), 10)
template: post-pages
```

As you can see here, the key is to use the built-in `paginate()`
function. See the API below for more details. Then accessing your paged
items within your template (in this case, `post-pages.html`):

```html+jinja
{% extends "base.html" %}

{% block title %}Posts, page {{ page.number }} of {{ page.total_pages }}{% endblock %}

{% block body %}
  <h1>Page {{ page.number }} of {{ page.total_pages }}</h1>
  <ul>
    {% for post in page %}
      <li><a href="{% url "posts", post %}">{{ post.title }}</a></li>
    {% endfor %}
  </ul>
  {% include "paginator.html" %}
{% endblock %}
```

We can then build a simple, reusable paginator (called `paginator.html`
in this example) to present the user with a list of pages:

```html+jinja
<div class="paginator">
  {% for page_no in page.page_range %}
    <a href="{% url "paged-posts", page_no %}">{{ page_no }}</a>
  {% endfor %}
</div>
```

If we really want to get fancy and give the user *next*/*previous*
links, and leave out the `<a/>` tag from our current page:

```html+jinja
<div class="paginator">
  {% if page.has_previous %}
    <a href="{% url "paged-posts", (page.number - 1) %}">&lt;</a>
  {% else %}
    &lt;
  {% endif %}
  {% for page_no in page.page_range %}
    {% if page_no == page.number %}
      {{ page_no }}
    {% else %}
      <a href="{% url "paged-posts", page_no %}">{{ page_no }}</a>
    {% endif %}
  {% endfor %}
  {% if page.has_next %}
    <a href="{% url "paged-posts", (page.number + 1) %}">&gt;</a>
  {% else %}
    &gt;
  {% endif %}
</div>
```

## Template Context Variable Pagination
If you wanted a particular query's results to be paginated only for use
within a template, you could simply add it to your dynamic template
context variables:

```yaml
path: /some/path
template: mypagedtemplateexample
context:
  dynamic:
    somevar: paginate(session.query(SomeVar), 10)
```

**Note**: rendering a paginated variable in a complex path results in
loss of access to the `Paginator` object itself (only the individual
pages are returned in the path variable). In the case of rendering
paginated variables in your template context, you will get direct
access to an instance of a `Paginator` class.

## API
### `paginate(db_query, items_per_page, offset=0)`
Returns an iterable `Paginator` instance for the given database query.

#### Parameters
* `db_query`: A SQLAlchemy database query object.
* `items_per_page`: The maximum number of items to allow in a single page.
* `offset`: An optional number of items to skip initially when
  paginating. As an alternative to this, one could simply just chain the
  `.offset()` SQLAlchemy filtering in the original `db_query` before
  passing it to `paginate()`.

#### Returns
An instance of the `Paginator` class.

### `Paginator`
A class to encapsulate a pagination operation. Iterating through this
(iterable) paginator provides each and every page (each one an instance
of the `Page` class - see below).

#### Properties
* `db_query`: The SQLAlchemy database query.
* `items_per_page`: The maximum number of items to allow in a single page.
* `offset`: The optional number of items to skip over first in `db_query` when rendering pages.
* `page_range`: A Python `range` object containing a range from 1 to `total_pages` (inclusive).
* `total_items`: The total number of items that would be returned by `db_query`.
* `total_pages`: The total number of pages in this paginator.

#### Methods
* `empty()`: Returns `True` if this paginator has no items at all, or `False` otherwise.

#### Accessing specific pages
To access an individual page, simply use Python's list accessors:

```python
# Remember, pages are numbered from 1 onwards! :-)
page4 = paginator[4]
```

### `Page`
Encapsulates a single page of paged items. Iterating through an instance
of the `Page` class will yield the items themselves. Many of the
important properties

#### Properties
* `count`: The number of items in this page.
* `has_next`: Returns `True` if there is another page after this one, otherwise `False`.
* `has_previous`: Returns `True` if this page has a preceding page, otherwise `False`.
* `items`: An iterable list of the actual items for this page.
* `items_per_page`: The maximum number of items on a single page.
* `number`: The number of this page (indexed from 1).
* `number0`: The number of this page (indexed from 0). So if `number` is 4, `number0` will be 3.
* `page_range`: A Python `range` object running from 1 through to `total_pages` (inclusive).
* `paginator`: Provides access to the original `Paginator` class instance.
* `total_items`: The total number of items in the paginator.
* `total_pages`: The total number of pages in the paginator.

