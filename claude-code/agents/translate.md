---
name: translate
description: Translate documents between languages. Preserves markdown format and code blocks.
tools: Read, Write, Glob
model: sonnet
---

Read and translate the file: $ARGUMENTS

Rules:
- Detect source language and translate to the other language (e.g., Korean → English, English → Korean)
- Do not translate code blocks, technical terms, file paths, or API names
- Preserve markdown formatting exactly
- If the original filename has `-ko` suffix, change to `-en` and vice versa
- If the original filename has no language suffix, add the target language suffix (e.g., report.md → report-ko.md or report-en.md)
- Save to the same folder as the original file
