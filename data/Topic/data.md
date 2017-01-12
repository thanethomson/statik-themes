---
title: Data
link-title: Data
order: 6
---

# Data
In order to populate your models' data, you need to create a unique
folder for each model, according to the model name, in your `data/`
folder. So, for example, if you have two models `Post` and `Author`, you
would have to create the directory structure:

```
data/Post/   - Where you will store all of your Post model instances
data/Author/ - Where you will store all of your Author model instances
```

## A Simple Instance
Let's say you wanted to create an instance of an `Author`. You would
create the following file:

```yaml
# data/Author/michael.yml
first-name: Michael
last-name: Anderson
email: manderson@somewhere.com
```

As mentioned in the [Models](../models/) section, every model is
automatically assigned a `pk` field (of type `String`) where the file
name of the instance is used as the primary key. In this case, our
instance's primary key will be `michael` (the filename minus the file
extension).

## Many Instances in a Single File
What if you have a simple model, and don't feel like going to the
trouble of defining every single instance in a separate file? Simply
create a file called `_all.yml` in your model's directory. For example,
if we have a `Tag` model as per our example
[here](../models/#many-to-many-relationships), we could create the following
file:

```yaml
# data/Tag/_all.yml
- pk: funny
  tag-name: Funny
- pk: philosophical
  tag-name: Philosophical
- pk: general
  tag-name: General
```

Note how we now have to define the value of our `pk` field, because
**Statik** can no longer get the value of the primary key from the file
name of the model instance. This example defines 3 instances of the
`Tag` class, ready to be referred to by our posts.

## One-to-Many/Many-to-One Relationships
As per the one-to-many/many-to-one example
[here](../models/#one-to-many-and-many-to-one-relationships), if we wanted
to define a `Post` instance and have the `author` field refer to our
newly created `Author` model, we'd just do this:

```yml
---
# data/Post/2016-06-22-my-first-post.md
title: My First Post
author: michael
---
```

The `author: michael` key/value pair in the example tells **Statik**
that the `pk` value to be associated with our new post's `author` field
must be `michael`.

## Many-to-Many Relationships
In a similar manner to how we handle one-to-many and many-to-one
relationships, we can also set up many-to-many relationships quite
easily. Let's say we want our `Post` model to be able to be tagged with
multiple `Tag`s, and we want a single `Tag` to be able to be applied to
multiple `Post`s - this is a perfect use case for a many-to-many
relationship, as in our example
[here](../models/#many-to-many-relationships).

Here's an example of a post with some tags:

```yml
---
title: My first post
tags:
  - funny
  - general
---
```

We've tagged this post with 2 tags: `funny` and `general`. It's
important to note that these are the `pk` field values of our `Tag`
instances which we defined earlier.