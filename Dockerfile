# 使用官方 Python 镜像
FROM bitnami/python:3.11.9

ENV HTTP_PROXY="http://10.1.1.18:20171/"
ENV HTTPS_PROXY="http://10.1.1.18:20171/"

# 输出 HTTP 和 HTTPS 代理信息
RUN echo "HTTP Proxy: $HTTP_PROXY" && \
    echo "HTTPS Proxy: $HTTPS_PROXY"

# 安装 MariaDB 客户端开发库和 pkg-config
RUN install_packages libmariadb-dev pkg-config git-lfs

# 设置工作目录
WORKDIR /app/

# 设置 PYTHONPATH 环境变量
ENV PYTHONPATH="/opt/bitnami/python/lib/python3.11/site-packages:$PYTHONPATH"

RUN git lfs install
RUN git clone https://huggingface.co/spaces/HuggingFaceH4/open_llm_leaderboard

# 安装项目依赖
RUN pip install --no-cache-dir -r ./open_llm_leaderboard/requirements.txt

WORKDIR /app/open_llm_leaderboard/

# 修改 app.py 中的一行内容
RUN sed -i 's/demo.queue(default_concurrency_limit=40).launch()/demo.queue(default_concurrency_limit=40).launch(share=False, server_name="0.0.0.0")/' app.py

# 默认执行指令
CMD ["python", "app.py"]
