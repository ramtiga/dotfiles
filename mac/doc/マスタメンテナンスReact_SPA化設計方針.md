# マスタメンテナンス React SPA化 設計方針（新規システム向け）

> 対象: 新規プロジェクト（Laravel 13 / React 19 / TypeScript 7 / Tailwind CSS、パッケージ導入済み）
> マスタメンテナンス機能（4機能）のみをReact化する。左メニュー選択→右側に機能表示のレイアウト。
> 初期表示からJSON API化。既存の `React移行計画.md`（旧システム向け）をベースに、新規システムの要件に合わせて再整理したもの。

## 1. 方式の選定

### SPA方式（採用）vs 画面ごとアイランド方式

| 方式 | 内容 | 判定 |
|---|---|---|
| SPA方式 | 1つのReactアプリが `/master` 配下全体を受け持ち、React Routerで内部遷移。レイアウト（サイドバー等）もReactで自作 | **採用** |
| 画面ごとアイランド方式 | 各画面ごとにBladeシェル+Reactマウント。レイアウトはBlade側を流用、画面遷移はフルリロード | 不採用（モックが既にHTML+vanilla JSで一体的に作られているため、SPA方式の方が自然） |

理由: 会社で使用するモック（`index.html` + 機能別vanilla JSファイル群、左メニュー→右コンテンツ切替のレイアウト）が既にSPA的な構造で作られているため、React Router によるSPA方式で移植するのが最も自然。

## 2. モックからの移植方針

モック構成: `index.html` が複数のvanilla JSファイル（機能ごとに分割）を `<script>` で読み込む構成。

| モック側 | React側 | 備考 |
|---|---|---|
| `index.html` | `App.tsx`（ルート定義） | |
| `sidebar.js`（クリックイベントで表示切替） | `Sidebar.tsx` + React Routerの`<NavLink>`/`<Outlet>` | 切り替えロジックは移植せずRouterに置き換える |
| `departments.js`（DOM操作で描画） | `pages/departments/Index.tsx` | DOM操作コードは使い回さず、宣言的JSXに書き直す |
| `app.js`（初期化） | `main.tsx` | |

移植の切り分け:
- **静的な見た目（マークアップ・Tailwindクラス）**: モックからほぼコピーで移植可能（簡単）
- **動的ロジック（表示切替・ハイライト）**: React Router標準機能（`<NavLink>`の`isActive`、`<Outlet>`）に置き換える前提で設計する。モックのJSをそのまま移植しようとしない

## 3. SPAシェルの配置方針

### 問題: 機能名に依存した命名を避ける

当初 `Admin/Master/MasterSpaController.php` のように「マスタメンテナンス専用」の配置を検討したが、将来別機能もReact化する場合に同じ発想で複製が必要になり、使い回しにくい。

一方で「Admin全体」を見据えた大掛かりな構成（`AdminSpaController`など）も検討したが、新規プロジェクトはユーザー種別を分けない設計（1種類のユーザーが複数の機能権限を持つ）であり、そもそも「Admin」という区分自体が存在しないため、この案は不採用。

### 採用方針

SPAコントローラー・シェルは「React化する領域」に対して1個、かつ**機能名に依存しない命名**にする。

```
app/Http/Controllers/
└── SpaController.php          # 1個、機能非依存の命名

resources/views/
└── spa.blade.php              # 1個
```

将来的に他機能もReact化することになった場合も、`SpaController`はシェルを返すだけの汎用コントローラーなのでルートを1行追加するだけで再利用できる。

## 4. ディレクトリ構成

### バックエンド（Laravel）

```
app/
├── Http/
│   ├── Controllers/
│   │   ├── SpaController.php                     # シェルを返すだけ（1個・機能非依存）
│   │   └── Api/
│   │       └── Master/
│   │           ├── DepartmentApiController.php   # 機能ごとに1個
│   │           └── ...
│   └── Requests/
│       └── Master/
│           └── Department/
│               └── SaveRequest.php
│
├── UseCase/
│   └── Master/
│       └── Department/
│           ├── ListUseCase.php
│           ├── SaveUseCase.php
│           ├── DeleteUseCase.php
│           └── Input/
│               ├── SaveInput.php
│               └── RowInput.php
│
└── Repository/
    └── Department/
        ├── DepartmentRepositoryInterface.php
        └── DoctrineDepartmentRepository.php

routes/
└── web.php   # SPAシェル用ルート + API用ルート

resources/views/
└── spa.blade.php
```

