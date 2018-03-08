## Highlite2 Sylius

#### Why not bind mounting application directory?
- https://stackoverflow.com/questions/38163447/docker-mac-symfony-3-very-slow
- http://blog.michaelperrin.fr/2017/04/14/docker-for-mac-on-a-symfony-app/
- https://docs.docker.com/docker-for-mac/troubleshoot/#known-issues


There are a number of issues with the performance of directories bind-mounted with osxfs. 
In particular, writes of small blocks, and traversals of large directories are currently slow. 
Additionally, containers that perform large numbers of directory operations, such as repeated 
scans of large directory trees, may suffer from poor performance. Applications that behave in 
this way include:

- rake
- ember build
- Symfony
- Magento
- Zend Framework
- PHP applications that use Composer to install dependencies in a vendor folder

As a work-around for this behavior, you can put vendor or third-party library directories in 
Docker volumes, perform temporary file system operations outside of osxfs mounts, and use 
third-party tools like Unison or rsync to synchronize between container directories and 
bind-mounted directories. We are actively working on osxfs performance using a number of 
different techniques. To learn more, see the topic on Performance issues, solutions, and roadmap.