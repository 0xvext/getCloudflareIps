#!/bin/dash

#Remove any temp files from previous execution
rm /tmp/cloudflare-ips.txt
rm /tmp/cloudflare-include.txt

#Download the latest IPv4 and IPv6 lists from Cloudflare and store into a temporary file
curl https://www.cloudflare.com/ips-v4 > /tmp/cloudflare-ips.txt
curl https://www.cloudflare.com/ips-v6 >> /tmp/cloudflare-ips.txt

#Loop through the resulting file and output a file formatted for nginx filtering
#2017.10.30 - This is currently stored to a temp folder. Need to move the file location to a production folder and reference it in the nginx site config file(s)
while read LINE
do
    echo "allow $LINE;" >> /tmp/cloudflare-include.txt
done < /tmp/cloudflare-ips.txt

#Remove the temporary file containing the raw IPs
rm /tmp/cloudflare-ips.txt
