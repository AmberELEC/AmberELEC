
## Overview
If you do not have write access to GitHub 351ELEC org or to the build server itself, this page will not help you as you won't have permissions to perform these actions.

### Build Server Overview
The build server is Ubuntu 20.04 machine setup for running builds.  It has two separate Github Action Runners register for `main` and `pr` builds.

Access to the server is given manually and is reserved for administrators of the 351ELEC project.

**Users**: 
- `cloud-user` - the administrator user - if you need to use `sudo` you will need to login here.  You can use `sudo` to switch to the root user (`sudo su - build`)
- `build` - the user which runs the builds - if you just need access to the build troubleshooting, use this.

**Directories**:
- `/var/runner` - The directory for the `main` builder.  Github Action registration/start/stop is done from here.
  - `/var/runner/_work/351ELEC/351ELEC` - is the git checkout for the `main` builder
- `/var/runner-pr` - The directory for the `pr` builder.  Github Action registration/start/stop is done from here.
  - `/var/runner-pr/_work/351ELEC/351ELEC` - is the git checkout for the `pr` builder
  

### GitHub Troubleshooting Steps

#### GitHub -Make Clean for main/PR
- A change to a PR or main requires a `make clean` (or perhaps deleting some folders) in order to run successfully. The only options within github is `make clean`.  
  - You can run `make clean` for either the PR or main builds by going to 351ELEC in Github -> `Actions` -> `Clean PR` (or `Clean Main`) -> `Run Workflow` (dropdown) -> `Run Workflow` (button)
  - After it is done you will likely want to retrigger `main` or go into the failed PR action and select `Rerun Jobs`.  It will take roughly 5 or 6 hours.

### GitHub - Cancelling in Progress Builds
- The UI for actions allows cancelling builds if you have write permissions in GitHub.  Sometimes, it is helpful to issue the cancel commmand two times to ensure full cancellation (similar to hitting ctrl-c twice).

### Build Server Troubleshooting Steps

#### Build Server - Make Clean for main/PR
- You can also run a `make docker-clean` or any other commands to remove certain directories by going into `/var/runner/_work/351ELEC/351ELEC` or `/var/runner-pr/_work/351ELEC/351ELEC` and running whatever commands you want
 - You probably want to ensure no other builds are running

#### Build Server - Disable Builds Temporarily (requires sudo)
Sometimes you need to disable builds because they are hanging or other manual commands are needed (run a custom build manually, etc).

You can disable the GitHub runner for main like this:
```
cd /var/runner/ && sudo ./svc stop
```
And for PRs like this:
```
cd /var/runner-pr/ && sudo ./svc stop
```

To renable:
```
cd /var/runner/ && sudo ./svc start
```
And for PRs like this:
```
cd /var/runner-pr/ && sudo ./svc start
```

#### Manually registering the GitHub Action Runners
If you are attempting to deploy a new build server (or repair a totally broken one) and can't use cloud-init or the cloud-init failed, you can manually register the server with GitHub.

You can `force delete` any existing runners you don't want from the GitHub UI under `Settings` -> `Actions` -> `Runners` -> `...` (Dropdown by each runner) -> `Delete` 

In general, to add a new runner, you can follow the instructions from: https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners# but customized the `./config.sh` command should look like as follows:


- For Main builder 
  - cd into `/var/runner` and setup GitHub runner there if it isn't already (`mkdir -p /var/runner/ && chown -R build:build /var/runner` if it doesn't exist)
  - `sudo runuser -l build -c "/var/runner/config.sh  --url https://github.com/351ELEC/351ELEC --token <get this from 'Add Runner' popup in GitHub> --unattended --name build-server --labels main"`
    - NOTE: The `runuser` command just runs the command as the `build` user. You can just login or `sudo su - build` to run the config.sh command.
    - If the action runner was already registered, you may need to run `sudo ./svc.sh stop` and `sudo ./svc.sh uninstall` first.
  - Register each runner with: `sudo ./svc install build` (`build` is the user builds will be run as).
  - See the [cloud-init](build-server-setup.md) for exactly what is done for deployment.
- For PR builder - follow the above steps with `/var/runner-pr` instead of `/var/runner` and `build-server-pr` instead of `build-server`

