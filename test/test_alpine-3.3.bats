setup() {
  docker history alpine:3.3 >/dev/null 2>&1
}

@test "version is correct" {
  run docker run alpine:3.3 cat /etc/os-release
  [ $status -eq 0 ]
  [ "${lines[2]}" = "VERSION_ID=3.2.0" ]
}

@test "package installs cleanly" {
  run docker run alpine:3.3 apk add --update openssl
  [ $status -eq 0 ]
}

@test "timezone" {
  run docker run alpine:3.3 date +%Z
  [ $status -eq 0 ]
  [ "$output" = "UTC" ]
}

@test "apk-install script should be available" {
  run docker run alpine:3.3 which apk-install
  [ $status -eq 0 ]
}

@test "repository list is correct" {
  run docker run alpine:3.3 cat /etc/apk/repositories
  [ $status -eq 0 ]
  [ "${lines[0]}" = "http://alpine.gliderlabs.com/alpine/edge/main" ]
  [ "${lines[1]}" = "http://alpine.gliderlabs.com/alpine/edge/community" ]
  [ "${lines[2]}" = "" ]
}

@test "cache is empty" {
  run docker run alpine:3.3 sh -c "ls -1 /var/cache/apk | wc -l"
  [ $status -eq 0 ]
  [ "$output" = "0" ]
}
