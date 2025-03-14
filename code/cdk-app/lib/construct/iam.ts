/*
╔════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║ EFS IAM Authentication Stack - Cloud Development Kit iam.ts                                                                                        ║
╠════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╣
║ This construct creates an L2 Construct IAM Role.                                                                                                   ║
╚════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
*/
import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";
import * as iam from "aws-cdk-lib/aws-iam";
import { iamRoleInfo } from "../../parameter";

export interface IamProps extends cdk.StackProps {
  ec2Role: iamRoleInfo;
}

export class Iam extends Construct {
  public readonly ec2Role: iam.Role;

  constructor(scope: Construct, id: string, props: IamProps) {
    super(scope, id);
    // EC2 Role
    this.ec2Role = this.createIamRole(this, props.ec2Role);
  }
  /*
  ╔════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
  ║ Method (private)                                                                                               ║
  ╠═══════════════════════════╤═════════════════════════╤══════════════════════════════════════════════════════════╣
  ║ createIamRole             │ iam.Role                │ Method to create IAM Role for L2 constructs.             ║
  ╚═══════════════════════════╧═════════════════════════╧══════════════════════════════════════════════════════════╝
  */
  private createIamRole(
    scope: Construct,
    roleInfo: iamRoleInfo,
    managedPolicy?: iam.ManagedPolicy[]
  ): iam.Role {
    const iamRole = new iam.Role(scope, roleInfo.id, {
      roleName: roleInfo.roleName,
      description: roleInfo.description,
      assumedBy: new iam.ServicePrincipal(roleInfo.assumed),
    });
    if (roleInfo.awsManagedPolicyAdd && roleInfo.awsManagedPolicyName) {
      for (const amp of roleInfo.awsManagedPolicyName) {
        iamRole.addManagedPolicy(
          iam.ManagedPolicy.fromAwsManagedPolicyName(amp.policyName)
        );
      }
    }
    if (roleInfo.customManagedPolicyAdd && managedPolicy) {
      for (const cmp of managedPolicy) {
        iamRole.addManagedPolicy(cmp);
      }
    }
    for (const tag of roleInfo.tags) {
      cdk.Tags.of(iamRole).add(tag.key, tag.value);
    }
    return iamRole;
  }
}
