#/bin/bash
cd $SRCROOT
rm -rf gcov
mkdir gcov
cp $(find ~/Library/Developer/Xcode/DerivedData/Clicky-fkelmhnxrtegnvgcjslcnkhtwyho/ -name *.gc*) gcov/
cp $(find ~/Library/Developer/Xcode/DerivedData/Clicky-fkelmhnxrtegnvgcjslcnkhtwyho/ -name *.o) gcov/
/usr/local/bin/coveralls --exclude lib --exclude tests
which git > /Users/aglenn/xcode.txt
which coveralls >> /Users/aglenn/xcode.txt
echo "Ran from xcode" >> /Users/aglenn/xcode.txt
