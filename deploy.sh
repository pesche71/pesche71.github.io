#!/usr/bin/env bash

# Abbruch bei Fehlern
set -e

# 1. Jekyll-Seite lokal bauen
echo "Baue Jekyll-Site..."
bundle exec jekyll build

# 2. In den _site-Ordner wechseln
cd _site

# 3. Git-Repository initialisieren und alle Dateien hinzufügen
git init
git add -A

# 4. Commit erstellen
git commit -m "Deploy Jekyll site $(date)"

# 5. Auf den gh-pages-Branch von GitHub pushen (URL anpassen!)
git branch -M gh-pages
git remote add origin https://pesche71.github.io
git push -u -f origin gh-pages

# 6. Aufräumen
cd ..
rm -rf _site

echo "Deploy abgeschlossen!"
