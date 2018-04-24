#
# more test should be added to cover each case

 curl http://localhost:81/id/adres/208700.subject_ttl
 curl -v -H "x-request-id: 123123" http://localhost:81/id/adres/208700.subject_rdf
 curl -v -H "x-request-id: 123123" http://localhost:81/id/adres/208701.subject_rdf