### フロントエンド（React）

```
resources/js/
├── main.tsx                          # エントリーポイント（1個）
├── App.tsx                           # React Routerのルート定義（機能追加のたび1行増える）
├── lib/
│   └── axios.ts                      # CSRFトークン設定済みaxiosインスタンス（共通）
├── components/
│   ├── layout/
│   │   ├── AppLayout.tsx             # サイドバー＋右コンテンツの箱（共通）
│   │   ├── Sidebar.tsx               # メニュー本体（共通、項目データが機能数分増える）
│   │   └── SidebarMenuItem.tsx
│   └── ui/
│       ├── LoadingSpinner.tsx
│       ├── ErrorMessage.tsx
│       ├── Toast.tsx
│       └── Button.tsx
├── pages/
│   └── departments/
│       └── DepartmentIndexPage.tsx # 機能ごとに1ページ
├── hooks/
│   └── departments/
│       └── useDepartments.ts       # API呼び出し＋状態管理（機能ごと）
└── types/
    └── department.ts               # TypeScript型定義（機能ごと）
```

### 機能追加時に触るファイル数の目安

4機能とも「一覧＋一括保存」の同パターンなら、1機能あたり新規8ファイル程度＋既存2ファイルへの1行追記で完結する見込み。

| 追加（新規ファイル） | 追記（既存ファイルへの1行） |
|---|---|
| Repository interface / 実装 | `App.tsx` にルート1行 |
| UseCase × 2〜3 | `Sidebar.tsx` にメニュー項目1行 |
| InputData | |
| FormRequest | |
| APIコントローラー | |
| React: page / hook / types | |

## 5. ルーティング設計

```php
// routes/web.php

// SPAシェル（マスタメンテナンス配下は全部これが受ける）
Route::middleware(['auth'])->group(function () {
    Route::get('/master/{any?}', [SpaController::class, 'index'])
        ->where('any', '.*')
        ->name('master.spa');
});

// API（webミドルウェア配下＝セッション認証を継続利用）
Route::middleware(['auth', 'feature:master-department'])
    ->prefix('api/master/departments')
    ->name('api.master.departments.')
    ->group(function () {
        Route::get('/', [DepartmentApiController::class, 'index'])->name('index');
        Route::post('/save', [DepartmentApiController::class, 'save'])->name('save');
        Route::delete('/{id}', [DepartmentApiController::class, 'destroy'])->name('destroy');
    });
```

- 画面表示用（Blade/SPAシェル）とAPI用（JSON）でコントローラーを分離する
- APIは `web` ミドルウェアグループ配下に置き、セッション認証をそのまま利用する（`api` グループはデフォルトでセッションを使わないため注意）
- CSRFトークンはBladeのmetaタグに埋め込み、axios側で共通ヘッダーに設定する

### React Router側

`main.tsx`（エントリーポイント）:

```tsx
// main.tsx
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { App } from './App'
import './lib/axios'
import './main.css'

const root_element = document.getElementById('app')

if (root_element === null) {
    throw new Error('#app element not found')
}

createRoot(root_element).render(
    <StrictMode>
        <App />
    </StrictMode>
)
```

- `document.getElementById('app')`で`spa.blade.php`の`<div id="app"></div>`を取得する。戻り値は`HTMLElement | null`型のためnullチェックが必須
- `./lib/axios`は副作用目的でimportする（axiosのデフォルト設定を行うだけで、返り値は使わない）だけなので値を受け取らない
- CSSは`main.css`（Tailwind CSSのエントリーファイル）をインポートする

`lib/axios.ts`（CSRFトークン設定済みaxiosインスタンス、共通）:

```tsx
// lib/axios.ts
import axios from 'axios'

const csrf_token = document
    .querySelector('meta[name="csrf-token"]')
    ?.getAttribute('content')

axios.defaults.headers.common['X-CSRF-TOKEN'] = csrf_token ?? ''
axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'

export default axios
```

- `spa.blade.php`の`<meta name="csrf-token" content="{{ csrf_token() }}">`から値を読み取り、axiosの共通ヘッダーに設定する
- `main.tsx`で副作用目的にimportすることでアプリ起動時に1度だけ設定される。API呼び出し側（`hooks/departments/useDepartments.ts`等）はこのファイルから`export default axios`されたインスタンスをimportして使う

