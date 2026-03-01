---
name: gh-release-latest-tag
description: Create a GitHub Release for the latest tag in this repository only when the release does not already exist. Use when Codex is asked to publish or backfill a missing Release for the newest `vYYYY.MM.DD` tag, and set the release body from the committed `summaries/YYYY.MM.DD.md` file referenced by that tag.
---

# Gh Release Latest Tag

Use this skill for this repository's release flow.

The repository convention is:

- Tag format: `vYYYY.MM.DD`
- Release title: same as the tag
- Release body: committed contents of `summaries/YYYY.MM.DD.md`

Do not read the working tree copy of the summary file for release notes. Always read the file from the tag's commit so the release body matches the committed artifact.

## Workflow

1. Check the newest local tag with `git tag --sort=-creatordate | head -n 1`.
2. Derive the summary date by removing the leading `v`.
3. Confirm the tag exists on `origin`.
4. Check whether the GitHub Release already exists with `gh release view`.
5. If the Release exists, stop without changing anything.
6. Read `summaries/YYYY.MM.DD.md` from the tag itself with `git show TAG:path`.
7. Create the Release with `gh release create TAG --title TAG --notes-file ...`.
8. Verify the created Release with `gh release view TAG`.

## Command

Run the bundled script from the repository root:

```bash
.agents/skills/gh-release-latest-tag/scripts/create_release_if_missing.sh
```

## Checks

- Require both `git` and `gh`.
- Assume repository slug `gh640/github-trending-repos-ja`.
- Fail if no local tag exists.
- Fail if the latest tag is not pushed to `origin`.
- Fail if `summaries/YYYY.MM.DD.md` does not exist in the tagged commit.
- Leave the working tree untouched.

## Notes

- This skill is project-local under `.agents/skills`.
- Use it for backfilling a missing Release after a tag was already pushed.
- If the user wants tag creation too, use or update the repository release script separately.

See `scripts/create_release_if_missing.sh` for the deterministic implementation.
