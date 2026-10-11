---
name: build-image
description: Prepare or execute one local Docker image build inside an explicit workspace. Dry-run is the default; Apply is required for the real build.
---

# build-image

## Inputs
Require a workspace, relative Dockerfile path, build context, and image tag.

## Workflow
1. Run `scripts/build.ps1` without `-Apply` and inspect the exact command.
2. Confirm Dockerfile and context remain inside the supplied workspace.
3. Use `-Apply` only when the caller authorized a local image build.
4. Return the Docker exit code and observed evidence. Do not push the image.

## Boundaries
No registry login, push, secret injection, remote builder creation, or container deletion. Paths must remain inside the workspace.
