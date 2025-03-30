# learn-sentinel

## Install
<https://developer.hashicorp.com/sentinel>

```shell
% sentinel version
Sentinel v0.30.0
```

## hello world

```shell
# Configuration files of Sentinel CLI
% touch sentinel.hcl

# Your first policy files
% touch hello.sentinel
```

## sentinel CLI

```shell
% sentinel --help
Usage: sentinel [--version] [--help] <command> [<args>]

Available commands are:
    apply      Execute a policy and output the result
    fmt        Format Sentinel policy to a canonical format
    test       Test policies
    version    Prints the Sentinel runtime version
```

Note that `sentinel.hcl` will NOT be evaluated when you specify the policy file.

```shell
# read sentinel.hcl and executed all *.sentinel configured in sentinel.hcl
% sentinel apply
Pass - hello_world_sentinel.sentinel

# sentinel.hcl will NOT be evaluated, so the prompt will be poped up for required param
% sentinel apply ./hello.sentinel
hello_world_sentinel.sentinel:5:7: requires value for parameter your_string
  variables (inputs)
https://developer.hashicorp.com/sentinel/docs/language/parameters

  Values can be strings, floats, or JSON array or object values. To force
  strings, use quotes.

  Enter a value:
# ...

# supply values for parameters from CLI flags or envar
% sentinel apply -param "your_string=hello, sentinel"
Pass - hello_world_sentinel.sentinel

% SENTINEL_PARAM_your_string="hello, sentinel" sentinel apply
Pass - hello_world_sentinel.sentinel

# debug (when policy evaluation fails, the debug output will be automatically shown in console)
% sentinel apply -trace hello.sentinel
# ...
```
