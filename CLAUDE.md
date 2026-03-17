# CLAUDE.md

This file provides guidance for AI assistants working with this repository.

## Project Overview

**Rabid Curiosity** is a Jekyll-based static blog hosted on GitHub Pages at [blog.thomas-bray.com](https://blog.thomas-bray.com). It uses the [Chirpy theme](https://github.com/cotes2333/jekyll-theme-chirpy) and covers topics in psychology, personal development, economics, and mental health.

- **Framework**: Jekyll (Ruby static site generator)
- **Theme**: jekyll-theme-chirpy ~> 7.4
- **Hosting**: GitHub Pages with custom domain
- **Branch for production**: `main` / `master`

## Repository Structure

```
dtbray.github.io/
├── _config.yml          # Main Jekyll site configuration
├── _posts/              # Blog post markdown files (YYYY-MM-DD-slug.md)
├── _tabs/               # Navigation tab pages (about, archives, categories, tags)
├── _data/               # YAML data files (contact.yml, share.yml)
├── _plugins/            # Ruby Jekyll plugins
├── assets/              # Static assets (images, JS, CSS)
│   └── lib/             # Git submodule: chirpy-static-assets
├── tools/               # Build and development shell scripts
│   ├── run.sh           # Start local dev server
│   └── test.sh          # Production build + HTML validation
├── .devcontainer/       # VS Code Dev Container configuration
├── .github/workflows/   # GitHub Actions CI/CD pipeline
├── .vscode/             # VS Code tasks and settings
├── Gemfile              # Ruby gem dependencies
├── CNAME                # Custom domain: blog.thomas-bray.com
└── index.html           # Homepage layout template
```

## Development Workflow

### Local Development

Start the Jekyll dev server with live reload:

```bash
bash tools/run.sh
```

Options:
- `-H <host>` / `--host <host>` — bind to a specific host
- `-p` / `--production` — build with `JEKYLL_ENV=production`
- `-h` / `--help` — display usage

The server runs at `http://localhost:4000` by default.

### Production Build & Testing

```bash
bash tools/test.sh
```

This cleans `_site/`, builds with `JEKYLL_ENV=production`, and runs `htmlproofer` to validate internal links.

### VS Code Tasks

- **Run Jekyll Server** (default build task) — runs `tools/run.sh`
- **Build Jekyll Site** (build task) — runs `tools/test.sh`

Trigger via `Cmd/Ctrl+Shift+B`.

## Git Submodules

The `assets/lib/` directory is a git submodule pointing to `chirpy-static-assets`. Always clone with submodules:

```bash
git clone --recurse-submodules <repo-url>
```

Or initialize after cloning:

```bash
git submodule update --init
```

The GitHub Actions workflow handles this automatically.

## Writing Blog Posts

### File Naming

Posts live in `_posts/` and must follow Jekyll's naming convention:

```
YYYY-MM-DD-title-slug.md
```

Example: `2025-11-29-growth-through-constraints.md`

### Front Matter

Every post requires this YAML front matter:

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

- `categories`: Use 1–2 broad categories (e.g., `Psychology`, `Economics`)
- `tags`: Use specific lowercase descriptors
- `date`: Include timezone offset (e.g., `-0500` for EST)

### Content Style

- Write in Markdown
- Use `##` and `###` for section headings (H2 and H3)
- Blog topics are psychology, personal development, economics, and mental health

## Site Configuration

Key fields in `_config.yml`:

| Field | Value |
|-------|-------|
| `title` | Rabid Curiosity |
| `tagline` | Pulling at threads, testing ideas, and making sense of the systems we live in |
| `url` | https://blog.thomas-bray.com |
| `author.name` | Thomas Bray |
| `author.email` | contact@thomas-bray.com |
| `github.username` | dtbray |
| `timezone` | America/New_York |
| `lang` | en |

Do not change `url`, `baseurl`, or `CNAME` without updating the GitHub Pages custom domain settings.

## Navigation Tabs (`_tabs/`)

Each tab is a Markdown file with front matter defining its position:

```yaml
---
layout: categories   # or tags, archives, page
icon: "fas fa-tag"
order: 1
---
```

Current tabs (in order): Categories (1), Tags (2), Archives (3), About (4).

## Plugins

`_plugins/posts-lastmod-hook.rb` — automatically sets `last_modified_at` on posts by querying git history. This runs at build time; do not remove it.

## Social Links & Sharing

- `_data/contact.yml` — defines footer social links (GitHub, Twitter, Email, RSS)
- `_data/share.yml` — defines post sharing buttons (Twitter, Facebook, Telegram)

Edit these files to add/remove social platforms using Font Awesome icon names.

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/pages-deploy.yml`) triggers on push to `main`/`master`:

1. Checkout with full git history and submodules
2. Setup Ruby 3.3 with bundler cache
3. Build Jekyll site (`JEKYLL_ENV=production`)
4. Test with htmlproofer (internal links only; external link testing is disabled)
5. Deploy to GitHub Pages

**Do not modify the workflow** unless you understand the impact on deployment.

## Code Style

The `.editorconfig` enforces:
- **Indentation**: 2 spaces (YAML, HTML, JS, CSS, Ruby, Markdown)
- **Line endings**: LF
- **Charset**: UTF-8
- **Trailing whitespace**: trimmed (except Markdown)
- **Final newline**: required

Prettier is the default formatter in VS Code. Format-on-save is enabled.

## Dependencies

Managed via `Gemfile`. Key gems:

- `jekyll-theme-chirpy ~> 7.4, >= 7.4.1`
- `html-proofer ~> 5.0`

Install with:

```bash
bundle install
```

Do not manually edit `Gemfile.lock`; let Bundler manage it.

## Common Tasks

### Add a new blog post

1. Create `_posts/YYYY-MM-DD-your-post-slug.md`
2. Add required front matter (title, date, categories, tags)
3. Write content in Markdown
4. Test locally with `bash tools/run.sh`

### Update site metadata

Edit `_config.yml`. Restart the dev server after changes — Jekyll does not hot-reload `_config.yml`.

### Add a navigation tab

Create a new file in `_tabs/` with appropriate front matter including `layout`, `icon`, and `order`.

### Change social links

Edit `_data/contact.yml` or `_data/share.yml` using Font Awesome icon class names.

## Pending Setup

### Comments (Giscus)

Comments are disabled (`comments: false` in `_config.yml` defaults). To enable:

1. Enable GitHub Discussions on the repo (Settings → General → Features → Discussions)
2. Install the Giscus GitHub App: https://github.com/apps/giscus → authorize for `dtbray/dtbray.github.io`
3. Visit https://giscus.app, enter `dtbray/dtbray.github.io`, choose a Discussion category
4. Copy the `data-repo-id` and `data-category-id` values it generates
5. Add to `_config.yml`:

```yaml
comments:
  provider: giscus
  giscus:
    repo: dtbray/dtbray.github.io
    repo_id: # paste data-repo-id here
    category: # category name chosen in step 3
    category_id: # paste data-category-id here
    mapping: pathname
    strict: 1
    input_position: bottom
    lang: en
    reactions_enabled: 1
```

6. Set `comments: true` in the `_config.yml` posts defaults
