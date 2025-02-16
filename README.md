# espnetのjetsを動かす

1. jetsを動かすためのRepositoryをclone 
```sh
git clone https://github.com/ayutaz/espnet.git
cd .\espnet\
git checkout -b jets origin/jets
```

**docker build**
```bash
docker build -t espnet-jets .
```

**docker run**
```bash
docker run -it --rm -v "${PWD}:/work" espnet-jets bash
```

**コンテナ内でインストール**
```bash
pip install -e .
cd egs2/ljspeech/tts1
```

**infer**
```bash
./run.sh --skip_data_prep false --skip_train true --download_model imdanboy/jets
```

# memo

## kaliのバージョン
[当時にkaldi](https://github.com/kaldi-asr/kaldi/tree/ac29a6ff09823d1cbb4814da60360c966f33cd0d) が espnetのgit checkout c173c30930631731e6836c274a591ad571749741と時期的に同じところ

現在は [kaldi](https://github.com/kaldi-asr/kaldi/tree/01aadd7c19372e3eacadec88caabd86162f33d69)

## 追加でインストールが必要だったのもの

```sh
pip install espnet_model_zoo
```

モデルのダウンロード

```sh
python -c "import nltk; nltk.download('averaged_perceptron_tagger_eng')"
```

# 推論

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