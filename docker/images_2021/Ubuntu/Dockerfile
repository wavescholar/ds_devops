FROM public.ecr.aws/lts/ubuntu:latest

RUN apt-get update  --fix-missing && apt upgrade -y
RUN apt-get install -y curl
# RUN apt-get install -y ncal
RUN apt-get install -y screenfetch


EXPOSE 6060

RUN echo "hi there"
ENTRYPOINT ["sh"]



#CMD ["tf-server", "--protected-mode no"]