`App.tsx`（ルート定義）:

```tsx
// App.tsx
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { AppLayout } from './components/layout/AppLayout'
import { DepartmentIndexPage } from './pages/departments/DepartmentIndexPage'

declare global {
    interface Window {
        __AVAILABLE_FEATURES__: string[]
    }
}

export function App() {
    return (
        <BrowserRouter basename="/master">
            <Routes>
                <Route element={<AppLayout />}>
                    <Route index element={<Navigate to="departments" replace />} />
                    <Route path="departments" element={<DepartmentIndexPage />} />
                    {/* 機能追加のたび、ここに1行追加していく */}
                </Route>
            </Routes>
        </BrowserRouter>
    )
}
```

- `basename="/master"`: `SpaController`が`/master/{any?}`で受けているルートに合わせ、React Router側のベースパスを揃える
- `<Navigate to="departments" replace />`: `/master`（インデックス）アクセス時に最初のマスタメンテナンス機能へリダイレクトする。`replace`でブラウザ履歴に無駄なエントリを残さない
- `<Route element={<AppLayout />}>`でラップし、その子要素として各ページを並べることで`Sidebar`を含む共通レイアウトを全ページで共有する（React Routerのネストルーティング）
- `declare global { interface Window { ... } }`は`window.__AVAILABLE_FEATURES__`をTypeScriptに認識させる型定義。`Sidebar.tsx`側でも同じ宣言を重複させない（`App.tsx`に集約する）

## 6. SpaControllerの実装

```php
<?php

namespace App\Http\Controllers;

class SpaController extends Controller
{
    public function index()
    {
        return view('spa', [
            'available_feature_codes' => auth()->user()->features->pluck('code'),
        ]);
    }
}
```

- 認証チェックはコントローラー内に書かず、ルート側のミドルウェア（`auth`）に委ねる
- `{any?}` パラメータはReact Router側で解釈するため、コントローラーでは使用しない
- 権限（機能コード）はサイドバー出し分けのため、シェル返却時にまとめて渡す

### テスト例

```php
<?php

namespace Tests\Http\Controllers;

use App\Models\User;
use Tests\TestCase;

class SpaControllerTest extends TestCase
{
    public function test_マスタメンテナンス画面のシェルが表示できること()
    {
        $user = User::create([
            'name' => 'user_test',
            'email' => 'user_test@example.com',
            'password' => bcrypt('password'),
            'email_verified_at' => now(),
        ]);

        $response = $this->actingAs($user)->get(route('master.spa'));

        $response->assertStatus(200);
        $response->assertViewIs('spa');
    }

    public function test_未認証の場合ログイン画面にリダイレクトされること()
    {
        $response = $this->get(route('master.spa'));

        $response->assertRedirect(route('login'));
    }
}
```

## 7. spa.blade.php

```blade
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>共済会管理システム</title>
    @vite(['resources/js/main.tsx'])
</head>
<body>
    <div id="app"></div>

    <script>
        window.__AVAILABLE_FEATURES__ = @json($available_feature_codes);
    </script>
</body>
</html>
```

- パスは `resources/js/` に統一（Laravel 13のVite標準構成に合わせる。旧`React移行計画.md`では`resources/src/`だったが、新規プロジェクトでは標準に寄せる）
- `window.__AVAILABLE_FEATURES__` への埋め込みで、ログインユーザーが利用できる機能コード一覧をReact側に渡す

## 8. APIコントローラーの返し方

対象は `SpaController` ではなく、UseCaseの結果をJSONとして返す**APIコントローラー**（`DepartmentApiController`など）。

### 基本方針

- **成功時**: `response()->json()`でデータまたはメッセージを返す
- **バリデーションエラー**: FormRequestに任せる（Laravelが自動で422を返すため、コントローラー側で意識する必要はない）
- **ビジネスロジック上のエラー**（UseCase内で発生する想定内の失敗）: 専用の例外を投げ、例外ハンドラでJSON化する（コントローラーにtry-catchを重複させない）

### index（一覧取得）

```php
public function index()
{
    $departments = $this->list_use_case->execute();

    return response()->json([
        'data' => $departments,
    ]);
}
```

