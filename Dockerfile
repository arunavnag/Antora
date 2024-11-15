# Use a base image with Ruby
FROM ruby:3.2-alpine

# Install system dependencies
RUN apk add --no-cache \
    nodejs \
    npm \
    git \
    python3 \
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
    freetype-dev

# Install Python diagram packages
RUN pip3 install --no-cache-dir \
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
    && npm install -g @mermaid-js/mermaid-cli

# Install Ruby gems for Asciidoctor
RUN gem install asciidoctor-pdf \
    && gem install asciidoctor-diagram \
    && gem install asciidoctor-plantuml

# Set the working directory
WORKDIR /antora

# Copy your project files into the container
COPY . .

# Set environment variables
ENV CUSTOM_OUTPUT_DIR=/home/demo/output \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk \
    PLANTUML_HOME=/usr/share/plantuml

# Ensure the output directory exists
RUN mkdir -p ${CUSTOM_OUTPUT_DIR}

# Expose port 8080 for the documentation site
EXPOSE 8080

# Set the command to run your Python script
CMD ["python3", "build_and_run_antora.py"]
