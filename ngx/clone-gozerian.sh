git clone git@github.com:30x/lua-gozerian.git gitlua
rm -rf lua/lib
pushd gitlua
mv lib ../lua/lib
popd
rm -rf gitlua
