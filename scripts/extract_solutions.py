#!/usr/bin/env python3
"""Extract prompt + full solution for every question from the Udemy .mhtml review pages.

The .mhtml archives (decoded to lab/N.decoded.html) contain, per question:
  - the question prompt (rich-text)
  - the "Correct answer" solution with step-by-step Commands/Steps + Explanation

Output: scripts/questions_solutions.json
  { "test1": [ {num, status, prompt, solution}, ... ], ... }
"""
import json
import re
from pathlib import Path
from html.parser import HTMLParser

LAB = Path(__file__).resolve().parent.parent / "lab"
OUT = Path(__file__).resolve().parent / "questions_solutions.json"

RICH = 'data-purpose="safely-set-inner-html:rich-text-viewer:html"'


def balanced_div(html: str, start: int) -> str:
    """Given index of a '<div' that opens a region, return inner HTML up to its
    matching </div> using depth counting over div tags only."""
    # move to end of the opening tag
    tag_end = html.index(">", start) + 1
    depth = 1
    i = tag_end
    for m in re.finditer(r"<(/?)div\b", html[tag_end:]):
        if m.group(1):
            depth -= 1
        else:
            depth += 1
        if depth == 0:
            return html[tag_end:tag_end + m.start()]
        i = tag_end + m.end()
    return html[tag_end:]


class Renderer(HTMLParser):
    """Render question/solution HTML to readable text preserving code blocks."""

    def __init__(self):
        super().__init__()
        self.out = []
        self.in_pre = False         # inside <pre> code block
        self.li_buf = None          # buffer for current code line
        self.code_inline = 0

    def handle_starttag(self, tag, attrs):
        if tag == "pre":
            self.in_pre = True
            self.out.append("\n```bash\n")
            return
        if self.in_pre:
            if tag == "li":
                self.li_buf = []
            return
        if tag == "code":
            self.code_inline += 1
            self.out.append("`")
        elif tag == "br":
            self.out.append("\n")
        elif tag in ("p", "div", "li", "ul", "ol", "tr", "h1", "h2", "h3", "h4"):
            self.out.append("\n")

    def handle_endtag(self, tag):
        if self.in_pre:
            if tag == "li" and self.li_buf is not None:
                self.out.append("".join(self.li_buf) + "\n")
                self.li_buf = None
            elif tag == "pre":
                self.in_pre = False
                self.out.append("```\n")
            return
        if tag == "code" and self.code_inline:
            self.out.append("`")
            self.code_inline -= 1
        elif tag in ("p", "div", "li"):
            self.out.append("\n")

    def handle_data(self, data):
        if self.in_pre and self.li_buf is not None:
            self.li_buf.append(data)
        elif not self.in_pre:
            self.out.append(data)

    def handle_entityref(self, name):
        import html as _h
        self.handle_data(_h.unescape(f"&{name};"))

    def handle_charref(self, name):
        import html as _h
        self.handle_data(_h.unescape(f"&#{name};"))

    def text(self):
        raw = "".join(self.out)
        lines = raw.split("\n")
        cleaned, in_code = [], False
        for ln in lines:
            s = ln.strip()
            if s == "```bash":
                in_code = True
                cleaned.append("```bash")
                continue
            if s == "```":
                in_code = False
                cleaned.append("```")
                continue
            if in_code:
                cleaned.append(ln.rstrip())           # keep indentation
            else:
                # normalize prose whitespace + tidy inline code spacing
                p = re.sub(r"[ \t]+", " ", ln).strip()
                p = re.sub(r"`\s*([^`\n]*?)\s*`", lambda m: "`" + m.group(1) + "`"
                           if m.group(1) else "", p)
                cleaned.append(p)
        # collapse blank lines
        out = []
        for ln in cleaned:
            if ln == "" and (not out or out[-1] == ""):
                continue
            out.append(ln)
        while out and out[-1] == "":
            out.pop()
        while out and out[0] == "":
            out.pop(0)
        return "\n".join(out)


def render(html: str) -> str:
    r = Renderer()
    r.feed(html)
    return r.text()


def find_rich_after(html: str, pos: int):
    idx = html.find(RICH, pos)
    if idx == -1:
        return None, -1
    div_start = html.rfind("<div", 0, idx)
    inner = balanced_div(html, div_start)
    return inner, idx


def extract(decoded: str):
    # question header positions
    heads = list(re.finditer(
        r"<span>Question (\d+)</span>"
        r'<span data-purpose="question-result-header-status-label"[^>]*>([^<]*)</span>',
        decoded))
    results = []
    for i, m in enumerate(heads):
        num = int(m.group(1))
        status = m.group(2).strip()
        seg_start = m.end()
        seg_end = heads[i + 1].start() if i + 1 < len(heads) else len(decoded)
        seg = decoded[seg_start:seg_end]
        # prompt = first rich text div
        prompt_html, p_at = find_rich_after(seg, 0)
        prompt = render(prompt_html) if prompt_html else ""
        # solution = div with id="question-explanation" (the real explanation)
        sol = ""
        ei = seg.find('id="question-explanation"')
        if ei != -1:
            div_start = seg.rfind("<div", 0, ei)
            sol = render(balanced_div(seg, div_start))
        results.append({"num": num, "status": status,
                        "prompt": prompt, "solution": sol})
    return results


def main():
    data = {}
    for n in (1, 2, 3, 4):
        decoded = (LAB / f"{n}.decoded.html").read_text(encoding="utf-8")
        qs = extract(decoded)
        data[f"test{n}"] = qs
        withsol = sum(1 for q in qs if q["solution"])
        print(f"Test {n}: {len(qs)} questions, {withsol} with solutions")
    OUT.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    print("Wrote", OUT)


if __name__ == "__main__":
    main()
