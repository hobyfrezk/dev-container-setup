# Dev container for my dev environment

This directory contains the configuration for my dev container. It is based on the Coder self-hosted container. 

The following diagram shows the architecture of the dev container. Since I want to persist my data on my NAS, I have to mount a volume in the container. This volume is mounted from NAS on the CoderServer container. The CoderServercan be userd to host multiple workspaces. 
```mermaid
flowchart LR
  subgraph LAN
    direction LR
    subgraph WindowsWSL
      CoderServer
      MountVolume
    end
    NASSMBServer
  end

  WorkSpace1 --> CoderServer
  WorkSpace2 --> CoderServer
  WorkSpace3 --> CoderServer
  CoderServer <.-> MountVolume
  NASSMBServer --> MountVolume ```

Here is some trick it needs to make it possible:
1. In order to make the workspace can use the volume normally, the user of the workspaces has to have same username and uid as the ownership of the volume. and the mounted volume would have same ownership as on its host, docker would simply inherit them. So i have to first create a user with the same username and uid inside WSL and mount the SMB volume with that user. 
2. I used the following command to configure the host(WSL), and by the way it's Arch Distros :)
```bash
# use super user to configure the WSL system
sudo su
# it has to be 1001 because the default user in the workspace would have uid 1001, and they has to be the same
useradd -m chongshun -u 1001
usermod -aG wheel chongshun

mkdir /mnt/z
chown chongshun:chongshun /mnt/z

mount -t cifs -o user=${nas_username},pass=${nas_password},$(echo uid=1001) //${NAS_IP}/${folder_name} /mnt/z
```

Also for automatically get authenticated with Github, according to the [Documentation](https://coder.com/docs/admin/auth#github), I need to add following enviornment variables to WSL

```bash
CODER_OAUTH2_GITHUB_ALLOW_SIGNUPS=true
CODER_OAUTH2_GITHUB_ALLOWED_ORGS="your-org"
CODER_OAUTH2_GITHUB_CLIENT_ID="8d1...e05"
CODER_OAUTH2_GITHUB_CLIENT_SECRET="57ebc9...02c24c"
```