# yaml-practice
## はじめに
**YAML**は「データの見やすさ」「人間が書きやすい構文」に特化したデータ記述フォーマットです。  
設定ファイル（例：GitHub Actions、Docker Compose）やデータ交換にも幅広く使われています。

この記事では、
- YAMLの基本構文
- RubyでのYAMLファイル読み込み方法
をわかりやすく解説します！

---

## YAMLの基本構文まとめ

### 1. スカラー（単一の値）

YAMLでは、次のような単一の値を「スカラー」と呼びます。

| 型     | 例                                      |
|:-------|:----------------------------------------|
| 文字列 | `a` 、 `"555"`                          |
| 数値   | `5`                                    |
| 真偽値 | `true` 、`false`、`yes`、`no`、`on`、`off` |
| null値 | `null` 、`~`                           |
| 日付   | `2025-04-29`                           |

**ポイント**
- コロン（`:`）の後には**必ずスペース**を入れる
- **インデントはスペース2つ**（タブ不可）

---

### 2. シーケンス（配列）

複数の値をリストで表すときに使います。

#### ブロックスタイル
```yml:mydata.yml
- a
- b
- c
```

#### フロースタイル
```yml:mydata.yml
[a, b, 5]
```

#### ネスト（入れ子）
```ymlmydata.yml
- a
- 
  - b-1
  - b-2
- c
```

---

### 3. マッピング（ハッシュ・オブジェクト）

キーとバリューのセットで表現します。

#### ブロックスタイル
```yml:mydata.yml
name: yamazaki
email: yamazaki@example.com
sex: male
age : 29
```
※コロンの直後にスペースを入れないとエラーになるので注意！

#### フロースタイル
```yml:mydata.yml
{name: yamazaki, email: yamazaki@example.com}
```

#### ネスト（入れ子）
```yml:mydata.yml
name:
  first: yuta
  last: yamazaki
```

---

### 4. シーケンスとマッピングの組み合わせ

#### マッピングの中にシーケンス
```yml:mydata.yml
name:
  - yuta
  - yamazaki
email:
  - yamazaki@example.com
  - yuta@example.com
```

#### シーケンスの中にマッピング
```yml:mydata.yml
- name: yuta
  email: yuta@example.com
- name: yamazaki
  email: yamazaki@example.com
```

#### フロースタイル混合
```yml:mydata.yml
- {name: yuta, email: yuta@example.com}
- {name: yamazaki, email: yamazaki@example.com}
```

---

### 5. 複数行（改行を含むデータ）

#### 通常（改行は無視される）
```yml:mydata.yml
I
am
from
Japan.
```

#### 改行を保持する (`|`)
```yml:mydata.yml
|
I
am
from
Japan
```

#### 改行をスペースに変換する (`>`)
```yml:mydata.yml
>
I
am
from
Japan
```

オプション
- `|-` ：最後の改行を削除
- `|+` ：最後に改行を追加
- `>-` ：スペース変換＋最後の改行削除
- `>+` ：スペース変換＋最後に改行追加

---

### 6. アンカーとエイリアス（再利用）

- アンカー（定義）: `&アンカー名`
- エイリアス（参照）: `*アンカー名`

#### 例
```yml:mydata.yml
- &yuta
  name: yuta
  email: yuta@example.com
- &yamazaki
  name: yamazaki
  email: yamazaki@example.com
  friend: *yuta
- &taro
  name: taro
  email: taro@example.com
  friend: [*yuta, *yamazaki]
```

---

### 7. マッピングをアンカー化して継承

共通設定をまとめる場合に便利です。

```yml:mydata.yml
common: &common
  user: user
  password: password

development:
  database: dev_db
  <<: *common

production:
  database: prod_db
  <<: *common

test:
  database: test_db
  <<: *common
```

---

### 8. YAMLファイルを分割する

複数データを一つのファイルにまとめたいとき。

```yml:mydata.yml
---
- a
- b
- c
...
---
- 1
- 2
- 3
...
```

---

## RubyでYAMLファイルを読み込む

### 基本の読み込み

```ruby
require 'yaml'

data = YAML.load_file('mydata.yml')
p data
```

※古い方法（`load_file`）にはセキュリティリスクがあるため注意！

---

### 【現在推奨】安全な読み込み (`safe_load`)

```ruby
require 'date'
require 'yaml'

data = YAML.safe_load(File.read('mydata.yml'), permitted_classes: [Date], aliases: true)
p data
```

- `permitted_classes: [Date]`  
  → YAMLファイルに日付型が含まれている場合に許可
- `aliases: true`  
  → アンカー＆エイリアスを許可

**セキュリティを確保しつつ、正しくデータを扱えます。**

---

### 分割されたYAMLファイルを読み込む

```ruby
File.open('mydata.yml') do |io|
  YAML.load_stream(io) do |data|
    p data
  end
end
```

- `load_stream`を使うと`---`で区切られた複数データも順番に読み込めます。

---

# まとめ

- YAMLは**シンプルかつ人間に優しい**データフォーマット
- Rubyで扱う場合は**`safe_load`**を使うのが基本
- 日付型やエイリアスを使うときはオプションを忘れずに！

実際の開発現場では、設定ファイル管理だけでなく、データモデリングにも役立つので、  
ぜひ**実践レベルでマスター**していきましょう！
