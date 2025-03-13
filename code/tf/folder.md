# フォルダ構成

- フォルダ構成は以下の通り

```
.
`-- tf
    |-- envs
    |   |-- backend.tf                          tfstateファイル管理設定ファイル
    |   |-- data.tf                             外部データソース定義ファイル
    |   |-- locals.tf                           ローカル変数定義ファイル
    |   |-- main.tf                             リソース定義ファイル
    |   |-- output.tf                           リソース戻り値定義ファイル
    |   |-- provider.tf                         プロバイダー設定ファイル
    |   |-- variable.tf                         変数定義ファイル
    |   `-- version.tf                          プロバイダー＆Terraformバージョン管理ファイル
    `-- modules
        |-- ec2                                 EC2モジュール
        |   |-- data.tf                           外部データソース定義ファイル
        |   |-- main.tf                           リソース定義ファイル
        |   |-- output.tf                         リソース戻り値定義ファイル
        |   `-- variable.tf                       変数定義ファイル
        |-- efs                                 EFSモジュール
        |   |-- data.tf                           外部データソース定義ファイル
        |   |-- json                              ファイルシステムポリシーSONファイル
        |   |   `-- filesystem-policy.json
        |   |-- main.tf                           リソース定義ファイル
        |   |-- output.tf                         リソース戻り値定義ファイル
        |   `-- variable.tf                       変数定義ファイル
        |-- iam                                 IAMモジュール
        |   |-- data.tf                           外部データソース定義ファイル
        |   |-- json                              バケットポリシー＆リダイレクトルールJSONファイル
        |   |   `-- ec2-trust-policy.json
        |   |-- main.tf                           リソース定義ファイル
        |   |-- output.tf                         リソース戻り値定義ファイル
        |   `-- variable.tf                       変数定義ファイル
        |-- kms                                 KMSモジュール
        |   |-- data.tf                           外部データソース定義ファイル
        |   |-- main.tf                           リソース定義ファイル
        |   |-- output.tf                         リソース戻り値定義ファイル
        |   `-- variable.tf                       変数定義ファイル
        `-- vpc_subnet                          NWモジュール
            |-- data.tf                           外部データソース定義ファイル
            |-- main.tf                           リソース定義ファイル
            |-- output.tf                         リソース戻り値定義ファイル
            `-- variable.tf                       変数定義ファイル
```
