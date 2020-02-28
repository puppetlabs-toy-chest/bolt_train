# Control Bolt train with Bolt

This module contains bolt tasks and plans for building a control route for the Bolt Train.

## Example
The following example shows how to compose the `bolt_train` module content to build and submit a route for the train.

The first step is to download the module. Create a new [bolt project](https://puppet.com/docs/bolt/latest/bolt_project_directories.html) and add the following `Puppetfile` to the bolt project (note I will simply add an empty `bolt.yaml` in my example directory. 

```
# Puppetfile
mod 'bolt_train',
  :git => 'https://github.com/puppetlabs/bolt_train'  
```
Next, create an [inventoryfile](https://puppet.com/docs/bolt/latest/inventory_file_v2.html) with a remote target configured to connect to the bolt-train-api server.

```yaml
# inventory.yaml
version: 2
targets:
  - name: bolt-train
    config:
      transport: remote
      remote:
        train_api_url: https://localhost:5000
```
Now create a plan that composes the tasks and plans in the bolt_spec module:
```puppet
# myplan.pp
steps:
  - name: session_token
    description: Obtaining BoltTrain token with bolt_train::session_token plan.
    plan: bolt_train::session_token
    parameters:
      email: cas.donoghue@puppet.com
      targets: bolt-train
  - name: forward
    description: Move train forward with the bolt_train::move task. 
    task: bolt_train::move
    target: bolt-train
    parameters:
      token: $session_token
      direction: forward
      speed: 10
      time: 15
  - name: run
    description: Deploy my plan to the train!
    task: bolt_train::run
    target: bolt-train
    parameters:
      token: $session_token
```
The first step is to request a session token. This is accomplished by using the `bolt_train::session_token` plan. That plan will use the `bolt_train::session` task to request a session token, parse the result and return the parsed token. Next the `bolt_train::move` task is used to make the train move forward. Any number of move steps can be added next. Finally the plan has a step to call the `bolt_train::run` task which will finalize the route and submit to the bolt train executor.

Now that the files are in place download the train module with `bolt puppetfile install` which will add the `modules` directory with the `bolt_train` module. The final directory structure should look like:
```
cas@cas-ThinkPad-T460p:~/working_dir/bolt_train_example$ tree
.
├── bolt.yaml
├── inventory.yaml
├── modules
│   └── bolt_train
│       ├── lib
│       │   └── request_helper.rb
│       ├── plans
│       │   └── session_token.pp
│       └── tasks
│           ├── move.json
│           ├── move.rb
│           ├── run.json
│           ├── run.rb
│           ├── session.json
│           └── session.rb
├── Puppetfile
└── site-modules
    └── train_route
        └── plans
            └── myplan.yaml

8 directories, 12 files
```
## Run the example plan
```
cas@cas-ThinkPad-T460p:~/working_dir/bolt_train_example$ bolt plan run train_route::myplan
Starting: plan train_route::myplan
Starting: plan bolt_train::session_token
Starting: task bolt_train::session on bolt-train
Finished: task bolt_train::session with 0 failures in 0.23 sec
Finished: plan bolt_train::session_token in 0.23 sec
Starting: Move train forward with the bolt_train::move task. on bolt-train
Finished: Move train forward with the bolt_train::move task. with 0 failures in 0.23 sec
Starting: Deploy my plan to the train! on bolt-train
Finished: Deploy my plan to the train! with 0 failures in 0.22 sec
Finished: plan train_route::myplan in 0.69 sec
Plan completed successfully with no result
```

## Compose your own plans and extend the tasks!
