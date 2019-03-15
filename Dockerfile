FROM rocker/tidyverse

# Install a missing linux package
RUN apt update && apt install -y tree pandoc-citeproc silversearcher-ag entr

# Install python3
RUN apt install -y python3-dev python3-pip

# Install requirements
COPY requirements.txt /root/requirements.txt
RUN pip3 install -r /root/requirements.txt

# Install R packages
RUN Rscript -e "install.packages('rmarkdown')"
RUN Rscript -e "install.packages('kableExtra')"
RUN Rscript -e "install.packages('reticulate')"

RUN Rscript -e "install.packages('sdcMicro')"
RUN Rscript -e "install.packages('brms')"
RUN Rscript -e "install.packages('prettydoc')"
RUN Rscript -e "install.packages('DT')"
