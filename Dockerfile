FROM nvidia/cuda:11.3.1-cudnn8-runtime-ubuntu20.04

# 非対話モードとタイムゾーンの設定
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

# tzdata を先にインストールしてタイムゾーンの設定、その後必要なパッケージをインストール
RUN apt-get update && \
    apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    apt-get update && \
    apt-get install -y git \
                       python3.8 python3.8-dev python3.8-venv python3-pip wget \
                       libfreetype6-dev libpng-dev pkg-config && \
    python3.8 -m pip install --upgrade pip


# PyTorch 1.10.1 (CUDA 11.3 対応版) のインストール
RUN python3.8 -m pip install torch==1.10.1+cu113 torchvision==0.11.2+cu113 torchaudio==0.10.1+cu113 \
    -f https://download.pytorch.org/whl/torch_stable.html

# python コマンドで python3.8 を利用できるようにシンボリックリンクを作成
RUN ln -sf /usr/bin/python3.8 /usr/bin/python

WORKDIR /work/espnet/egs2/ljspeech/tts1

# デフォルトのコマンド（対話シェルを起動）
CMD ["/bin/bash"]