- トップレベルを `{ "data": [...] }` の形にラップする（Laravelの`JsonResource`/`ResourceCollection`の慣習に合わせる）。将来ページネーションやメタ情報を追加する際に`data`キーの外側に足せるので拡張しやすい
- レスポンス形式を全APIで統一しておくと、React側の型定義（`{ data: Department[] }`）も揃えやすい
- UseCaseの戻り値はEloquent Model / Doctrineエンティティをそのまま返さず、**素の配列やDTOに変換する**（内部プロパティの意図しない露出を防ぐ）

```php
class ListUseCase
{
    public function execute(): array
    {
        return array_map(
            fn (Department $department) => [
                'id' => $department->id,
                'name' => $department->name,
                'representative_name' => $department->representative_name,
            ],
            $this->department_repository->findAll(),
        );
    }
}
```

### save（一括保存）

#### 成功時メッセージはBEが返すか、FEがlangから組み立てるか

**結論: 固定文言（「保存しました」等）はFE側でlangから取得する方式を推奨。BEはステータス（成功可否）とデータのみ返す。**

理由:
1. **責務の一貫性**: エラーメッセージ（Not Found等）をBEが返すのは「BEしか知らない情報」を伝える必要があるため。一方、成功メッセージは「何を保存したか」という文脈をFEが既に知っており、BEが改めて教える必要がない。「保存できた」という事実（HTTPステータス）さえ返せば、「何と表示するか」はFEの表示側の関心事
2. **通信コストと結合度**: 成功時にメッセージ文字列をレスポンスに含めると、BEのlangファイルとFEの表示が1対1に固定される。文言を変えたいときBE/FE両方を経由する必要が生じ、多言語対応時もBE側でAccept-Languageを見て切り替える実装が必要になる（FEのi18nライブラリで完結する方が負担が小さい）
3. **エラー時メッセージの扱い（BE側で組み立てる）とは非対称に見えるが、これは「エラーはBEにしかない情報を伝える」「成功はFEの表示の都合」という違いに基づくものであり矛盾しない**

例外的にBEがメッセージを返す方が良いケース:
- メッセージの中身が動的にBEの計算結果に依存する場合（例:「3件保存、1件は重複のためスキップしました」のように件数等BEでしか分からない値を文中に含める必要がある場合）
- FE側にi18nの仕組みがまだなく、langファイルの二重管理を避けたい過渡期（暫定的にBEの`message`をそのまま使う）

#### 実装（推奨: BEはステータスのみ返す）

```php
public function save(SaveRequest $request)
{
    $input = SaveInput::fromArray($request->validated());
    $this->save_use_case->execute($input);

    return response()->json(null, 200);
}
```

```tsx
// React側：成功したらlangキーからメッセージを組み立てて表示
async function save(payload: SavePayload) {
    try {
        await axios.post('/api/master/departments/save', payload)
        showToast(t('departments.message.save_success')) // FE側i18nライブラリ
    } catch (error) {
        // ...
    }
}
```

新規作成した行のID（DB自動採番）をReact側が以降の操作で必要とする場合は、更新後の全件データを返す:

```php
public function save(SaveRequest $request)
{
    $input = SaveInput::fromArray($request->validated());
    $departments = $this->save_use_case->execute($input);

    return response()->json([
        'data' => $departments,
    ], 200);
}
```

この場合 `SaveUseCase::execute()` の戻り値も `void` ではなく、保存後の一覧配列を返す形に変える。

#### 例外パターン（BEがメッセージを返す場合）

```php
public function save(SaveRequest $request)
{
    $input = SaveInput::fromArray($request->validated());
    $this->save_use_case->execute($input);

    return response()->json([
        'message' => __('departments.message.save_success'),
    ], 200);
}
```

### destroy（削除）

```php
public function destroy(int $id)
{
    $this->delete_use_case->execute($id);

    return response()->json(null, 204);
}
```

削除成功時は `204 No Content`（ボディなし）がREST的な定石。

`DeleteUseCase` の実装例:

```php
namespace App\UseCase\Master\Department;

class DeleteUseCase
{
    public function __construct(
        private DepartmentRepositoryInterface $department_repository,
    ) {
    }

    public function execute(int $id): void
    {
        $department = $this->department_repository->find($id);

        if ($department === null) {
            throw new NotFoundException($id);
        }

        $this->department_repository->delete($department);
    }
}
```

