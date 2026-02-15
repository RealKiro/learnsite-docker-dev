# learnsite-docker-dev
OpenLearnSite信息科技学习平台Docker部署文件，拟适配基于.net10+postgresql重构的预览版learnsite源码

```
# 构建并启动
docker compose up -d

# 查看日志
docker logs learnsite-app
docker logs learnsite-db

# 停止并删除卷（慎用，会清除数据）
docker compose down -v
```

# 下一步需要确认的事项
- 项目结构：周老师重构后的项目名可能不叫 LearnSite.csproj，请根据实际情况修改 Dockerfile 中的路径和 .csproj 文件名。
- 启动程序集：如果发布后生成的可执行文件名不是 LearnSite.dll，记得修改 ENTRYPOINT 中的名称。
- 连接字符串配置：如果项目使用 appsettings.json，确保其中配置的键名与上面环境变量一致（例如 ConnectionStrings:DefaultConnection）。
- 数据库初始化：如果需要自动建表，请准备好 SQL 脚本并挂载到 PostgreSQL 容器的 /docker-entrypoint-initdb.d 目录。
