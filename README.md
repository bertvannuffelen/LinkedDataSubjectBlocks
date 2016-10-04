Linked Data Subject Blocks
--------------------------
(This is work in progress)

A Linked Data Subject Block (LDSB) forms a chain of Linked Data Documents that reflect the state of a single subject over time.
LDSBs are constructed in such a way that both today's view on the subject aswell as a historic view can be explored.

A LDSB compressed set of files consisting of 
    *) a RDF file containing information about the view (document) and the subject it is describing.
    *) a LDSB containing the previous versions
    *) a version describing document:
          a) the URI describing this versioned document 
          b) a mapping of all used URIs in the RDF file to the versioned LDSB documents at the moment of creatig a LDSB 
          c) a reference to the template the RDF subject description has been constructed with (typically a SPARQL construct query) (*).

(*) SPARQL construct queries are less ambigeous than SPARQL describe since the implementation of the describe is tool dependent.


Using this information the following Linked Data key operations can be supported 

a) retrieve the subject page in RDF 
b) retrieve the subject page in RDF at a point of time in the past
c) browse through the data given a point in time.


Note that the consistency of the view is dependent on the consistency of the information at the point the LDSB is being generated.

Usually RDF subject views are created dynamically by querying the source SPARQL endpoint. However adding the historic view creates an additional complexity into the store, which is often not required for the majority of the usages. 
Materialized views like LDSB's provide several advantages over the traditional apporach:
    *) persistence is more guaranteed (accidental deleting is avoided,as LDSB's are write only),
    *) historic views can be handled cheaply (unfolding the LDSB) 
    *) long existing web techniques like caching http requests can be more exploited
    *) LDSB's creation is inherently scalable
    *) exploitation costs are low, as storage is the cheapest cloud resource available.
    *) Cloud providers provide also out-of-the box supported solutions for data safety (RAID levels)
LDSB's trade higher computations costs of the traditional approach with higher costs in space. But since the unit costs by cloud providers for storage is astronomic less then processing costs LDSB's offer a substantial cost benefit.

Subject & Document page definition
==================================
_Note_: the URIs are assumed to follow the Flemish Government URI strategy, but this should not limit the approach.

SubjectURI  = the identifier of the item under consideration
DocumentURI = the identifier of the document describing the view at a given timepoint for a SubjectURI.
            = function(SubjectURI, timestamp)




URLs to be supported
--------------------

<url>.ldsb           = the ldsb 
<url>.ldsb_v<NUM>    = the <NUM> version of the ldsb
<url>.latest_version = the current version of the ldsb
<url>.subject        = the current subject page of the ldsb as stored in the ldsb
<url>.subject_ttl    = the current subject page of the ldsb in turtle
<url>.subject_nt     = the current subject page of the ldsb in ntriples
<url>.subject_rdf    = the current subject page of the ldsb in RDF xml

Implementation
--------------
The implementation is done as shell scripts exposing the functionality via a webserver.

Chosen technology:
    shell: bash, curl, rapper
    webserver: apache 2.4

The implememtation is available as a standalone Docker configuration. 


Actions
=======
   *) implementation of URLs 
	**) <url>.ldsb           [DONE]
	**) <url>.ldsb_v<NUM>    [TODO]
	**) <url>.latest_version [DONE]
	**) <url>.subject        [DONE]
	**) <url>.subject_ttl    [DONE]
	**) <url>.subject_nt     [DONE]
	**) <url>.subject_rdf    [DONE]
   *) implementation of storage layer as volume on docker [DONE]
   *) implementation of creation script
        **) basic version        [DONE]
        **) version mapping      [DONE]
   *) support for schema versioning [TODO]
   *) support for transformation/data aquisition [TODO]


Storage layer
-------------
An external storage layer can be used to create long term stability e.g. the Azure Cloud blob service. [TODO]
The current implementation keep the information on a local volume, this approach is sensible for caching, but for long term storage not. But it is sufficient to demonstrate the behavior.

