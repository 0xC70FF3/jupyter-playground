# https://github.com/jupyter/docker-stacks/blob/master/minimal-notebook/Dockerfile
FROM jupyter/minimal-notebook

USER root

# copy requirements
COPY requirements.txt /tmp/
COPY optional-requirements.txt /tmp/

# Install Python 3 packages
RUN conda install --yes \
    --file /tmp/requirements.txt \
    && conda clean -yt

# installing pip3 and optional dependencies
ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py
RUN python3 /tmp/get-pip.py
RUN pip install jupyter-themer
RUN pip install -r /tmp/optional-requirements.txt

ARG THEME
RUN jupyter-themer -c $THEME

ENV PYTHONPATH $PYTHON_PATH:/src

WORKDIR /src

ENTRYPOINT ["tini", "--", "start-notebook.sh", "--notebook-dir=\"/src\""]
CMD []