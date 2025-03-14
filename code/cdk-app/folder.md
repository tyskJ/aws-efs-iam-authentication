# フォルダ構成

- フォルダ構成は以下の通り

```
.
`-- cdk-app
    |-- bin
    |   `-- cdk-app.ts                        CDK App定義ファイル
    |-- lib
    |   |-- construct                         コンストラクト
    |   |   |-- ec2.ts                          EC2
    |   |   |-- efs.ts                          EFS
    |   |   |-- iam.ts                          IAM
    |   |   |-- kms.ts                          KMS
    |   |   `-- network.ts                      Network
    |   |-- json
    |   |   `-- filesystem-policy.json        EFSファイルシステムポリシー
    |   `-- stack
    |       `-- cdk-app-stack.ts              スタック
    `-- parameter.ts                          環境リソース設定値定義ファイル
```
