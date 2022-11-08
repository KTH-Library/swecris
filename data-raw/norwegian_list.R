# httr::POST("https://dbh.nsd.uib.no/publiseringskanaler/BrukerLoggpaSjekk.action",
#   add_headers(
#     Origin = "https://dbh.nsd.uib.no",
#     DNT = "1",
#     Connection = "keep-alive",
#     Referer = "https://dbh.nsd.uib.no/publiseringskanaler/BrukerLoggpa.action;jsessionid=Cuj0+qnEazOL6ydPVg6fplA6.undefined",
#     Cookie = "JSESSIONID=Cuj0+qnEazOL6ydPVg6fplA6.undefined",
#     `Upgrade-Insecure-Requests` = "1",
#     `Sec-Fetch-Dest` = "document",
#     `Sec-Fetch-Mode` = "navigate",
#     `Sec-Fetch-Site` = "same-origin",
#     `Sec-Fetch-User` = "?1"
#   ),
#    encode = c("form"),
#    body = list(skjemaEpost="markussk@kth.se", skjemaPassord="stolpverk12")
# )


# {
#   "credentials": "include",
#   "headers": {
#     "User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:93.0) Gecko/20100101 Firefox/93.0",
#     "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
#     "Accept-Language": "en-US,en;q=0.5",
#     "Content-Type": "application/x-www-form-urlencoded",
#     "Upgrade-Insecure-Requests": "1",
#     "Sec-Fetch-Dest": "document",
#     "Sec-Fetch-Mode": "navigate",
#     "Sec-Fetch-Site": "same-origin",
#     "Sec-Fetch-User": "?1"
#   },
#   "referrer": "https://dbh.nsd.uib.no/publiseringskanaler/BrukerLoggpa.action;jsessionid=Cuj0+qnEazOL6ydPVg6fplA6.undefined",
#   "body": "skjemaEpost=markussk%40kth.se&skjemaPassord=stolpverk12&id=",
#   "method": "POST",
#   "mode": "cors"
# });

#curl 'https://dbh.nsd.uib.no/publiseringskanaler/BrukerLoggpaSjekk.action' -X POST -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:93.0) Gecko/20100101 Firefox/93.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Origin: https://dbh.nsd.uib.no' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://dbh.nsd.uib.no/publiseringskanaler/BrukerLoggpa.action;jsessionid=Cuj0+qnEazOL6ydPVg6fplA6.undefined' -H 'Cookie: JSESSIONID=Cuj0+qnEazOL6ydPVg6fplA6.undefined' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-Fetch-User: ?1' --data-raw 'skjemaEpost=markussk%40kth.se&skjemaPassord=stolpverk12&id='

curl 'https://kanalregister.hkdir.no/publiseringskanaler/AlltidFerskListeTidsskrift2SomCsv' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:105.0) Gecko/20100101 Firefox/105.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://kanalregister.hkdir.no/publiseringskanaler/AlltidFerskListe' -H 'Cookie: JSESSIONID=PSq-kj874+92x0OE3QpxJW70.undefined; samtykke=test' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-Fetch-User: ?1' -H 'Sec-GPC: 1' -H 'TE: trailers'

