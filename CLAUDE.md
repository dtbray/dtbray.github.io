# CLAUDE.md

This file provides guidance for AI assistants working with this repository.

## Project Overview

**Rabid Curiosity** is a Hugo-based static blog hosted on GitHub Pages at
[blog.thomas-bray.com](https://blog.thomas-bray.com). It uses the
[PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme and covers
psychology, personal development, economics, technology, and mental health.

- **Framework**: Hugo
- **Theme**: PaperMod, tracked as a git submodule at `themes/PaperMod`
- **Hosting**: GitHub Pages with custom domain
- **Production branch**: `main`

## Repository Structure

```text
dtbray.github.io/
├── hugo.toml            # Main Hugo site configuration
├── content/
│   ├── posts/           # Blog post Markdown files
│   ├── about.md         # About page
│   ├── archives.md      # PaperMod archives page
│   └── search.md        # PaperMod search page
├── static/CNAME         # Custom domain: blog.thomas-bray.com
├── themes/PaperMod      # Git submodule
├── tools/               # Build, lint, writing, and stats scripts
└── .github/workflows/   # GitHub Actions CI/CD
```

## Development

Start the local server:

```bash
bash tools/run.sh
```

The script uses a local `hugo` binary if present, otherwise it runs Hugo
`0.164.0` through Docker.

Build the production site:

```bash
bash tools/test.sh
```

Lint post front matter:

```bash
bash tools/lint-posts.sh
```

## Submodules

Clone with submodules:

```bash
git clone --recurse-submodules <repo-url>
```

Initialize after cloning:

```bash
git submodule update --init --recursive
```

## Writing Posts

Create a new post:

```bash
bash tools/new-post.sh "Post Title"
```

Posts live in `content/posts/` and use this front matter:

```yaml
---
title: "Post Title"
date: YYYY-MM-DD HH:MM:SS +/-TTTT
categories:
  - Category1
  - Category2
tags:
  - tag1
  - tag2
---
```

- `categories`: use 1-2 broad categories.
- `tags`: lowercase, hyphenated descriptors.
- `date`: include timezone offset when possible.

Before helping write or expand posts:

1. Read `WRITING.md`.
2. Run `bash tools/writing-context.sh`.
3. Read the target post.
4. Use `bash tools/new-post.sh "Title"` for new posts.

Most short posts are scaffolds. Treat generic headings like `## Introduction`,
`## Key Points`, and `## Conclusion` as placeholders, not final structure.

## Deployment

`.github/workflows/pages-deploy.yml` builds with Hugo `0.164.0`, uploads the
generated `public/` directory, and deploys to GitHub Pages. PaperMod currently
emits Hugo deprecation warnings for language fields; they are known upstream and
do not block builds with the pinned Hugo version.
