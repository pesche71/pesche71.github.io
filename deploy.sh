#!/bin/bash

# Konfiguration
BUILD_DIR="_site"
BRANCH="gh-pages"
COMMIT_MSG="Deploy Jekyll site $(date +'%a %d %b %Y %H:%M:%S %Z')"

echo "🧹 Lösche alten Build-Ordner (ausser Git-Verzeichnis)..."
# Wir löschen alles im Ordner _site, behalten aber den versteckten .git-Ordner,
# damit Git nicht jedes Mal komplett neu initialisiert werden muss.
if [ -d "$BUILD_DIR" ]; then
  find $BUILD_DIR -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +
fi

echo "📦 Baue Jekyll-Seite lokal..."
bundle exec jekyll build

# Prüfen, ob der Build erfolgreich war
if [ ! -d "$BUILD_DIR" ]; then
  echo "❌ Fehler: Jekyll-Build ist fehlgeschlagen!"
  exit 1
fi

echo "🚀 Wechsle in den Build-Ordner..."
cd $BUILD_DIR

# Git initialisieren, falls noch gar kein Repository da ist
if [ ! -d ".git" ]; then
  git init
  git checkout -b $BRANCH
fi

# Remote-URL automatisch aus dem Hauptprojekt holen
REMOTE_URL=$(git -C .. config --get remote.origin.url)

# Prüfen, ob "origin" bereits existiert
if git remote | grep -q "^origin$"; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

echo "💾 Füge Dateien hinzu und erstelle Commit..."
git add -A
git commit -m "$COMMIT_MSG"

echo "⬆️ Pushe zu GitHub ($BRANCH)..."
git push origin $BRANCH --force

echo "🎉 Erfolgreich auf GitHub Pages gepusht!"
