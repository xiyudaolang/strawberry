# xiyudaolang [![](https://images.microbadger.com/badges/version/arthurkiller/strawberry.svg)](http://microbadger.com/images/arthurkiller/strawberry "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/arthurkiller/strawberry.svg)](http://microbadger.com/images/arthurkiller/strawberry "Get your own image badge on microbadger.com") 
my docker env
* build with CentOS 
* added golang support (vim-go & go complier)
* changed shell into fish & Now you can enjoy it!
* I added my vimrc file from my github

# packages images
docker build -t registry.baidu.com/huzaibin/mygolang:1.0 .
# run image
docker run -d -p 2222:22 -v {host_go_path}:/root/golang -h Metrix-CentOS registry.baidu.com/huzaibin/mygolang:1.0

# no pwd login
# copy local host ssh public key to container
ssh-copy-id -p 2222 -i ~/.ssh/id_rsa.pub root@{host IP}
ssh -p 2222 root@{host IP}