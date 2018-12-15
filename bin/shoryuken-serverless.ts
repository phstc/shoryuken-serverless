#!/usr/bin/env node
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

    const fn = new lambda.Function(this, 'MyFunction', {
      runtime: new lambda.Runtime('ruby2.5'),
      handler: 'lambda.handler',
      code: lambda.Code.asset('./rails_sample_app')
    })

    queue.grantSendMessages(fn.role)

    fn.addEventSource(new SqsEventSource(queue))
  }
}

const app = new cdk.App()

new ShoryukenServerlessStack(app, 'ShoryukenServerlessStack')

app.run()
