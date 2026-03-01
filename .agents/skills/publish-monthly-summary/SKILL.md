---
name: publish-monthly-summary
description: Copy a generated monthly summary Markdown file from the path the user specifies into this repo, rename it to `summaries/YYYY.MM.DD.md`, then commit, tag, and push. Use when updating this repository with a new monthly summary and releasing it with the existing `vYYYY.MM.DD` tag convention.
---

# Publish Monthly Summary

Use this workflow for the monthly summary release in this repository.

## Inputs

- Source file
- Destination file: `summaries/YYYY.MM.DD.md`

## Steps

1. Confirm the source file exists.
2. Check existing files under `summaries/` and follow the `YYYY.MM.DD.md` naming rule.
3. Copy the source Markdown into this repository and place it at `summaries/YYYY.MM.DD.md`.
4. Review `git status --short` to ensure only the expected summary file is new or changed.
5. Check recent commit messages with `git log --oneline -n 12`.
6. Commit with `Add \`YYYY.MM.DD.md\``.
7. Check existing tags with `git tag --sort=-creatordate`.
8. Create the matching tag `vYYYY.MM.DD` on `HEAD`.
9. Push the current branch and the new tag to `origin`.

## Commands

```bash
cp [the file the user specifies] summaries/YYYY.MM.DD.md
git add summaries/YYYY.MM.DD.md
git commit -m "Add \`YYYY.MM.DD.md\`"
git tag vYYYY.MM.DD
git push origin main
git push origin vYYYY.MM.DD
```

## Checks

- Do not invent a filename pattern; always match existing files in `summaries/`.
- Do not create a second tag if `vYYYY.MM.DD` already exists.
- If the current branch is not `main`, push the current branch explicitly instead of assuming `main`.
- If the file was copied to the repository root by mistake, move it into `summaries/` before committing.
