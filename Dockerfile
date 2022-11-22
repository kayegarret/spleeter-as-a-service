FROM tensorflow/tensorflow:1.14.0-gpu-py3

# because nvida rotated the keys ? ...
RUN rm /etc/apt/sources.list.d/cuda.list
RUN rm /etc/apt/sources.list.d/nvidia-ml.list
RUN apt-key del 7fa2af80
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub

RUN apt-get update -y
RUN apt-get install vim -y

# Set container port
ENV PORT 8080

# Copy local code to the container image.
ADD src /src

WORKDIR /src
COPY . ./

# Spleeter installation.
RUN apt-get update && apt-get install -y ffmpeg libsndfile1 wget
RUN pip install musdb museval
RUN pip install spleeter-gpu==1.4.5
RUN pip install -r requirements.txt

CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app:app
