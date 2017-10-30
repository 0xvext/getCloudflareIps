# getCloudflareIps
Bash script(s) to download updated Cloudflare IP ranges (IPv4 and IPv6)

Since Cloudflare does at times change their IP ranges, any source-filtering (Nginx, Apache, IPTables, etc.) that uses their source address ranges will run into issues from time to time. Fortunately, Cloudflare provides convenient lists of their current ranges.

These scripts are a quick way to download the latest lists of Cloudflare IP ranges straight from the source. They can then be used to update applicable IP filter lists.
