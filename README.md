# Grafonnet Devcontainer

This repo provides an easy way to develop [Grafana](https://grafana.com/) dashboards using [Grafonnet](https://github.com/grafana/grafonnet/).

With this, you'll able to code your dashboards and see the changes in real time in your local Grafana.

## Getting started

Before opening this repo, make sure that you have the [grafana docker container](https://hub.docker.com/r/grafana/grafana) running and the port of it is correctly set in `$GRAFANA_PORT`.

Next, you need to open this repository in the existing [devcontainer](https://code.visualstudio.com/docs/devcontainers/tutorial) in VSCode.

After the container has finished building, you are ready to start building your beautiful dashboards.

Dashboards are generally defined under `src/dashboards` and in `.jsonnet` files. Other content can be added via `.libsonnet` files.

## Publishing dashboards

To publish dashboards to your real Grafana instance, build them using the following command:

```bash
jsonnet -J "vendor" -o <dashboard-name.json> <path/to/dashboard.jsonnet>
```

Afterwards, just simply upload the JSON output into your Grafana and you're done!
