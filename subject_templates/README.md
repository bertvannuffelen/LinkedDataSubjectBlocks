This directory contains SPARQL construct queries which create a subject page.
Each template offers a differnt view which can be selected.
Specific templates can be derived from it, however for consistency reasons it is best that the user is confronted with a coherent view per data domain. 
If that is not possible, consistency per Class is adviced.


The script to retrieve and create them is based on the redland RDF linux tools.

``sudo apt-get install rasqal-utils raptor``


Execution

``./query_store.sh direct.rq http://dbpedia.org/resource/Belgium ``


# TODO
* The script is not yet suited for concurrent usages. 
* Defaults and argument handling can be improved.
