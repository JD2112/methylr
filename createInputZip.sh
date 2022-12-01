if [[ ! -e noData ]]; then
    mkdir noData
elif [[ ! -d noData ]]; then
    rm -rf noData/
fi

find . -name '*.idat' -exec cp "{}" noData \;
cd noData

if [[ ! -e idat ]]; then
    mkdir idat
elif [[ ! -d idat ]]; then
    rm -rf idat/
fi

mv *.idat idat/

wait
cd ..
find . -name '*.csv' -exec cp "{}" noData \;

wait
rm Data.zip
cd noData && zip -r "$OLDPWD/Data.zip" .

wait
cd ..
rm -rf noData/
