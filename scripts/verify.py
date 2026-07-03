#!/usr/bin/env python3
"""Verify that every folder's Questions.bash and SolutionNotes.bash contain the
EXACT prompt/solution from the source, and that the HTML and MHTML sources agree."""
import json, re, sys
from pathlib import Path
sys.path.insert(0, 'scripts')
from gen_labs import MAPPING, DATA  # DATA = questions_solutions.json (from mhtml)

BASE = Path('.')
ALLQ = json.load(open('scripts/all_questions.json', encoding='utf-8'))  # from html

def src(tag):
    t = int(tag[1]); n = int(tag[3:])
    for q in DATA[f'test{t}']:
        if q['num'] == n:
            return t, n, q
    raise KeyError(tag)

def norm(s):
    return re.sub(r'\s+', ' ', s).strip().lower()

q_ok = s_ok = 0
q_bad = []; s_bad = []
for rel, tag in MAPPING.items():
    t, n, q = src(tag)
    qf = (BASE/rel/'Questions.bash').read_text(encoding='utf-8')
    sf = (BASE/rel/'SolutionNotes.bash').read_text(encoding='utf-8')
    # exact verbatim substring check
    if q['prompt'].strip() in qf: q_ok += 1
    else: q_bad.append(rel)
    if (q['solution'].strip() or 'No solution') in sf: s_ok += 1
    else: s_bad.append(rel)

print(f"[1] Questions.bash contains EXACT source prompt : {q_ok}/55" + ("  ✅" if q_ok==55 else f"  ❌ {q_bad}"))
print(f"[2] SolutionNotes.bash contains EXACT source sol : {s_ok}/55" + ("  ✅" if s_ok==55 else f"  ❌ {s_bad}"))

# [3] cross-check: mhtml prompt vs html prompt agree (proves question is faithful to source)
# build html lookup: test -> list of bodies in order
agree = disagree = 0; dis = []
for rel, tag in MAPPING.items():
    t, n, q = src(tag)
    html_list = ALLQ.get(f'test{t}', [])
    # html question n is index n-1 (same numbering)
    if n-1 < len(html_list):
        hb = norm(html_list[n-1]['body'])
        mb = norm(q['prompt'])
        # compare first 120 normalized chars (html strips some inline spacing differently)
        if hb[:120] == mb[:120] or hb in mb or mb in hb:
            agree += 1
        else:
            disagree += 1; dis.append((rel, tag))
    else:
        disagree += 1; dis.append((rel, tag, 'no-html'))
print(f"[3] MHTML prompt agrees with HTML prompt         : {agree}/55" + ("  ✅" if disagree==0 else f"  ⚠️ {disagree} differ: {dis}"))
