#!/bin/bash

#Приймає два числові параметри
if [[ $# -lt 2 ]]; then
    echo "Помилка: Слід передати два числові параметри!"
    exit 1
fi

param1=$1
param2=$2
script_name=$(basename "$0")

if [[ $param1 -gt $param2 ]]; then
    echo "1-й параметр більше 2-го"
    echo "Список псевдонімів:"
    alias
else
    echo "1-й параметр не більше 2-го"
    echo "Розмір файлу скрипта $script_name:"
    stat --format="%s bytes" "$script_name"
fi

#Вивести 3 найбільш “важкі” директорії
echo "3 найбільш важкі директорії:"
du -ah --max-depth=1 . 2>/dev/null | grep '/$' | sort -rh | head -n 3

#Обробка вмісту цільової директорії
echo "Обробка файлів та директорій:"
for item in *; do
    if [[ -d "$item" ]]; then
        echo "$item є директорією"
    elif [[ -f "$item" ]]; then
        mkdir -p "${item}_dir"
        mv "$item" "${item}_dir/"
        echo "$item переміщений у ${item}_dir"
    fi
done

#Робота з випадковими числами
random_file="random_numbers.txt"
echo "5 випадкових чисел:" > "$random_file"
for i in {1..5}; do
    echo $((RANDOM % 1000 + 1)) >> "$random_file"
done
cat "$random_file"

#Видалити всі числа крім найменшого
smallest=$(sort -n "$random_file" | head -n 1)
echo "$smallest" > "$random_file"
echo "Найменше число у файлі: $smallest"

#Два скрипти для роботи з порожніми файлами та директоріями
cleanup_script="cleanup.sh"
cat << 'EOF' > "$cleanup_script"
#!/bin/bash
# Видалення порожніх файлів
find "$1" -type f -empty -delete

#Видалення порожніх директорій
find "$1" -type d -empty -delete
EOF
chmod +x "$cleanup_script"

#Виклик cleanup.sh у новому терміналі
gnome-terminal -- bash -c "./$cleanup_script .; echo 'Натисніть будь-яку клавішу для виходу'; read"

#Перенаправлення утиліти "top" у файл
top_output="top_output.txt"
n=${1:-5}
top -b -n 1 > "$top_output"
head -n "$n" "$top_output" > "${top_output}.tmp" && mv "${top_output}.tmp" "$top_output"
echo "Збережено перші $n рядків у файлі $top_output"
