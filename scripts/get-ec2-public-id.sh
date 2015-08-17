#!/usr/bin/env bash

AWS_REGION=${2:-us-west-2}
AWS_PROFILE=${3:-mycluster}
ASG=${1:-etcd}

EC2_IDS=$(aws --profile $AWS_PROFILE autoscaling describe-auto-scaling-groups \
        --region $AWS_REGION --auto-scaling-group-name $ASG \
    | jq .AutoScalingGroups[0].Instances[].InstanceId | xargs)

aws --profile $AWS_PROFILE ec2 describe-instances --region $AWS_REGION --instance-ids $EC2_IDS \
    | jq -r '.Reservations[].Instances | map(.NetworkInterfaces[].Association.PublicIp)[]'
