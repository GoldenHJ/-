#!/usr/bin/env bash
#编译+部署项目站点
#需要配置如下参数
# 项目路径, 在Execute Shell中配置项目路径, pwd 就可以获得该项目路径
# export PROJ_PATH=这个jenkins任务在部署机器上的路径
# 输入你的环境上tomcat的全路径
# export TOMCAT_APP_PATH=tomcat在部署机器上的路径
### base 函数
killTomcat()
{
    #pid=`ps -ef|grep tomcat|grep java|awk '{print $2}'`
    #echo "tomcat Id list :$pid"
    #if [ "$pid" = "" ]
    #then
    #  echo "no tomcat pid alive"
    #else
    #  kill -9 $pid
    #fi
    #上面注释的或者下面的
    cd $TOMCAT_APP_PATH/bin
    sh shutdown.sh
}
cd $PROJ_PATH/my-scrum
mvn clean install
# 停tomcat
killTomcat
# 删除原有工程
rm -rf $TOMCAT_APP_PATH/webapps/ROOT
rm -f $TOMCAT_APP_PATH/webapps/ROOT.war
rm -f $TOMCAT_APP_PATH/webapps/my-scrum.war
# 复制新的工程到tomcat上
cp $PROJ_PATH/scrum/target/order.war $TOMCAT_APP_PATH/webapps/
cd $TOMCAT_APP_PATH/webapps/
mv my-scrum.war ROOT.war
# 启动Tomcat
cd $TOMCAT_APP_PATH/
sh bin/startup.sh
