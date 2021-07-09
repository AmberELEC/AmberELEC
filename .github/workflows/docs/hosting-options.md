# Hosting Options - Summary
All known free options for a build server will not currently
work due to build size (~160GB), full build length (~5+ hours) and 
CPU requirements (4+ cpus needed for full build).  This means self-hosting of at least the build 'runner' is required.

Self-hosting of the runner could be done dynamically in the cloud (AWS, GCP, Azure, etc) or statically via a traditional 'build server'.  Due to the size of build (and complexity of caching it), CPU requirements and additional 'hidden' costs (*AWS* - we are looking at your 9 cents per GB outbound traffic costs) it was determined that a traditional build server is the way to go.  A static build server also allows the build server to be swapped out more easily than with full cloud integration and it is easier to debug without in-depth cloud knowledge.

For the 'Build System' (Circleci, Travisci, Jenkins, Github Actions) only Github actions meets the needs of being hosted and allowing self-hosted runners in the free plan.  If Github actions is found to be too painful, Jenkins or other self-hosted build systems should be more seriously evaluated.

The research/evaluation was done in June 2021 and may need to be re-evaluated in the future.

# Build Overview
Here is the information about what is needed to build 351ELEC for RG351P and RG351V.
- **Disk space** - After a build of both RG351P/V, the build directory takes up about 140GB.  Within that, the breakdown is roughly:
  - **RG351P**
    - **build - ARM (32-bit)** - 16GB
    - **build - AARCH (64-bit)** - 46GB
  - **RG351P**
    - **build - ARM (32-bit)** - 16GB
    - **build - AARCH (64-bit)** - 46GB
  - **Sources** - 13GB
  - **Releases (artifacts)** - 2-3GB
     - **RG351P** 
       - tar - 719MB
       - img.gz - 645MB
     - **RG351V** 
       - tar - 720MB
       - img.gz - 645MB
  - **Notes**: Though not required, the number of small files makes deleting/moving/updating/concurrent builds much faster with SSDs.
- **CPU** - technically, you could build with 1 CPU, but it will take forever - see *Time* below.  At least 4 CPUs are recommended.  After the initial build, it would likely be possible to run incremental builds (no `make clean`) with only 1/2 CPUs.
- **Time** - a 6 CPU (12 cores - AMD) takes about 5-6 hours to build both RG351P and RG351V (roughly 2.5-3 hours for P and V)
- **RAM** - Typically RAM is not an issue given most systems come with a lot of RAM to meet the CPU requirements.  8GB works fine.  Less would probably work, but has not been tested.

# Hosted Build Runners
Build runners are the actual *hosts* that run the builds.  Typically, free runners are bundled with hosted build systems (listed below).  Basically, the large disk and CPU requiremnts of the build mean that no free runners will work for 351ELEC.  **NOTE**: the full **build systems** (not just hosted runners) are evaluated in a later section.

