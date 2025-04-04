# Nicehash Docker 環境構築

このリポジトリは、Docker を使用して Nicehash マイニング環境を簡単に構築するためのツールです。特定のGPU（デフォルトではGPU3）のみを使用するように最適化されています。

## 概要

このプロジェクトは以下のファイルで構成されています：

1. **Dockerfile** - マイニング環境の構築に必要な設定
2. **start-mining.sh** - マイニングを開始するためのスクリプト
3. **config.json** - XMRig の設定ファイル（特定のGPUのみを使用）
4. **README.md** - このドキュメント

## 前提条件

- Docker がインストールされていること
- NVIDIA GPU を搭載したマシンであること
- nvidia-docker がインストールされていること
- インターネット接続が安定していること

## インストール方法

1. リポジトリをクローンまたはダウンロードします：

```bash
git clone https://your-repository-url/nicehash-docker.git
cd nicehash-docker
```

2. Docker イメージをビルドします：

```bash
docker build -t nicehash-miner .
```

## 使用方法

### 基本的な使用方法

以下のコマンドでコンテナを起動します：

```bash
docker run --gpus '"device=2"' -e NICEHASH_USER=あなたのビットコインアドレス -e NICEHASH_WORKER=ワーカー名 nicehash-miner
```

これだけで設定は完了します。コンテナ内の`start-mining.sh`スクリプトが自動的にこれらの環境変数を使用して設定を行います。

### 環境変数

以下の環境変数を設定することで、マイニング設定をカスタマイズできます：

| 環境変数 | 説明 | デフォルト値 |
|----------|------|------------|
| NICEHASH_USER | あなたのビットコインアドレス | 必須 |
| NICEHASH_WORKER | ワーカー名（識別用） | 必須 |
| NICEHASH_REGION | サーバーリージョン（usa/eu/hk） | usa |
| COIN | マイニングする通貨 | BTC |
| GPU_INDEX | 使用するGPUのインデックス（0から始まる） | 2 (GPU3) |

### GPU の指定

#### デフォルト設定（GPU3のみ使用）

このDockerイメージはデフォルトでGPU3（インデックス2）のみを使用するよう設定されています：

```bash
docker run --gpus '"device=2"' -e NICEHASH_USER=あなたのビットコインアドレス -e NICEHASH_WORKER=ワーカー名 nicehash-miner
```

#### 別のGPUを使用する場合

別のGPUを使用したい場合は、`GPU_INDEX`環境変数を設定します：

```bash
# GPU2（インデックス1）を使用する例
docker run --gpus '"device=1"' -e NICEHASH_USER=あなたのビットコインアドレス -e NICEHASH_WORKER=ワーカー名 -e GPU_INDEX=1 nicehash-miner
```

注意: GPUのインデックスは0から始まります。

#### すべてのGPUを使用する場合

すべてのGPUを使用したい場合は、`config.json`ファイルを変更する必要があります。独自の設定ファイルを用意し、マウントしてください：

```bash
docker run --gpus all -v /path/to/your/config.json:/nicehash/xmrig/build/config.json -e NICEHASH_USER=あなたのビットコインアドレス -e NICEHASH_WORKER=ワーカー名 nicehash-miner
```

## モニタリング

マイニングの状況を確認するには、コンテナのポート 4067 を公開し、Web ブラウザからアクセスします：

```bash
docker run --gpus '"device=2"' -p 4067:4067 -e NICEHASH_USER=あなたのビットコインアドレス -e NICEHASH_WORKER=ワーカー名 nicehash-miner
```

その後、ブラウザで `http://localhost:4067` にアクセスすると、マイニングの状況を確認できます。

## トラブルシューティング

### コンテナが起動しない場合

以下のコマンドでログを確認します：

```bash
docker logs <コンテナID>
```

### GPU が検出されない場合

1. GPUドライバーが正しくインストールされていることを確認してください
2. `nvidia-smi` コマンドを実行してGPUの状態を確認してください
3. `--gpus` パラメータが正しく指定されているか確認してください

### パフォーマンスが低い場合

- GPU ドライバーが最新であることを確認してください
- 使用しているGPUに適したマイニングアルゴリズムを選択してください
- 冷却が適切に行われているか確認してください

## 注意事項

- マイニングはコンピュータのリソースを大量に消費します。電気代や機器の寿命に影響する可能性があります。
- 仮想通貨のマイニングは地域によって法的規制がある場合があります。自己責任で行ってください。
- 長時間のマイニングはハードウェアに負担をかけます。適切な冷却と監視を行ってください。

## ライセンス

このプロジェクトは MIT ライセンスの下で公開されています。詳細は LICENSE ファイルを参照してください。