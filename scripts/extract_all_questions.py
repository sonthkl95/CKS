#!/usr/bin/env python3
"""Extract all questions (and any explanations) from the 4 CKS practice-test HTML files.

Produces a clean JSON reference: scripts/all_questions.json
Inline <code> is wrapped in backticks and kept inline; block-level elements
(<p>, <li>, <pre>, <br>) create line breaks so Dockerfiles / YAML stay readable.
"""
import json
import re
from pathlib import Path
from html.parser import HTMLParser

LAB_DIR = Path(__file__).resolve().parent.parent / "lab"
OUT = Path(__file__).resolve().parent / "all_questions.json"

FILES = {
    1: "1. Certified Kubernetes Security Specialist (CKS) \u2013 Practice Test 1.html",
    2: "2. Certified Kubernetes Security Specialist (CKS) \u2013 Practice Test 2.html",
    3: "3. Certified Kubernetes Security Specialist (CKS) \u2013 Practice Test 3.html",
    4: "4. Certified Kubernetes Security Specialist (CKS) \u2013 Practice Test 4.html",
}

BLOCK_TAGS = {"p", "div", "li", "ul", "ol", "pre", "br", "tr", "h1", "h2", "h3", "h4"}


class CardExtractor(HTMLParser):
    """Collect text from a single element subtree, preserving code + line breaks."""

    def __init__(self):
        super().__init__()
        self.parts = []
        self.code_depth = 0

    def handle_starttag(self, tag, attrs):
        if tag == "code":
            self.code_depth += 1
            self.parts.append("`")
        elif tag == "br":
            self.parts.append("\n")
        elif tag in BLOCK_TAGS:
            self.parts.append("\n")

    def handle_endtag(self, tag):
        if tag == "code":
            self.parts.append("`")
            if self.code_depth > 0:
                self.code_depth -= 1
        elif tag in BLOCK_TAGS:
            self.parts.append("\n")

    def handle_data(self, data):
        self.parts.append(data)

    def text(self):
        raw = "".join(self.parts)
        # collapse spaces around backticks a little, normalize whitespace per line
        lines = [re.sub(r"[ \t]+", " ", ln).strip() for ln in raw.split("\n")]
        # drop leading/trailing empty lines and collapse >1 blank line
        out = []
        for ln in lines:
            if ln == "" and (not out or out[-1] == ""):
                continue
            out.append(ln)
        while out and out[-1] == "":
            out.pop()
        text = "\n".join(out)
        # tidy empty inline code and stray backticks
        text = text.replace("``", "").replace("` `", " ")
        return text.strip()


def extract_file(html: str):
    """Return list of (header, body) for each question-card."""
    results = []
    # Split on question-card boundaries
    cards = re.split(r'<div class="question-card">', html)
    for card in cards[1:]:
        # header
        hm = re.search(r'<div class="q-header">(.*?)</div>', card, re.S)
        if not hm:
            continue
        header = re.sub(r"<[^>]+>", "", hm.group(1)).strip()
        # body: from q-body up to the options/explanation/answer area
        bm = re.search(r'<div class="q-body">(.*?)(?:<div class="q-options"|'
                       r'<div class="q-answer"|<div class="exp-header"|'
                       r'<div class="explanation"|<button|$)', card, re.S)
        body_html = bm.group(1) if bm else ""
        pe = CardExtractor()
        pe.feed(body_html)
        body = pe.text()
        # explanation (usually "No explanation provided.")
        em = re.search(r'<div class="exp-content">(.*?)</div>', card, re.S)
        expl = ""
        if em:
            pe2 = CardExtractor()
            pe2.feed(em.group(1))
            expl = pe2.text()
        results.append({"header": header, "body": body, "explanation": expl})
    return results


def main():
    all_q = {}
    for test_num, fname in FILES.items():
        path = LAB_DIR / fname
        html = path.read_text(encoding="utf-8", errors="replace")
        qs = extract_file(html)
        all_q[f"test{test_num}"] = qs
        print(f"Test {test_num}: extracted {len(qs)} questions")
    OUT.write_text(json.dumps(all_q, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"\nWrote {OUT}")


if __name__ == "__main__":
    main()
