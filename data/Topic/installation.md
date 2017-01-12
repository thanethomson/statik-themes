---
title: Installation
link-title: Installation
order: 2
---

# Installation

There are two primary ways in which you can install **Statik**.

## Installation in a Virtual Environment
This is generally the recommended way of installing Python software, because it allows you to easily install multiple different versions of the same packages, with different (incompatible) versions of Python, all running simultaneously without interfering with each other.

Firstly, [install `virtualenv` on your operating system](https://virtualenv.pypa.io/en/stable/installation/).

```bash
> cd /path/to/your/desired/virtualenv/folder

# Create the virtual environment, but explicitly specify to use Python 3
# (If you want to use Python 2.7+, do: "virtualenv -p python2 ." instead)
> virtualenv -p python3 .

# Activate the virtual environment
> source bin/activate

# Upgrade PIP
> pip install --upgrade pip

# Install Statik
> pip install statik

# Check that it's installed properly
> statik --help
```

## Global Installation

### Via PyPI
Not really recommended, but definitely the easiest way to get **Statik** going without having to activate virtual environments. Make sure you've got Python 3 available on your command line, and that `PIP` is installed, then do the following:

```bash
> pip install statik

# On some systems, you may need sudo/root access to install Python packages globally
> sudo pip install statik
```

### Via Homebrew (MacOS only)
For ease-of-use, installation via [Homebrew](http://brew.sh) is
supported on MacOS.

```bash
# Update your local Homebrew installation
> brew update

# Install Statik and its dependencies
> brew install statik
```
