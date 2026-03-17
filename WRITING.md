# Writing Guide — Rabid Curiosity

This file is for AI assistants helping write or edit blog posts. Read it before
drafting or expanding any content.

---

## Voice and Tone

The clearest voice reference is the **About page** (`_tabs/about.md`). Read it
before writing anything. Key characteristics:

- **Analytical but personal.** Posts reason through ideas with structure, but
  the first-person perspective is always present. This isn't academic writing —
  it's thinking out loud by someone who happens to think carefully.
- **Intellectually honest.** Acknowledge when something is complicated, when
  you're not sure, when a model breaks down. Avoid false confidence.
- **Direct.** Short sentences preferred over long ones. Active voice. No
  throat-clearing preambles like "In today's post we will explore..."
- **Specific over general.** Concrete examples, named concepts, actual numbers
  when relevant. Avoid vague assertions.
- **Not a brand.** The about page says it plainly: this isn't a polished
  portfolio. Don't write like a content marketer. No listicles, no "key
  takeaways" boxes, no "click here to learn more."

Sentences from the about page that capture the register well:

> "I like understanding why things function the way they do—organizations,
> tools, habits, even the patterns in my own thinking."

> "Writing helps me do that. Hopefully reading some of it helps you do the
> same."

---

## The Blog's Intellectual Identity

The recurring move across posts is **applying a framework from one domain to
illuminate something in another**. This is the distinguishing characteristic —
not just writing about mental health, and not just writing about economics, but
using the vocabulary of each to sharpen thinking in the other.

Examples already in the works:
- Monetary discount rates → depression (temporal decision-making under illness)
- Transaction costs → social anxiety (the economic cost of social friction)
- Soma/Brave New World → psychiatric medication (literary frame for a real question)
- FIRE movement → mental health (financial independence as it actually intersects with illness)
- Scott Galloway → career philosophy (a concrete interlocutor to push against)

When writing a post, ask: **what's the frame, and is it doing real work?** A
clever title isn't enough — the framework should actually clarify something that
would otherwise be fuzzy.

---

## Post Structure

Scaffolds use `## Introduction / ## Key Points / ## Conclusion` as placeholders.
**Finished posts should not use this structure.** Replace it with:

- An opening that earns the reader's attention — a question, a tension, a
  specific observation. Not a definition of terms.
- Section headings (`##`) that reflect the actual argument, not generic labels.
- A conclusion that lands somewhere. Not a summary — a destination.

**Target length: 600–1,200 words** for a standard post. The public finance
series runs longer (800–1,500) because the subject requires it. Personal
reflection posts can be shorter if they're tight.

---

## Thematic Threads

Several threads run through multiple posts and should be acknowledged when
relevant. Don't force connections, but don't ignore them either.

**Mental health + economics**
The most distinctive thread. Posts: discount rates/depression, transaction
costs/social anxiety, FIRE/mental health, Zoloft/soma, shackles of anxiety,
discount rates and depression, self-efficacy and self-esteem. These posts form
a coherent body of work and should reference each other where natural.

**Learning and epistemics**
How we know things, how we change our minds, how we build knowledge. Posts:
reading widely/deeply, how to change your mind, building fundamental technical
knowledge, reflections on trusting trust, reflecting as a student. The
underlying question: what does it mean to actually understand something?

**Work and organizational life**
The experience of work, organizations, and careers. Posts: new guy syndrome,
customer service/Nordstrom, Scott Galloway/passion-skill-profit, Sam Altman/AI
productivity. Often grounded in personal professional experience.

**Public finance series**
Standalone analytical series. See the series overview post for structure. These
posts are more research-oriented and less personal than the other threads.

---

## What "Finished" Looks Like

A post is done when:
- It has a real argument, not just information
- The opening doesn't start with a definition or "In this post..."
- Section headings reflect structure, not generic labels (not "Introduction")
- It acknowledges genuine complexity without hiding behind it
- It ends somewhere, not just stops

A post is still a scaffold when:
- It has bullet points where paragraphs should be
- The word count is under ~200 (run `bash tools/stats.sh` to check)
- Headings are `## Introduction`, `## Key Points`, `## Conclusion`

---

## Categories and Tags in Use

Keep categories to 1–2 per post from this list:
- `Economics`
- `Psychology`
- `Personal Development`
- `Mental Health`
- `Public Finance of the States` (always paired with `Economics`)

Tags should be lowercase, hyphenated. Check existing tags before inventing new
ones (`bash tools/stats.sh` shows the current vocabulary). Prefer specificity:
`social-anxiety` over `anxiety` if the post is specifically about social anxiety.

---

## Cross-Referencing Posts

Jekyll/Chirpy supports post links via:
```markdown
[anchor text]({% post_url YYYY-MM-DD-slug %})
```

Use sparingly — only when the reference adds genuine value, not just to
demonstrate that other posts exist.

---

## Series Notes

**Public Finance of the States**: 7 states scaffolded (Indiana, Illinois, Ohio,
Texas, California, New York, Florida). 43 remaining. Indiana is the most
complete and serves as the structural model for state posts. Regional overviews
exist for all 4 Census Bureau regions. When writing state posts, keep the
Indiana post open as a reference for depth and structure.

---

## Things to Avoid

- Filler transitions: "In conclusion...", "As we can see...", "It is important
  to note that..."
- Hedging that doesn't add information: "some might argue", "it could be said"
- Motivational tone: this blog doesn't tell readers what to do or cheerlead
- Excessive qualifications in topics Thomas knows well (IT, Indiana politics,
  personal experience with mental health)
- Lists where prose would be clearer
