#!/bin/bash

# Script beenden, falls ein Befehl fehlschlägt
set -e

echo "⏳ Starte Jekyll-Deployment..."

# 1. Änderungen zu Git hinzufügen
git add .

# 2. Commit-Nachricht abfragen
echo "✍️  Bitte Commit-Nachricht eingeben (oder Enter für 'Update Jekyll site'):"
read commit_message

if [ -z "$commit_message" ]; then
    commit_message="Update Jekyll site"
fi

# 3. Änderungen committen
git commit -m "$commit_message"

# 4. Den aktuellen Branch-Namen ermitteln (main oder master)
CURRENT_BRANCH=$(git branch --show-current)

# 5. Zu GitHub pushen
echo "🚀 Pushe Änderungen auf Branch '$CURRENT_BRANCH' zu GitHub..."
git push origin "$CURRENT_BRANCH"

echo "✅ Erfolgreich gepusht! GitHub Actions baut die Seite jetzt im Hintergrund."
