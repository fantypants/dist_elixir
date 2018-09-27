# DistElixir
## Usage

```bash
iex --name a@127.0.0.1 -S mix
iex --name b@127.0.0.1 -S mix
iex --name c@127.0.0.1 -S mix
```

* The following will spin through up-to 3 workers specified in the config file
* The workers checks the port upon each change of ownership and then uses the Plug to correctly send the request to the browser.
* For testing the process kill them selves and recreate them selves simulating consistent crashes for the VM
