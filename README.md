# Shoryuken Serverless

This is a PoC for making existing [Shoryuken](https://github.com/phstc/shoryuken) (Active Job or Standard workers) to work with [Lambda Ruby using SQS as an event source](https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html).

### Shoryuken Lambda

Check [this sample Lambda](https://github.com/phstc/shoryuken-serverless/blob/master/rails_sample_app/lambda.rb) for an example of Shoryuken compatible Lambda

It is important to load Rails outside the method `handler` so that it gets "cached" while your Lambda (container) is still hot.

#### Lambdas vs Queues

The number of Lambdas or queues is entirely up to you. You can use multiple queues and Lambdas - it is all up-to-you.

### Deploy your Lambdas

For deploying your Ruby Lambdas, you need to vendorize your gems with the same container Ruby Lambdas run.

```sh
docker run -v `pwd`:`pwd` -w `pwd` -i -t lambci/lambda:build-ruby2.5 bundle install --deployment --without development test
docker run -v `pwd`:`pwd` -w `pwd` -i -t lambci/lambda:build-ruby2.5 gem pristine --all
```
#### Deploy with aws-cdk

This sample app uses [aws-cdk](https://github.com/awslabs/aws-cdk) for making it easy to create stacks and deploy Lambda.

For deploying your stack using this sample project, you can run the commands below (or `./deploy.sh`).

```sh
(
  cd rails_sample_app
  docker run -v `pwd`:`pwd` -w `pwd` -i -t lambci/lambda:build-ruby2.5 bundle install --deployment --without development test
  docker run -v `pwd`:`pwd` -w `pwd` -i -t lambci/lambda:build-ruby2.5 gem pristine --all
)
npm run build
cdk deploy
```
