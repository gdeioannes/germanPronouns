# Trims each book's extra exercises until every practice and review page keeps some room above the
# "I can" box. It never touches the exercise texts in extras_<stem>.py: it writes how many extra
# items each page keeps to extras_fit.json, which kit.apply_extras honours. Per page it searches
# for the most extra items that still leave LOW mm, so pages end up full but never crammed.
#   python -I tool/companion/fit_extras.py B2.2 [C1.1 …]      (needs the dev server on :5173)
import importlib.util
import json
import math
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..', '..')
sys.path.insert(0, HERE)
import kit  # noqa: E402

FIT = os.path.join(HERE, 'extras_fit.json')
LOW, GOAL = 8.0, 12.0   # a page must keep LOW mm; the first jump aims for about GOAL mm
MM_PER_UNIT = 10.0      # rough height of one extra item
NL, TAB = chr(10), chr(9)


def rebuild(stem):
    script = os.path.join(HERE, f'{stem}.py')
    cmd = [sys.executable, '-I', script] if os.path.exists(script) else [sys.executable, '-I', os.path.join(HERE, 'apply_extras.py'), stem]
    subprocess.run(cmd, check=True, cwd=ROOT, stdout=subprocess.DEVNULL)


def measure(level):
    out = subprocess.run(['node', os.path.join(HERE, 'free-space.cjs'), level], check=True, cwd=ROOT, capture_output=True, text=True).stdout
    pages = {}
    for line in out.splitlines():
        sid, where, mm, _ = line.split()
        pages[f'{sid}:left' if where == 'review-left' else sid] = float(mm)
    return pages


def extras_of(stem):
    spec = importlib.util.spec_from_file_location(f'extras_{stem}', os.path.join(HERE, f'extras_{stem}.py'))
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    units = {sid: kit.extra_units(exs) for sid, exs in getattr(mod, 'EXTRAS', {}).items()}
    units.update({f'{sid}:left': kit.extra_units(exs) for sid, exs in getattr(mod, 'EXTRAS_LEFT', {}).items()})
    return units


def save(fit):
    with open(FIT, 'w', encoding='utf-8', newline=NL) as f:
        json.dump(fit, f, indent=TAB, sort_keys=True)
        f.write(NL)


for level in sys.argv[1:]:
    stem = level.lower().replace('.', '_')
    units = extras_of(stem)
    fit = json.load(open(FIT, encoding='utf-8')) if os.path.exists(FIT) else {}
    caps = fit[stem] = {}
    lo = {k: 0 for k in units}      # most items known to fit
    hi = {k: None for k in units}   # fewest items known not to fit
    done = set()
    for round_ in range(14):
        save(fit)
        rebuild(stem)
        pages = measure(level)
        for k in units:
            if k in done:
                continue
            cap = caps.get(k, units[k])
            if pages[k] >= LOW:
                lo[k] = max(lo[k], cap)
            else:
                hi[k] = cap if hi[k] is None else min(hi[k], cap)
            if hi[k] is None:
                done.add(k)
                caps.pop(k, None)
            elif hi[k] - lo[k] <= 1 or hi[k] == 0:
                done.add(k)
                caps[k] = lo[k]
            elif cap == units[k]:
                caps[k] = max(lo[k], min(hi[k] - 1, cap - math.ceil((GOAL - pages[k]) / MM_PER_UNIT)))
            else:
                caps[k] = (lo[k] + hi[k]) // 2
        if len(done) == len(units):
            break
        print(f'{level} round {round_ + 1}: {len(units) - len(done)} pages still searching')
    for k in units:
        if k not in done:
            caps[k] = lo[k]
    save(fit)
    rebuild(stem)
    pages = measure(level)
    low = {k: v for k, v in pages.items() if v < LOW}
    print(f'{level}: done; free {min(pages.values())} to {max(pages.values())} mm; under {LOW} mm: {low or "none"}')
