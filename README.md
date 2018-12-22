# Shoryuken Serverless

This is a PoC for making existing [Shoryuken](https://github.com/phstc/shoryuken) (Active Job or Standard workers) to work with Lambda Ruby using SQS as an event source.

The code below is pretty much what you need in your Lambda for make it work with Shoryuken Standard workers or Active Job.

### Shoryuken Lambda

See https://github.com/phstc/shoryuken-serverless/blob/master/rails_sample_app/lambda.rb

It is important to load Rails outside the method `handler`, so that it gets "cached" while your Lambda (container) is still hot.

With that, you can send and consume messages with your existing workers.

#### Lambdas vs Queues

The number of Lambdas or queues is totally up to you. Shoryuken Serverless work in the same way a regular Shoryuken worker. You can use multiple queues, multiple Lambdas - it is all up-to-you.

### Deploy your Lambdas

For deploying your Ruby Lambdas you need to vendorize your gems with the same container Ruby Lambdas run.

```sh
docker run -v `pwd`:`pwd` -w `pwd` -i -t lambci/lambda:build-ruby2.5 bundle install --deployment --without development test
docker run -v `pwd`:`pwd` -w `pwd` -i -t lambci/lambda:build-ruby2.5 gem pristine --all
```
#### Deploy with aws-cdk

```sh
(
  cd rails_sample_app
  docker run -v `pwd`:`pwd` -w `pwd` -i -t lambci/lambda:build-ruby2.5 bundle install --deployment --without development test
  docker run -v `pwd`:`pwd` -w `pwd` -i -t lambci/lambda:build-ruby2.5 gem pristine --all
)
npm run build
cdk deploy
```
