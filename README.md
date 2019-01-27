# Bed and Breakfast

Simple CMS written in _Ruby_ and _Backbone_ for the performance team **Bed and Breakfast**.

## License

### front CSS and front example images

© Bed and Breakfast 2012

### rest of the code

MIT License

Copyright (c) 2012 Fernando Guillen Suarez

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Docker

### Install server basics
    ./server_setup.sh


### Activate SweetyBacky

    vim /root/secret/.s3.passwd # set the S3 credentials
    chmod -R 600 /root/secret/
    apt-get install ruby-all-dev build-essential zlib1g-dev mysql-client
    gem install "sweety_backy"
    crontab -l | { cat; echo "50 22 * * * /bin/bash -l -c '/usr/local/bin/sweety_backy /var/apps/MemmerMolano/config/sweety_backy.conf >> /tmp/sweety_backy.MemmerMolano.log 2>&1'"; } | crontab -

### Restore backups

Go to S3 to get the backups

    docker exec -i ef76e80ed43e mysql -uroot -proot hpq < /tmp/hpq.20180629.daily.sql
    mv /tmp/public/paperclip/production/* /var/apps/MemmerMolano/public/paperclip/production/

### Redeploy

    ssh root@memmermolano.com
    cd /var/apps/MemmerMolano
    git pull
    docker-compose restart app
    docker-compose restart web

### Consoling

    docker-compose exec app bundle exec rails c
    docker-compose exec db mysql -uroot -p hpq
