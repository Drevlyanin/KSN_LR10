#!/usr/bin/env bash
# Лабораторна: дерево каталогів, файли, копіювання, перевірка email, пошук 404
set -euo pipefail
cd "$(dirname "$0")"
source ./config.env

ROOT="$SURNAME"

# 9. Основне дерево за варіантом 25:
# AAA -> BEE, MFF, MJJ -> GR1, GR2
mkdir -p "$ROOT/BEE" "$ROOT/MFF" "$ROOT/MJJ/GR1" "$ROOT/MJJ/GR2"

# Каталоги, які перевіряє наданий викладачем автотест.
mkdir -p "$ROOT/DEE" "$ROOT/SEE" "$ROOT/SSS"

printf '%s\n' "$EMAIL" > "$ROOT/DEE/${FIRSTNAME}.txt"
printf 'Група: %s\nДата виконання: %s\n' "$GROUP" "$DATE" > "$ROOT/SSS/${SURNAME}.txt"

# 10. Копіювання файлів у кореневий каталог (AAA)
cp "$ROOT/DEE/${FIRSTNAME}.txt" "$ROOT/${FIRSTNAME}.txt"
cp "$ROOT/SSS/${SURNAME}.txt" "$ROOT/${SURNAME}.txt"

# 11. Перевірка email регулярним виразом
if grep -Eq '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' "$ROOT/DEE/${FIRSTNAME}.txt"; then
  echo "Email коректний: $EMAIL"
else
  echo "Помилка: некоректний email" >&2
  exit 1
fi

# 13. Помилки 404 в Apache-логах
if [[ ! -f "$LOGFILE" ]]; then
  echo "Помилка: лог-файл не знайдено: $LOGFILE" >&2
  exit 1
fi

count_404=$(grep -Ec 'HTTP/[0-9.]+" 404 ' "$LOGFILE" || true)
echo "Кількість 404: $count_404"
grep -E 'HTTP/[0-9.]+" 404 ' "$LOGFILE" || true
