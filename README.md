# espnetのjetsを動かす

```bash
docker build -t espnet-jets .
```

```bash
docker run -it --rm -v "${PWD}:/work" espnet-jets bash
```

# memo

## kaliのバージョン
[当時にkaldi](https://github.com/kaldi-asr/kaldi/tree/ac29a6ff09823d1cbb4814da60360c966f33cd0d) が espnetのgit checkout c173c30930631731e6836c274a591ad571749741と時期的に同じところ

現在は [kaldi](https://github.com/kaldi-asr/kaldi/tree/01aadd7c19372e3eacadec88caabd86162f33d69)

## 追加でインストールが必要だったのもの

```sh
pip install kaldiio humanfriendly numpy resampy soundfile tqdm typeguard==2.7.1 inflect==5.0.3 matplotlib espnet_model_zoo
```

モデルのダウンロード

```sh
python -c "import nltk; nltk.download('averaged_perceptron_tagger_eng')"
```