# ESLint導入手順

対象ディレクトリ: `src/`（Laravel + React SPAのフロントエンド）

## 実行環境について

**すべてMac（ホスト）側で実行する。** PHPコンテナ（`work-php-1`）にはNode.js/npmが入っておらず、フロントエンドのビルド・Lint・型チェックはコンテナを介さずホストで完結する運用になっている。

```bash
which node npm npx
# → /opt/homebrew/bin/node など、Mac側のパスが返ることを確認
```

## 前提: TypeScriptを7系から6系にダウングレードする

このプロジェクトは `typescript@^7.0.2`（Go実装のネイティブコンパイラ、プレビュー版）を使っているが、事実上標準のLintツールである `typescript-eslint` は **2026年時点でTS7系を明示的に未サポート**で、TS7を検出すると起動時に強制的にエラーを投げて停止する仕様になっている（`typescript-estree` のエントリーポイントに直書きされたハードガードで、設定では回避不可）。

過去に一度ESLintを試してロールバックしたのはこれが原因。回避策として `typescript-eslint` パッケージだけTS6系を見せる方法も公式にあるが、npm環境では管理が複雑になるため、**プロジェクト全体のTypeScriptをいったん6系にダウングレードする方針**を採用した。

### ダウングレードの影響

- TypeScript 7はTS6.0との機能パリティを目指すプレビュー版であり、6→7の変更は基本的に破壊的変更が少ない設計。7→6に戻す場合も、7固有の新機能を使っていなければ実害はほぼない
- このプロジェクトの `tsconfig.json` は、TS7で非推奨になった設定値（`module: "amd"/"umd"`、`moduleResolution: "node"/"classic"`、`target: "es5"` など）を使っていないため、影響なし
- 実際にダウングレード後、`tsc --noEmit` と `vite build` の両方が正常に通ることを確認済み

### ダウングレードコマンド

```bash
cd src
npm install --save-dev typescript@6.0.3
```

`package.json` の `typescript` が `^6.0.3` になっていればOK。

```bash
npx tsc --version
# → Version 6.0.3
```

## ESLint本体・関連パッケージのインストール

```bash
cd src
npm install --save-dev eslint @eslint/js typescript-eslint eslint-plugin-react-hooks eslint-plugin-react-refresh eslint-config-prettier globals
```

インストールされるパッケージ（2026-08-22時点のバージョン）:

| パッケージ | バージョン | 役割 |
|---|---|---|
| `eslint` | `^10.9.0` | ESLint本体 |
| `@eslint/js` | `^10.0.1` | ESLint公式の基本ルールセット |
| `typescript-eslint` | `^8.67.0` | TypeScript対応（パーサー・ルール一式） |
| `eslint-plugin-react-hooks` | `^7.1.1` | Reactフックのルール（依存配列チェックなど） |
| `eslint-plugin-react-refresh` | `^0.5.4` | Vite HMR（React Fast Refresh）を壊すコードを検出 |
| `eslint-config-prettier` | `^10.1.8` | 既存のPrettierとフォーマット系ルールが競合しないよう無効化 |
| `globals` | `^17.11.0` | ブラウザ環境のグローバル変数定義（`window`, `document` 等） |

既存の `prettier`（`^3.9.6`）はそのまま使い続ける。ESLintはコードの誤りや設計上の問題を指摘する役割、Prettierはフォーマット（インデント・改行など）の役割で使い分けている。

## 設定ファイル

`src/eslint.config.js`（新規作成、ESLintのフラットコンフィグ形式）:

