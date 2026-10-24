# Merges tool/companion/extras_<stem>.py into a book that has no build script of its own (A1.1):
#   python -I tool/companion/apply_extras.py a1_1
# Books with a script (a1_2.py …) merge their extras when the script runs.
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kit  # noqa: E402

stem = sys.argv[1]
path = os.path.join(os.path.dirname(__file__), '..', '..', 'assets', 'content', 'companion', 'de_cert_a1', f'{stem}.json')
with open(path, encoding='utf-8') as f:
    book = json.load(f)
kit.write_book(path, book)
