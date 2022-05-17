# Why?
We have serious issues with M1 Apples running kubebuilder tests.

# TL;DR
```
cd ~/workspace/external-secrets/eso-infrastructure/lima
./run.sh
```

# Jump into a default lima instance
just `lima` (ie in your VSCode terminal)

If you run multiple lima VMs you might wish to change an instance name, to ie `eso` via `LIMA_VM_NAME` var (in `run.sh`)
Then `limactl shell < your-vm-name >`
