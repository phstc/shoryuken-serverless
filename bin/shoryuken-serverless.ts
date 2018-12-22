#!/usr/bin/env node
import sqs = require('@aws-cdk/aws-sqs')
import cdk = require('@aws-cdk/cdk')
import lambda = require('@aws-cdk/aws-lambda')
import { SqsEventSource } from '@aws-cdk/aws-lambda-event-sources'

class ShoryukenServerlessStack extends cdk.Stack {
  constructor(parent: cdk.App, name: string, props?: cdk.StackProps) {
    super(parent, name, props)

    const queueStandardWorkers = new sqs.Queue(this, 'ShoryukenStandardQueue', {
      visibilityTimeoutSec: 300
    })

    const queueActiveJob = new sqs.Queue(this, 'ShoryukenActiveJobQueue', {
      visibilityTimeoutSec: 300
    })

    const fn = new lambda.Function(this, 'MyFunction', {
      runtime: new lambda.Runtime('ruby2.5'),
      handler: 'lambda.handler',
      code: lambda.Code.asset('./rails_sample_app'),
      timeout: 60,
      environment: {
        QUEUE_STANDARD: queueStandardWorkers.queueName,
        QUEUE_ACTIVEJOB: queueActiveJob.queueName,
        RAILS_ENV: 'production'
      }
    })

    queueActiveJob.grantSendMessages(fn.role)

    fn.addEventSource(new SqsEventSource(queueStandardWorkers))
    fn.addEventSource(new SqsEventSource(queueActiveJob))
  }
}

const app = new cdk.App()

new ShoryukenServerlessStack(app, 'ShoryukenServerlessStack')

app.run()
