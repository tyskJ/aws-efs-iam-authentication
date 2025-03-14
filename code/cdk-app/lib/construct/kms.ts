/*
╔════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ EFS IAM Authentication Stack - Cloud Development Kit kms.ts                                                                                        ║
╠════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╣
║ This construct creates an L2 Construct KMS Key and Alias.                                                                                          ║
╚════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
*/
import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";
import * as kms from "aws-cdk-lib/aws-kms";
import { kmsInfo } from "../../parameter";

export interface KmsProps extends cdk.StackProps {
  efsCmk: kmsInfo;
}

export class Kms extends Construct {
  public readonly CmkEfs: kms.Key;

  constructor(scope: Construct, id: string, props: KmsProps) {
    super(scope, id);

    // EFS CMK
    this.CmkEfs = new kms.Key(this, props.efsCmk.id, {
      alias: props.efsCmk.alias,
      description: props.efsCmk.description,
      enableKeyRotation: props.efsCmk.keyRotation,
      pendingWindow: cdk.Duration.days(props.efsCmk.pendingWindow),
      removalPolicy: cdk.RemovalPolicy.DESTROY,
    });
    for (const tag of props.efsCmk.tags) {
      cdk.Tags.of(this.CmkEfs).add(tag.key, tag.value);
    }
  }
}
