# 使用官方 Python 镜像
FROM bitnami/python:3.11.9

# 安装 MariaDB 客户端开发库和 pkg-config
RUN install_packages libmariadb-dev pkg-config git-lfs

# 设置工作目录
WORKDIR /app/

# 设置 PYTHONPATH 环境变量
ENV PYTHONPATH="/opt/bitnami/python/lib/python3.11/site-packages:$PYTHONPATH"

RUN git lfs install
RUN git clone https://huggingface.co/spaces/HuggingFaceH4/open_llm_leaderboard

# 设置 pip 使用国内镜像源
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 安装项目依赖
RUN pip install --default-timeout=5 --retries=9999 --no-cache-dir -r ./open_llm_leaderboard/requirements.txt

WORKDIR /app/open_llm_leaderboard/

# 修改 app.py 中的一行内容
RUN sed -i 's/demo.queue(default_concurrency_limit=40).launch()/demo.queue(default_concurrency_limit=40).launch(share=True)/' app.py

# 默认执行指令
CMD ["python", "app.py"]