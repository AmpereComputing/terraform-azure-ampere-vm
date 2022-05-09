# Recording

Run the following command to record the video assets


```
asciinema rec assets/AmpereAzureVMs.cast --title='Ampere Azure VMs' --command='terraform init && terraform plan && terraform apply -auto-approve && terraform show' --overwrite
```
# To convert 
docker pull asciinema/asciicast2gif
docker run --rm -v $PWD:/data asciinema/asciicast2gif -s 2 -t solarized-dark demo.json demo.gif
# To convert 
ffmpeg -i AmpereAzureVMs.gif -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" video.mp4
docker run --rm -it -v $(pwd):/config linuxserver/ffmpeg -i AmpereAzureVMs.gif -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" video.mp4
# Resources 
* [https://unix.stackexchange.com/questions/40638/how-to-do-i-convert-an-animated-gif-to-an-mp4-or-mv4-on-the-command-line] (https://unix.stackexchange.com/questions/40638/how-to-do-i-convert-an-animated-gif-to-an-mp4-or-mv4-on-the-command-line)
* [http://rigor.com/blog/2015/12/optimizing-animated-gifs-with-html5-video][(http://rigor.com/blog/2015/12/optimizing-animated-gifs-with-html5-video
* [https://github.com/asciinema/asciicast2gif/](https://github.com/asciinema/asciicast2gif/)
