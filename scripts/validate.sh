#!/usr/bin/env bash
# Publication constraints for the ux-skills repo. Run before every push.
# Prints every failure rather than stopping at the first.
set -uo pipefail
cd "$(dirname "$0")/.."

fail=0
err() { echo "FAIL: $*"; fail=1; }
ok()  { echo "  ok: $*"; }

echo "== 1. No third-party text reproduced verbatim =="
if grep -rn '^> .*lawsofux\.com' skills/ >/dev/null 2>&1; then
  grep -rn '^> .*lawsofux\.com' skills/
  err "block-quoted definitions found — these were copied from lawsofux.com"
else
  ok "no copied definitions"
fi

echo "== 2. Attribution present in every lens file =="
lensdir=$(ls -d skills/*heuristics-audit/laws 2>/dev/null | head -1)
if [ -z "$lensdir" ]; then
  err "cannot locate the laws/ directory"
else
  missing=0
  for f in "$lensdir"/*.md; do
    grep -q "Wording here is our own" "$f" || { echo "  $f"; missing=1; }
  done
  [ "$missing" -eq 1 ] && err "lens files missing the attribution footer" || ok "all $(ls "$lensdir"/*.md | wc -l) lens files attributed"
fi

echo "== 3. Attribution URLs use a path that exists =="
if grep -rn 'lawsofux\.com/laws/' skills/ >/dev/null 2>&1; then
  grep -rn 'lawsofux\.com/laws/' skills/
  err "these URLs 404 — the site has no /laws/ segment"
else
  ok "attribution URLs use the correct path"
fi

echo "== 4. No internal project identifiers =="
# Scope to git-tracked files: those are what actually ship. Untracked/ignored
# noise (regenerating hook logs) is check 5's job.
# Note: generic column names like is_deleted/deleted_at are deliberately NOT
# here — the skills use them as search hints, which is correct and not a leak.
pattern='fs-k8s|freeswitch|comax|uman\.pw|agentmail|mail-bot|babysitter|148ylr|/root/|127\.0\.0\.1|body_text|unconvert|delivery badge|prefix language'
hits=$(git ls-files -z | xargs -0 grep -rniE "$pattern" 2>/dev/null | grep -vE '^(docs/superpowers/plans/|scripts/validate\.sh)' || true)
if [ -n "$hits" ]; then
  echo "$hits"
  err "internal identifiers found (see above)"
else
  ok "no internal identifiers"
fi

echo "== 5. No stray hook logs or hidden state tracked by git =="
if git ls-files | grep -E '(^|/)\.a5c/|\.log$' >/dev/null 2>&1; then
  git ls-files | grep -E '(^|/)\.a5c/|\.log$'
  err "hook logs are tracked by git"
else
  ok "no hook logs tracked"
fi

echo "== 6. Every relative markdown link resolves =="
# Fenced code blocks are stripped first: documents that *illustrate* markdown
# (the plan doc) would otherwise fail on links that are sample content.
: > /tmp/ux-broken-links.txt
while IFS= read -r f; do
  d=$(dirname "$f")
  awk '/^```/{inblock=!inblock; next} !inblock' "$f" \
    | grep -o '](\([^)#]*\.md\))' 2>/dev/null | sed 's/](\(.*\))/\1/' | while read -r t; do
    case "$t" in http*) continue;; esac
    [ -f "$d/$t" ] || echo "  $f -> $t" >> /tmp/ux-broken-links.txt
  done
done < <(find . -name '*.md' -not -path './.git/*')
if [ -s /tmp/ux-broken-links.txt ]; then cat /tmp/ux-broken-links.txt; err "broken relative links"; else ok "all relative links resolve"; fi

echo "== 7. Skill frontmatter is valid and matches the directory =="
fm=0
for s in skills/*/SKILL.md; do
  head -1 "$s" | grep -q '^---$' || { err "$s: missing frontmatter opening"; fm=1; }
  grep -q '^name: ' "$s" || { err "$s: missing name:"; fm=1; }
  grep -q '^description: ' "$s" || { err "$s: missing description:"; fm=1; }
  dir=$(basename "$(dirname "$s")")
  nm=$(grep '^name: ' "$s" | head -1 | sed 's/^name: *//')
  [ "$dir" = "$nm" ] || { err "$s: name '$nm' != directory '$dir'"; fm=1; }
done
[ "$fm" -eq 0 ] && ok "frontmatter valid for $(ls -d skills/*/ | wc -l) skills"

echo "== 8. Every lens declares a unit of analysis, and it matches SKILL.md =="
if [ -n "${lensdir:-}" ]; then
  python3 - "$lensdir" <<'PY'
import re, sys, glob, os
lensdir = sys.argv[1]
skill = open(os.path.join(os.path.dirname(lensdir), "SKILL.md")).read()
groups = {}
for label, unit in [("Object lenses", "object"), ("Screen lenses", "screen"), ("Flow lenses", "flow")]:
    if f"**{label}" not in skill:
        print(f"FAIL: SKILL.md has no '{label}' group"); sys.exit(1)
    seg = skill.split(f"**{label}")[1].split("\n\n")[0]
    for m in re.findall(r"laws/([a-z0-9-]+)\.md", seg):
        groups[m] = unit
bad = 0
files = sorted(glob.glob(os.path.join(lensdir, "*.md")))
for f in files:
    k = os.path.basename(f)[:-3]
    t = open(f).read()
    u = "object" if "the **object**" in t else "screen" if "the **screen**" in t else "flow" if "the **flow**" in t else None
    if u is None:
        print(f"FAIL: {k} declares no unit of analysis"); bad = 1
    elif groups.get(k) != u:
        print(f"FAIL: {k}: SKILL.md says {groups.get(k)}, file says {u}"); bad = 1
for k in groups:
    if not os.path.exists(os.path.join(lensdir, k + ".md")):
        print(f"FAIL: SKILL.md links laws/{k}.md which does not exist"); bad = 1
if bad: sys.exit(1)
print(f"  ok: all {len(files)} lenses declare a unit and agree with SKILL.md")
PY
  [ $? -ne 0 ] && err "unit-of-analysis mismatch"
fi

echo "== 9. Manifests are valid JSON and point at real skills =="
for j in .claude-plugin/plugin.json .claude-plugin/marketplace.json; do
  if [ ! -f "$j" ]; then err "$j missing"; continue; fi
  jq empty "$j" 2>/dev/null || err "$j is not valid JSON"
done
if [ -f .claude-plugin/marketplace.json ]; then
  : > /tmp/ux-missing-skills.txt
  jq -r '.plugins[].skills[]?' .claude-plugin/marketplace.json 2>/dev/null | while read -r p; do
    [ -f "${p#./}/SKILL.md" ] || echo "  declared but missing: $p" >> /tmp/ux-missing-skills.txt
  done
  if [ -s /tmp/ux-missing-skills.txt ]; then cat /tmp/ux-missing-skills.txt; err "marketplace declares skills that do not exist"; else ok "declared skill paths exist"; fi
fi

echo
if [ "$fail" -eq 0 ]; then echo "ALL CHECKS PASSED"; else echo "VALIDATION FAILED"; fi
exit "$fail"
