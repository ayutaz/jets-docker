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

WORKDIR /work/espnet

ENV PYTHONPATH=/work/espnet:$PYTHONPATH

# ここで ESPnet の依存ライブラリをインストール
RUN python -m pip install \
    kaldiio==2.18.0 \
    humanfriendly==10.0 \
    numpy==1.24.4 \
    resampy==0.4.3 \
    soundfile==0.13.1 \
    nltk==3.9.1 \
    tqdm==4.67.1 \
    matplotlib==3.7.5 \
    typeguard==2.7.1 \
    inflect==5.0.3 \
    espnet_model_zoo==0.1.7 \
    tensorboard==2.14.0 \
    Pillow==9.5.0 \
    wandb==0.19.4

# 必要な NLTK リソースのダウンロード（同じ Python 環境内で実行）
RUN python -c "import nltk; nltk.download('averaged_perceptron_tagger_eng')"

CMD ["/bin/bash"]
