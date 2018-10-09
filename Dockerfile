FROM khanlab/neuroglia-dwi:v1.4.1
MAINTAINER <alik@robarts.ca>

RUN mkdir -p /opt/vasst-dev
COPY / /opt/vasst-dev

RUN echo addpath\(genpath\(\'/opt/vasst-dev/tools/matlab\'\)\)\; >> /etc/octave.conf 
RUN cd /opt/vasst-dev/install_scripts
ENV DEBIAN_FRONTEND=noninteractive

RUN bash /opt/vasst-dev/install_scripts/05.install_MCR.sh /opt v92 R2017a
RUN bash /opt/vasst-dev/install_scripts/27.install_vasst_dev_atlases_by_source.sh /opt

#vasst-dev
ENV VASST_DEV_HOME=/opt/vasst-dev
ENV PIPELINE_ATLAS_DIR /opt/atlases
ENV PIPELINE_DIR $VASST_DEV_HOME/pipeline
ENV PIPELINE_TOOL_DIR $VASST_DEV_HOME/tools
ENV MIAL_DEPENDS_DIR $VASST_DEV_HOME/mial-depends
#MIAL_DEPENDS_LIBS $VASST_DEV_HOME/mial-depends/lib
#ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$MIAL_DEPENDS_LIBS
ENV PIPELINE_CFG_DIR $PIPELINE_DIR/cfg
ENV PATH $PIPELINE_TOOL_DIR:$MIAL_DEPENDS_DIR:$PATH
ENV MCRBINS $VASST_DEV_HOME/mcr/v92
ENV PATH $PIPELINE_DIR/batch:$PATH
ENV PATH $PIPELINE_DIR/dwi:$PATH
ENV PATH $PIPELINE_DIR/fmri:$PATH
ENV PATH $PIPELINE_DIR/import:$PATH
ENV PATH $PIPELINE_DIR/qc:$PATH
ENV PATH $PIPELINE_DIR/recipes:$PATH
ENV PATH $PIPELINE_DIR/registration:$PATH
ENV PATH $PIPELINE_DIR/t1:$PATH

#mcr - vasst-dev dependency
ENV MCRROOT /opt/mcr/v92

