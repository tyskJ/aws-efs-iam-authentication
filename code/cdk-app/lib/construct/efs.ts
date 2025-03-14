/*
╔════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ EFS IAM Authentication Stack - Cloud Development Kit efs.ts                                                                                        ║
╠════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╣
║ This construct creates an L1 Construct FileSystem, MountTarget, AccessPoints.                                                                      ║
╚════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
*/
import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";
import * as efs from "aws-cdk-lib/aws-efs";
import * as ec2 from "aws-cdk-lib/aws-ec2";
import * as kms from "aws-cdk-lib/aws-kms";
import * as iam from "aws-cdk-lib/aws-iam";
import { subnetKey } from "../../parameter";
import * as fs from "fs";
import * as path from "path";

export interface EfsProps extends cdk.StackProps {
  efsSg: ec2.CfnSecurityGroup;
  efsCmk: kms.Key;
  ec2Role: iam.Role;
  subnets: Record<subnetKey, ec2.CfnSubnet>;
}

export class Efs extends Construct {
  constructor(scope: Construct, id: string, props: EfsProps) {
    super(scope, id);

    // FileSystem
    const jsonData = fs.readFileSync(
      path.join(`${__dirname}`, "../json/filesystem-policy.json"),
      "utf8"
    );
    const jsonPolicy = JSON.parse(
      jsonData.replace(/{Ec2RoleArn}/g, props.ec2Role.roleArn)
    );
    const fileSystem = new efs.CfnFileSystem(this, "FileSystem", {
      encrypted: true,
      kmsKeyId: props.efsCmk.keyId,
      performanceMode: "generalPurpose",
      throughputMode: "elastic",
      fileSystemTags: [{ key: "Name", value: "efs-filesystem" }],
      fileSystemPolicy: jsonPolicy,
    });

    // MountTarget
    const mntTarget = new efs.CfnMountTarget(this, "MountTarget", {
      fileSystemId: fileSystem.attrFileSystemId,
      subnetId: props.subnets["private-a"].attrSubnetId,
      securityGroups: [props.efsSg.attrGroupId],
    });

    // AccessPoints
    const accessPoint = new efs.CfnAccessPoint(this, "AccessPoint", {
      fileSystemId: fileSystem.attrFileSystemId,
      posixUser: {
        uid: "1500",
        gid: "1500",
      },
      rootDirectory: {
        path: "/App",
        creationInfo: {
          ownerUid: "1500",
          ownerGid: "1500",
          permissions: "0755",
        },
      },
      accessPointTags: [{ key: "Name", value: "efs-access-point" }],
    });
  }
}
