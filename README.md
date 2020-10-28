# craft-cms-docker-bootstrap
Set of files to set up a Docker container inffrastructure capable of running Craft CMS 3.

# How to

1. docker-compose up
2. docker-compose exec web bash
3. composer create-project craftcms/craft ./install
4. (shopt -s dotglob; mv -v ./install/* .)
5. rm -r install
6. php craft setup
7. chmod -R o+w config && chmod -R o+w storage && chmod -R o+w web/cpresources
8. Profit

# Reload everything

docker-compose down && docker image rm craft-demo_web && docker-compose up
