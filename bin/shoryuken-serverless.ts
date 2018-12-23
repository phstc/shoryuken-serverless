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

    // batchSize defaults to 10, if you use > 1, your Lambda needs to be able to process in parallel,
    // otherwise, if your messages take 1 minute to be processed, the last one will take up to 10 minutes to start being processed
    fn.addEventSource(new SqsEventSource(queueStandardWorkers, { batchSize: 1 }))
    fn.addEventSource(new SqsEventSource(queueActiveJob, { batchSize: 1 }))
  }
}

const app = new cdk.App()

new ShoryukenServerlessStack(app, 'ShoryukenServerlessStack')

app.run()
