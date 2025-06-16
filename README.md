# Flu Dashboard

The {flu.dashboard} R package contains:

- A Shiny application for viewing the information provided in the application.

For information about the content and purpose of the application, read the file at [_inst/about/about_main.md_](inst/about/about_main.md).

A version of this app is deployed to [gallery-flu.jmpr.io](https://gallery-flu.jmpr.io/).
You can also view some of the other apps, dashboards and widgets from Jumping Rivers in our [gallery](https://www.jumpingrivers.com/data-science/gallery/).

## Environment variables

The app stores data using pins.
The current pin location used in the code is for a Posit Connect server.
If this is where your pins will be stored, you'll need to [create an API key](https://docs.posit.co/connect/user/api-keys/#api-keys-creating), or know what your existing one is.

Then you'll need to add these details to an _.Renviron_ file, which contains the following details:

```
CONNECT_SERVER=https://your.connect.server
CONNECT_API_KEY=AbCdE123456f
```

Replacing the placeholders with the value for your server address and API key.

## For application users

To install the application, use:

```r
remotes::install_github("jumpingrivers/flu.dashboard")
```

With any necessary [environment variables](#environment-variables) set to connect to the data sources through {pins}, you can start the Shiny application using:

```r
flu.dashboard::run()
```

## For application developers

### Restoring {renv}

If you are forking the repository to develop, note this uses {renv} to manage R package dependencies.
To install the R packages from the {renv} lockfile, run `renv::restore()` or read [documentation from the {renv} website](https://rstudio.github.io/renv/#workflow).

### Running the application

From the root directory of the repository, you can start the application in the normal way for a Shiny application.

```r
shiny::runApp()
```

### Deploying the application

1. If you have introduced or updated packages for the application, update the {renv} lockfile

    ```r
    renv::snapshot(dev = TRUE)
    ```

1. If performing a git-backed deployment from Posit Connect, update the _manifest.json_ file:

    ```r
    rsconnect::write_manifest()
    ```

1. Deploy to your hosting service from the *app.R* file at the root of the repository, or allow Posit Connect's git-backed deployment to perform the deployment and automatically check for updates to the manifest.json file by pushing changes to the git repository.

## Authors and acknowledgment

This has been created by the Data Science team at Jumping Rivers.
You can get in touch with us at [hello@jumpingrivers.com](mailto:hello@jumpingrivers.com).

We'd like to thank Andy McCann and the DS Team within NUCT at NHS ML who created the original inspiration inspiration for this app with their ['flu-tracker Shiny application](https://nhsml-nuct.shinyapps.io/NationalFlu/) ([source code](https://github.com/MLCSU/NationalFlu)).

## License

This R package has a [GNU GPL v3 license](LICENSE.md).
