FROM swift:4.2
LABEL Description="Letterer Stories" Vendor="Marcin Czachurski" Version="1.0"

ADD . /stories
WORKDIR /stories

RUN swift build --configuration release
EXPOSE 8003
ENTRYPOINT [".build/release/Run", "--port", "8003", "--hostname", "0.0.0.0"]