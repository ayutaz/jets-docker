# espnetのjetsを動かす

<!-- TOC -->
* [espnetのjetsを動かす](#espnetのjetsを動かす)
  * [1 jetsを動かすためのRepositoryをclone](#1-jetsを動かすためのrepositoryをclone)
  * [2 Docker Imageの準備](#2-docker-imageの準備)
    * [2.1 独自でビルド](#21-独自でビルド)
    * [2.2 DockerHubからpull](#22-dockerhubからpull)
  * [3 jetsの実行](#3-jetsの実行)
* [memo](#memo)
  * [kaliのバージョン](#kaliのバージョン)
  * [追加でインストールが必要だったのもの](#追加でインストールが必要だったのもの)
  * [推論のメモ](#推論のメモ)
* [FAQ](#faq)
<!-- TOC -->

## 1 jetsを動かすためのRepositoryをclone

```sh
git clone https://github.com/ayutaz/espnet.git
cd .\espnet\
git checkout -b jets origin/jets
cd .\tools\
git clone https://github.com/ayutaz/kaldi.git
cd .\kaldi\
git checkout -b jets origin/jets
```

## 2 Docker Imageの準備

### 2.1 独自でビルド
**docker build**
```bash
docker build -t espnet-jets .
```

**docker run**
```bash
docker run -it --rm -v "${PWD}:/work" espnet-jets bash
```

### 2.2 DockerHubからpull

[ayousanz/espnet-jets](https://hub.docker.com/repository/docker/ayousanz/espnet-jets/general)にビルド済みのイメージがあるのでpullして使用することができます。

```bash
docker pull ayutaz/espnet-jets:latest
docker run -it --shm-size=20g --gpus all --rm -v "${PWD}:/work" ayousanz/espnet-jets:latest bash
```

## 3 jetsの実行


**コンテナ内でインストール**
```bash
pip install -e .
cd egs2/ljspeech/tts1
```

**infer**
```bash
./run.sh --skip_data_prep false --skip_train true --download_model imdanboy/jets
```

**train**

```bash
./run.sh --train_config conf/tuning/train_jets.yaml --tts_task gan_tts --stage 1 --stop_stage 7 --ngpu 1
```

epoch数などのパラメータを変更したい場合は、以下をオプションにつける

```bash
--train_args "--max_epoch 1 --num_iters_per_epoch 30"
```

# memo

## kaliのバージョン
[当時にkaldi](https://github.com/kaldi-asr/kaldi/tree/ac29a6ff09823d1cbb4814da60360c966f33cd0d) が espnetのgit checkout c173c30930631731e6836c274a591ad571749741と時期的に同じところ

現在は [kaldi](https://github.com/kaldi-asr/kaldi/tree/01aadd7c19372e3eacadec88caabd86162f33d69)

##  推論のメモ

推論後に音声は以下のパスに保存される
```sh
/work/espnet/egs2/ljspeech/tts1/exp/imdanboy/jets/decode_train.loss.ave/dev/log/output.XX
```

推論時のログを見るコマンド
```sh
cat dump/raw/org/tr_no_dev/logs/format_wav_scp.*.log
```

# FAQ
* `/usr/bin/env: 'bash\r': No such file or directory` と出た場合は改行コードをLFに変更する

```sh
apt-get update && apt-get install -y dos2unix
find . -type f \( -iname "*.sh" -o -iname "*.py" -o -iname "*.pl" \) -exec dos2unix {} +
```