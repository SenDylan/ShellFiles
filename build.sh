#! /bin/bash

# export LC_ALL=zh_CN.GB2312;
# export LANG=zh_CN.GB2312

#一些路径的切换：切换到你的工程文件目录---------
projectPath=$(cd `dirname $0`; pwd)
cd ..
cd $projectPath

###############设置需编译的项目配置名称
buildConfig="Debug" #编译的方式,有Release,Debug，自定义的AdHoc等

##########################################################################################
##############################以下部分为自动生成部分，不需要手动修改############################
##########################################################################################
#项目名称
projectName=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'`
echo "项目名称:$projectName"
projectDir=`pwd` #项目所在目录的绝对路径
echo $projectDir
wwwIPADir=~/Desktop/$projectName-IPA #ipa，icon最后所在的目录绝对路径
isWorkSpace=false  #判断是用的workspace还是直接project，workspace设置为true，否则设置为false

echo "~~~~~~~~~~~~~~~~~~~开始编译~~~~~~~~~~~~~~~~~~~"
if [ -d "$wwwIPADir" ]; then
echo $wwwIPADir
echo "文件目录存在"
else
echo "文件目录不存在"
mkdir -pv $wwwIPADir
echo "创建${wwwIPADir}目录成功"
fi

###############进入项目目录
cd $projectDir
rm -rf ./build
buildAppToDir=$projectDir/build #编译打包完成后.app文件存放的目录

###############获取版本号,bundleID
infoPlist="$projectName/*-Info.plist"
bundleVersion=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $infoPlist`
bundleIdentifier=`/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" $infoPlist`
bundleBuildVersion=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $infoPlist`

###############开始编译app
if $isWorkSpace ; then  #判断编译方式
echo  "开始编译workspace...."
xcodebuild  -workspace $projectName.xcworkspace -scheme $projectName  -configuration $buildConfig clean build SYMROOT=$buildAppToDir
else
echo  "开始编译target...."
xcodebuild  -target  $projectName  -configuration $buildConfig clean build SYMROOT=$buildAppToDir -sdk iphonesimulator12.4
fi
#判断编译结果
if test $? -eq 0
then
echo "~~~~~~~~~~~~~~~~~~~编译成功~~~~~~~~~~~~~~~~~~~"
else
echo "~~~~~~~~~~~~~~~~~~~编译失败~~~~~~~~~~~~~~~~~~~"
exit 1
fi

xcrun instruments -w "iPhone Xʀ (12.4)"
xcrun simctl install "iPhone Xʀ" /Users/sdy/Desktop/Test/build/Debug-iphonesimulator/Test.app
xcrun simctl launch "iPhone Xʀ" com.JD.Test