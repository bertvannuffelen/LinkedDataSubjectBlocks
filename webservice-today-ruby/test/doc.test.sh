echo "\n"
echo "generated" 
curl http://localhost/doc


echo "\n"
echo "rdfstore" 
curl http://localhost/id/adres/208700.subject_ttl

echo "\n"
echo "rdfstore" 
curl http://localhost:80/id/adres/208700.subject_rdf

echo "\n"
echo "propagation x-correlation-id" 
curl -H "x-correlation-id: XCORID23213" http://localhost:80/id/adres/208701.subject_rdf

echo "\n"



echo "\n"
echo "rdfstore ntriples" 
curl  http://localhost:80/id/concept/208701.subject_nt
echo "\n"
echo "rdfstore turtle" 
curl http://localhost:80/id/concept/208701.subject_ttl
echo "\n"
echo "rdfstore rdf/xml" 
curl http://localhost:80/id/concept/208701.subject_rdf
echo "\n"
echo "rdfstore json" 
curl http://localhost:80/id/concept/208701.subject_json

echo "\n"
echo "rdfstore ntriples" 
curl  -H "Accept: text/ntriples" http://localhost:80/id/concept/208701.subject
echo "\n"
echo "rdfstore turtle" 
curl -H "Accept: text/turtle" http://localhost:80/id/concept/208701.subject
echo "\n"
echo "rdfstore rdf/xml" 
curl -H "Accept: application/rdf+xml" http://localhost:80/id/concept/208701.subject
echo "\n"
echo "rdfstore json" 
curl -H "Accept: application/json" http://localhost:80/id/concept/208701.subject


echo "\n"
