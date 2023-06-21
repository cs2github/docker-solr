# Solr Docker container

A Docker container with Solr Server based on [Apache Solr for TYPO3 CMS](https://github.com/TYPO3-Solr/ext-solr).
More info [here](https://docs.typo3.org/p/apache-solr-for-typo3/solr/main/en-us/GettingStarted/Solr.html#docker)

## Usage

Docker image from [Apache Solr for TYPO3 CMS](https://github.com/TYPO3-Solr/ext-solr) is based on [official Apache Solr docker image](https://github.com/docker-solr/docker-solr).</br>
That means that also **THIS** image exports a volume */var/solr* for persistent data.</br>
Moreover THIS image also supports extension mechanims. At run time, before starting Solr, the container will execute scripts in the */docker-entrypoint-initdb.d/* directory. Use [bind mounts](https://docs.docker.com/storage/bind-mounts/) for adding custom scripts into container. More info [here](https://solr.apache.org/guide/solr/latest/deployment-guide/solr-in-docker.html#extending-the-image).

```
docker run -d \
  -v /root/solr:/docker-entrypoint-initdb.d \
  --name cs2-typo3s-solr-server \
  -p 8983:8983 \
  cs2ag/docker-solr:v9.2
```

## Environmental variables

Specify environment variables within file that ends with '.sh' extension.

```
cat /root/solr/env.sh #script needs to end with '.sh' extension
export SOLR_HEAP=1024m
```

Then use [bind mount](https://docs.docker.com/storage/bind-mounts/) of docker host directory into the container with *-v* option - see [Usage](https://github.com/cs2github/docker-solr#usage) section

> -v `/root/solr:/docker-entrypoint-initdb.d`

## Exposing ports

In case there are running multiple docker containers of Sorl server you need to specify unused (free) port on docker host level.</br>
For example default port of Solr server (port 8983) is already in use then you need to specify another unused (free) port (e.g. 8984) on docker host with *-p* option - see [Usage](https://github.com/cs2github/docker-solr#usage) section

> -p `8984:8983`

More info [here](https://docs.docker.com/config/containers/container-networking/#published-ports).

## Create Solr core into docker container

You can interact with Solr server via [CoreAdmin API calls](https://solr.apache.org/guide/solr/latest/configuration-guide/coreadmin-api.html) in order to create/unload/status of solr core.</br>
Below example shows API call for create/unload (remove)/status. Docker container is expected to be running on default 8983 sorl port.

```
core=test
curl "http://localhost:8983/solr/admin/cores?action=CREATE&&name=$core&configSet=ext_solr_12_0_0&schema=english/schema.xml&instanceDir=/var/solr/data/cores/$core&dataDir=/var/solr/data/data/$core"
curl "http://localhost:8983/solr/admin/cores?action=STATUS&core=$core"
curl "http://localhost:8983/solr/admin/cores?action=UNLOAD&core=$core&deleteIndex=true&deleteDataDir=true&deleteInstanceDir=true"
```

## Restart docker container with Solr server

```
docker restart CONTAINER_NAME
```


## Author

* Peter Misinsky (<github@cs2.ch>)

---