- 対象が存在しない場合は専用例外（`NotFoundException`）を投げ、コントローラーには例外処理を書かせない（後述の「エラー時の返し方」で例外ハンドラに一括変換させる方針と対応する）
- `find()` → `delete()` の2段構えにすることで、「存在しないIDを削除しようとした」ケースを明示的に検知できる（Repositoryの`delete()`にモデルではなくIDを直接渡す設計にすると、存在チェックが暗黙的になり意図が伝わりにくい）

### エラー時の返し方

UseCase内の想定内エラー（対象が見つからない等）は専用例外を投げ、**例外ハンドラで一括してJSON変換する**方式を推奨（コントローラーごとのtry-catch重複を防ぐ）。

```php
// app/Exceptions/Handler.php
public function register()
{
    $this->renderable(function (NotFoundException $e, $request) {
        if ($request->is('api/*')) {
            return response()->json(['message' => $e->getMessage()], 404);
        }
    });
}
```

コントローラー内で個別にtry-catchするパターンも可能だが、API化する画面が複数（4機能）ある前提のため、例外ハンドラでの一括対応が望ましい。

### 想定外の例外（500エラー）のフォールバック

`renderable()`は型で絞り込まれたコールバックのため、`NotFoundException`以外の例外（DB接続エラー、null参照、型エラーなど想定していないもの）が発生した場合はこの関数は呼ばれず、Laravelのデフォルトのエラーハンドリングに流れる。

対応しない場合の挙動:
- `APP_DEBUG=true`（開発環境）: スタックトレース付きの詳細な情報がそのまま返る。ファイルパスやコード構造が漏れるため本番では不可
- `APP_DEBUG=false`（本番環境）: 中身を伏せた汎用の500エラー（`{"message": "Server Error"}`など）が返り、FEには意味のある情報が一切届かない

「想定内エラー」と「想定外エラー」を分け、想定外エラー用の共通フォールバックもAPI向けに用意しておく。

```php
// app/Exceptions/Handler.php
public function register()
{
    // 想定内エラー：BEが用意したメッセージをそのまま返す
    $this->renderable(function (NotFoundException $e, $request) {
        if ($request->is('api/*')) {
            return response()->json(['message' => $e->getMessage()], 404);
        }
    });

    // 想定外エラー：APIリクエストなら共通のフォールバックメッセージを返す
    $this->renderable(function (Throwable $e, $request) {
        if ($request->is('api/*')) {
            report($e); // ログには詳細を残す

            return response()->json([
                'message' => __('common.message.unexpected_error'),
            ], 500);
        }
    });
}
```

```php
// lang/ja/common.php
'message' => [
    'unexpected_error' => '予期せぬエラーが発生しました。時間をおいて再度お試しください。',
],
```

ポイント:
- `renderable`は登録順に、型が一致するものが優先される。個別の想定内エラー（`NotFoundException`等）を先に登録し、その後に`Throwable`（PHPの全例外・エラーの最上位）用を登録することで「個別の想定内エラー→それ以外全部」という優先順位になる
- `report($e)`を明示的に呼び、ログに詳細を残す（`renderable()`使用時にデフォルトのログ記録がスキップされる場合があるため。Laravel 13での実際の挙動は実装前に確認する）
- FE側の実装はそのまま使い回せる（`error.response.data.message`を読む処理は、想定内・想定外どちらのエラーでも同じ形 `{ message: "..." }` のため分岐不要）
- 本番の`APP_DEBUG=false`が確実に効いているか合わせて確認する（この対応をしていても`APP_DEBUG=true`のままだとLaravelが先に詳細なデバッグ情報を返すケースがある）

### エラーメッセージはBE（例外クラス）が持つ

エラーメッセージの文言はBE側に一元化する。例外クラス自身が、langファイルを参照してメッセージを組み立てる。

```php
// app/Exceptions/NotFoundException.php
namespace App\Exceptions;

use Exception;

class NotFoundException extends Exception
{
    public function __construct(int $id)
    {
        parent::__construct(
            __('departments.message.not_found', ['id' => $id])
        );
    }
}
```

```php
// lang/ja/departments.php
return [
    'message' => [
        'save_success' => '部署情報を更新しました',
        'not_found' => '指定された部署（ID: :id）が見つかりません',
    ],
];
```

例外ハンドラは`$e->getMessage()`をそのままJSONに載せるだけでよく、変更不要。

