#!/bin/bash
whoami
echo "cd /home/belenios/install"
cd /home/belenios/install

pwd

echo "eval $(opam env)"
eval $(opam env) 

echo "/home/belenios/install/demo/run-server.sh &"
/home/belenios/install/demo/run-server.sh &

echo 'Server launching...'

sleep 5

echo 'Server testing ...'
first_access_index_page_output=$(wget --retry-connrefused --no-check-certificate -T 30 http://localhost:8080 -O-)

if [ "$(echo \"$first_access_index_page_output\" | grep '>Belenios</a>' | wc -l)" != "1" ]; then echo "[First page access] First page access does not show a single '>Belenios</a>' text, but it should" && exit 1; else echo "[First page access] First page access shows a single '>Belenios</a>' text, as expected"; fi

# il faut toujours garder un processus qui ne s'arrête jamais comme un tail -f.
echo '/var/log/ reading...'
tail -f /var/log/faillog
