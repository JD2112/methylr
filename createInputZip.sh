if [[ ! -e tmp ]]; then
    mkdir tmp
elif [[ ! -d tmp ]]; then
    rm -rf tmp/
fi

find . -name '*.idat' -exec cp "{}" tmp \;
cd tmp

if [[ ! -e idat ]]; then
    mkdir idat
elif [[ ! -d idat ]]; then
    rm -rf idat/
fi

mv *.idat idat/

wait
cd ..
find . -name '*.csv' -exec cp "{}" tmp \;

wait
zip -r Data.zip tmp/

wait
rm -rf tmp/
