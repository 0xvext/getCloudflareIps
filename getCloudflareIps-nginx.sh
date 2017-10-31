#!/bin/dash

#Download the latest IPv4 and IPv6 lists from Cloudflare and merge into a temporary file
curl https://www.cloudflare.com/ips-v4 > /tmp/cloudflare-ips.txt
curl https://www.cloudflare.com/ips-v6 >> /tmp/cloudflare-ips.txt

#Check if there has been a change since last run
if ! cmp --silent /tmp/cloudflare-ips.txt /etc/nginx/cloudflare-allow.conf; then
    #Remove the existing include file
    rm /etc/nginx/cloudflare-allow.conf

    #Loop through the temp file and output a file formatted for nginx filtering
    #Note: this file must be referenced in the appropriate conf file(s) stored in /etc/nginx/sites-available/
    #Add the following line to your conf(s): include /etc/nginx/cloudflare-allow.conf;

    while read LINE
    do
        echo "allow $LINE;" >> /etc/nginx/cloudflare-allow.conf
    done < /tmp/cloudflare-ips.txt

    #Remove the temporary file containing the raw IPs
    rm /tmp/cloudflare-ips.txt

    #Restart nginx
    service nginx restart
else
    echo "No change since last run. Exiting."
fi
