# 构建阶段
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# 复制项目文件并还原依赖（利用 Docker 层缓存）
COPY ["LearnSite/LearnSite.csproj", "LearnSite/"]
RUN dotnet restore "LearnSite/LearnSite.csproj"

# 复制剩余源码并发布
COPY . .
WORKDIR "/src/LearnSite"
RUN dotnet publish "LearnSite.csproj" -c Release -o /app/publish

# 运行阶段
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app

# 可选：安装 PostgreSQL 客户端工具（如果需要在容器内执行 SQL 脚本）
# RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

# 复制发布文件
COPY --from=build /app/publish .

# 设置非 root 用户运行
USER $APP_UID

# 配置环境变量（可被 docker-compose 覆盖）
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

# 暴露端口
EXPOSE 8080

# 健康检查（建议）
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

ENTRYPOINT ["dotnet", "LearnSite.dll"]
