WIP :construction_worker:

This is a PoC for making existing [shoryuken](https://github.com/phstc/shoryuken) projects to work with Lambda Ruby using SQS as an event source.

The idea is to make Shoryuken Standard Workers and ActiveJob to work in a Lambda. The main test would be to see how a Lambda performs having to load a Rails environment.

* This project uses aws-cdk for setting the a stack in AWS
* For deploying you need to `bundle install --deployment` for vendorizing the gems (AWS does not bundle install)
* Deploy command `cdk deploy`