svn co http://192.168.57.xxx/svn/testrepo/apimx/
cd apimx/
svn update
rm -rf *
svn rm ./-1234
svn rm 1
svn rm 2
svn commit -m "cleanup"
cd ..
rm -rf apimx
