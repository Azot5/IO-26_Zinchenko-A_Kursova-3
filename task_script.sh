#!/bin/bash

#������ ��� ������ ���������
if [[ $# -lt 2 ]]; then
    echo "�������: ��� �������� ��� ������ ���������!"
    exit 1
fi

param1=$1
param2=$2
script_name=$(basename "$0")

if [[ $param1 -gt $param2 ]]; then
    echo "1-� �������� ����� 2-��"
    echo "������ ���������:"
    alias
else
    echo "1-� �������� �� ����� 2-��"
    echo "����� ����� ������� $script_name:"
    stat --format="%s bytes" "$script_name"
fi

#������� 3 ������� ����곔 ��������
echo "3 ������� ���� ��������:"
du -ah --max-depth=1 . 2>/dev/null | grep '/$' | sort -rh | head -n 3

#������� ����� ������� ��������
echo "������� ����� �� ���������:"
for item in *; do
    if [[ -d "$item" ]]; then
        echo "$item � ���������"
    elif [[ -f "$item" ]]; then
        mkdir -p "${item}_dir"
        mv "$item" "${item}_dir/"
        echo "$item ���������� � ${item}_dir"
    fi
done

#������ � ����������� �������
random_file="random_numbers.txt"
echo "5 ���������� �����:" > "$random_file"
for i in {1..5}; do
    echo $((RANDOM % 1000 + 1)) >> "$random_file"
done
cat "$random_file"

#�������� �� ����� ��� ����������
smallest=$(sort -n "$random_file" | head -n 1)
echo "$smallest" > "$random_file"
echo "�������� ����� � ����: $smallest"

#��� ������� ��� ������ � �������� ������� �� �����������
cleanup_script="cleanup.sh"
cat << 'EOF' > "$cleanup_script"
#!/bin/bash
# ��������� ������� �����
find "$1" -type f -empty -delete

#��������� ������� ���������
find "$1" -type d -empty -delete
EOF
chmod +x "$cleanup_script"

#������ cleanup.sh � ������ �������
gnome-terminal -- bash -c "./$cleanup_script .; echo '�������� ����-��� ������ ��� ������'; read"

#��������������� ������ "top" � ����
top_output="top_output.txt"
n=${1:-5}
top -b -n 1 > "$top_output"
head -n "$n" "$top_output" > "${top_output}.tmp" && mv "${top_output}.tmp" "$top_output"
echo "��������� ����� $n ����� � ���� $top_output"
