check-sys-info() {
  lsb_release -a;
  echo;
  cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l | awk '{print "cpu counts: "$1}';
  cat /proc/cpuinfo| grep "cpu cores"| uniq;
  cat /proc/cpuinfo| grep "processor"| wc -l | awk '{print "total processor counts: "$1}';
  cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c | awk '{print "cpu version:"$0}' ;
  echo;
  awk '$3=="kB"{$2=$2/1024^2;$3="GB";} 1' /proc/meminfo | column -t | head -6;
  echo;
  df -h;
}

mamba-env(){
  mamba activate $1 && export HOST=$(hostname);
}
mamba-export(){
  mamba env export -n $1 --no-builds | grep -v "prefix"
}
ssh-key(){
  ssh-keygen -t rsa -b 4096 -C "sumin2012@163.com"
  echo ssh-copy-id -i $HOME/.ssh/id_rsa.pub  -p 22 user@host
}
