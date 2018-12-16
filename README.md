WIP :construction_worker:

This is a PoC for making existing [shoryuken](https://github.com/phstc/shoryuken) projects to work with Lambda Ruby using SQS as an event source.

The idea is to make Shoryuken Standard Workers and Active Job to work in a Lambda. The main test would be to see how a Lambda performs having to load a Rails environment.


```sh
cd rails_sample_app
docker run -v `pwd`:`pwd` -w `pwd` -i -t lambci/lambda:build-ruby2.5 bundle install --deployment --without development test
docker run -v `pwd`:`pwd` -w `pwd` -i -t lambci/lambda:build-ruby2.5 gem pristine --all
cd ..
# npm run build
cdk deploy
```
