#!/usr/bin/env node
import sns = require('@aws-cdk/aws-sns')
import sqs = require('@aws-cdk/aws-sqs')
import cdk = require('@aws-cdk/cdk')
import lambda = require('@aws-cdk/aws-lambda')
import { SqsEventSource } from '@aws-cdk/aws-lambda-event-sources'

class ShoryukenServerlessStack extends cdk.Stack {
  constructor(parent: cdk.App, name: string, props?: cdk.StackProps) {
    super(parent, name, props)

    const queue = new sqs.Queue(this, 'ShoryukenServerlessQueue', {
      visibilityTimeoutSec: 300
    })

    const topic = new sns.Topic(this, 'ShoryukenServerlessTopic')

    topic.subscribeQueue(queue)

    const fn = new lambda.Function(this, 'MyFunction', {
      runtime: lambda.Runtime.NodeJS810,
      handler: 'index.handler',
      code: lambda.Code.asset('./lambda-handler')
    })

    fn.addEventSource(new SqsEventSource(queue))
  }
}

const app = new cdk.App()

new ShoryukenServerlessStack(app, 'ShoryukenServerlessStack')

app.run()
