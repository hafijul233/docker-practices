#tell which os eco system is need
FROM node:latest

# set the working directory
WORKDIR /home/server

# run inital project environment setup command

# install latest npm first 
RUN npm install -g npm

# install required packages
RUN npm install -g json-server

# copy source
COPY  database/default.json /home/server/default.json

COPY  database/alt.json /home/server/alt.json

#release the outer accessable port 
EXPOSE 3000

#run the docker booting start point
# array format double quote(")  with space between
ENTRYPOINT [ "json-server" , "--host" , "0.0.0.0" ]

#if you want to overwrite arguments of entry point
CMD [ "default.json" ]