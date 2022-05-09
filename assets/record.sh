#!/usr/bin/env bash

#docker run --rm -ti -v "$HOME/.config/asciinema":/root/.config/asciinema asciinema/asciinema rec assets/AmpereAzureVMs.cast --title='Ampere Azure VMs' --command='terraform init && terraform plan && terraform apply -auto-approve && sleep 10' --overwrite
docker run --rm -v $PWD:/data asciinema/asciicast2gif -t solarized-dark AmpereAzureVMs.cast AmpereAzureVMs.gif
sleep 10
docker run --rm -it -v $(pwd):/config linuxserver/ffmpeg -i /config/AmpereAzureVMs.gif -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" /config/AmpereAzureVMs.mp4
