from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit


class ReferenceParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.references = []

    def handle_starttag(self, tag, attrs):
        attributes = dict(attrs)
        if tag == "a" and "href" in attributes:
            self.references.append(attributes["href"])
        if tag in {"img", "script"} and "src" in attributes:
            self.references.append(attributes["src"])
        if tag == "link" and "href" in attributes:
            self.references.append(attributes["href"])


site = Path("_site").resolve()
errors = []
html_files = sorted(site.rglob("*.html"))
if len(html_files) != 11:
    errors.append(f"Expected 11 HTML pages, found {len(html_files)}")

for html_file in html_files:
    parser = ReferenceParser()
    parser.feed(html_file.read_text(encoding="utf-8"))
    for reference in parser.references:
        parts = urlsplit(reference)
        if parts.scheme or parts.netloc or reference.startswith(("#", "mailto:", "javascript:")):
            continue
        target_text = unquote(parts.path)
        if not target_text:
            continue
        target = (html_file.parent / target_text).resolve()
        if site not in target.parents and target != site:
            errors.append(f"Escaping reference in {html_file}: {reference}")
        elif not target.exists():
            errors.append(f"Missing reference in {html_file}: {reference}")

if errors:
    raise SystemExit("\n".join(errors))
print(f"Link validation passed for {len(html_files)} HTML pages.")
