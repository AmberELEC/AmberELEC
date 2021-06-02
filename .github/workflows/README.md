# Build Overview
The build server is a single server with SSD disks.  It runs two self-hosted Github action runners to perform builds. Conceptually, this is pretty much like using free GitHub actions except we register our own server to run the build as GitHub actions and other free options are too small to run the 351ELEC build.

**Runners**
- One runner for main. Driven by [build-main.yaml](build-main.yaml)
  - An 'incremental' build (no `make clean`) is run on every commit to `main`.
  - If a 'full' build is required.  `make clean` can be run manually by 351ELEC admins.  Driven by: [clean-main.yaml](docs/clean-main.yaml)
- One runner for PR's. Driven by [build-pr.yaml](build-pr.yaml)
  - An 'incremental' build (no `make clean`) is run on every PR which: 1. Has requested reviewers OR 2. Is from a 351ELEC branch.  
    - Limiting the PRs built is done for security to ensure randomly submitted PRs are not built without some level of review (only 351ELEC admins are allowed to request reviewers)
  - If a 'full' PR build is required `make clean` can be run manually by 351ELEC admins for the PR builder.  Driven by: [clean-pr.yaml](docs/clean-pr.yaml)

This two-runner design is to ensure that 'main' builds are not clogged up by random PR pushes, etc.  

**NOTE**: Only a single build will be queued for a given PR or main at a time.

### Dev Artifacts
The 'main' branch publishes `.img.gz` and `.tar` updates for every build.  They are split into two packages, one for RG351P and RG351P.  
Unfortunately, GitHub actions currently has a limitation that all artifacts must be zipped.  This means that the .tar.gz and .tar file will be inside a zip. 
This is primarily a UI limitation and may be addressed in the future as the artifacts are stored separately and the zip is dynamically created. 
See: https://github.com/actions/upload-artifact#zipped-artifact-downloads

PR's currently only publish `.tar` updates as fresh flashing from the `.img.gz` is not typically needed.  This is just
done to speed up PR builds.

# Hosting Options and Alternatives
It is not ideal to require a non-free build system for an open source project.  However, at this time, it appears to 
be the only realistic option due to the large build size (~160GB) combined with the long duration for full builds (~5 hours)

See: [Hosting Options](docs/hosting-options.md) for more details on why the current design (single server) along with
GitHub actions was chosen.

# Build Server Setup
Due to requiring a build server - as opposed to cloud/hosted options - it is imporant to ensure that 
the build server itself can be easily swapped out for another server.  The following documents how to create a new build server.

See: [Build Server Setup](docs/build-server-setup.md) for more details on provisioning the build server and configuring GitHub.

# Troubleshooting Build Server issues
If builds aren't working correctly and you have permissions to 351ELEC GitHub and/or the build server, see: [Build Server Troubleshooting](docs/build-server-troubleshooting.md)
