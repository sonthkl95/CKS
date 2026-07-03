#!/usr/bin/env python3
"""Decode an .mhtml archive to raw HTML so we can inspect / extract questions."""
import sys
import email
from pathlib import Path

def decode_mhtml(path: Path) -> str:
    msg = email.message_from_bytes(path.read_bytes())
    htmls = []
    for part in msg.walk():
        ctype = part.get_content_type()
        if ctype == "text/html":
            payload = part.get_payload(decode=True)
            charset = part.get_content_charset() or "utf-8"
            htmls.append(payload.decode(charset, errors="replace"))
    return "\n".join(htmls)

if __name__ == "__main__":
    src = Path(sys.argv[1])
    out = Path(sys.argv[2]) if len(sys.argv) > 2 else src.with_suffix(".decoded.html")
    html = decode_mhtml(src)
    out.write_text(html, encoding="utf-8")
    print(f"Decoded {src.name} -> {out} ({len(html)} chars)")
    print("q-header count:", html.count("q-header"))
    print("question-card count:", html.count("question-card"))
