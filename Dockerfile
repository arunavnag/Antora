# Use a base image with Ruby
FROM ruby:3.2-alpine

# Install system dependencies
RUN apk add --no-cache \
    nodejs \
    npm \
    git \
    python3 \
    py3-virtualenv \
    py3-pip \
    build-base \
    openjdk17 \
    graphviz \
    ttf-dejavu \
    fontconfig \
    plantuml \
    python3-dev \
    jpeg-dev \
    zlib-dev \
    freetype-dev \
    wget \
    unzip \
    openjdk17-jre \
    curl \
    tar \
    docker-cli

# Create and activate a virtual environment
RUN python3 -m venv /opt/venv

# Install Python packages in the virtual environment
RUN . /opt/venv/bin/activate \
    && /opt/venv/bin/pip install --no-cache-dir \
    blockdiag \
    seqdiag \
    actdiag \
    nwdiag \
    pillow

# Install specific versions of Antora CLI and site generator globally using npm
RUN npm install -g @antora/cli@3.1.9 \
    && npm install -g @antora/site-generator@3.1.9 \
    && npm install -g @antora/lunr-extension@1.0.0-alpha.8 \
    && npm install -g @antora/pdf-extension@1.0.0-alpha.9 \
    && npm install -g @mermaid-js/mermaid-cli \
    && npm install -g asciidoctor-kroki

# Install Ruby gems for Asciidoctor
RUN gem install asciidoctor-pdf \
    && gem install asciidoctor-diagram \
    && gem install asciidoctor-plantuml

# Set the working directory
WORKDIR /antora

# Copy project files
COPY . .

# Create Kroki startup script
RUN echo '#!/bin/sh' > /start-kroki.sh \
    && echo 'docker run -d -p 8000:8000 yuzutech/kroki' >> /start-kroki.sh \
    && chmod +x /start-kroki.sh

# Set environment variables with more flexible paths
ENV INPUT_DIR=/home/demo/input \
    OUTPUT_DIR=/home/demo/output \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk \
    PLANTUML_HOME=/usr/share/plantuml \
    KROKI_SERVER_URL=http://localhost:8000 \
    KROKI_ENABLE=true \
    PATH="/opt/venv/bin:$PATH"

# Create input and output directories
RUN mkdir -p ${INPUT_DIR} ${OUTPUT_DIR}

# Expose ports for documentation site and Kroki server
EXPOSE 8080 8000

# Create main startup script with dynamic input handling
RUN echo '#!/bin/sh' > /start.sh \
    && echo '. /opt/venv/bin/activate' >> /start.sh \
    && echo '/start-kroki.sh' >> /start.sh \
    && echo 'sleep 10' >> /start.sh \
    && echo 'python3 build_and_run_antora.py' >> /start.sh \
    && chmod +x /start.sh

# Set the command to run the startup script
CMD ["/start.sh"]
