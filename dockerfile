ARG python_version=3.9
ARG build_target=$python_version
ARG publish_target=$python_version

FROM python:$build_target as Builder

# Add arguments to container scope
ARG build_target
ARG package
ARG package_version

# Identify package manager (ubuntu or alpine).
RUN if which apk > /dev/null ; then apk add build-base jq ; fi
RUN if which apt-get > /dev/null ; then apt-get update; apt-get install -y jq ; fi

# Install rust to compile oso.
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /opt
RUN git clone --depth 1 --branch "v$package_version" https://github.com/osohq/oso.git
WORKDIR /opt/oso
RUN rm -Rf .git
RUN make python-build
RUN make python-sqlalchemy-build


# Build our actual container now.
FROM python:$publish_target

# Add args to container scope.
ARG publish_target
ARG python_version
ARG package
ARG maintainer=""
ARG TARGETPLATFORM=""
LABEL python=$python_version
LABEL package=$package
LABEL maintainer=$maintainer
LABEL org.opencontainers.image.description="python:$publish_target $package:$package_version $TARGETPLATFORM"


# Copy all of the python files built in the Builder container into this smaller container.
COPY --from=Builder /usr/local/lib/python$python_version /usr/local/lib/python$python_version
COPY --from=Builder /opt/oso /opt/oso