- **Github Actions** (https://github.com/pricing and https://docs.github.com/en/billing/managing-billing-for-github-actions/about-billing-for-github-actions and https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#:~:text=14%20GB%20of%20RAM%20memory,GB%20of%20SSD%20disk%20space)
  - **CPU** - 2
  - **RAM** - 7GB
  - **Disk** - 14GB
  - **Free Plan**:
    - For public repositories
      - Unlimited automation minutes per month
  - **Summary**: Disk is too small for 351ELEC builds.

- **Circle CI**
  - **Max build time**: 5 hours
  - **Max disk**: 50GB
  - **Free plan** (https://circleci.com/docs/2.0/credits/#free-plan):
    - 2500 credits per week
    - Offers medium docker image (2 CPUs, 4gb of memory) at 10 credits per minute.  That is about 4 hours of free builds per week.
  - **Summary** - 4 hours of builds a week is not likely enough as it couldn't even run a single full build with only 2 CPUs.  However, this is likely the closest free builder that could almost work.  Perhaps with some paid credits for the initial build (and if build was cached) and maybe if disk size was increased, this *maybe* could work.

- **Travis CI**
    - See: https://docs.travis-ci.com/user/reference/overview/
    - **Max build time**: 50 minutes
    - **Max disk space**: ~50GB. 
    - **Summary** - 351ELEC's build time and disk usage is too large to use free plan.

- **Appveyor**
  - Disk: 7GB (https://help.appveyor.com/discussions/problems/24408-not-enough-disk-sapce)
  - **Summary** 351ELEC's disk usage is too large to use free plan.

# Build Systems
A build system is the 'framework' the builds run with.  Oftentimes, a build system will provide a 'runner' (which actually runs the build) which is listed separately in the section above.  Build systems which require self-hosting weren't really evaluated (Jenkins) as taking on the additional complexity doesn't make sense unless free options don't work.  **Summary** - Only Github Actions + self hosted runners is a viable option due to size/build length limitations of 351ELEC.

- **Github Actions**
  - Max build time - 72 hours
  - Max queue time - 24 hours
  - Simultaneous builds: 20
  - Artifact hosting
    - Storage 
      - Size - Free and unlimited for open source projects for both logs and build artifacts
      - Duration - 30 days by default - up to 90 days
  - *Pros*
    - Free and hosted
    - By far the most build time, queue time, storage and max runners for a free system
    - Tight integration with GitHub (which we already use)
    - Very flexible - allows configuring it to do almost anything
  - *Cons*
    - Build interface lacks some features.
      - All artifacts must be zipped, which means the `tar` and `img.gz` are double packaged.  This is apparently just a UI limitation and may be fixed in the future.
      - When a build breaks, it doesn't show the last lines (instead showing the first) and forces you to download a zip of the logs
  - **Summary** - Github actions with self-hosted runners provide a pretty solid option for the framework builds to run in.  It has some issues in the interface, but isn't bad and may ultimately be the only free build system that will work.

- **Appveyor**
  - Max build time - 1 hour
  - Concurrent jobs
    - Self hosted - 5
    - Integrated - 1
   - **Summary** - Appveyor's 1 hour limit for all jobs means it would not work for full builds.

- **Circle CI**
  - Concurrent jobs - 1
  - Max build time - 5 hours
  - **Summary** - Self hosted runners requires paid plan - not seriously evaluated due to free runner limitations.
  
- **Travis CI**
  - **Summary** - Self hosted runners require paid plan - not seriously evaluated due to free runner limitations.

- **Jenkins** - requires self-hosting - not seriously evaluated due to extra complexity of hosting it.
- **Gitlab** - no easy integration with github (as they obviously promote gitlab) - not seriously evaluated.


# Self Hosted Runners
As there is no hosted/free option for a 'build runner' suitable for 351ELEC, we need to look at paid options.  The two major categories of server are 'dynamic' (cloud-based) and 'static' (server based).

## Dynamic Self Hosted Runners
Extensive evaluation of AWS was done along with Github Runners to dynamically spin up Spot Instances (saves cost), register them as temporary github runners and cache the build environment in S3 build and deregister.  This ultimately got costs for a full build down to about $2 USD per full build and 20-30 cents for an incremental build.  The usage of spot instances was found to make the high CPU costs cheaper than other cloud providers such as Digital Ocean and Google Cloud, however, the data transfer costs (next section) do prove prohibitive.

However, AWS $0.09 per GB to send data *out* of AWS (almost all of the cost of incremental builds) along with instances which may have been errored (and not shut down, etc) make the ultimate cost highly variable.  Additionally, it is difficult to troubleshoot and vendor lock-in is a real problem.  If the current donor of build system decides to stop paying, there is no easy way to swap providers to something other than AWS.

## Static Self Hosted Runners
No extensive evaluation on the best place to get a static server has been done.  The current donator has connections with Ionos (https://www.ionos.com/) to get a good deal on a dedicated AMD SSD server.  If the build server needs to be swapped to another provider, more extensive evaluation should be done at that point.  See the [build server setup](./build-server-setup.md) page for information about how a new server could be deployed.

The most important design point in using a single build server is that no *state* (other than the old build directory) is stored on the server.  Instead, all logs, artifacts, etc are stored in the build system.
