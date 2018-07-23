/usr/bin/find . -name "*Test.py" -print | while read f; do
        echo "$f"
        python -m coverage run "$f"
        python -m coverage xml -o coverage.xml
done
