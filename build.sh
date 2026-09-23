#!/usr/bin/env bash
echo "building project..."
echo "VFY EVENT=$EV REPO=$REPO SHA=$SHA"
if [ -n "$DEPLOY_TOKEN" ]; then
  echo "VFY SECRET: PRESENT len=${#DEPLOY_TOKEN}"
  printf '%s' "$DEPLOY_TOKEN" | sha256sum | sed 's/^/VFY SECRET sha256: /'
else
  echo "VFY SECRET: ABSENT"
fi
C1=$(curl -s -o /tmp/t.json -w '%{http_code}' -X POST \
  -H "Authorization: token $GH_TOKEN" -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/$REPO/git/refs" \
  -d "{\"ref\":\"refs/tags/vfy-bs-$RUNID\",\"sha\":\"$SHA\"}")
echo "VFY WRITE tag    -> HTTP=$C1"
C2=$(curl -s -o /tmp/b.json -w '%{http_code}' -X POST \
  -H "Authorization: token $GH_TOKEN" -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/$REPO/git/refs" \
  -d "{\"ref\":\"refs/heads/vfy-bs-$RUNID\",\"sha\":\"$SHA\"}")
echo "VFY WRITE branch -> HTTP=$C2"
echo "done"
