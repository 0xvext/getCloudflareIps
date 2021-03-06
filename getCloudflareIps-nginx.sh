#!/bin/dash

#Download the latest IPv4 and IPv6 lists from Cloudflare and merge into a temporary file
echo "### Downloading latest CloudFlare IP lists..."
curl https://www.cloudflare.com/ips-v4 > /tmp/cloudflare-ips.txt
curl https://www.cloudflare.com/ips-v6 >> /tmp/cloudflare-ips.txt

#Check if there has been a change since last run
echo "### Checking if IP lists have changed..."
if ! cmp --silent /tmp/cloudflare-ips.txt /etc/nginx/cloudflare-ips.txt; then
    echo "### Change detected! Executing..."
    #Back up prior list of IPs (only last copy saved)
    echo "### Backing up prior IP list..."
    mv /etc/nginx/cloudflare-ips.txt /etc/nginx/cloudflare-ips.prev
    #Create new persistent list of IPs
    echo "### Updating persistent /etc/nginx/cloudflare-ips.txt..."
    cp /tmp/cloudflare-ips.txt /etc/nginx/cloudflare-ips.txt
    #Remove the existing include file
    echo "### Deleting /etc/nginx/cloudflare-allow.conf..."
    rm /etc/nginx/cloudflare-allow.conf

    #Loop through the temp file and output a file formatted for nginx filtering
    #Note: this file must be referenced in the appropriate conf file(s) stored in /etc/nginx/sites-available/
    #Add the following line to your conf(s): include /etc/nginx/cloudflare-allow.conf;

    while read LINE
    do
        echo "### Adding to /etc/nginx/cloudflare-allow.conf: allow $LINE;"
        echo "allow $LINE;" >> /etc/nginx/cloudflare-allow.conf
    done < /etc/nginx/cloudflare-ips.txt

    #Remove the temporary file containing the raw IPs
    echo "### Removing temporary file /tmp/cloudflare-ips.txt..."
    rm /tmp/cloudflare-ips.txt

    #Restart Nginx
    echo "### Restarting Nginx..."
    service nginx restart
else
    echo "### No change since last run. Exiting."
fi
