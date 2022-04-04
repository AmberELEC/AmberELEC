# Build Overview
The build server is a single server with solid state disks (SSDs).  It runs two self-hosted Github action runners to perform builds. Conceptually, this is like using free GitHub actions except we register our own server to run the build. Using self-hosted runners is required as all known free options to run builds are too small (typically in disk size) to run the AmberELEC build.

A major advantage of using GitHub actions with a self hosted server - as opposed to a full self hosted build system like Jenkins - is that the server is effectively stateless. Build folders are cached, but can easily be rebuilt, making it easy to replace the server.

**Runners**
- **main** Driven by [build-main.yaml](build-main.yaml)
  - **Logic**: An 'incremental' build (no `make clean`) is run on every commit to `main`.  All *build.* directories are saved between builds.
  - If a 'full' build is required.  `make clean` can be run manually by AmberELEC admins via the Github UI.  Driven by: [clean-main.yaml](docs/clean-main.yaml)
- **Pull Requests**. Driven by [build-pr.yaml](build-pr.yaml)
  - **Logic**: An 'incremental' build (no `make clean`) is run on every PR which is from a previous committer. 
    - Limiting the PRs built is done for security to ensure randomly submitted PRs are not built without some level of review (only AmberELEC admins are allowed to request reviewers)
  - If a 'full' PR build is required `make clean` can be run manually by AmberELEC admins for the PR builder.  Driven by: [clean-pr.yaml](docs/clean-pr.yaml)

This two-runner design is to ensure that 'main' builds are not clogged up by random PR pushes, etc.  

**NOTE**: Only a single build will be queued for a given PR or main at a time.

### Dev Artifacts
The 'main' branch publishes `.img.gz` and `.tar` updates for every build.  They are split into two packages, one for RG351P and another RG351V.  
Unfortunately, GitHub actions currently has a limitation that all artifacts must be zipped.  This means that the .tar.gz and .tar file will be inside a zip. 
This is primarily a GitHub UI limitation and may be addressed in the future as artifacts are stored separately and the zip is dynamically created. 
See: https://github.com/actions/upload-artifact#zipped-artifact-downloads

PR's currently only publish `.tar` updates as fresh flashing from the `.img.gz` is not typically needed.  This is just
done to speed up PR builds.

# Hosting Options and Alternatives
It is not ideal to require a non-free build system for an open source project.  However, at this time, it appears to 
be the only realistic option due to the large build size (~160GB) combined with the long duration for full builds (~5 hours).

See: [Hosting Options](docs/hosting-options.md) for more details on why the current design (single server) along with
GitHub actions was chosen.

# Build Server Setup
Due to requiring a build server - as opposed to cloud/hosted options - it is imporant to ensure that 
the build server itself can be easily swapped out for another server.  The following link documents how to create a new build server.

See: [Build Server Setup](docs/build-server-setup.md) for more details on provisioning the build server and configuring GitHub.

# Troubleshooting Build Server issues
If builds aren't working correctly and you have permissions to AmberELEC GitHub and/or the build server, see: [Build Server Troubleshooting](docs/build-server-troubleshooting.md)
