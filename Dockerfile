FROM tbaudier/cours_jm:v1.7

# Adapted from https://github.com/ContinuumIO/docker-images/blob/master/miniconda3/debian/Dockerfile
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}

USER root

COPY . ${HOME}

RUN cp /root/.profile /home/$NB_USER/.profile
RUN cat /home/$NB_USER/.profile
RUN chown --recursive $NB_UID:users /home/$NB_USER/

USER $NB_UID

CMD [ "/bin/bash" ]
RUN cat /home/$NB_USER/.profile
RUN ls /software/miniconda/bin
RUN ls /software
# Adapted from https://pythonspeed.com/articles/activate-conda-dockerfile/
RUN conda env create -f ${HOME}/environment.yml
SHELL ["conda", "run", "-n", "example-environment", "/bin/bash", "-c"]

ENV JUPYTER_ENABLE_LAB=yes

USER ${USER}
SHELL ["conda", "run", "-n", "example-environment", "/bin/bash", "-c"]
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "example-environment"]
