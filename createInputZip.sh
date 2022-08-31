if [[ ! -e tempData ]]; then
    mkdir tempData
elif [[ ! -d tempData ]]; then
    rm -rf tempData/
fi

find . -name '*.idat' -exec cp "{}" tempData \;
cd tempData

if [[ ! -e idat ]]; then
    mkdir idat
elif [[ ! -d idat ]]; then
    rm -rf idat/
fi

mv *.idat idat/

wait
cd ..
find . -name '*.csv' -exec cp "{}" tempData \;

wait
zip -r Data.zip tempData/

wait
rm -rf tempData/
