# Stch

## What

A simple shell based templating language kind of like mustache(5) and gomplate , etc but ~512 bytes vs ~30MB, only use this in containerized or restricted envs as the templating script will happily `rm -rf /*`.

## Why

All other templating languages were:

1. larger than the container I was deploying.
2. Too complicated for such a simple task.

## How

* `\`\`` is escaped
* `$[[:alpha:]_][[:alnum:]_]*` is escaped.
* `${var}` is not escaped and will do env replacement.
* `$()` is not escaped and will do command substitution.

## Example

```sh
$variables are not interpolated but ${variables} are,
$(echo "will execute a command") and ${ENV_VAR} will be subtituted.
```