```js
// @ts-check

import js from '@eslint/js'
import tseslint from 'typescript-eslint'
import reactHooks from 'eslint-plugin-react-hooks'
import reactRefresh from 'eslint-plugin-react-refresh'
import eslintConfigPrettier from 'eslint-config-prettier'
import globals from 'globals'

export default tseslint.config(
  {
    ignores: ['node_modules', 'public', 'vendor', 'storage', 'bootstrap/cache'],
  },
  {
    files: ['resources/js/**/*.{ts,tsx}'],
    extends: [js.configs.recommended, ...tseslint.configs.recommended],
    languageOptions: {
      ecmaVersion: 2022,
      globals: globals.browser,
    },
    plugins: {
      'react-hooks': reactHooks,
      'react-refresh': reactRefresh,
    },
    rules: {
      ...reactHooks.configs.recommended.rules,
      'react-hooks/set-state-in-effect': 'off',
      'react-refresh/only-export-components': [
        'warn',
        { allowConstantExport: true },
      ],
      '@typescript-eslint/no-unused-vars': [
        'error',
        { caughtErrors: 'none' },
      ],
    },
  },
  eslintConfigPrettier,
)
```

### ルールセットの選定について

`typescript-eslint` には型情報を使う厳格なルールセット（`recommendedTypeChecked`）と、型情報を使わない軽量なルールセット（`recommended`）がある。当初 `recommendedTypeChecked` を試したところ、既存コード全体で **76件** のエラー（主に `no-floating-promises` / `no-misused-promises` — Promiseの戻り値を無視している箇所、`onClick` に `async` 関数を直接渡している箇所）が検出された。実際のバグの可能性がある指摘だが、一度に全部直すのは変更量が大きいため、**まず軽量な `recommended` を採用し既存コードを0件の状態にし、今後の新規コードから段階的に厳格なルールを適用する**方針にした。

### 個別に無効化・調整したルール

- **`react-hooks/set-state-in-effect`（無効化）**: `useEffect(() => { fetchXxx() }, [...])` という「マウント時にデータ取得する」定石パターン全体に警告が出る。React公式でも一般的なパターンであり、実害がないため無効化した
- **`@typescript-eslint/no-unused-vars` に `caughtErrors: 'none'`**: `catch (error) { setErrorMessage('...') }` のように、エラーの詳細を使わず固定の日本語メッセージだけ表示する既存の設計パターンがプロジェクト全体で一貫して使われているため、`catch` の引数が未使用でもエラーにしないよう調整した

## package.json への追加

```json
"scripts": {
    "build": "vite build",
    "dev": "vite",
    "lint": "eslint ."
}
```

## 実行コマンド（チェック方法）

すべてMac側、`src/` ディレクトリで実行する。

```bash
cd src

# ESLintチェック
npm run lint

# TypeScript型チェック（既存）
npx tsc --noEmit

# 本番ビルド確認（既存）
npm run build
```

`npm run lint` が **exit code 0** かつ出力なしであれば問題なし。

## 別PCでのセットアップ手順まとめ

1. リポジトリを `git pull` して最新の `package.json` / `package-lock.json` / `eslint.config.js` を取得する
2. `src/` で `npm install` を実行する（`package.json` に基づき、TypeScript6系・ESLint関連パッケージが自動的にインストールされる。個別にバージョン指定してのインストールコマンドを再実行する必要はない）
3. `npx tsc --version` で `Version 6.0.3` になっていることを確認する
4. `npm run lint` を実行し、エラーが出ないことを確認する

つまり、このドキュメントの「インストールコマンド」は初回導入時の手順であり、**別PCで最新のコミットを `pull` した後は `npm install` だけで環境が揃う**（`package-lock.json` にバージョンが固定されているため）。

## 留意点

- TypeScriptを6系に固定しているため、今後 `vite` や他の依存パッケージがTS7固有の機能を要求するようになった場合、追従できなくなる可能性がある
- `typescript-eslint` のTS7サポートは公式Issueで追跡中（`typescript-eslint/typescript-eslint#10940`）。解決した際はTS7への復帰を検討する余地がある
- 型情報を使う厳格なルール（`recommendedTypeChecked`）へ将来的に移行したい場合は、既存コードの76件の指摘（Promise関連が中心）を先に解消する必要がある
