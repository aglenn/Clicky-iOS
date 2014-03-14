#/bin/bash
cd $SRCROOT
rm -rf gcov
mkdir gcov
cp $(find ~/Library/Developer/Xcode/DerivedData/Clicky-fkelmhnxrtegnvgcjslcnkhtwyho/ -name *.gc* | grep -v "Tests") gcov/
coveralls --exclude lib --exclude tests
