FROM tbaudier/cours_jm:v1.6

# install the notebook package and requirements.txt
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook && \
    pip install -r notebook/requirements.txt

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

COPY notebook /home/$NB_USER/notebook
COPY simuGate /home/$NB_USER/simuGate
RUN cp /root/.profile /home/$NB_USER/.profile
RUN chown --recursive $NB_UID:users /home/$NB_USER/

USER $NB_UID

ENV JUPYTER_ENABLE_LAB=yes

USER ${USER}

