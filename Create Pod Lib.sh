#! /bin/bash
#! /bin/bash

# 把库索引地址拉去到本地
pod repo add DYSpecs  https://github.com/SenDylan/DYSpecs.git

# 指定项目目录
cd ~/Desktop/

# 创建pod项目
pod lib create Test

# pod项目校验是否有问题
pod lib lint --allow-warnings

# pod 用到私有Pod 用到静态库 用如下命令校验
# pod lib lint --sources=http:私有,http:共有 --use-libraries --allow-warnings

# 创建代码远程仓库连接
git remote add origin https://github.com/SenDylan/DYCategoryKit
git add .  
git commit -m "注释描述"
git push origin master
# 强制推送代码
git push origin master -f

# 打标记
git tag 0.1.0
# 推送标记
git push --tags

# 连接pod库和索引
pod repo push DYSpecs DYCategoryKit.podspec --allow-warnings
# 用到静态库 用如下命令校验
pod repo push DYSpecs DYCategoryKit.podspec —use—libraries --allow-warnings