### コントローラーはtry-catch不要

例外ハンドラでの一括変換方式を採用する場合、コントローラー側にエラーハンドリングを書く必要はない。

```php
public function destroy(int $id)
{
    $this->delete_use_case->execute($id);   // ここで例外が飛んでも…

    return response()->json(null, 204);       // このreturnまで到達せず、例外ハンドラが横取りする
}
```

PHPの例外は「投げたら、それをキャッチする場所まで自動的に巻き戻る」仕組みのため、`execute()`内で`throw`された時点でコントローラーの残りの処理は実行されず、`app/Exceptions/Handler.php`の`renderable()`に登録した処理が呼ばれる。コントローラーごとにtry-catchを重複させないための設計。

### FEでのmessage表示方法

BEのレスポンス形式（再掲）:

```json
// 成功時（204 No Content）
（ボディなし）

// エラー時（404）
{ "message": "指定された部署（ID: 5）が見つかりません" }
```

React側はaxiosの`try/catch`で拾う。

```tsx
// hooks/departments/useDepartments.ts
import axios from '@/lib/axios'
import { useState } from 'react'

export function useDepartments() {
    const [error_message, setErrorMessage] = useState<string | null>(null)

    async function destroyDepartment(id: number) {
        try {
            await axios.delete(`/api/master/departments/${id}`)
            // 成功時の処理（一覧から該当行を除去する等）
        } catch (error) {
            if (axios.isAxiosError(error) && error.response) {
                setErrorMessage(error.response.data.message)
            } else {
                setErrorMessage('通信エラーが発生しました')
            }
        }
    }

    return { destroyDepartment, error_message }
}
```

```tsx
// pages/departments/DepartmentIndexPage.tsx
const { destroyDepartment, error_message } = useDepartments()

return (
    <div>
        {error_message && (
            <div className="bg-red-50 text-red-700 p-3 rounded">{error_message}</div>
        )}
        {/* 一覧テーブルなど */}
    </div>
)
```

ポイント:
- `error.response.data.message` が、BE側で`response()->json(['message' => $e->getMessage()], 404)`として返した文字列そのもの。BE→FEの受け渡しは`message`キー1本に統一しておくと、どのエラー（Not Found、その他業務エラーなど）でも同じ取り出し方でFEが処理できる
- **バリデーションエラー（422）だけは形が違う**点に注意。`{ message, errors }`という形で、`errors`はフィールドごとのエラー配列を持つ。フォーム入力エラーの表示には`error.response.data.errors`を使い、それ以外の業務エラー（404等）は`error.response.data.message`だけを使う、という2パターンの処理分けが必要
- 一定時間で消えるトースト通知として表示したい場合は、`error_message`を共通の`Toast`コンポーネント（`components/ui/Toast.tsx`）に渡す形にすると、他の画面でも同じパターンで使い回せる

### バリデーションエラー

FormRequestの`rules()`定義により、バリデーション失敗時はLaravelが自動的に **422 Unprocessable Entity** ＋エラー内容のJSONを返す。コントローラー側の明示的なハンドリングは不要。

```json
{
    "message": "The name field is required.",
    "errors": {
        "name": ["The name field is required."]
    }
}
```

React側はaxiosの`catch`で422を拾い、`error.response.data.errors`をフォームのエラー表示に使う。

### 配列バリデーション時のキー構造（一覧の一括保存）

マスタメンテナンスの一括保存（`departments.*.name`のような配列バリデーション）では、`errors`のキーがインデックス付きのドット記法になる。

```php
// SaveRequest
public function rules(): array
{
    return [
        'departments' => ['required', 'array'],
        'departments.*.name' => ['required', 'string', 'max:255'],
        'departments.*.representative_name' => ['required', 'string', 'max:255'],
    ];
}
```

```json
{
    "message": "The departments.0.name field is required.",
    "errors": {
        "departments.0.name": [
            "The departments.0.name field is required."
        ],
        "departments.2.representative_name": [
            "The departments.2.representative_name field is required."
        ]
    }
}
```

`departments.0.name`は「0番目の行のnameフィールド」を意味する。React側は、このキーから行インデックスとフィールド名を取り出し、対応するセルにエラーを表示する必要がある。

