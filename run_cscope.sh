#!/bin/sh

files=.
echo $files
find  $files -name '*.c' -print  > cscope.files
find  $files -name '*.h' -print >> cscope.files
find  $files -name '*.cc' -print >> cscope.files
find  $files -name '*.cpp' -print >> cscope.files
find  $files -name '*.hpp' -print >> cscope.files
find  $files -name '*.yang' -print >> cscope.files
find  $files -name '*.proto' -print >> cscope.files
find  $files -name '*.xml' -print >> cscope.files
find  $files -name '*.csv' -print >> cscope.files
find  $files -name '*.cmake' -print >> cscope.files
find  $files -name '*.make' -print >> cscope.files
find  $files -name '*.dts' -print >> cscope.files
find  $files -name '*.mib' -print >> cscope.files
find  $files -name '*.MIB' -print >> cscope.files
find  $files -name '*.soc' -print >> cscope.files
find  $files -name '*.proj' -print >> cscope.files
find  $files -name '*.go' -print >> cscope.files
cat cscope.files > check1
cat check1 | grep -v _ut_ | grep -v test > check2; mv check2 check1;
cat check1  |grep -v "\/build\/" > check2; mv check2 check1;
mv check1 cscope.files
cscope -b > check_cscope 2>&1 
ctags -L cscope.files > /dev/null 2>&1 

