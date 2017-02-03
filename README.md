Percy.io  + Capyara + Selenium to test static files <3
========================================================

A minimal example to test one file `example.html`, that has javascript on it.

## Steps
0. You have some static files you want to test.
1. Capyara start to run the two tests we have in `example_spec.rb`
2. Selenium executes all the hardpart as JS
3. Percy takes screenshots and sends it to percy.io for visual regression.

##prerequisite
Ruby installed, I needed version 2.4.

## Setup

execute  `setup.sh`


## Configure

Set your PERCY_TOKEN  and PERCY_PROJECT variables so their are part of your env.var.

e.g
```
export PERCY_TOKEN="....."
export PERCY_PROJECT="....."
```

## Run

execute  `run.sh`

now the test should execute and you should be uploading 3 visual diffs to percy.io
