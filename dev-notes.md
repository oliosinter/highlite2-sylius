# Docker commands

##### Build image 
`docker build -f path/Dockerfile -t testphpenv ./`

##### Create volume
`docker volume create --name ecommerce`

##### Install sylius
`docker run --rm --tty -i -v $PWD:/app -v ecommerce:/cache testphpenv composer create-project sylius/sylius-standard sylius`

##### Run bash in container
`docker run --rm --tty -i -v $PWD/sylius:/app -v ecommerce:/cache testphpenv bash`

##### Get dangling images
`docker images -q -f dangling=true`

##### Find containers by image id
`docker ps -f ancestor=6d1b8249c66a`

##### Find containers by name
`docker ps -a -f name=highlite2build_release`