```tsx
// hooks/departments/useDepartments.ts
import axios from '@/lib/axios'
import { useState } from 'react'

type FieldErrors = Record<string, string[]>

export function useDepartments() {
    const [field_errors, setFieldErrors] = useState<FieldErrors>({})

    async function save(payload: { departments: DepartmentRow[] }) {
        try {
            await axios.post('/api/master/departments/save', payload)
            setFieldErrors({})
        } catch (error) {
            if (axios.isAxiosError(error) && error.response?.status === 422) {
                setFieldErrors(error.response.data.errors)
            }
        }
    }

    // "departments.0.name" → { row_index: 0, field: "name" }
    function getRowError(row_index: number, field: string): string | undefined {
        return field_errors[`departments.${row_index}.${field}`]?.[0]
    }

    return { save, getRowError }
}
```

```tsx
// pages/departments/DepartmentIndexPage.tsx（抜粋）
const { getRowError } = useDepartments()

<input value={row.name} />
{getRowError(row_index, 'name') && (
    <span className="text-red-600 text-sm">{getRowError(row_index, 'name')}</span>
)}
```

### エラー種別ごとのレスポンス形の違い（比較）

| エラー種別 | ステータス | 形 | FE側の使い道 |
|---|---|---|---|
| バリデーションエラー | 422 | `{ message, errors }` | `errors`を使ってフィールドごとにエラー表示（配列の場合は`departments.N.field`形式） |
| 業務エラー（Not Foundなど） | 404等 | `{ message }`のみ | `message`をトースト等で表示 |
| 想定外エラー | 500 | `{ message }`のみ | `message`をトースト等で表示 |

`errors`キーの有無で処理を分岐する必要がある点に注意（422のみ`errors`を持つ）。

### まとめ

| アクション | 成功時ステータス | 返却内容 |
|---|---|---|
| index | 200 | `{ data: [...] }` |
| save | 200 | ボディなし（推奨。またはID等が必要なら`{ data: [...] }`） |
| destroy | 204 | ボディなし |
| バリデーションエラー | 422（Laravel自動） | `{ message, errors }` |
| 業務エラー（Not Foundなど） | 404等 | `{ message: "..." }`（例外ハンドラで一括変換推奨） |

成功時の`message`はBEが返さず、FE側でlangキーから組み立てて表示するのが推奨（エラー時のみBEがメッセージを持つ非対称設計）。`save`の戻り値に更新後データを含めるかは未確定（React側で新規行のIDをその場で扱う必要があるか次第）。

## 9. 権限（機能制御）の設計

### テーブル構成

```
users               # ユーザー（単一のユーザー種別。機能権限を複数持つ）
features            # 機能マスタ（id, code, name など）
user_permissions    # 中間テーブル（user_id, feature_id）※1ユーザーが複数レコードを持つ
```

新規プロジェクトはユーザー種別を分けず、1種類のユーザーが複数の機能権限を持つ設計（既存の共済会システムのようなEmployee/BusinessPerson/Admin/Externalの区分はない）。

多対多のリレーション。Eloquentの場合の例:

```php
// app/Models/User.php
public function features()
{
    return $this->belongsToMany(Feature::class, 'user_permissions', 'user_id', 'feature_id');
}
```

### 制御ポイントは2箇所（両方必要）

| 箇所 | 役割 | 実装 |
|---|---|---|
| React側（表示制御） | サイドバーのメニュー出し分け | `window.__AVAILABLE_FEATURES__` を参照してフィルタ |
| API側（実効制御・必須） | URLを直接叩かれても権限外の操作を防ぐ | ミドルウェア（例: `feature:master-department`）でチェック |

React側の表示制御は見た目だけであり、URLを直接叩けば権限がなくてもAPIが呼べてしまうため、API側の権限チェックは省略不可。

### React側の実装イメージ

```tsx
// components/layout/Sidebar.tsx
// window.__AVAILABLE_FEATURES__ の型定義は App.tsx に集約済み（declare globalの重複回避）
const menuItems = [
    { label: '部署', path: 'departments', feature_code: 'master-department' },
    { label: 'Xxx', path: 'xxx', feature_code: 'master-xxx' },
]

export function Sidebar() {
    const available_features = window.__AVAILABLE_FEATURES__ ?? []
    const visible_items = menuItems.filter(item =>
        available_features.includes(item.feature_code)
    )

    return (
        <nav>
            {visible_items.map(item => (
                <NavLink key={item.path} to={item.path}>{item.label}</NavLink>
            ))}
        </nav>
    )
}
```

