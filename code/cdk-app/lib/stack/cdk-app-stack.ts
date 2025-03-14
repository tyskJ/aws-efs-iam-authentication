import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";
import { Parameter } from "../../parameter";
import { Network } from "../construct/network";
import { Iam } from "../construct/iam";
import { Kms } from "../construct/kms";

export class CdkAppStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: Parameter) {
    super(scope, id, props);

    // Pseudo Parameters
    const pseudo = new cdk.ScopedAws(this);

    // Network Construct
    const nw = new Network(this, "Nw", {
      pseudo: pseudo,
      vpc: props.vpc,
      subnets: props.subnets,
      nacl: props.nacl,
      rtbPub: props.rtbPub,
      rtbPri: props.rtbPri,
      sgEc2: props.sgEc2,
      sgEfs: props.sgEfs,
    });

    // IAM
    const iam = new Iam(this, "Iam", {
      ec2Role: props.ec2Role,
    });

    // KMS
    const kms = new Kms(this, "Kms", {
      efsCmk: props.efsCmk,
    });
  }
}
