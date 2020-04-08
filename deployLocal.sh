#!/bin/bash

TAG_NAME=$(<LOCAL)
COMPUTER_NAME=$(cat /proc/sys/kernel/hostname)

if [ $COMPUTER_NAME = "maso97" ]; then
    ./deploy.sh 4B12F965799E4FCF9399 mQtNkKMTmjtF4rNH5AEF239ebcbH3tawx1Dc5C3c http://localhost:8080/v2-beta/projects/1a5 lcl
elif [ $COMPUTER_NAME = "maso89" ]; then
    ./deploy.sh 0C0636EC95524674AABF YVLbqbL14gcq2yQPJvbwz3MeJK5UAWNgKoYe9UCL http://localhost:8080/v2-beta/projects/1a5 lcl
elif [ $COMPUTER_NAME = "maso71" ]; then
    ./deploy.sh 389DF31EAD49512C006F BKz8WH8n7rR37vpXKfCSZTKrAqY6TLQ5BS6eKCA6 http://localhost:8080/v2-beta/projects/1a5 lcl    
elif [ $COMPUTER_NAME = "maso86" ]; then
    ./deploy.sh  9842480944A9D72541B6 XV4q4nTtrScVXMcQtVbuCtZnznU5Tu1ikKdu9dyR http://localhost:8080/v2-beta/projects/1a5 lcl
else
    ./deploy.sh C3EB1019A856653D3D7A WcF7KbNgrUStCYryH7YWKPvKf3VkfV3rnvtb4QnF http://localhost:8080/v2-beta/projects/1a5 lcl
fi