### window グローバル変数についての補足

FEに詳しくない前提での解説メモ:

- `window` はブラウザが用意する、ページ全体で共有されるグローバルなオブジェクト
- Blade側の `window.__AVAILABLE_FEATURES__ = @json(...)` は、サーバー側（Laravel）が持つ情報をHTMLに焼き込み、ブラウザに渡す処理。ページ読み込み時に1回だけ必要な情報（ログインユーザーの権限一覧など）を渡す手軽な方法
- React側の `window.__AVAILABLE_FEATURES__` は、渡された情報を読み取る処理
- `declare global { interface Window { __AVAILABLE_FEATURES__: string[] } }` はTypeScript特有の型定義で、「windowにこのプロパティが追加されている」とコンパイラに教えるためのもの。実行時の動作には影響せず、型チェックのためだけの記述
- `window` への直書きはシンプルだが、大規模になるほど「どこで何を生やしているか」が散らかりやすい弱点がある。今回のように渡す情報が数個程度であれば実用的

## 10. 全体フロー（アクセス〜表示まで）

```
ブラウザ: GET /master/departments
    ↓
routes/web.php → SpaController::index()
    ↓
return view('spa', [...])  ← Reactのエントリーポイントとなるシェルを1つ返すだけ
    ↓
Reactが起動 → React Router が /master/departments を見る
    ↓
pages/departments/DepartmentIndexPage.tsx をレンダリング
    ↓
useEffect内で GET /api/master/departments を叩く
    ↓
Api/Master/DepartmentApiController::index()
    ↓
UseCase → Repository → JSON返却
    ↓
Reactがデータを受け取ってテーブル描画
```

## 11. タスク分割案

### フェーズ0: 基盤整備

| # | タスク |
|---|---|
| 0-1 | ルーティングの2層構造（SPAシェル用 / API用）を用意 |
| 0-2 | `SpaController` 作成 |
| 0-3 | `spa.blade.php` 作成 |
| 0-4 | axios共通設定（CSRFトークン埋め込み、`lib/axios.ts`） |
| 0-5 | React Router導入・`App.tsx` の骨組み |
| 0-6 | `AppLayout` / `Sidebar` 実装（モックのマークアップを移植） |
| 0-7 | 共通UIコンポーネント最小セット（LoadingSpinner, ErrorMessage, Button） |
| 0-8 | BE側の共通土台（UseCase/Repositoryディレクトリ構成、命名規則をサンプル1つで確定） |
| 0-9 | 権限（機能コード）テーブルとミドルウェアの実装 |

### フェーズ1: 練習台となる1画面を通しで実装

4機能のうち最もシンプルな画面を選び、BE〜FEを1本通して実装しきる。ここで確立したパターンを残り機能に横展開する。

| # | タスク |
|---|---|
| 1-1 | Repository実装（`findAll`, `find`, `save`, `delete`） |
| 1-2 | UseCase実装（`ListXxxUseCase`, `SaveXxxUseCase`） |
| 1-3 | FormRequest + InputData実装 |
| 1-4 | APIコントローラー実装（JSON返却） |
| 1-5 | コントローラーテスト（UseCaseモック化） |
| 1-6 | React側: 一覧取得・表示（`useXxx`フック＋ページコンポーネント） |
| 1-7 | React側: 一括保存（右上ボタン→バリデーション→送信→トースト表示） |
| 1-8 | エラーハンドリング・ローディング状態のパターン確立 |

### フェーズ2: 残り機能への横展開

フェーズ1で確立したパターンを残り3機能に適用。

### フェーズ3: 仕上げ

| # | タスク |
|---|---|
| 3-1 | i18n方式の確定・適用（API経由 or ビルド時JSON） |
| 3-2 | 全画面の動作確認 |
| 3-3 | 不要になった旧資産の整理 |

## 12. 未確定事項（要確認）

- 4機能それぞれの画面種別（一覧のみか、詳細/新規作成画面もあるか）と、「一覧全行編集＋右上ボタンで一括保存」パターンに該当する機能の特定
- `features` / `user_permissions` のテーブル名・カラム名の正式名称
- i18n（ラベル文言）の受け渡し方式（API経由 or ビルド時JSON）
- `save`のレスポンスに更新後データを含めるか（React側で新規行のIDをその場で扱う必要があるか次第）
