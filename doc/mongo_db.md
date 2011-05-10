# MongoDB

Start:

    $ mongod --fork --logpath /var/log/mongodb.log --logappend --dbpath /var/lib/mongodb/

Stop:

    $ mongo
    > db.shutdownServer()
