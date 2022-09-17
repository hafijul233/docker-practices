#tell which os eco system is need
FROM node:latest

# set the working directory
WORKDIR /home/server

# run inital project environment setup command
RUN npm install -g json-server
 
COPY  database/default.json /home/server/default.json

COPY  database/alt.json /home/server/alt.json

#release the outer accessable port 
EXPOSE 3000

#run the docker booting start point
# array format double quote(")  with space between
ENTRYPOINT [ "json-server" , "default.json", "--host" , "0.0.0.0" ]

#if you want to overwrite arguments of entry point
CMD [ "alt.json" ]