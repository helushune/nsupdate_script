# nsupdate_script
Quick [RFC 2136](https://tools.ietf.org/html/rfc2136) bash script for A and AAAA records.  
There is no error checking or handling.  Currently in use on a FreeBSD system; should work on Linux.
  
Requirements:  
* bash
* curl
* dig (part of bind-tools or bind-utils)
* nsupdate or samba-nsupdate
* Dual stack support
  
Default TTL is 1800 (30 mins), adjust to your liking; don't forget to update both the AAAA and A record blocks.
